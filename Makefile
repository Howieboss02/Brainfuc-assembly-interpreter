objects = build/main.o build/brainfuck.o build/read_file.o
.PHONY: clean

brainfuck: $(objects)
	$(CC) -no-pie -O3 -o "$@" $^

build:
	mkdir build

build/%.o: %.s | build
	$(CC) -no-pie -O3 -c -o "$@" "$<"

clean:
	rm -rf brainfuck build
