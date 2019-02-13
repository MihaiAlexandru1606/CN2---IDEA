#include <stdio.h>
#include <stdint.h>

#define MOD1    65536
#define MOD2    65537
#define INV(a)   (unsigned short) (~(a) + 1)

unsigned short sub_key[52];
unsigned short decrp_key[52];

void shift_key(const unsigned short *key , unsigned short *new_key);

void generate_subKey(const unsigned char *key);

unsigned short invMod(unsigned short x);

void key_schedule(int round , unsigned short *key , char encrypt);

void round_my(int number_round , char encrypt , unsigned short *plaintext , unsigned short *ciphertext);

void final_round(char encrypt , unsigned short *plaintext , unsigned short *ciphertext);

void idea(unsigned char *key , unsigned char *plaintext , unsigned char *ciphertext , char encrypt);

int main() {

    /** test criptare */
    unsigned char key[] = "\x00\x64\x00\xc8\x01\x2c\x01\x90\x01\xf4\x02\x58\x02\xbc\x03\x20";
    unsigned char plaintext[] = "\x05\x32\x0a\x64\x14\xc8\x19\xfa";
    unsigned char ciphertext[8];

    idea (key , plaintext , ciphertext , 1);
    for (int i = 0; i < 8; i++) {
        printf ("%.2X" , ciphertext[i]);
    }
    printf ("\n");

    /** test decriptare */
    unsigned char key2[] = "\x00\x64\x00\xc8\x01\x2c\x01\x90\x01\xf4\x02\x58\x02\xbc\x03\x20";
    unsigned char plaintext2[8];
    unsigned char ciphertex2[8] = "\x65\xbe\x87\xe7\xa2\x53\x8a\xed";

    idea (key2 ,ciphertex2, plaintext2 , 0);
    for (int i = 0; i < 8; i++) {
        printf ("%.2X" , plaintext2[i]);
    }
    printf ("\n");
	
    return 0;
}

void generate_subKey(const unsigned char *key) {
    unsigned short new_key[8];

    for (int i = 0; i < 8; i++) {
        sub_key[i] = (unsigned short) (256 * key[2 * i] + key[2 * i + 1]);
    }

    shift_key (sub_key , new_key);
    for (int i = 8; i < 16; i++) {
        sub_key[i] = new_key[i - 8];
    }

    for (int i = 2; i < 7; i++) {
        shift_key (new_key , new_key);

        for (int j = 0; j < 8; ++j) {
            if (i * 8 + j > 52)
                break;

            sub_key[i * 8 + j] = new_key[j];
        }
    }

    decrp_key[0] = invMod (sub_key[48]);
    decrp_key[1] = INV (sub_key[49]);
    decrp_key[2] = INV (sub_key[50]);
    decrp_key[3] = invMod (sub_key[51]);

    for (int i = 4; i < 52; i += 6){
        decrp_key[i] = sub_key[50 - i];
        decrp_key[i + 1] = sub_key[51 - i];

        decrp_key[i + 2] = invMod (sub_key[46 - i]);

        if (i == 46 ) {
            decrp_key[i + 4] = INV (sub_key[48 - i]);
            decrp_key[i + 3] = INV (sub_key[47 - i]);
        }else {
            decrp_key[i + 3] = INV (sub_key[48 - i]);
            decrp_key[i + 4] = INV (sub_key[47 - i]);
        }

        decrp_key[i + 5] = invMod (sub_key[49 -i]);
    }
}

unsigned short invMod(unsigned short x) {
    uint64_t pow = 1;
    uint64_t a = x;

    for (int i = 0; i < 16; i++) {
        pow = (pow * a) % MOD2;
        a = (a * a) % MOD2;
    }

    return (unsigned short) pow;
}

void shift_key(const unsigned short *key , unsigned short *new_key) {
    uint64_t first = 0 , second = 0 , aux1 , aux2 , aux3 , aux4;

    for (int i = 0; i < 4; i++) {
        first <<= 16;
        second <<= 16;

        first += key[i];
        second += key[4 + i];
    }

    aux1 = first << 25;
    aux2 = first >> 39;

    aux3 = second << 25;
    aux4 = second >> 39;

    first = aux1 | aux4;
    second = aux3 | aux2;

    for (int i = 0; i < 4; ++i) {
        new_key[3 - i] = (unsigned short) (first & 0x0000FFFF);
        new_key[7 - i] = (unsigned short) (second & 0x0000FFFF);

        first >>= 16;
        second >>= 16;
    }

}

void key_schedule(int round , unsigned short *key , char encrypt) {
    if (encrypt == 1) {
        if (round != 9) {
            for (int i = 0; i < 6; i++) {
                key[i] = sub_key[(round - 1) * 6 + i];
            }
        } else {
            for (int i = 0; i < 4; i++) {
                key[i] = sub_key[(round - 1) * 6 + i];
            }
        }
    } else {
        if (round != 9) {
            for (int i = 0; i < 6; i++) {
                key[i] = decrp_key[(round - 1) * 6 + i];
            }
        } else {
            for (int i = 0; i < 4; i++) {
                key[i] = decrp_key[(round - 1) * 6 + i];
            }
        }
    }
}

void round_my(int number_round , char encrypt , unsigned short *plaintext , unsigned short *ciphertext) {
    unsigned short key[6];
    unsigned short P[14];
    uint64_t calc;

    key_schedule (number_round , key , encrypt);

    /** step 1*/
    calc = plaintext[0] * key[0];
    P[0] = (unsigned short) (calc % MOD2);
    /** step 2 */
    calc = plaintext[1] + key[1];
    P[1] = (unsigned short) (calc % MOD1);
    /** step 3 */
    calc = plaintext[2] + key[2];
    P[2] = (unsigned short) (calc % MOD1);
    /** step 4 */
    calc = plaintext[3] * key[3];
    P[3] = (unsigned short) (calc % MOD2);
    /** step 5*/
    P[4] = P[0] ^ P[2];
    /** step 6*/
    P[5] = P[1] ^ P[3];
    /** step 7*/
    calc = P[4] * key[4];
    P[6] = (unsigned short) (calc % MOD2);
    /** step 8 */
    calc = P[5] + P[6];
    P[7] = (unsigned short) (calc % MOD1);
    /** step 9 */
    calc = P[7] * key[5];
    P[8] = (unsigned short) (calc % MOD2);
    /** step 10 */
    calc = P[6] + P[8];
    P[9] = (unsigned short) (calc % MOD1);
    /** step 11 */
    P[10] = P[0] ^ P[8];
    /** step 12 */
    P[11] = P[2] ^ P[8];
    /** step 13 */
    P[12] = P[1] ^ P[9];
    /** step 14 */
    P[13] = P[3] ^ P[9];

    ciphertext[0] = P[10];
    ciphertext[1] = P[11];
    ciphertext[2] = P[12];
    ciphertext[3] = P[13];
}

void final_round(char encrypt , unsigned short *plaintext , unsigned short *ciphertext) {
    unsigned short key[4];
    unsigned short P[4];
    uint64_t calc;

    key_schedule (9 , key , encrypt);

    calc = plaintext[0] * key[0];
    P[0] = (unsigned short) (calc % MOD2);
    calc = plaintext[2] + key[1];
    P[1] = (unsigned short) (calc % MOD1);
    calc = plaintext[1] + key[2];
    P[2] = (unsigned short) (calc % MOD1);
    calc = plaintext[3] * key[3];
    P[3] = (unsigned short) (calc % MOD2);

    ciphertext[0] = P[0];
    ciphertext[1] = P[1];
    ciphertext[2] = P[2];
    ciphertext[3] = P[3];
}

void idea(unsigned char *key , unsigned char *plaintext , unsigned char *ciphertext , char encrypt) {
    unsigned short P[4];

    generate_subKey (key);
    for (int i = 0; i < 4; i++) {
        P[i] = (unsigned short) (256 * plaintext[2 * i] + plaintext[2 * i + 1]);
    }

    for (int i = 1; i < 9; i++) {
        round_my (i , encrypt , P , P);
    }

    final_round (encrypt , P , P);

    for (int i = 0; i < 4; i++) {
        ciphertext[2 * i] = (unsigned char) (P[i] >> 8);
        ciphertext[2 * i + 1] = (unsigned char) (P[i] & 0x00FF);
    }
}