        .data

        .text

        .global _sous_vige

_sous_vige:
        movq $1, %r15            # si r15 = 1 alors la chaine nest pas fini

boucle:
        inc %r8
        movb ( %r14, %r8, 1) , %cl	# cl = R14[R8]
        test %cl, %cl			# si vide alors fin_tab
        jz fin_tab

verif_maj:
        cmp $65, %rcx           # on regarde si %rcs >= code ascii 'A'
        JL boucle       # si non alors n'est pas un caractere valide
        cmp $90, %rcx           # on regarde si %rcs > code ascii 'A'
        JG verif_min            # si oui on v verifier les minuscule
        jmp fin

verif_min:
        cmp $97, %rcx           # on verif si il est >= code ascii 'a'
        JL boucle               # c'est un caraactere non valide
        cmp $122, %rcx          # on verifie si le caracte !> a 'z'
        JG boucle               # si c'est le cas caractere invalide
        jmp fin

fin_tab:
        movq $0, %r15		# permet de savoir si la chaine est fini

fin:
        ret
        
