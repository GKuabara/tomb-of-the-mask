; Trabalho de Prática em Organização Computacional

; buneco - z amarelo
; parede normal - } azul
; parede mortal - } vermelho
; linha de chegada - ) branco
; start - } verde
; moedinhas - * amarela

jmp main

menu_art : string "                                                                                                                                                                            Nome do Jogo                                                                                                                                                                                        Gabriel Alves Kuabara                                                       Gabriel Victor Cardoso Fernandes                                                 Lourenyo de Salles Roselino                                                                                                       }}}}}}}}                                }      }                                } }  } }                                }      }                                } }  } }                                } }}}} }                                }      }                                }}}}}}}}                                                                                                      Pressione Enter para Jogar                                                                                                                                 "

direcao : var #1

posicao : var #1

velocidade : var #5
static velocidade + #0, #0 ; velocidade parado
static velocidade + #1, #40 ; velocidade subindo
static velocidade + #2, #1 ; velocidade direita
static velocidade + #3, #40 ; velocidade descendo
static velocidade + #4, #1 ; velocidade esquerda
      
                              
main:	
		loadn r0, #menu_art
		call menu ; constroi tela de menu
		
		halt
		
		; Espera até o usuário apertar enter para começar o jogo
menu:
		loadn r2, #13 ; Caracter do enter
		loadn r0, #0
		loadn r3, #156895

loop_menu: 
		inc r0
		cmp r0, r3
		jeq menu
		inchar r1 ; Le teclado
		cmp r1, r2
		jeq inicia_jogo ; Se apertou enter, inicia o jogo.	
		jmp loop_menu   ; Se não, fica em loop
		
inicia_jogo:
		call apaga_menu
		loadn r0, #mapa1
		call constroi_cenario
		
		load r1, #posicao_inicial
		
movimentacao:
		; recebe o prox movimento
		; checa se posicao é valida
		; comparaçao -> se nao for morte -> fim_game_over
		; comparaçao -> se for parede -> fica no lugar
		; else -> se for valido -> movimenta
		; atualiza posicao
		; printa nova posicao
		; loop movimentacao

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
