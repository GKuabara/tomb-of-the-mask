jmp main
; Declaracao e Inicializacao de variaveis estaticas

; ----------x--------------x-----------
main:
	loadn r0, #165
	loadn r1, #10
	call Printnr

	halt

; Final do codigo


; ----------x--------------x-----------
; inicio das Subrotinas

Printnr:	; Imprime um numero menor que 1000 com todas as casas: Parametors: r0 - numero; r1 - posicao na tela
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6

	loadn r3, #9
	loadn r2, #48
	cmp r0, r3
	jgr PrintnrDezena ; Se menor que 10, imprime o valor
	add r0, r0, r2	; Soma 48 que e' o caracter 0 da tabela ASCII
	outchar r0, r1	; Imprime na tela
	jmp PrintnrRts	; Fim da subrotina

PrintnrDezena:
	loadn r3, #99
	cmp r0, r3
	jgr PrintnrCentena	; Se menor que 100, imprime os dois caracteres
	loadn r6, #10
	div r4, r0, r6
	loadn r2, #48
	add r5, r4, r2
	outchar r5, r1
	mul r4, r4, r6
	sub r0, r0, r4
	add r0, r0, r2
	inc r1
	outchar r0, r1
	jmp PrintnrRts	; Fim da subrotina

PrintnrCentena:
	loadn r3, #999
	cmp r0, r3
	jgr PrintnrMilhar	; Se menor que 1000, imprime os 3 caracteres
	loadn r6, #100
	div r4, r0, r6
	loadn r2, #48
	add r5, r4, r2
	outchar r5, r1
	mul r4, r4, r6
	sub r4, r0, r4
	loadn r6, #10
	div r0, r4, r6
	loadn r2, #48
	add r5, r0, r2
	inc r1
	outchar r5, r1
	mul r0, r0, r6
	sub r0, r4, r0
	add r0, r0, r2
	inc r1
	outchar r0, r1
	jmp PrintnrRts	; Fim da subrotina

PrintnrMilhar:		; Se maior que 999, imprime ????
	loadn r0, #'?'
	outchar r0, r1
	inc r1
	outchar r0, r1
	inc r1
	outchar r0, r1
	inc r1
	outchar r0, r1

PrintnrRts:	; Fim da subrotina
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts	; Retorna da Subrotina mantendo todos os registradores intactos
	




