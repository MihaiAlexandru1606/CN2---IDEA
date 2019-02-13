build: idea

idea:
	gcc idea.c -o idea

run: idea
	./idea
	
clean:
	rm -fr idea