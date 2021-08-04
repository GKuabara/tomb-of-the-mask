# Tomb of the Mask
Game developed for the course "Practice in Computer Organization at University of São Paulo.

Inspired by the mobile game "Tomb of the Mask".

### Participants
* Gabriel Alves Kuabara - nUSP 11275043
* Gabriel Victor Cardoso Fernandes - nUSP 11878296
* Lourenço de Salles Roselino - nUSP 11796805

# How to play
The files "tomb_of_mask.asm" and "charmap.mif" should be in "Simulador/"

- In the folder "Simulador" open "Sublime Text 3/sublime_text.exe" (**do not click on update**)
- in the modified Sublime, open "tomb_of_mask.asm"
- press F7 to launch the simulator
- press Home to start playing!

The keys for moving are "a", "w", "s", "d".

# Presentation of this project
https://drive.google.com/file/d/1QArHdNm-3OhqUi5Dp47jkgN13p3JA9r2/view?usp=sharing

# Coin/Score Displayer snippet
The following snippet **only works when displaying the Coins/Score with a color**,
if you remove the color replace it by **48** (0 in the ASCII table).

```asm
; conta_bancaria é a variável que guarda a quantidade de moedas
atualizar_moedas:
	push r0
	push r1
	push r2
	push r3
	push r4
	
	load r2, conta_bancaria
	inc r2						; atualiza conta com +1
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
```