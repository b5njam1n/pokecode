IDEAL
MODEL small
STACK 100h
DATASEG
	arr1 db 1,2,3,4,5,5,6,7,7
	length1 dw 9
	arr2 db 12,43,11,22,11
	length2 dw 5
	returnad dw ?

CODESEG
start:
	mov ax, @data
	mov ds, ax
	push length1
	push seg arr1
	push offset arr1
	call switch
	push length2
	push seg arr2
	push offset arr2
	call switch

exit:
	mov ax, 4c00h
	int 21h
	proc switch
		pop returnad
		pop bx
		pop es
		pop cx
		mov ax,0
		mov si,0
		lolop:
		cmp al,[byte ptr es:bx+si]
		ja no
		mov al,[byte ptr es:bx+si]
		no:
		inc si
		loop lolop
		call ShowAxDecimal
		push returnad
		ret
	endp switch
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


