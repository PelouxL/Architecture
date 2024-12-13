AS = as -a --gstabs 

vigenere: vigenere.o sous_vigenere.o
	ld $^ -o $@

vigenere.o: vigenere.s
	$(AS) -o $@ $<

sous_vigenere.o: sous_vigenere.s
	$(AS) -o $@ $<

jules_cesar: jules_cesar.o
	ld $^ atoi_module.o -o $@

jules_cesar.o: jules_cesar.s
	$(AS) -o $@ $<

clean:
	rm -rf jules_cesar.o jules_cesar vigenere.o vigenere
