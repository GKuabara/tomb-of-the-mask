; Hello World - Escreve mensagem armazenada na memoria na tela



; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco							0000 0000
; 256 marrom						0001 0000
; 512 verde							0010 0000
; 768 oliva							0011 0000
; 1024 azul marinho						0100 0000
; 1280 roxo							0101 0000
; 1537 teal							0110 0000
; 1793 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2561 lima							1010 0000
; 2816 amarelo						1011 0000
; 3072 azul							1100 0000
; 3328 rosa							1101 0000
; 3584 aqua							1110 0000
; 3839 branco						1111 0000



jmp main

mensagem : string "Ola Mundo!"	; Poe "\0" automaticamente no final da string


; ------ Programa Principal -----------

main:
	loadn r0, #0		; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #mensagem	; Carrega r1 com o endereco do vetor que contem a mensagem

	call Imprime   ;  r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem;   Obs: a mensagem sera' impressa ate' encontrar "/0"
	
	halt
	
Imprime:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem;   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r2 na pilha para ser usado na subrotina
	push r3	; protege o r3 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

LoopImprime:	
	loadi r2, r1	; r2 <- Conteudo da MEMORIA enderecada por r1
	cmp r2, r3	; Checa se chegou no final da mensagem = "\0"
	jeq SaiImprime	; Se chegou no fin da mensagem
	outchar r2, r0	; Imprima caracter
	inc r0		; incrementa posicao na tela
	inc r1		; incrementa ponteiro da mensagem
	jmp LoopImprime	; Goto Loop
	
SaiImprime:	
	pop r3	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r2
	pop r1
	pop r0
	rts