        .data #debut
        
diff:
        .quad 26

erreur:
	.string "Il faut 2 arguments !!\n"

saut_de_ligne:
	.string "\n"
	
        .text

        .global _start


   
_start:
        xor %rcx, %rcx          # on vide %rcx prendra le int
        xor %rbx, %rbx          # on vide %rbx prendra la chaine
        xor %rax, %rax          # on vide %rax prendra le resultat
        xor %r10, %r10          # incrementeur
	xor %r11, %r11		# recup le nombre d'argument

	mov saut_de_ligne, %r13 # on recup le caractere \n
	
        xor %rdx, %rdx          # caracteres de l'increment
        
        pop %r11                # on reucp argc
	pop %rcx		# on recup argv[0]
        pop %rcx                # on recup argv[1]
        
        call atoi_PE            # on appel atoi qui met sa
                                # valeur transformer dans %rax
        mov %rax, %rcx          # on recup la velur apres atoi

        pop %rbx                 # on recup argv[2] donc la chaine

verif_arg:
	cmp $3, %r11		# on verif qu'il y ai 2 argument
				# argv[0], argv[1], argv[2]
	JGE boucle		# si on a au moins 2 argument jmp boucle
	jmp affichage_erreur	# sinon on renvoie a la fin
	
boucle:
        mov (%rbx, %r10, 1), %dl          # %rbx[%r10] dans %dl
        test %rdx, %rdx                   # on regarde si le caractere est pas null
        jz affichage                      # si il l'est on va a fin 
        add %rcx, %rdx                    # on ajoute argv[1] a %dl
       

ajout_val:
        cmp $122, %rdx  		# on compare %rdx a la valeur de 'z'
        JG  depassement			# si rdx depasse 'z' alors depassement
        mov %dl, (%rbx, %r10, 1)        # on remplace la valeur de notre tableau
        inc %r10			# on incremente %r10
        jmp boucle			# on va a la boucle
        
depassement:
        sub diff, %rdx			# on soustrait la difference entre a et z (26)
        jmp ajout_val			#on retourne a ajout valeur

	
affichage_erreur:
	mov $1, %rax         	# num de syscall pour write
        mov $1, %rdi         	# sortie voulu (stdout)
        mov $erreur, %rsi      	# adresse de la chaine argv[2]
        mov $24, %rdx       	# taille en octet a afficher)
        syscall
	jmp fin

	
affichage:
	mov %r13 , (%rbx, %r10, 1)	# on ajoute \n a la fin de la chaine
	inc %r10			# incremente %r10
	mov $1, %rax         		# num de syscall pour write
        mov $1, %rdi         		# sortie voulu (stdout)
        mov %rbx, %rsi       		# adresse de la chaine argv[2]
        mov %r10, %rdx       		# taille en octet a afficher)
        syscall              		# appel système pour écrire les données

  
fin:			
	 mov $60, %rax	
	 xor %rdi, %rdi
	syscall
	
