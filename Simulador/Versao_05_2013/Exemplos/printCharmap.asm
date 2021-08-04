jmp main


main:
	loadn r0, #0
	loadn r1, #1199

a:
	outchar r0, r0
	inc r0
	cmp r0, r1
	jeq fim
	jmp a

fim:
	halt

