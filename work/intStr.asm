 
IDEAL

MODEL small

	stack 256
DATASEG
 
	right db "right",'$'
	left db "left ",'$'
	bye db" bye ",'$'
		

CODESEG

start:
		mov ax, @data
		mov ds,ax
	mov si,0
	mainloop:
  	 mov ah, 1		; check if key was pressed
  	 int 16h
 	 jz Delay 		; if zero flag on – no key was pressed
  				; zero flag is 0 so key was pressed 
 	 mov ah,0		; check which key was pressed
     int 16h
  	 cmp ah, 4Dh 		; Right Arrow was pressed
 	 je RightArrow
 	 cmp ah, 4Bh		; Left Arrow was pressed
  	 je LeftArrow
	 cmp ah,1		; Esc was pressed
 	 je Exitt
Delay:
	call LoopDelay1Sec
	xor dx,dx
	mov ax,si
	mov bx,10
	div bx
	cmp dx,0
	jne yeah
	mov ah,2
	mov bh,0
	mov dh, 0 ; line number
	mov dl, 0; column number
	int 10h
	mov ax,si
	mov bx,10
	div bx
	call printAxDec
	yeah:
	inc si
	jmp mainloop
RightArrow:	; Handle RightArrow
	  	mov ah,2
		mov bh,0
		mov dh, 12 ; line number
		mov dl, 19; column number
		int 10h
		mov dx,offset right
		mov ah,9
		int 21h
		jmp mainloop	
LeftArrow: 
		mov ah,2
		mov bh,0
		mov dh, 12 ; line number
		mov dl, 19; column number
		int 10h
		mov dx,offset left
		mov ah,9
		int 21h
		jmp mainloop


Exitt:
		mov ah,2
		mov bh,0
		mov dh, 12 ; line number
		mov dl, 19; column number
		int 10h
		mov dx,offset bye
		mov ah,9
		int 21h


exit:
		mov ax, 04C00h
		int 21h

proc LoopDelay1Sec
	push cx
	mov cx ,100 
@@Self1:
	  push cx
	mov cx,3000   
@@Self2:	
	loop @@Self2
	pop cx
	loop @@Self1
	pop cx
	ret
endp LoopDelay1Sec

proc printAxDec  
	   
       push bx
	   push dx
	   push cx
	           	   
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_next_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_next_to_stack

	   cmp ax,0
	   jz pop_next_from_stack  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next_from_stack: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next_from_stack

	   pop cx
	   pop dx
	   pop bx
	   
       ret
endp printAxDec 


END start
