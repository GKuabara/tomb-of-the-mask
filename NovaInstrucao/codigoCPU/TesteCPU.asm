jmp main

main:
	loadn r0, #1
	loadn r1, #50
	ADDINTTOASCII r0, r0, r0
	cmp r0, r1
	call deu_certo
	
	loadn r2, #2
	loadn r3, #20
	ADDINTTOASCII r2, r2, r2
	cmp r2, r3
	jmp deu_errado
	jmp fim

deu_certo:
	loadn r0, #'c'
	loadn r1, #0
	outchar r0, r1
	rts

deu_errado:
	loadn r0, #'e'
	loadn r1, #1
	outchar r0, r1

fim:
	halt