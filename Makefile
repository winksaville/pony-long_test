.PHONY: all
all: test

test: pony-long_test
	./pony-long_test

pony-long_test: main.pony
	ponyc -d --pic .

clean:
	@rm -f ./pony-long_test
