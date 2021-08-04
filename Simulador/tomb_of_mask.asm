; ────┤ Trabalho de Prática em Organização Computacional │ Agosto 2021 ├────
; Gabriel Victor Cardoso Fernandes - 11878296
; Gabriel Alves Kuabara - 11275043
; Lourenço de Salles Roselino - 11796805

; Caracteres que constroem o Mapa
; boneco - z amarelo
; parede normal - } azul
; parede mortal - { vermelho
; bandeira de chegada - ) rosa
; moedinhas - * amarela

jmp main

; ────────┤ Strings e dados do menu e do mapa ├────────
menu_art : string "                                                                                                                                                                          Tomb of the Mask                                                                                                                                                                                      Gabriel Alves Kuabara                                                       Gabriel Victor Cardoso Fernandes                                                 Lourenyo de Salles Roselino                                                                                                       }}}}}}}}                                }      }                                } }  } }                                }      }                                } }  } }                                } }}}} }                                }      }                                }}}}}}}}                                                                                                                                                                                                                                Pressione Enter para Jogar       "
mapa : string "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}*                    )   }}}}}}}}}}}}}}}*}}}}}}}}}}}}}}}}}}}}}}} }}}}}}}}}}}}}}}*}}}}}}}}}}}}}}}}}}}}}}}   }}}}}}}}}}}}}*}}}}}}}}}}}******}}}}}} } }}}}}}}}}}}}}*}}}}}}}}}}}*}}{}*}}}}        }}}}}}}}}}******************}}}}  * *      }}}}}}}*}          }}}*}}}}}}} ***   }} }}}}}}}*              *}}}}}}  }}*      }}}}}}}*            }}*}}}}}}    *   }}}}}}}}}}*}********************        }}}}}}}}}}*}}}}}}}}}}} }}}}}}}}}}}}}}}}}}}}}}}}}}}*}}}*******}                         }}}*}}}*******} }}}} }}}}}}}}}}}}}}}}}} }}}**********}} }}}} }}}}}}}}}}}}}}}}}}  }}}}}}}}}}}}}} }}}}****************}}}  }}}}}}****}}}} }}}}*********************}}}}}**********}}}}*              **** }}}}}}****}}}}}*}}}{*      }      }****}}}}}  ****}*****}}}{********      }}}}}}}}}} }***}}*}}}}}}}}}}}}}}}*}}}}} }}}}}}}}}} }}}}}}*}}}}}}}}}}}}}}}*}}}}} }}}}}}}}}} }}}}}**}}}}}}}}}}}}}}}*}}}}} }}}}}}}}}} }}}}}*}}}}}}}}}}}}}}}}*}}}}} }}}}}}}}}}***************************** }}}}}}}}}} }}}}}*}}}}}}}}}}}}}}}} }}}} }}}}}}}}}}} }}}}}*}}}}}}}}}}}}}}}}  s        }}}}}{*                                  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}             GET TO THE )               "

; Temos 2 linhas pra printar: menu_art[1080] e menu_art[1120]
mensagem_vitoria: string "Parabens, voce venceu"
mensagem_derrota: string "Tente novamente parca"

cores_sprites : var #5
static cores_sprites + #0, #2816	; Cor da moeda
static cores_sprites + #1, #1024	; Cor da parede_normal
static cores_sprites + #2, #2304	; Cor da parede_mortal
static cores_sprites + #3, #3328	; Cor da bandeira
static cores_sprites + #4, #0		; sem cor

; ─────────────────────────────────────────────────────

; ──────────┤ Dados relacionados ao jogador ├──────────
posicao_inicial : var #1
static posicao_inicial, #1067	; Posicao inicial do boneco

conta_bancaria: var #1			; guarda quanta moedinhas o jogador tem
static conta_bancaria + #0, #0

posicao_print_moedas: var #1
static posicao_print_moedas, #1196	; Posicao da tela onde imprimir as moedas

;Variaveis de velocidade
velocidade : var #2
static velocidade + #0, #40	; velocidade vertical   (subindo || descendo)
static velocidade + #1, #1	; velocidade horizontal (esquerda || direita)
; ─────────────────────────────────────────────────────

; ────────────┤ Dados para delay do clock ├────────────
numero_loops : var #1
static numero_loops, #1

numero_nops_por_loop : var #1
static numero_nops_por_loop, #300000
; ─────────────────────────────────────────────────────
                         
main:
	loadn r7, #0	; Carrega estado inicial do jogo (0 = inicial | 1 = perdeu | 2 = ganhou)
	loadn r6, #0

imprime_menu:
	loadn r0, #0		; r0 = print_pos
	loadn r1, #menu_art ; r1 = end(menu_art)
	call imprime_string	; Printa menu

	cmp r6, r7		; Caso o estado do jogo nao seja o inicial, acabar programa
	jeq iniciar_jogo
	call delay_clock
	halt
	
	iniciar_jogo:
	; Inicializa timer pro usuario apertar Enter
	loadn r0, #0
	loadn r3, #300000
		
; ────────────┤ Espera até o usuário apertar enter para começar o jogo ├────────────
loop_menu:
	loadn r2, #13 ; Caracter do enter
	inc r0
	cmp r0, r3
	jeq main
	
	inchar r1 ; Le teclado
	cmp r1, r2
	jeq inicia_jogo ; Se apertou Enter, inicia o jogo.	
	jmp loop_menu   ; Se não, fica em loop
		
inicia_jogo:
	loadn r0, #0	; r0 = print_pos
	loadn r1, #mapa	; r1 = end(mapa)
	call imprime_string	; Printa o mapa
	
	; ────┤ Daqui pra frente a pos_boneco vai estar sempre em r0 ├────
	load r0, posicao_inicial ; r0 = pos_inicial do boneco
	loadn r6, #0
	call imprime_boneco

; ────────────┤ Leitura da movimentação ├────────────
le_direcao:
	loadn r1, #0
	loadn r2, #0
	
	inchar r1		; r1 = dir | direção lida pelo usuario
	
	cmp r1, r2		; nao leu nada -> loop pra ler denovo
	jeq le_direcao

; r1 = direção lida
checa_movimento:
	; ────────────┤ Checagem de movimento vertical ├────────────
	loadn r3, #0	; velocidades[0] = #40 -> vertical (subindo || descendo)
	
	; ────────────┤ Checagem subindo ├────────────
	loadn r2, #'w'
	cmp r1, r2		; dir == 'w'
	loadn r5, #velocidade_decrementando
	jeq velocidade_decrementando
	
	; ────────────┤ Checagem descendo ├────────────
	loadn r2, #'s'
	cmp r1, r2		; dir == 's'
	loadn r5, #velocidade_incrementando
	jeq velocidade_incrementando
	
	; ────────────┤ Checagem de movimento horizontal ├────────────
	loadn r3, #1	; velocidades[1] = #1 -> horizontal (esquerda || direita)
	
	; ────────────┤ Checagem direita ├────────────
	loadn r2, #'d'
	cmp r1, r2		; dir == 'd'
	loadn r5, #velocidade_incrementando
	jeq velocidade_incrementando

	; ────────────┤ Checagem esquerda ├────────────
	loadn r2, #'a'	; velocidades[3] = indo pra esquerda
	cmp r1, r2		; dir == 'a'
	loadn r5, #velocidade_decrementando
	jeq velocidade_decrementando
	
	jmp le_direcao	; Se não moveu -> Le entrada de novo

; ────────────┤ Fim da leitura de movimentação ├────────────	

; ────────────┤ Funções de velocidade ├────────────
; Geram a velocidade de movimentação no r2
; Movimento continuo dá jump pra r5 (evita ifs desnecessarios)
velocidade_incrementando:	; Movimento para direita ou para baixo -> Incrementa pos
	nop
	loadn r1, #velocidade	; r1 = end(velocidade)
	add r1, r1, r3			; r1 = end(velocidade[i])
	loadi r2, r1			; r2 = velocidade[i]
	
	add r1, r0, r2	; r1 = prox_pos | prox_pos = pos_atual + velocidade
	
	jmp confere_colisao

velocidade_decrementando:	; Movimento para esquerda ou para cima -> Decrementa pos
	nop
	loadn r1, #velocidade	; r1 = end(velocidade)
	add r1, r1, r3			; r1 = end(velocidade[i])
	loadi r2, r1			; r2 = velocidade[i]
	
	sub r1, r0, r2	; r1 = prox_pos | prox_pos = pos_atual - velocidade

; ────────────┤ Logica de Colisao ├────────────
; r0 = pos_atual | r2 = velocidade
confere_colisao:
	loadn r6, #mapa	; r6 = end(mapa)
	add r6, r6, r1	; r6 = end(mapa[prox_pos])
	loadi r6, r6	; r6 = mapa[prox_pos] | sprite que vamos comparar
	
	; ────┤ Posicao vazia: continua movendo ├────
	loadn r4, #' '
	cmp r6, r4
	jne posicao_nao_vazia
	
	call movimentar_boneco
	; Continua movendo: pula para função de velocidade (que o end tá no r5)
	push r5
	rts
	; ────────────────────────────────────────
	
	posicao_nao_vazia:
	; ────┤ Moeda: fica rico ├────
	loadn r4, #'*'
	cmp r6, r4
	jne nao_coletou_moeda

	call atualizar_moedas	
	call movimentar_boneco
	; Continua movendo: pula para função de velocidade (que o end tá no r5)
	push r5
	rts
	; ────────────────────────────────────────
	
	nao_coletou_moeda:
	; ────┤ Parede normal: pede movimento ├────
	loadn r4, #'}'
	cmp r6, r4
	jne nao_bateu_em_parede_normal
	
	loadn r6, #0
	call imprime_boneco
	jeq le_direcao
	
	nao_bateu_em_parede_normal:
	; ────┤ Parede mortal: perder jogo ├────
	loadn r4, #'{'
	cmp r6, r4
	loadn r7, #1	; Jogador perdeu
	jeq game_over
	
	; ────┤ Bandeira: ganhar jogo ├────
	loadn r4, #')'
	cmp r6, r4
	loadn r7, #2	; Jogador ganhou

; r7 = estado final (0 = nada | 1 = derrota | 2 = vitoria)
game_over:
	loadn r5, #1
	loadn r6, #mensagem_derrota
	cmp r5, r7		; estado_final == derrota
	jeq game_over_saida
	
	loadn r5, #2
	loadn r6, #mensagem_vitoria
	cmp r5, r7	; estado_final == vitoria
	
	game_over_saida:	; Copia string resultado e sai do jogo
	call copia_string
	jeq imprime_menu

; ────────────┤ Fim logica de Colisao ├────────────

; ────────────┤ Movimentação ├────────────
; r0 = pos_atual | r1 = prox_pos
movimentar_boneco:
	push r2
	push r3
	
	; ────┤ Apagando o boneco da pos_atual ├────
	loadn r2, #' '
	outchar r2, r0	; Apaga boneco do mapa[r0]
	; ──────────────────────────────────────────
	
	; ────┤ Atualiza e printa o boneco pra prox_pos ├────
	mov r0, r1		; r0 = prox_pos
	loadn r3, #mapa	; r3 = end(mapa)
	add r1, r0, r3	; r1 = end(mapa[prox_pos])
	storei r1, r2	; Apaga o que estiver na proxima posicao
	call imprime_boneco
	; ───────────────────────────────────────────────────
	
	call delay_clock
	pop r3
	pop r2
	rts

; ────────┤ Fim da Movimentação ├────────

; ────────────┤ Utilidades Gerais ├────────────
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
	loadi r4, r1	; ; r4 = sprite  | sprite = string[i]
	cmp r4, r3		; sprite == '\0' -> terminou de printar
	jeq imprime_string_fim
	
	
	loadn r5, #'*'
	cmp r4, r5		; sprite = moeda
	loadn r2, #0
	jeq imprime_sprite
	
	loadn r5, #'}'
	cmp r4, r5		; sprite = parede_normal
	loadn r2, #1
	jeq imprime_sprite
	
	loadn r5, #'{'
	cmp r4, r5		; sprite = parede_mortal
	loadn r2, #2
	jeq imprime_sprite
	
	loadn r5, #')'
	cmp r4, r5		; sprite = bandeira
	loadn r2, #3
	jeq imprime_sprite
	
	loadn r2, #4
	
	imprime_sprite:
	add r2, r2, r6	; cor_sprite = end(cores_sprites[sprite])
	loadi r2, r2	; cor_sprite = cores_sprites[sprite]
	add r4, r2, r4	; sprite + cor_sprite
	outchar r4, r0
	
	inc r0	; pos++
	inc r1	; i++ (string[i])
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

atualizar_moedas:
	push r0
	push r1
	push r2
	push r3
	push r4
	
	load r2, conta_bancaria
	inc r2
	store conta_bancaria, r2
	
	load r0, posicao_print_moedas
	loadn r1, #2858		; r1 = moeda amarela
	outchar r1, r0
	
	inc r0
	
	loadn r1, #100	; Primeiro digito
	div r1, r2, r1
	
	loadn r3, #2864	; r3 = cor amarelo
	add r1, r3, r1	; r1 = primeiro digito + cor amarelo
	outchar r1, r0
	
	inc r0
	
	loadn r4, #10	; Segundo digito
	div r1, r2, r4
	mod r1, r1, r4
	
	add r1, r3, r1	; r1 = segundo digito + cor amarelo
	outchar r1, r0
	
	inc r0
	
	loadn r1, #10	; Terceiro digito
	mod r1, r2, r1
	
	add r1, r3, r1	; r1 = terceiro digito + cor amarelo
	outchar r1, r0
	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

; Escreve uma string dentro de outra a partir da posicao no r6
; r6 = end(string)
copia_string:
	loadn r3, #1089		; Posicao inicial da mensagem de finalizacao
	loadn r4, #menu_art	; r4 = end(menu)
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

; Funcao de delay: mantém o clock ocupado para atrasar o jogo
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
