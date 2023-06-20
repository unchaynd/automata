.PHONY : all
all:

%.elf: %.c
	gcc $< -o $@

.PHONY : clean
clean:
	mv *.o *.elf -t trash