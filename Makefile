AS = as -gstabs 

jules_cesar: jules_cesar.o
	ld -e _jules_cesar $^ atoi_module.o -o $@

jules_cesar.o: jules_cesar.s
	$(AS) -o $@ $<

clean:
	rm -rf jules_cesar.o jules_cesar
