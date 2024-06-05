;
; here write your ID. DOnt forget the name of the file should be your id . asm
; ID  = 

; For tester:
; Tester name = 
; Tester Total Grade = 

 
;---------------------------------------------
; 
; Skelatone Solution for Chapter 8 Work
;  
;----------------------------------------------- 


IDEAL

MODEL small

	stack 256
DATASEG
		 
		 ; Ex1 Variables 
		 aTom db 13 dup(?)  ; example to varible for exercise 1
		 ; Ex2 Variables 
		 marach db 10 dup(?)
		 ; Ex3 Variables 
		 marach1 db 10 dup(?)
		; ex4 veriables
		array4 db 100 dup(?)
		;ex5 veriables
		bufferfrom5 db 1,2,3,4,5,6,7,8,9,0
		 bufferto5 db 10 dup(?)
		 ;ex6 veriables
		 bufferfrom6 db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50
		bufferto6 db 50 dup(?)
		bufferto6len db 0
		 ;ex7 veriables
		 myline7 db 1,2,3,4,5,6,7,8,9,0,0Dh
		line7length db 0
		 ;ex7b veriables
		 mywords7 dw 1,2,3,4,5,6,7,8,9,0,0DDDDh
		mywords7length db 0
		;ex8 veriables
		myq8 db 101,130,30,201,120,-3,100,255,0
		;ex9 veriables
		myset9 dw 101,130,30,201,120,-3,100,255,0,0ffffh
		count0 db 0
		count db 0
		countminus db 0
		;ex10 veriables
		number db 8 dup(?),"B, $"
		;ex11 veriables
		endgates11 db 3
		yes db "both 7 and 8 are false, $"
		no db "at least one of the bits 7 , 8  - true, $" 
		;ex13 veriables
		string db "4556!"
		wordnum dw 0
		;ex14 veriables
		saverax dw ?
		stringax db ?,?,?,?,'$'
		 ; Ex11 Variables 
		 
		 
CODESEG

start:
		mov ax, @data
		mov ds,ax
		;call ex1
		call ex1
		;call ex2
		call ex2
		;call ex3
		call ex3
		;call ex4
		call ex4
		;call ex5
		call ex5
		;call ex6
		call ex6
		;call ex7a
		call ex7a
		;call ex7b
		call ex7b
		;call ex8
		call ex8
		;call ex9
		call ex9
		;call ex10
		call ex10
		;call ex11
		call ex11
		;call ex12
		call ex12
		;call ex13
		call ex13
		mov ax, 0F70ch  
		mov [saverax],ax
		call ex14c

exit:
		mov ax, 04C00h
		int 21h

		
		
;------------------------------------------------
;------------------------------------------------
;-- End of Main Program ... Start of Procedures 
;------------------------------------------------
;------------------------------------------------





;================================================
; Description -  Move 'a' -> 'm'  to variable at DSEG 
; INPUT: None
; OUTPUT: array on Dataseg name : aTom
; Register Usage: al si and cx
;================================================
proc ex1

    mov cx,13
	mov si,0
	mov al,97
	lopp:
	mov [aTom+si],al
	inc al
	inc si
	loop lopp

    ret
endp ex1

;================================================
; Description -  move 1 to 9 (ascii) to an arrey
; INPUT:  none
; OUTPUT:  array on datasegment name : marach
; Register Usage:  cx si and al
;================================================
proc ex2
    mov cx,10
	mov si,0
	mov al,'0'
	loppp:
	mov [marach+si],al
	inc al
	inc si
	loop loppp
    ret
endp ex2
;================================================
; Description -  move 1 to 9  to an arrey
; INPUT:  none
; OUTPUT:  array on datasegment name : marach1
; Register Usage:  cx si and al
;================================================
proc ex3
    mov cx,10
	mov si,0
	mov al,0
	lopppp:
	mov [marach1+si],al
	inc al
	inc si
	loop lopppp
    ret
endp ex3
;================================================
; Description: move the number 0cch 100 times into an arrey
; INPUT:  none
; OUTPUT:  array on datasegment name : arr
; Register Usage: cx and si
;================================================
proc ex4
    mov bx,0
	mov cx,100
	loop4:
	mov ax,bx
	jmp check7
	aa:
	mov ax,bx
	and ax,1
	cmp ax,1
	je cc
	inc bx 
	loop loop4
	jmp bibib
	cc: mov [array4+bx],0cch
	inc bx
	loop loop4
	jmp bibib
	check7:
	cmp ax,7
	je cc
	shr ax,1
	cmp ax,0
	je aa
	jmp check7
	bibib:
    ret
endp ex4
;================================================
; Description: moving from one arrey to the other
; INPUT:  array on datasegment name : bufferfrom5
; OUTPUT:  array on datasegment name : bufferto5
; Register Usage: cx and si
;================================================
proc ex5
	mov cx,10
	mov si,0
	ex5lopp:
	mov bl,[bufferfrom5+si]
	mov [bufferto5+si],bl
	inc si
	loop ex5lopp
    ret
endp ex5
;================================================
; Description: move only numbers above 12 to the other arrey and count the times that you moved numbers from one arrey to the other
; INPUT:  array on datasegment name : bufferfrom6
; OUTPUT:  array on datasegment name : bufferto6 and variable on datasegment name : bufferto6len
; Register Usage: cx bl and si
;================================================
proc ex6
	mov cx,50
	mov si,0
    ex6loop:
		cmp [bufferfrom6+si],12
		jb cont
		mov bl,[bufferfrom6+si]
		mov [bufferto6+si],bl
		inc bufferto6len
	cont:
		inc si
		loop ex6loop
    ret
endp ex6
;================================================
; Description: count the length of an arrey
; INPUT:  none
; OUTPUT: variable on datasegment name : myline7 
; Register Usage: cx and si
;================================================
proc ex7a
     mov cx,2
	mov si,0
	ex7loop:
		cmp [myline7+si],0dh
		je conti
		inc si
		inc cx
		inc [line7length]
		loop ex7loop
	conti:
	inc [line7length] 
    ret
endp ex7a




;================================================
; Description: count the length of an arrey (word)
; INPUT:  none
; OUTPUT:  variable on datasegment name : mywords7length
; Register Usage: si and cx
;================================================
proc ex7b
	mov cx,2
	mov si,0
	ex7bloop:
		cmp [mywords7+si],0ddddh
		je contin
		add si,2
		inc cx
		inc [mywords7length]
		loop ex7bloop
	contin:
	inc [mywords7length] 
    ret
endp ex7b




;================================================
; Description: adds all the numbers from an array that is above 100
; INPUT:  none
; OUTPUT:  screen
; Register Usage: ax cx and si
;================================================
proc ex8
      mov ax,0
	mov cx,2
	mov si,0
	ex8loop:
		cmp [myq8+si],0
		je done
		cmp [myq8+si],100
		jb continu
		cmp [myq8+si],100
		je continu
		cmp [myq8+si],07fh
		ja continu
		add al, [myq8+si]
		continu:
		inc cx
		inc si
		loop ex8loop
	done:
	call ShowAxDecimal
    ret
endp ex8




;================================================
; Description: count the number of positive negative or zero numbers in an array
; INPUT:  none
; OUTPUT:  the counters
; Register Usage: cx and si
;================================================
proc ex9
      mov cx,2
	mov si,0
	ex9loop:
		cmp [myset9+si],0ffffh
		je done
		cmp [myset9+si],0
		jg plus
		cmp [myset9+si],0
		je zero
		cmp [myset9+si],0
		jl minus
		zero:
		inc count0
		inc cx
		add si,2
		loop ex9loop
		plus:
		inc count
		inc cx
		add si,2
		loop ex9loop
		minus:
		inc countminus
		inc cx
		add si,2
		loop ex9loop
	doone:
    ret
endp ex9




;================================================
; Description: takes al and prints it in binery
; INPUT:  al
; OUTPUT:  screen
; Register Usage: ax,cx,si,bx,dx
;================================================
proc ex10
    mov al ,128
	mov cx,8
	mov si,0
	ex10oop:
		shl al,1
		jc one
		jnc zero10
		one:
		mov bl , '1'
		jmp continue10
		zero10:
		mov bl,'0'
		jmp continue10
		continue10:
		mov [number+si],bl
		inc si
		loop ex10oop
	mov dx,offset number
	mov ah,9
	int 21h
    ret
endp ex10




;================================================
; Description: checks the 6th and 7th bit in a variable and prints if they are both 0 or at least one of them is 1
; INPUT:  none
; OUTPUT:  screen
; Register Usage: ax,dx
;================================================
proc ex11
     
	or endgates11,159
	cmp endgates11,159
	jne @@noo
	mov dx,offset yes
	mov ah,9
	int 21h
	ret
	@@noo:
	mov dx,offset no
	mov ah,9h
	int 21h
	ret
endp ex11




;================================================
; Description: checks if in ds:a there is a number between 10 to 70 if it does have a number between 10 and 70 it copys ds:a to ds:b
; INPUT:  ds:a
; OUTPUT:  ds:b
; Register Usage: bx 
;================================================
proc ex12
      mov [byte ds:0ah] ,11h
	cmp [byte ds:0ah],10
	jb nooo
	cmp [byte ds:0ah],70
	ja nooo
	mov bl,[ds:0ah]
	mov [ds:0bh],bl
	nooo:

    ret
endp ex12




;================================================
; Description: puts a certen number to an array
; INPUT:  string
; OUTPUT:  screen
; Register Usage: ax,cx,si,bx
;================================================
proc ex13
      mov bx,0
	mov si,0
	mov cx,2
	ex3loop:
		cmp [string+si],'!'
		je bye
		sub[string+si],'0'
		mov ax,10
		mul bx
		mov bx,ax
		add bl,[string+si]
		inc cx
		inc si
		loop ex3loop
	bye:
	mov [wordnum],bx
    ret
endp ex13




;================================================
; Description: prints a nibble
; INPUT:  al
; OUTPUT:  screen
; Register Usage: ax,dx
;================================================
proc ex14a
	and al,0fh
	cmp al,10
	jb numbers
	letters:
		add al,55
		jmp print
	numbers:
		add al,'0'
		jmp print
	print:
		mov dl,al
		mov ah,2
		int 21h 
		mov ax,[saverax]
    ret
endp ex14a




;================================================
; Description:saperates al to 2 nibbles and uses 14a to print it to the screen
; INPUT:  al
; OUTPUT:  screen
; Register Usage: ax,bh
;================================================
proc ex14b
	xor ah,ah
	 shl ax ,4
	 shr al,4
	 mov bh,al
	 mov al,ah
	 call ex14a
	 mov al,bh
	 call ex14a
	 mov ax,saverax
    ret
endp ex14b




;================================================
; Description: prints ax
; INPUT:  ax
; OUTPUT:  screen
; Register Usage: ax,bx
;================================================
proc ex14c
	mov bl,al
	mov al,ah
	call ex14b
	mov al,bl
	call ex14b
    ret
endp ex14c












;================================================
; Description - Write on screen the value of ax (decimal)
;               the practice :  
;				Divide AX by 10 and put the Mod on stack 
;               Repeat Until AX smaller than 10 then print AX (MSB) 
;           	then pop from the stack all what we kept there and show it. 
; INPUT: AX
; OUTPUT: Screen 
; Register Usage: AX  
;================================================
proc ShowAxDecimal
       push ax
	   push bx
	   push cx
	   push dx
	   
	   ; check if negative
	   test ax,08000h
	   jz PositiveAx
			
	   ;  put '-' on the screen
	   push ax
	   mov dl,'-'
	   mov ah,2
	   int 21h
	   pop ax

	   neg ax ; make it positive
PositiveAx:
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_mode_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_mode_to_stack

	   cmp ax,0
	   jz pop_next  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next
		
	   mov dl, ','
       mov ah, 2h
	   int 21h
   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   
	   ret
endp ShowAxDecimal



END start
