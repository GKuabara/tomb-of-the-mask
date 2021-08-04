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


start : var #21
static start + #0, #'P'
static start + #1, #'R'
static start + #2, #'E'
static start + #3, #'S'
static start + #4, #'S'
static start + #5, #' '
static start + #6, #'E'
static start + #7, #'N'
static start + #8, #'T'
static start + #9, #'E'
static start + #10, #'R'
static start + #11, #' '
static start + #12, #'T'
static start + #13, #'O'
static start + #14, #' '
static start + #15, #'S'
static start + #16, #'T'
static start + #17, #'A'
static start + #18, #'R'
static start + #19, #'T'
static start + #19, #'\0'


; str : string "Ola Mundo!"

; ------ jogo -----------

main:
	loadn r0, #0		; Posicao na tela onde a mensagem sera' escrita
	loadn r1, #start	; Carrega r1 com o endereco do vetor que contem a mensagem
	loadn r2, #256		; Seleciona a COR da Mensagem
	
	call Imprime   ;  r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"

	halt
	
Imprime:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r2 na pilha para ser usado na subrotina
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina

	
	loadn r3, #'\0'	; Criterio de parada

LoopImprime:	
	loadi r4, r1
	cmp r4, r3
	jeq SaiImprime
	add r4, r2, r4
	outchar r4, r0
	inc r0
	inc r1
	jmp LoopImprime
	
SaiImprime:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts