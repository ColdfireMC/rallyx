include timer.inc

permanencia_bandera=100
scancode_esp=57
bande_up=7404h
humo_up=08b2h
humo_do=0020h
or_arriba=0
or_abajo=2
or_izquierda=4
or_derecha=6
esta_up=00000001b
esta_up_iz=00000011b
esta_up_de=00000101b
esta_do=00001000b
esta_do_iz=00001010b
esta_do_de=00001100b
esta_de=00000100b
esta_iz=00000010b
scancode_up=048h
scancode_do=050h
scancode_iz=04bh
scancode_de=04dh
vacio=0720h
autop_up=04F8h
autop_do=04F9h
autop_iz=04FAh
autop_de=04FBh
autoe_up=02F8h
autoe_do=02F9h
autoe_iz=02FAh
autoe_de=02FBh
camino_hor=08FF4h
camino_ver=08FF5h
camino_cru=08FF7h
.286
    video_mem SEGMENT at 0b800h

    video_cell STRUCT
	  atrib db  ?
	  car	db  ?
    Video_cell ends
    video_fila struct
       fila video_cell 40 dup (<,>)
       video_fila ends
    pagina struct
       columna video_fila 25 dup(<>)
    pagina ends
    video_buf pagina <>

    video_mem ENDS

    localstack segment STACK 'STACK'
	byte 100h dup ('S')
    localstack ENDS
     localvar SEGMENT 'DATA'
     mssg2   db "ingresa tu rut ",0Dh,0Ah,'$'
     mssg3   db "rut correcto$"
     errmsg1 db "caracter fuera del conjunto permitido",0Dh,0Ah,'$'
     errmsg2 db "RUT incorrecto",0Dh,0Ah,'$'
     rut     db '1','8','0','3','8','3','7','2','-','7','$'
     inrut   db 11 DUP (0)
     cmpbuf  db '1','2','3','4','5','6','7','8','9','0','-'

      ;variales del reloj
      counter dw 0
      counter_sprite dw 0
	  counter_enemigo dw 0
      counter_player dw 0
      counter_ruta dw 0
      counter_humo dw 0
	  counter_bandera dw 0
      oldvec dw 2 dup(0)
    ;variables de juego
      largo_playfield dw 0
      player_map db esta_do
      posicion struct
	    x  db  0
	    y  db  0
      posicion ends
      atr struct
	ruta_index db (0)
	pos_actual posicion <>
	pos_objetivo  posicion <>
	car dw 4 dup (0)
	or_actual dw (0)
	puntos dw (0)
	vidas dw (3)
      atr ends
      player atr <>
      enemigo atr <>
      bandera atr <>
      humo	  atr <>
      dic_camino dw camino_hor, camino_ver, camino_cru

     ;definiciones graficas

     carfont_up db 00000000b,00000000b,00000000b,00011000b,01111110b,00011000b,00011000b,00111100b,00100100b,11111111b,11111111b,01100110b,01100110b,00000000b,00000000b,00000000b

     carfont_do db 00000000b,00000000b,00000000b,01100110b,01100110b,11111111b,11111111b,00100100b,00111100b,00011000b,00011000b,01111110b,00011000b,00000000b,00000000b,00000000b

     carfont_iz db 00000000b,00000000b,00000000b,00000110b,00000110b,01000111b,01011111b,11101110b,11101110b,01011111b,01000111b,00000110b,00000110b,00000000b,00000000b,00000000b

     carfont_de db 00000000b,00000000b,00000000b,01100000b,01100000b,11100010b,11111010b,01110111b,01110111b,11111010b,11100010b,01100010b,01100000b,00000000b,00000000b,00000000b

     caminov	db 10011001b,10011001b,10000001b,10000001b,10000001b,10011001b,10011001b,10011001b,10011001b,10011001b,10000001b,10000001b,10000001b,10011001b,10011001b,10011001b

     caminoh	db 11111111b,11111111b,00000000b,00000000b,00000000b,00000000b,00000000b,11100111b,11100111b,00000000b,00000000b,00000000b,00000000b,00000000b,11111111b,11111111b

     cruce      db 10011001b,10000001b,00000000b,00000000b,00000000b,00000000b,00000000b,10000001b,10000001b,00000000b,00000000b,00000000b,00000000b,00000000b,10000001b,10011001b
     tabla_x db 255 dup(0)
	 tabla_y db 4,8,15,21, 24
	 tabla_dum db 250 dup(0)
playfield dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,00923h,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,00C20h,autop_up,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw camino_cru,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor
dw camino_hor,camino_hor,camino_hor,camino_cru,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor
dw camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_cru,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver
dw camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver
dw camino_cru,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor
dw camino_hor,camino_hor,camino_hor,camino_cru,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor
dw camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_cru,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver
dw camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver
dw camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver
dw camino_ver,vacio,00A20h,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,camino_cru,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor
dw camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_cru,camino_hor,camino_hor,camino_hor,camino_hor
dw camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_cru
dw camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver
dw camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver
dw camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,camino_cru,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor
dw camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_cru,camino_hor,camino_hor,camino_hor,camino_hor
dw camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_cru
dw camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,camino_ver,vacio,vacio,vacio,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver,vacio,vacio,vacio,vacio
dw vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,vacio,camino_ver
dw camino_cru,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor
dw camino_hor,camino_hor,camino_hor,camino_cru,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor
dw camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_hor,camino_cru
SIZEOFplayfield EQU $-playfield
lengthofplayfield EQU Sizeofplayfield/2
    
localvar ENDS

    code_seg SEGMENT 'CODE'
	assume cs:code_seg, ds:localvar, es:video_mem, ss:localstack

    Main PROC
    mov ax, localvar
    mov ds, ax
    mov ax, video_mem
    mov es, ax
    ;call cord2addr
    call init_main
    jc general_error
    call juego

    general_error:
    mov bx, 1
    call TIMER_INT_INSTALL
    mov ah, 04Ch
    int 21h


    MAIN ENDP
    juego PROC

      siguiente_turno:
       mov ax, 1000
	   mov bx, player.puntos
	   cmp ax, bx
	   jbe fin_de_juego
       call get_input
       jc fin_de_juego
      

       mov ax, 3
       cmp ax, counter_player
       ja paso0
       call animar_player
       mov counter_player, 0
       
       paso0:
       call animar_humo
       call animar_bandera	   
       mov ax, 2
       cmp ax, counter_enemigo
       ja paso1 
       mov al, enemigo.pos_actual.x
       mov ah, enemigo.pos_actual.y
       mov bl, humo.pos_actual.x
       mov bh, humo.pos_actual.y
       cmp ax, bx
	   je paso1
       
       call animar_enemigo
	   mov counter_enemigo, 0
       
       paso1:
       mov ax, 5
       cmp ax, counter_ruta
       ja paso2

       call calcular_ruta
       mov counter_ruta, 0

       paso2:
       clc
       call video_update
	   clc 
       call arbitro_puntaje
       
	   jnc siguiente_turno
       
	   
	   
	   mov ax, 0
       cmp ax, player.vidas
       je fin_de_juego
       call init_player
	   mov bandera.or_actual, or_arriba
       
	   jmp siguiente_turno
	  
    fin_de_juego:

    ret
    juego ENDP
    animar_bandera proc
	      
		  mov ax, permanencia_bandera
		  cmp ax, counter_bandera
		  ja mantener_bandera
		  
		  read_PIT_count:
	     
	      cli
	      mov al, 10000000b    ; al = channel in bits 6 and 7, remaining bits clear
	      out 43h, al         ; Send the latch command
 
	      in al, 40h          ; al = low byte of count
	      mov ah, al           ; ah = low byte of count
	      in al, 40h          ; al = high byte of count
	      rol ax, 8            ; al = low byte, ah = high byte (ax = current count)
		  mov cx, ax
	      
		  
		  
	     
	      mov al, 00000000b    ; al = channel in bits 6 and 7, remaining bits clear
	      out 43h, al         ; Send the latch command
 
	      in al, 40h          ; al = low byte of count
	      mov ah, al           ; ah = low byte of count
	      in al, 40h          ; al = high byte of count
	      rol ax, 8            ; al = low byte, ah = high byte (ax = current count)
		  mov bx, ax
	    
	     
		  mov al, 01000000b    ; al = channel in bits 6 and 7, remaining bits clear
	      out 43h, al         ; Send the latch command
 
	      in al, 40h          ; al = low byte of count
	      mov ah, al           ; ah = low byte of count
	      in al, 40h          ; al = high byte of count
	      rol ax, 8            ; al = low byte, ah = high byte (ax = current count)
		  sti
	      
		  xor bx, ax
		  or bx, cx
		  mov ax, bx
		  mov dx, 0
		  mov cx, 40
		  div cx 
		  
		  mov bandera.pos_actual.x, dl
		  
		  cli
	      mov al, 10000000b    ; al = channel in bits 6 and 7, remaining bits clear
	      out 43h, al         ; Send the latch command
 
	      in al, 40h          ; al = low byte of count
	      mov ah, al           ; ah = low byte of count
	      in al, 40h          ; al = high byte of count
	      rol ax, 8            ; al = low byte, ah = high byte (ax = current count)
		  mov cx, ax
	      
		  
		  
	     
	      mov al, 00000000b    ; al = channel in bits 6 and 7, remaining bits clear
	      out 43h, al         ; Send the latch command
 
	      in al, 40h          ; al = low byte of count
	      mov ah, al           ; ah = low byte of count
	      in al, 40h          ; al = high byte of count
	      rol ax, 8            ; al = low byte, ah = high byte (ax = current count)
		  mov bx, ax
	    
	     
		  mov al, 01000000b    ; al = channel in bits 6 and 7, remaining bits clear
	      out 43h, al         ; Send the latch command
 
	      in al, 40h          ; al = low byte of count
	      mov ah, al           ; ah = low byte of count
	      in al, 40h          ; al = high byte of count
	      rol ax, 8            ; al = low byte, ah = high byte (ax = current count)
		  sti
	      
		  xor bx, ax
		  or bx, cx
		  mov ax, bx
		  mov dx, 0
		  mov cx, 5
		  div cx
          
		  mov al, dl
		  mov bx, OFFSET tabla_y
		  xlat
		  
		  mov bandera.pos_actual.y, al
		  mov bandera.or_actual, or_arriba
		  mov counter_bandera, 0
		  
		  
		  
		  mantener_bandera:
		  ret
	animar_bandera endp
	
	
	animar_humo proc
		mov ax, 50
		cmp ax, counter_humo
		ja man_humo
		mov counter_humo, 0
        mov humo.or_actual, or_abajo
        mov humo.pos_actual.x, 0
        mov humo.pos_actual.y, 0
		
		man_humo:
		ret
    animar_humo endp
    animar_enemigo proc
	  

	  siguiente_pos:
	  mov al, enemigo.pos_actual.x
	  mov bl, enemigo.pos_actual.y
	  mov cx, enemigo.or_actual

	  cmp cx, or_arriba
	  je enemigo_next_up
	  cmp cx, or_abajo
	  je enemigo_next_do
	  cmp cx, or_izquierda
	  je enemigo_next_iz
	  cmp cx, or_derecha
	  je enemigo_next_de

	  enemigo_next_up:
	       sub bl, 1
	       call cord2addr
	       jc esc_cond_up_e
	       mov dx, playfield[di]
	       cmp dx, vacio
	       je esc_cond_up_e
	       cmp dx, camino_ver
	       je sto_new_pos_e
	       cmp dx, camino_cru
	       je sto_new_pos_e
	       cmp dx, camino_hor
	       je sto_new_pos_e

	       mov cl, enemigo.pos_actual.y
	       cmp cl, 4
	       je esc_cond_up_e


	       esc_cond_up_e:
	       mov bl, enemigo.pos_actual.y
	       mov al, enemigo.pos_actual.x
	       cmp al, 0
	       je up_esc_de
	       cmp al, 39
	       je up_esc_iz
	       call calcular_ruta
           jmp siguiente_pos

	       up_esc_de:
	       mov enemigo.or_actual, or_derecha
	       jmp enemigo_next_de

	       up_esc_iz:
	       mov enemigo.or_actual, or_izquierda
	       jmp enemigo_next_iz


	  enemigo_next_do:

	       add bl, 1
	       call cord2addr
	       jc esc_cond_do_e
	       mov dx, playfield[di]
	       cmp dx, vacio
	       je esc_cond_do_e
	       cmp dx, camino_ver
	       je sto_new_pos_e
	       cmp dx, camino_cru
	       je sto_new_pos_e
	       cmp dx, camino_hor
	       je sto_new_pos_e

	       mov cl, enemigo.pos_actual.y
	       cmp cl, 24
	       je esc_cond_do_e

	       esc_cond_do_e:
	       mov bl, enemigo.pos_actual.y
	       mov al, enemigo.pos_actual.x

	       cmp al, 0
	       je do_esc_de
	       cmp al, 39
	       je do_esc_iz
	       call calcular_ruta
           jmp siguiente_pos
	       do_esc_de:

	       mov enemigo.or_actual, or_derecha
	       jmp enemigo_next_de

	       do_esc_iz:

	       mov enemigo.or_actual, or_izquierda
	       jmp enemigo_next_iz

	  enemigo_next_iz:

	       sub al, 1
	       call cord2addr
	       jz esc_cond_iz_e
	       mov dx, playfield[di]
	       cmp dx, vacio
	       je esc_cond_iz_e
	       cmp dx, camino_hor
	       je sto_new_pos_e
	       cmp dx, camino_cru
	       je sto_new_pos_e
	       cmp dx, camino_ver
	       je sto_new_pos_e

	       mov cl, enemigo.pos_actual.x
	       cmp cl, 0

	       je  esc_cond_iz_e

	       esc_cond_iz_e:

	       mov bl, enemigo.pos_actual.y
	       mov al, enemigo.pos_actual.x

	       cmp bl, 24
	       je iz_esc_up
	       cmp bl, 4
	       je iz_esc_do
           call calcular_ruta
		   jmp siguiente_pos
	       
           iz_esc_up:
	       mov enemigo.or_actual, or_arriba
	       jmp enemigo_next_up


	       iz_esc_do:
	       mov enemigo.or_actual, or_abajo
	       jmp enemigo_next_do


	  enemigo_next_de:

	       add al, 1
	       call cord2addr
	       jz esc_cond_de_e
	       mov dx, playfield[di]
	       cmp dx, vacio
	       je esc_cond_de_e
	       cmp dx, camino_cru
	       je sto_new_pos_e
	       cmp dx, camino_hor
	       je sto_new_pos_e
	       cmp dx, camino_ver
	       je sto_new_pos_e

	       mov cl, enemigo.pos_actual.x
	       cmp cl, 39
	       je  esc_cond_de_e

	       esc_cond_de_e:

	       mov bl, enemigo.pos_actual.y
	       mov al, enemigo.pos_actual.x

	       cmp bl, 24
	       je de_esc_up
	       cmp bl, 4
	       je de_esc_do
           call calcular_ruta
           jmp siguiente_pos

	       de_esc_up:
	       mov enemigo.or_actual, or_arriba
	       jmp enemigo_next_up

	       de_esc_do:
	       mov enemigo.or_actual, or_abajo
	       jmp enemigo_next_do
	  sto_new_pos_e:

	     mov enemigo.pos_actual.x, al
	     mov enemigo.pos_actual.y, bl
		ret
animar_enemigo ENDP
animar_player PROC
	  play:
	  mov ax, 0
	  mov bx, 0
	  mov cx, 0

	  mov al, player.pos_actual.x
	  mov bl, player.pos_actual.y
	  mov cx, player.or_actual

	  cmp cx, or_arriba
	  je player_next_up
	  cmp cx, or_abajo
	  je player_next_do
	  cmp cx, or_izquierda
	  je player_next_iz
	  cmp cx, or_derecha
	  je player_next_de

	  player_next_up:
	       sub bl, 1
	       call cord2addr
	       jc esc_cond_up_p
	       mov dx, playfield[di]
	       cmp dx, vacio
	       je esc_cond_up_p
	       cmp dx, camino_ver
	       je sto_new_pos_p
	       cmp dx, camino_cru
	       je sto_new_pos_p
	       cmp dx, camino_hor
	       je sto_new_pos_p

	       mov cl, player.pos_actual.y
	       cmp cl, 5
	       je esc_cond_up_p

	       esc_cond_up_p:
	       mov bl, player.pos_actual.y
	       mov al, player.pos_actual.x

	       cmp al, 0
	       je up_esc_de_p
	       cmp al, 39
	       je up_esc_iz_p
	       cmp al, 4
	       je up_esc_iz_p

	       up_esc_de_p:

	       mov player.or_actual, or_derecha
	       jmp player_next_de

	       up_esc_iz_p:

	       mov player.or_actual, or_izquierda
	       jmp player_next_iz


	  player_next_do:

	       add bl, 1
	       call cord2addr
	       jc esc_cond_do_p

	       mov dx, playfield[di]
	       cmp dx, vacio
	       je esc_cond_up_p
	       cmp dx, camino_ver
	       je sto_new_pos_p
	       cmp dx, camino_cru
	       je sto_new_pos_p
	       cmp dx, camino_hor
	       je sto_new_pos_p

	       mov cl, player.pos_actual.y
	       cmp cl, 24
	       je esc_cond_do_p


	       esc_cond_do_p:
	       mov bl, player.pos_actual.y
	       mov al, player.pos_actual.x

	       cmp al, 0
	       je do_esc_de_p
	       cmp al, 39
	       je do_esc_iz_p
	       cmp al, 19
	       je do_esc_de_p

	       do_esc_de_p:

	       mov player.or_actual, or_derecha
	       jmp player_next_de

	       do_esc_iz_p:

	       mov player.or_actual, or_izquierda
	       jmp player_next_iz

	  player_next_iz:

	       sub al, 1
	       call cord2addr
	       jz esc_cond_iz_p
	       mov dx, playfield[di]
	       cmp dx, vacio
	       je esc_cond_iz_p
	       cmp dx, camino_hor
	       je sto_new_pos_p
	       cmp dx, camino_cru
	       je sto_new_pos_p

	       mov cl, player.pos_actual.x
	       cmp cl, 0
	       je  esc_cond_iz_p


	       esc_cond_iz_p:
	       mov bl, player.pos_actual.y
	       mov al, player.pos_actual.x

	       cmp bl, 24
	       je iz_esc_up_p
	       cmp bl, 4
	       je iz_esc_do_p

	       iz_esc_up_p:
	       mov player.or_actual, or_arriba
	       jmp player_next_up

	       iz_esc_do_p:
	       mov player.or_actual, or_abajo
	       jmp player_next_do


	  player_next_de:

	       add al, 1
	       call cord2addr
	       jz esc_cond_de_p
	       mov dx, playfield[di]
	       cmp dx, vacio
	       je esc_cond_de_p
	       cmp dx, camino_cru
	       je sto_new_pos_p
	       cmp dx, camino_hor
	       je sto_new_pos_p
	       cmp dx, camino_ver
	       je sto_new_pos_p

	       mov cl, player.pos_actual.x
	       cmp cl, 0
	       je  esc_cond_de_p

	       esc_cond_de_p:

	       mov bl, player.pos_actual.y
	       mov al, player.pos_actual.x

	       cmp bl, 24
	       je de_esc_up_p
	       cmp bl, 4
	       je de_esc_do_p


	       de_esc_up_p:
	       mov player.or_actual, or_arriba
	       jmp player_next_up

	       de_esc_do_p:
	       mov player.or_actual, or_abajo
	       jmp player_next_do

	  sto_new_pos_p:

	     mov player.pos_actual.x, al
	     mov player.pos_actual.y, bl
	  ret
    animar_player ENDP
    get_input PROC
	get_key:

	mov ax, 1100h
	int 16h
	jz fin
	mov ax, 1000h
	int 16h
	;comparaciones
	mov bl, scancode_up
	cmp bl, ah
	je  arriba
	mov bl, scancode_do
	cmp bl, ah
	je  abajo
	mov bl, scancode_iz
	cmp bl, ah
	je  izquierda
	mov bl, scancode_de
	cmp bl, ah
	je derecha
    mov bl, scancode_esp
	cmp bl, ah
	je hu_mo
	mov bl, 01h
	cmp bl, ah

	je escape
	jmp fin

	arriba:
	mov player.or_actual, or_arriba
	jmp fin
	abajo:
	mov player.or_actual, or_abajo
	jmp fin

	izquierda:
	mov player.or_actual, or_izquierda
	jmp fin

	derecha:
	mov player.or_actual, or_derecha
	jmp fin

	hu_mo:
	mov humo.or_actual, or_arriba
	mov al, player.pos_actual.x
	mov ah, player.pos_actual.y
	mov humo.pos_actual.x, al
	mov humo.pos_actual.y, ah
	jmp fin
	fin:
	clc
	ret

	escape:
	STC
	ret
    get_input ENDP

    init_main PROC

	mov ah, 9
	mov dx, OFFSET mssg2
	int 21h
	call getrut
	call comprut
	call video_init
	call timer_int_install
	call init_player
	call playfield_update
	mov ah, 00
	int 16h




	ret
    init_main ENDP

    video_init PROC uses  AX BX ES BP SI DI DS

	; set_mode
	mov ah,00h
	NOP
	mov al,01h
	int 10h
	mov ah, 11h
	mov al, 14h
	mov bl, 0h
	int 10h
	;set no blink
	mov ax, 1003h
	mov bx, 0000h
	int 10h

	NOP
	push bp
	;auto_up
	mov bp, OFFSET carfont_up
	mov ax, localvar
	mov es, ax
	mov bl, 0
	mov bh, 16
	mov cx, 1
	mov ax, 1110h
	mov dx, 0F8h
	int 10h
	NOP
	;auto_do
	mov bp, OFFSET carfont_do
	mov ax, localvar
	mov es, ax
	mov bl, 0
	mov bh, 16
	mov cx, 1
	mov ax, 1110h
	mov dx, 0F9h
	int 10h
	NOP
	;auto_iz
	mov bp, OFFSET carfont_iz
	mov ax, localvar
	mov es, ax
	mov bl, 0
	mov bh, 16
	mov cx, 1
	mov ax, 1110h
	mov dx, 0FAh
	int 10h
	NOP
	;auto_de
	mov bp, OFFSET carfont_de
	mov ax, localvar
	mov es, ax
	mov bl, 0
	mov bh, 16
	mov cx, 1
	mov ax, 1110h
	mov dx, 0Fbh
	int 10h
	NOP

	;caminoh
	mov bp, OFFSET caminoh
	mov ax, localvar
	mov es, ax
	mov bl, 0
	mov bh, 16
	mov cx, 1
	mov ax, 1110h
	mov dx, 0F4h
	int 10h
	;caminov
	mov bp, OFFSET caminov
	mov ax, localvar
	mov es, ax
	mov bl, 0
	mov bh, 16
	mov cx, 1
	mov ax, 1110h
	mov dx, 0F5h
	int 10h
	;cruce
	mov bp, OFFSET cruce
	mov ax, localvar
	mov es, ax
	mov bl, 0
	mov bh, 16
	mov cx, 1
	mov ax, 1110h
	mov dx, 0F7h
	int 10h
	pop bp

	mov ax, 1003h
	mov bx, 0000h
	int 10h
	ret
    video_init ENDP
    playfield_update proc uses ax bx si di ds es
	mov si, OFFSET playfield
	mov cx, lengthofplayfield
	mov bx, localvar
	mov ds, bx
	mov ax, video_mem
	mov es, ax
	mov si, OFFSET playfield
	cld
	mov di, OFFSET video_buf
	rep movsw
	std
	ret
    playfield_update ENDP
    sprite_update PROC uses di si bx ax
	 ;enemigo
	 mov si, 0
	 mov ax, 0
	 mov bx, 0
	 mov cx, 0
	 mov dx, 0

	 mov al,enemigo.pos_actual.x
	 mov bl,enemigo.pos_actual.y
	 call cord2addr
	 NOP
	 mov ax, video_mem
	 mov es, ax ;di va a tener la direccion efectiva del word
	 mov bx, enemigo.or_actual
	 lea si, enemigo.car[bx]
	 movsw

	;player

	 mov si, 0
	 mov si, 0
	 mov ax, 0
	 mov bx, 0
	 mov cx, 0
	 mov dx, 0

	 mov al,player.pos_actual.x
	 mov bl,player.pos_actual.y
	 call cord2addr
	 NOP
	 mov ax, video_mem
	 mov es, ax ;di va a tener la direccion efectiva del word
	 mov bx, player.or_actual
	 lea si, player.car[bx]
	 movsw

	 ;texto
     COMMENT!
	 mov ax, counter
	 add ax, 48
	 mov ah, 08Fh
	 mov di, 0
	 mov es:[di], ax

	 mov ax, counter_sprite
	 add ax, 48
	 mov ah, 08Fh
	 mov di, 4
	 mov es:[di], ax

	 mov ax, counter_ruta
	 add ax, 48
	 mov ah, 08Fh
	 mov di, 8
	 mov es:[di], ax
		!
	 
     mov al, 4
	 mov bl, 1
	 call cord2addr
	 mov ax, player.puntos
     call int2a
     mov al, 20
     mov bl, 1
     call cord2addr
     mov ax, player.vidas
     add ax, 48
     mov ah, 8Fh
     mov es:[di], ax
     ;humo
     mov al, humo.pos_actual.x
     mov bl, humo.pos_actual.y
     call cord2addr
     mov bx, 0
     mov ax, video_mem
     mov es, ax ;di va a tener la direccion efectiva del word
     mov bx, humo.or_actual
     lea si, humo.car[bx]
     movsw
	 
	 ;bandera
	 mov al, bandera.pos_actual.x
     mov bl, bandera.pos_actual.y
     call cord2addr
     mov bx, 0
     mov ax, video_mem
     mov es, ax ;di va a tener la direccion efectiva del word
     mov bx, bandera.or_actual
     lea si, bandera.car[bx]
     movsw

     ret
    sprite_update ENDP
    video_update PROC
	 mov dx, 03DAh
    vsync:

	 in al,dx
	 test al, 00000100b ;vertical retrace set
	 jnz vsync

	 ;sino, redibujar playfield y los personajes


	 mov ax, 1
	 cmp ax, counter_sprite
	 ja sali
	 cli
	 vsync2:

	 in al,dx
	 test al, 00000100b ;vertical retrace set
	 jnz vsync2

	 call playfield_update
	 call sprite_update
	 mov counter_sprite, 0
	 sti
	 sali:
	 ret
    video_update ENDP
    comprut PROC uses di si cx bx es
	push ds
	push ds
	pop es
	pop ds
	mov di, OFFSET rut
	mov si, OFFSET inrut
	mov cx, LENGTHOF inrut
	cld
	repe cmpsb
	jne error_ne

	mov ax, 0
	ret
	error_ne:
	mov ah, 9h
	mov bx, 1
	mov cx, SIZEOF errmsg2
	mov dx, OFFSET errmsg2
	int 21h
	stc
	std
	ret
    COMPRUT ENDP
    val_rut_key PROC USES CX DI SI ES
	push ds
	pop es
	mov ah, 0
	mov di, OFFSET cmpbuf
	mov cx, LENGTHOF cmpbuf
	repne scasb
	jne error_rut_1
	ret

	error_rut_1:
	mov ah, 9h
	mov bx, 1
	mov cx, SIZEOF errmsg1
	mov dx, OFFSET errmsg1
	int 21h
	STC
	std
	ret
    val_rut_key ENDP


    hidecursor PROC
	mov ah, 3
	int 10h
	or ch, 30h
	mov ah,1
	int 10h
	ret
    hideCursor ENDP
    Showcursor PROC
	mov ah, 3
	int 10h
	mov ah, 1
	mov cx, 0607h
	int 10h
	ret
    Showcursor ENDP

    getrut PROC uses ax cx di
	mov cx, lengthof inrut-1
	mov di, 0

	tecla_sig:

	mov ah, 10h
	int 16h
	cmp al, 0Dh
	je rut_close
	call val_rut_key
	jc tecla_sig

	mov [inrut+di], al
	pusha
	mov ah, 6h
	mov dl,[inrut+di]
	int 21h
	popa
	inc di
	loop tecla_sig

	rut_close:

	mov al, '$'
	mov [inrut+di], al
	ret
    GETRUT ENDP
     ;si bx=1 desinstala la int
    Timer_int_install PROC uses ax dx ds es di si

	cmp bx, 1
	je recuperacion

	;obteniendo la direccion del ISR anterior
	mov ah, 35h
	mov al, 08h
	int 21h

	mov di, OFFSET oldvec
	mov [di], es
	mov [di+(TYPE oldvec)], bx

	push ds
	;instalacion
	cli
	mov ax, SEG heartbeat_add
	mov ds, ax
	mov dx, OFFSET heartbeat_add
	mov al, 08h
	mov ah, 25h
	int 21h
	pop ds
	sti
	ret


    recuperacion:
	nop
	cli
	mov di, 0
	mov ax, SEG oldvec
	mov ds, ax
	mov bx, OFFSET oldvec
	mov ax, [bx+di]
	add di, TYPE oldvec
	mov dx, [bx+di]
	mov ds, ax

	mov al, 08h
	mov ah, 25h
	int 21h

	sti
	ret
    TIMER_INT_INSTALL ENDP
     set_map_do PROC uses ax

	mov al, esta_do
	or player_map, al
	ret
     set_map_do ENDP

     set_map_up PROC
	mov al, esta_up
	or player_map, al
	ret
     set_map_up ENDP

     set_map_iz PROC
	mov al, esta_iz
	or player_map, al
	ret
     set_map_iz ENDP

     set_map_de PROC
	mov al, esta_de
	or player_map, al
	ret
     set_map_de ENDP

    calcular_ruta proc;solo para el enemigo
	nop

	 siguiente_mov:


	    mov ah, 0
	    mov bl, 0
	    mov player_map, 0
	    mov al, enemigo.pos_actual.x
	    mov bl, enemigo.pos_actual.y

	    mov cl, player.pos_actual.x
	    mov dl, player.pos_actual.y

	    ;determinando en que orientacion esta player
	    pusha

	    vertical:
	    cmp dl, bl

	    ja abajo
	    jb arriba

	    horizontal:

	    cmp cl, al
	    jb izquierda
	    ja derecha

	    jmp fin

	    abajo:
	      call set_map_do
	      jmp horizontal
	    arriba:
	      call set_map_up
	      jmp horizontal
	    izquierda:
	      call set_map_iz
	      jmp fin
	    derecha:
	      call set_map_de
	      jmp fin


	    fin:
	      mov al, player_map
	      cmp al, esta_up
	      je esc_up
	      cmp al, esta_do
	      je esc_do
	      cmp al, esta_iz
	      je esc_iz
	      cmp al, esta_de
	      je esc_de
	      cmp al, esta_up_de
	      je esc_up_de
	      cmp al, esta_up_iz
	      je esc_up_iz
	      cmp al, esta_do_de
	      je esc_do_de
	      cmp al, esta_do_iz
	      je esc_do_iz
	     popa
	    ret

	      esc_up:
	       mov al, enemigo.pos_actual.x
	       mov bl, enemigo.pos_actual.y
	       call cord2addr
	       mov ax, playfield[di]
	       cmp ax, camino_hor
	       je preservar
	       mov enemigo.or_actual, or_arriba
	       popa
	      ret
	      esc_do:
	       mov al, enemigo.pos_actual.x
	       mov bl, enemigo.pos_actual.y
	       call cord2addr
	       mov ax, playfield[di]
	       cmp ax, camino_hor
	       je preservar
	       mov enemigo.or_actual, or_abajo
	       popa
	      ret
	      esc_up_iz:
	       mov al, enemigo.pos_actual.x
	       mov bl, enemigo.pos_actual.y
	       call cord2addr
	       mov ax, playfield[di]
	       cmp ax, camino_hor
	       je esc_iz
	       cmp ax, camino_ver
	       je esc_up
		   mov al, enemigo.pos_actual.x
		   mov ah, enemigo.pos_actual.y
		   mov bx, 0419h
		   cmp ax, bx
		   je esc_iz
		   mov enemigo.or_actual, or_arriba
		   popa
	      ret
	       
           esc_up_de:
	       mov al, enemigo.pos_actual.x
	       mov bl, enemigo.pos_actual.y
	       call cord2addr
	       mov ax, playfield[di]
	       cmp ax, camino_hor
	       je esc_de
	       cmp ax, camino_ver
	       je esc_up
	       mov al, enemigo.pos_actual.x
		   mov ah, enemigo.pos_actual.y
		   mov bx, 0419h
		   cmp ax, bx
		   je esc_de
		   mov enemigo.or_actual, or_arriba
		   popa
	      ret
		  esc_do_iz:
	       mov al, enemigo.pos_actual.x
	       mov bl, enemigo.pos_actual.y
	       call cord2addr
	       mov ax, playfield[di]
	       cmp ax, camino_hor
	       je esc_iz
	       cmp ax, camino_ver
	       je esc_do
	       mov enemigo.or_actual, or_abajo
		   mov al, enemigo.pos_actual.x
		   mov ah, enemigo.pos_actual.y
		  mov bx, 0419h
		   cmp ax, bx
		   je esc_do
		   mov enemigo.or_actual, or_abajo
	       popa
	      ret
		   esc_do_de:
	       mov al, enemigo.pos_actual.x
	       mov bl, enemigo.pos_actual.y
	       call cord2addr
	       mov ax, playfield[di]
	       cmp ax, camino_hor
	       je esc_de
	       cmp ax, camino_ver
	       je esc_do
	       mov enemigo.or_actual, or_abajo
		   mov al, enemigo.pos_actual.x
		   mov ah, enemigo.pos_actual.y
		   mov bx, 0419h
		   cmp ax, bx
		   je esc_do
		   mov enemigo.or_actual, or_abajo
	       popa
	      ret
		  esc_de:
	       mov al, enemigo.pos_actual.x
	       mov bl, enemigo.pos_actual.y
	       call cord2addr
	       mov ax, playfield[di]
	       cmp ax, camino_ver
	       je preservar
	       mov enemigo.or_actual, or_derecha
	       popa
	      ret
	       esc_iz:
	       mov al, enemigo.pos_actual.x
	       mov bl, enemigo.pos_actual.y
	       call cord2addr
	       mov ax, playfield[di]
	       cmp ax, camino_ver
	       je preservar
	       mov enemigo.or_actual, or_izquierda
	       popa
	      ret


	    distancia:
	    preservar:

	    popa

	    ret
    calcular_ruta ENDP

    init_player PROC uses si di

	mov si, 0
	mov di, 0

	playr:
	;diccionario del auto
	mov player.car[di],autop_up
	add di, TYPE player.car
	mov player.car[di],autop_do
	add di, TYPE player.car
	mov player.car[di],autop_iz
	add di, TYPE player.car
	mov player.car[di],autop_de

	;posicion inicial
	 mov di, 0
	 mov player.pos_actual.x,19
	 mov player.pos_actual.y, 23
	;obj inicial
	 mov di, 0
	 mov player.pos_objetivo.x, 20
	 mov player.pos_objetivo.y, 5
	;orientacion actual
	 mov player.or_actual, or_abajo


	enem:
	;diccionario del enemigo
	mov si, 0
	mov di, 0

	mov enemigo.car[di],autoe_up
	add di, TYPE enemigo.car
	mov enemigo.car[di],autoe_do
	add di, TYPE enemigo.car
	mov enemigo.car[di],autoe_iz
	add di, TYPE enemigo.car
	mov enemigo.car[di],autoe_de

	 ;posicion inicial
	 mov di, 0
	 mov enemigo.pos_actual.x, 19
	 mov enemigo.pos_actual.y, 4
	;obj inicial
	 mov di, 0
	 mov enemigo.pos_objetivo.x, 19
	 mov enemigo.pos_objetivo.y, 23
	 mov enemigo.or_actual, or_abajo

       ;bandera
       mov di, 0
       mov bandera.car[di], bande_up
       mov bandera.or_actual, or_abajo
	   mov bandera.car[or_abajo], humo_do
       ;humo
       mov di, 0
       mov humo.car[or_arriba], humo_up
       mov humo.or_actual, or_arriba
       mov humo.car[or_abajo], humo_do
	   mov humo.or_actual, or_abajo

       ret
    init_player ENDP

    cord2addr proc uses cx si dx
    ;entra ax=x bx=y, sale di=direccion efectiva de la coordenada P=coord x invalida  cy=coord y invalida


     mov ah, 0
     mov bh, 0
     mov dx, 0
     push ax
     push bx
     cmp al, 39
     ja error_x
     cmp bl, 24
     ja error_y
     nop
     mov cl, 2
     mul cl
     xchg bx, ax
     mov cl, 80
     mul cl
     add ax, bx
     mov di, ax
     pop bx
     pop ax

     ret

     error_x:
	mov al, 1
	mov bl, 1
	sub al,bl
	pop bx
	pop ax
	ret
     error_y:
	stc
	pop bx
	pop ax
	ret
    cord2addr ENDP

    addr2cord PROC uses cx dx es ds
    ;entra addr, sale di=x si=y
     NOP
     mov ax, 0
     mov ax, bx
     mov dx, 0
     mov cx, 80
     div cx
     mov di, dx
     mov si, ax
     mov dx, 0
     mov cx, 2
     mov ax, di
     div cx
     mov di, ax
     ret
    addr2cord ENDP
   int2a PROC
    ;EAX = integer
	mov   cx,0		; count = 0
	mov   bx,10

    WIS2:
	mov   dx,0
	div   bx		; AX/10
	or    dl,30h		; resto a ascii
	sub   di,2		; retroceder en el buffer
    mov   dh, 08h
	mov   es:[di],dl		; guardar el digito ascii
	or    ax,ax	       ; > 0?
	jnz   WIS2		; seguir dividiendo
	
 ret
    Int2a ENDP


    arbitro_puntaje PROC uses ax bx
     mov al, player.pos_actual.x
     mov ah, player.pos_actual.y
     mov bl, enemigo.pos_actual.x
     mov bh, enemigo.pos_actual.y
     cmp ax, bx
     jne anotar_puntos
     sub player.vidas, 1
     stc
     ret

     anotar_puntos:
     mov bl, bandera.pos_actual.x
     mov bh, bandera.pos_actual.y
     cmp ax, bx
     jne no_hay_cambios
     add player.puntos, 100
	 mov counter_bandera, permanencia_bandera
	 mov bandera.or_actual, or_abajo
	 mov bandera.pos_actual.y, 0
	 mov bandera.pos_actual.x, 0
	 clc
     ret

     no_hay_cambios:
	 clc
     ret
    arbitro_puntaje ENDP
    
    heartbeat_add PROC FAR
      pusha

      cli
      ;ref a variable del programa
      mov ax, SEG counter
      mov ds, ax

      add counter, 1
      add counter_sprite, 1
      add counter_ruta, 1
      add counter_enemigo, 1
      add counter_player, 1
      add counter_humo, 1
	  add counter_bandera, 1
      eoi:
      mov al, 020h
      out 020h, al

      popa
      sti
      iret

     heartbeat_add ENDP



    code_seg ENDS


END  MAIN
END
