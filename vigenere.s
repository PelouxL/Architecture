	.data
	
saut_de_ligne:
	.string "\n"

ini_rax:
        .string "\0"

point:
        .string "."
	
msg:
	.string "Il faut 2 arguments !!\n"
	
	.text

	.global _start

_start:
	xor %r14, %r14		# vide %r14 prendra valeur argv[2]
        mov $ini_rax, %rax      # initialise le futur tab
        
	xor %rbx, %rbx		# vide %rbx prendra valeur argv[1]
	xor %rcx, %rcx		# vide %rcx prendra valeur argv2[%r8]
	xor %rdx, %rdx		# vide %rdx prendra valeur argv1[%r9]

        
	xor %r8, %r8		# vide %r8 increment de argv[2]
	xor %r9, %r9		# vide %r9 increment de argv[1]
        xor %r13, %r13          # vide %r13 increment de %rax
	xor %r10, %r10		# prend la valer de argc
	
	mov saut_de_ligne, %r11 # on recup le caractere \n
        mov point, %r12         # on met '.' dans %r12

	
	pop %r10		# on recup argc
	pop %rbx		# on recup argv[0] qu'on va ecraser
	pop %rbx 		# on recup argv[1]
	pop %r14		# on recup argv[2]

veirf_argc:
	cmp $3, %r10		# on verifie qu'il y est bien 2 argument
	JGE test_indice		# si %r10 plus petit alors jmp a erreur
	jmp erreur

test_indice:
	mov (%r14, %r8, 1), %cl	# cl = RAX[R8]
	test %cl, %cl		# si plus de caracter alorso n affiche
	jz affichage
	mov (%rbx, %r9, 1), %dl # dl = RBX[R9]
	test %dl, %dl		# on verifie si != 0
	jz fin_clef		

verif_maj:
        cmp $65, %rcx           # on regarde si %rcs >= code ascii 'A'
        JL sous_programme       # si non alors n'est pas un caractere valide
        cmp $90, %rcx           # on regarde si %rcs > code ascii 'A'
        JG verif_min            # si oui on v verifier les minuscule
        add $32, %rcx           # si non on soustrait la diff entre les
        jmp asci_rdx            # minuscule et majuscule + les caacteres
                                # entre eux


verif_min:
        cmp $97, %rcx           # on verif si il est >= code ascii 'a'
        JL sous_programme       # c'est un caraactere non valide
        cmp $122, %rcx          # on verifie si le caracte !> a 'z'
        JG sous_programme       # si c'est le cas caractere invalide
        
asci_rdx:
	sub $97, %rdx           # on soustrait depuis la valeur 'a'
	add %rdx, %rcx          # on ajoute notre valeurs a %rcx
        jmp boucle

sous_programme:
        call _sous_vige
        mov %r12, (%rax, %r13, 1)
        inc %r13
        cmp $0, %r15
        JE affichage
        jmp test_indice
       
        
boucle:
	cmp $122, %rcx                  # on verifie que %rcx !> 'z'
	JG depassement                 # si c'est le cas jmp depassement
	mov %cl, (%rax, %r13, 1)        # on met la valeur correcte dans %rax
	inc %r8                         # incremnte %r8
	inc %r9
        inc %r13                        # increment %r13
	jmp test_indice                 # on retourne recup les indices

depassement:	
	sub $26, %rcx                   # on enleve la diff 'a' et 'z' a %rcx
	jmp boucle                      

fin_clef:
	mov $0 ,%r9		        # on remet l'indice de RBX a 0
        mov (%rbx, %r9, 1), %dl         # dx = RBX[R9]
	jmp verif_maj

erreur:
	mov $1, %rax         		# num de syscall pour write
        mov $1, %rdi         		# sortie voulu (stdout)
        mov $msg, %rsi       		# adresse de la chaine argv[2]
        mov $24, %rdx       		# taille en octet a afficher)
        syscall
	jmp fin
	
affichage:
	mov %r11, (%rax, %r13, 1)
	mov %rax, %rbx
        
	mov $1, %rax         		# num de syscall pour write
        mov $1, %rdi         		# sortie voulu (stdout)
        mov %rbx, %rsi       		# adresse de la chaine argv[2]
        mov %r13, %rbx       		# taille en octet a afficher)
        syscall              		# appel système pour écrire les données

fin:
	 mov $60, %rax	
	 xor %rdi, %rdi
	 syscall
