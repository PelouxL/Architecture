AS = as -a --gstabs 

jules_cesar: jules_cesar.o
	ld $^ atoi_module.o -o $@

jules_cesar.o: jules_cesar.s
	$(AS) -o $@ $<

clean:
	rm -rf jules_cesar.o jules_cesar
