IDEAL
MODEL small
STACK 100h
DATASEG
arr db 13,42,23,41,35,36,7,8,238
lengtharr dw 9
sum equ [bp-2]
answer equ [bp-4]
x dw 3
y dw 5
z dw 5
CODESEG
start:
	mov ax, @data
	mov ds, ax
	;push offset arr 
	;push [lengtharr]	
	;call printarr
	;push [x]
	;push [y]
	;push [z]
	;call pitagoras
	;sub sp,10
	;pop ax
	;all ShowAxDecimal
	push 521
	call perfecto
	push 496
	call IsPerfect
exit:
	mov ax, 4c00h
	int 21h
	proc printarr
	push bp
	mov bp,sp
	push ax
	push cx
	push si
	push bx
	mov bx,[bp+6]
	mov cx, [bp+4]
	mov si,0
	lop:
	mov ah,0
	mov al ,[ds:bx+si]
	call ShowAxDecimal
	add si,1
	loop lop
	pop bx
	pop si
	pop cx
	pop ax
	pop bp
	ret 
	endp printarr
	
	proc pitagoras
	push bp
	mov bp,sp
	push 0
	sub sp , 2
	mov ax,[bp+8]
	mul [word bp+8]
	add sum,ax
	mov ax,[bp+6]
	mul [word bp+6]
	add sum,ax
	mov ax,[bp+4]
	mul [word bp+4]
	cmp sum,ax
	jne no
	push 1
	add sp,2
	jmp endd
	no:
	push 0
	add sp,2
	endd:
	add sp,4
	pop bp
	ret  
	endp pitagoras
	
	proc IsPrine
	push  bp
	mov bp,sp
	
	push ax
	push bx
	push cx
	push dx
	
	mov ax,[bp+4]
	mov bx,2
	div bx
	
	mov bx,2
	mov cx,ax
	sub cx,2
	
	looop:
	add cx,2
	xor dx,dx
	mov ax,[bp+4]
	div bx
	cmp dx,0
	je sheerit
	inc bx
	sub cx,2
	loop looop
	mov ax,[bp+4]
	call ShowAxDecimal
	sheerit:
	
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	ret 
	endp IsPrine
	
	proc IsPerfect
	push bp
	mov bp,sp
	mov sum,0000
	sub sp,2
	
	push bx
	push cx
	push ax
	push dx
	
	mov bx,1
	mov cx,[bp+4]
	dec cx
	
	plpl:
	xor dx,dx
	inc bx	
	mov ax, [bp+4]
	div bx
	cmp dx,0
	jne notadd
	add sum,ax
	notadd:

	loop plpl
	
	mov ax,[bp-2]
	cmp ax,[bp+4]
	jne notperfect
	
	mov ax,[bp+4]
	call ShowAxDecimal
	
	notperfect:
	pop dx
	pop ax
	pop cx
	pop bx
	add sp,2
	pop bp
	ret 2
	endp IsPerfect
	
	proc perfecto
	pop cx
	loopperfect:
	push cx
	call IsPerfect
	pop cx
	loop loopperfect
	ret
	endp perfecto
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


