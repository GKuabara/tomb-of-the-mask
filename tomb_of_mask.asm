; Trabalho de Prática em Organização Computacional

; Caracteres que constroem o Mapa
; buneco - z amarelo
; rastro 1 - > amarelo
; parede normal - } azul
; parede mortal - { vermelho
; linha de chegada - ) branco
; start - s verde
; moedinhas - * amarela 

jmp main

; ------- Strings e dados do menu e do mapa ------------------
menu_art : string "                                                                                                                                                                            Nome do Jogo                                                                                                                                                                                        Gabriel Alves Kuabara                                                       Gabriel Victor Cardoso Fernandes                                                 Lourenyo de Salles Roselino                                                                                                       }}}}}}}}                                }      }                                } }  } }                                }      }                                } }  } }                                } }}}} }                                }      }                                }}}}}}}}                                                                                                                                                                                                                                Pressione Enter para Jogar       "
mapa : string "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}*                    )   }}}}}}}}}}}}}}}*}}}}}}}}}}}}}}}}}}}}}}} }}}}}}}}}}}}}}}*}}}}}}}}}}}}}}}}}}}}}}}   }}}}}}}}}}}}}*}}}}}}}}}}}******}}}}}} } }}}}}}}}}}}}}*}}}}}}}}}}}*}}{}*}}}}        }}}}}}}}}}******************}}}}  * *      }}}}}}}*}          }}} }}}}}}} ***   }} }}}}}}}*              *}}}}}}  }}*      }}}}}}}*            }}*}}}}}}    *   }}}}}}}}}}*}********************        }}}}}}}}}}*}}}}}}}}}}} }}}}}}}}}}}}}}}}}}}}}}}}}}}*}}}*******}                         }}}*}}}*******} }}}} }}}}}}}}}}}}}}}}}} }}}**********}} }}}} }}}}}}}}}}}}}}}}}}  }}}}}}}}}}}}}} }}}}****************}}}  }}}}}}****}}}} }}}}*********************}}}}}**********}}}}*              **** }}}}}}****}}}}}*}}}{*      }      }****}}}}}  ****}*****}}}{********      }}}}}}}}}} }***}}*}}}}}}}}}}}}}}}*}}}}} }}}}}}}}}} }}}}}}*}}}}}}}}}}}}}}}*}}}}} }}}}}}}}}} }}}}}**}}}}}}}}}}}}}}}*}}}}} }}}}}}}}}} }}}}}*}}}}}}}}}}}}}}}}*}}}}} }}}}}}}}}}***************************** }}}}}}}}}} }}}}}*}}}}}}}}}}}}}}}} }}}} }}}}}}}}}}} }}}}}*}}}}}}}}}}}}}}}}  s        }}}}}{*                                  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}             GET TO THE )               "


; Temos 2 linhas pra printar: 1080 e 1120
mensagem_vitoria: string "abluble"
mensagem_derrota: string "akwtitita"

cores_sprites : var #5
static cores_sprites + #0, #2816	; Cor da moeda
static cores_sprites + #1, #1024	; Cor da parede_normal
static cores_sprites + #2, #2304	; Cor da parede_mortal
static cores_sprites + #3, #3328	; Cor da bandeira
static cores_sprites + #4, #0		; sem cor

; ------------------------------------------------------------

; ------ Dados relacionados ao jogador -------
direcao : var #1

posicao : var #2
static posicao + #0, #1067	; Posicao do boneco
static posicao + #1, #1067	; Posicao do rastro

conta_bancaria: var #3		; guarda quanta moedinhas o jogador tem
static conta_bancaria + #0, #0
static conta_bancaria + #1, #0
static conta_bancaria + #2, #0

posicao_print_moedas: var #1
static posicao_print_moedas, #1196

;Variaveis de velocidade
velocidade : var #5
static velocidade + #0, #0	; velocidade parado
static velocidade + #1, #40	; velocidade subindo
static velocidade + #2, #1	; velocidade direita
static velocidade + #4, #40	; velocidade descendo
static velocidade + #3, #1	; velocidade esquerda

;0 parado
;par -> somando
;impar -> decrementando

; ---------------------------------------------

; ------ Dados para delay do clock ------------
valordelay : var #1
offsetdelay : var #1
decdelay : var #1
delay: var #1			; variavel pra guardar o tempo de delay de cada movimento

static decdelay, #1000
static valordelay, #1000000
static offsetdelay, #50
static delay, #100000

; ----------------------------------------------
                              
main:	
	loadn r0, #0		; Posicao na tela que inicia o print
	loadn r1, #menu_art ; Carregando o end do menu
	loadn r2, #256		; Carrega a cor da tela

	call imprime_string

	loadn r0, #0 		; Inicializa timer pro usuario apertar Enter
	loadn r3, #300000
		
loop_menu:
	; Espera até o usuário apertar enter para começar o jogo
	
	; Loop esperando usuario apertar enter
	loadn r2, #13 ; Caracter do enter
	inc r0
	cmp r0, r3
	jeq main
	
	inchar r1 ; Le teclado
	cmp r1, r2
	jeq inicia_jogo ; Se apertou Enter, inicia o jogo.	
	jmp loop_menu   ; Se não, fica em loop
		
inicia_jogo:
	loadn r0, #0
	loadn r1, #mapa
	loadn r2, #512
	
	call imprime_string	; Printa o mapa
	
	; --- Daqui pra frente a pos_boneco vai estar sempre em r0 ----
	load r0, posicao ; r0 = pos_inicial do buneco
	loadn r6, #0
	call imprime_boneco

; -------- Fazendo leitura da movimentação -----
le_direcao:
	loadn r1, #0
	loadn r2, #0
	
	inchar r1		; r1 = dir | direção lida pelo usuario
	
	cmp r1, r2
	jeq le_direcao

; r1 = direção lida
checa_movimento:
	; ---- Checagem subindo ----
	loadn r3, #1	; velocidades[1] = subindo
	loadn r2, #'w'
	cmp r1, r2		; dir == 'w'
	loadn r5, #velocidade_decrementando
	jeq velocidade_decrementando
	
	; ---- Checagem direita ----
	loadn r3, #2	; velocidades[2] = indo pra direita
	loadn r2, #'d'
	cmp r1, r2		; dir == 'd'
	loadn r5, #velocidade_incrementando
	jeq velocidade_incrementando

	; ---- Checagem descendo ----
	loadn r3, #4	; velocidades[4] = descendo
	loadn r2, #'s'
	cmp r1, r2		; dir == 's'
	loadn r5, #velocidade_incrementando
	jeq velocidade_incrementando
	
	; ---- Checagem esquerda ----
	loadn r3, #3
	loadn r2, #'a'	; velocidades[3] = indo pra esquerda
	cmp r1, r2		; dir == 'a'
	loadn r5, #velocidade_decrementando
	jeq velocidade_decrementando
	
	; Se não moveu -> velocidade[0] = parado (valor 0)
	;loadn r3, #0
	jmp le_direcao

; Gera a velocidade de movimentação no r2
; Se o personagem for para direita ou para baixo -> Incrementa pos
velocidade_incrementando:
	nop
	nop
	loadn r1, #velocidade	; r1 = end(velocidade)
	add r1, r1, r3			; r1 = end(velocidade[i])
	loadi r2, r1			; r2 = velocidade[i]
	
	add r1, r0, r2	; r1 = prox_pos | prox_pos = pos_atual + velocidade
	
	jmp confere_colisao

; Gera a velocidade de movimentação no r2
; Se o personagem for para esquerda ou para cima -> Decrementa pos
velocidade_decrementando:
	nop
	nop
	loadn r1, #velocidade	; r1 = end(velocidade)
	add r1, r1, r3			; r1 = end(velocidade[i])
	loadi r2, r1			; r2 = velocidade[i]
	
	sub r1, r0, r2	; r1 = prox_pos | prox_pos = pos_atual - velocidade

; -------- Fim da leitura de movimentação -----

; ----------- Logica de Colisao -----------
; r0 = pos_atual | r2 = velocidade
confere_colisao:
	loadn r6, #mapa	; r3 = end(mapa)
	add r6, r6, r1	; r3 = end(mapa[prox_pos])
	loadi r6, r6	; r3 = mapa[prox_pos] | sprite que vamos comparar
	
	; ---- Posicao vazia -> continua movendo ----
	loadn r4, #' '
	cmp r6, r4
	jne posicao_nao_vazia
	
	call movimentar_boneco
	; Esse bloco dá um jmp pra funcao com endereço no r5
	push r5
	rts
	; ------------------------------------------------
	
	posicao_nao_vazia:
	; ---- Moeda -> fica rico ----
	loadn r4, #'*'
	cmp r6, r4
	jne nao_coletou_moeda

	push r2
	
	load r2, conta_bancaria
	inc r2
	store conta_bancaria, r2
	call printar_moedas
	
	pop r2
	
	call movimentar_boneco
	; Esse bloco dá um jmp pra funcao com endereço no r5
	push r5
	rts
	; ------------------------------------------------
	
	nao_coletou_moeda:
	; ---- Parede normal -> pede movimento ----
	loadn r4, #'}'
	cmp r6, r4
	jne nao_bateu_em_parede_normal
	
	loadn r6, #0
	call imprime_boneco
	jeq le_direcao
	
	nao_bateu_em_parede_normal:
	; ---- Parede mortal -> morre ----
	loadn r4, #'{'
	cmp r6, r4
	loadn r7, #1
	jeq game_over
	
	; ---- Bandeira -> vive ----
	loadn r4, #')'
	cmp r6, r4
	loadn r7, #2

; r7 = estado final (0 = nada | 1 = derrota | 2 = vitoria)
game_over:
	loadn r5, #1
	loadn r6, #mensagem_derrota
	cmp r5, r7		; estado_final == derrota
	jeq game_over_saida
	
	loadn r5, #2
	loadn r6, #mensagem_vitoria
	cmp r5, r7	; estado_final == vitoria
	
	game_over_saida:
	call copia_string
	jeq main

	
; ----------- Fim Logica de Colisao -----------

; -------- Movimentação -----


; r0 = pos_atual | r1 = prox_pos
movimentar_boneco:
	push r2
	push r3 
	
	; --- Apagando o boneco da pos_atual --
	loadn r2, #' '
	outchar r2, r0	; Apaga boneco do mapa[r0]
	; -------------------------------------
	
	; --- Atualiza e printa o boneco pra prox_pos --
	mov r0, r1		; r0 = prox_pos
	loadn r3, #mapa	; r3 = end(mapa)
	add r1, r0, r3	; r1 = end(mapa[prox_pos])
	storei r1, r2	; Apaga o que estiver na proxima posicao
	call imprime_boneco
	; -------------------------------------
	
	call delay_clock
	pop r3
	pop r2
	rts
	; -------- Fim da movimentação -----

; ----------------- Utilidades Gerais -----------------

; r0 = posicao da tela | r1 = end da string | r2 = cor da string
imprime_string:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	
	loadn r3, #'\0'		; Criterio de parada do print da string
	loadn r6, #cores_sprites
	
imprime_string_loop:
	; r4 = sprite  | sprite = menu[i]
	loadi r4, r1
	cmp r4, r3		; sprite = '\0' -> terminou de printar
	jeq imprime_string_fim
	
	
	loadn r5, #'*'	; 
	cmp r4, r5		; sprite = moeda
	loadn r2, #0
	jeq imprime_sprite
	
	loadn r5, #'}'	; 
	cmp r4, r5		; sprite = parede_normal
	loadn r2, #1
	jeq imprime_sprite
	
	loadn r5, #'{'	; 
	cmp r4, r5		; sprite = parede_mortal
	loadn r2, #2
	jeq imprime_sprite
	
	loadn r5, #')'	; 
	cmp r4, r5		; sprite = bandeira
	loadn r2, #3
	jeq imprime_sprite
	
	loadn r2, #4
	
	imprime_sprite:
	add r2, r2, r6
	loadi r2, r2
	add r4, r2, r4	; sprite += cor | cor ocupa os bits altos
	outchar r4, r0
	
	inc r0	; pos++
	inc r1	; i++ (menu[i])
	jmp imprime_string_loop

imprime_string_fim:
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

; r0 = pos_boneco
imprime_boneco:
	push r1
	push r2
	
	loadn r1, #'z'	; r1 = boneco
	loadn r2, #768	; Cor do boneco
	add r1, r1, r2
	outchar r1, r0	; Printa boneco em mapa[r0]

	pop r2
	pop r1
	rts

; r2 = valor na conta bancaria
printar_moedas:
	push r0
	push r1
	push r3
	push r4
	
	load r0, posicao_print_moedas
	loadn r1, #2858
	outchar r1, r0
	
	inc r0
	
	loadn r1, #100
	div r1, r2, r1
	
	loadn r3, #2864
	add r1, r3, r1
	outchar r1, r0
	
	inc r0
	
	loadn r4, #10
	div r1, r2, r4
	mod r1, r1, r4
	
	add r1, r3, r1
	outchar r1, r0
	
	inc r0
	
	loadn r1, #10
	mod r1, r2, r1
	
	add r1, r3, r1
	outchar r1, r0
	
	pop r4
	pop r3
	pop r1
	pop r0
	rts

; r6 = end(string)
copia_string:
	loadn r3, #1080		; Posicao inicial da mensagem de finalizacao
	loadn r4, #menu_art		; r4 = end(menu)
	add r3, r3, r4		; r3 = end(menu[pos_mensagem])
	loadn r4, #'\0'		; Caractere de parada da string
	
	copia_string_loop:
	loadi r5, r6	; r5 = menu[pos_mensagem]
	cmp r5, r4		; r5 == '\0' -> terminou de printar
	jeq copia_string_fim
	
	copia_caractere:
	storei r3, r5

	inc r3	; menu_pos++
	inc r6	; string_pos++
	jmp copia_string_loop
	
	copia_string_fim:
	rts

; Faz uns nops pra atrasar o clock
delay_clock:
	push r0
	push r1
	push r2
	
	loadn r0, #1		; n de loops
	loadn r2, #0
	
	delay_loop:
	loadn r1, #300000	; n de nops
	dec r0
	delay_nop:	; roda (n_loops * n_nops) vezes
	nop
	dec r1
	cmp r1, r2
	jne delay_nop
	
	cmp r0, r2
	jne delay_loop
	
	pop r2
	pop r1
	pop r0
	rts