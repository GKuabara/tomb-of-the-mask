; Trabalho de Prática em Organização Computacional

; Caracteres que constroem o Mapa
; buneco - z amarelo
; parede normal - } azul
; parede mortal - { vermelho
; linha de chegada - ) branco
; start - s verde
; moedinhas - * amarela

jmp main

; string do menu
menu_art : string "                                                                                                                                                                            Nome do Jogo                                                                                                                                                                                        Gabriel Alves Kuabara                                                       Gabriel Victor Cardoso Fernandes                                                 Lourenyo de Salles Roselino                                                                                                       }}}}}}}}                                }      }                                } }  } }                                }      }                                } }  } }                                } }}}} }                                }      }                                }}}}}}}}                                                                                                      Pressione Enter para Jogar                                                                                                                                 "

; variavel pra guardar o tempo de delay de cada movimento
delay: var #1
static delay + #0, #100000

direcao : var #1

posicao : var #1

velocidade : var #5
static velocidade + #0, #0 ; velocidade parado
static velocidade + #1, #40 ; velocidade subindo
static velocidade + #2, #1 ; velocidade direita
static velocidade + #3, #40 ; velocidade descendo
static velocidade + #4, #1 ; velocidade esquerda

; guarda quanta moedinhas o jogador tem
conta_bancaria: var #1 
                              
main:	
		loadn r0, #menu_art
		call menu ; constroi tela de menu
		
		halt
		
; carrega valores para o loop_menu
menu:
		loadn r2, #13 ; Caracter do enter
		loadn r0, #0
		loadn r3, #156895

; Espera até o usuário apertar enter para começar o jogo
loop_menu: 
		inc r0
		cmp r0, r3 ; reseta o contador, para continuar esperando o usuario teclar Enter
		jeq menu
		inchar r1 ; Le teclado
		cmp r1, r2
		jeq inicia_jogo ; Se apertou Enter, inicia o jogo.	
		jmp loop_menu   ; Se não, fica em loop
		
inicia_jogo:
		call apaga_menu
		loadn r0, #mapa1
		call constroi_cenario
		
		load r1, #posicao_inicial ; r1 sempre guarda a posição atual

loop_principal:
		loadn r0, #'z'
		outchar r0, r1 ; printa o buneco no mapa

		load r2, #delay
		loadn r3, #0 
		
; faz o delay de cada movimentação	
delay_mov
		nop
		dec r5
		cmp r2, r3
		jne delay_mov

; fazendo leitura da movimentação ---------------
le_direcao:
		inchar r2
		loadn r4, #0 

checa_cima:
		loadn r3, #'w'
		cmp r2, r3
		jne checa_direita
		loadn r4, #1
		
checa_direita:
		loadn r3, #'d'
		cmp r2, r3
		jne checa_baixo
		loadn r4, #2

checa_baixo:
		loadn r3, #'s'
		cmp r2, r3
		jne checa_esquerda
		loadn r4, #3

checa_esquerda:
		loadn r3, #'a'
		cmp r2, r3
		jne fim_checagem
		loadn r4, #4

; guarda velocidade da movimentação
fim_checagem:
		load r4, velocidade + r4
		
; movimentação --------------------------------------------

; verifica se posição está disponível
confere_posicao_valida:
		; prox posição
		add r5, r1, r4
		
		cmp r5, #'del'
		jne confere_colisao

; atualiza a posição do buneco em r1
movimento_valido:
		cmp r3, #'a'
		jeq movimentacao_negativa
		cmp r3, #'w'
		jeq movimentacao_negativa
		
		; atualiza posição atual
		add r1, r1, r4
		jmp confere_posicao_valida
		
movimentacao_negativa:

		; atualiza posição atual
		sub r1, r1, r4
		jmp confere_posicao_valida
		
; verifica qual tipo de colisão existe
confere_colisao:
		load r7, mapa + r5
		
		; caso moeda continuamos como movimentação válida
		loadn r6, #'*'
		cmp r6, r7
		load r0, conta_bancaria
		inc r0
		store conta_bancaria, r0
		jeq movimento_valido
		
		; parede normal, pedimos proximo movimento
		loadn r6, #'}'
		cmp r6, r7
		jeq le_direcao
		
		; perdeu o jogo com parede mortal
		loadn r6, #'{'
		cmp r6, r7
		loadn r0, #0
		jeq game_over
		
		; ganhou o jogo
		loadn r6, #')'
		cmp r6, r7
		loadn r0, #1
		jeq game_over
				
; fim movimentação-----------------------------------

apaga_menu: 
		loadn r0, #575
		loadn r1, #586
		loadn r3, #40
		loadn r4, #80
		loadn r2, #' '
		
loop_apaga_menu:
		cmp r0,r1
		jeq fim_apaga_menu
		
		outchar r2,r0
		add r5,r0,r4
		outchar r2,r5
		add r5,r5,r3
		outchar r2,r5
		
		inc r0
		jmp loop_apaga_menu
		
fim_apaga_menu: rts	

; faz a construção do mapa
constroi_cenario:
		loadn r1, #0
		loadn r2, #1200
		
		; Um loop percorre todo o vetor que constitui o cenario inicial declarado como a 'parede'
loop1:	cmp r1,r2
		jeq fim_cenario
		loadi r3,r0
		outchar r3,r1
		inc r1
		inc r0
		jmp loop1
		
fim_cenario: rts
