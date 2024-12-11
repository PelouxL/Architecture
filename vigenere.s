	.data
	
saut_de_ligne:
	.string "\n"

	
msg:
	.string "Il faut 2 arguments !!\n"
	
	.text

	.global _start

_start:
	xor %rax, %rax		# vide %rax prendra valeur argv[2]
	xor %rbx, %rbx		# vide %rbx  prendra valeur argv[1]
	xor %rcx, %rcx		# vide %rcx prendra valeur argv2[%r8]
	xor %rdx, %rdx		# vide %rdx prendra valeur argv1[%r9]
	xor %r8, %r8		# vide %r8 increment de argv[2]
	xor %r9, %r9		# vide %r9 increment de argv[1]
	xor %r10, %r10		# prend la valer de argc
	
	mov saut_de_ligne, %r11 # on recup le caractere \n

	
	pop %r10		# on recup argc
	pop %rbx		# on recup argv[0] qu'on va ecraser
	pop %rbx 		# on recup argv[1]
	pop %rax		# on recup argv[2]

veirf_argc:
	cmp $3, %r10		# on verifie qu'il y est bien 2 argument
	JGE test_indice		# si %r10 plus petit alors jmp a erreur
	jmp erreur

test_indice:
	mov (%rax, %r8, 1), %cl	# cl = RAX[R8]
	test %cl, %cl		# si plus de caracter alorso n affiche
	jz affichage
	mov (%rbx, %r9, 1), %dl # dl = RBX[R9]
	test %dl, %dl		# on verifie si != 0
	jz fin_clef		


asci_rbx:
	sub $97, %rdx
	add %rdx, %rcx
	
boucle:
	cmp $122, %rcx
	JGE depassement
	mov %cl, (%rax, %r8, 1)
	inc %r8
	inc %r9
	jmp test_indice

depassement:	
	sub $26, %rcx
	jmp boucle
	jmp asci_rbx

fin_clef:
	mov $0 ,%r9		# on remet l'indice de RBX a 0
        mov (%rbx, %r9, 1), %dl # dx = RBX[R9]
	jmp asci_rbx

erreur:
	mov $1, %rax         		# num de syscall pour write
        mov $1, %rdi         		# sortie voulu (stdout)
        mov $msg, %rsi       		# adresse de la chaine argv[2]
        mov $24, %rdx       		# taille en octet a afficher)
        syscall
	jmp fin
	
affichage:
	mov %r11, (%rax, %r8, 1)
	inc %r8
	mov %rax, %rbx
	mov $1, %rax         		# num de syscall pour write
        mov $1, %rdi         		# sortie voulu (stdout)
        mov %rbx, %rsi       		# adresse de la chaine argv[2]
        mov %r8, %rdx       		# taille en octet a afficher)
        syscall              		# appel système pour écrire les données

fin:
	 mov $60, %rax	
	 xor %rdi, %rdi
	 syscall
