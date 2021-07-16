; Imprime os 127 caracteres da tabela ASCII

jmp main
; Declaracao e Inicializacao de variaveis estaticas

; ----------x--------------x-----------
main:
	loadn r2, #0	; Inicializa variavel do codigo do caracter com 0
	loadn r0, #0	; Inicializa variavel da posicao na tela com 0
	loadn r1, #128	; Condicao de parada = 127 caracteres impressos
	loadn r6, #255	; Se inchar rodar quando nenhuma tecla e' pressionada, responde 255

loop:
	outchar r0, r2	; Imprime o caracter
	inc r2		; Incrementa o caracter
	inc r0		; Incrementa a posicao na tela
	cmp r0, r1	; checa se ja' imprimiu os 127 caracteres
	jne loop	; Se nao, volta pro loop

	;Espera ate' que uma tecla seja pressionada	
input1:
	inchar r7	; Le tecla (se nada for pressionado, r7 = 255
	cmp r7, r6	; Compara com 255
	jeq input1	; Fica lendo ate' que uma tecla valida seja pressionada

	inc r2		; Incrementa o caracter
	inc r2		; Incrementa o caracter
	outchar r7, r2	; Imprime o caracter
	
	halt		; Pausa a execucao!



