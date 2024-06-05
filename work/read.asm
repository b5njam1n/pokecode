IDEAL
MODEL small
STACK 100h
DATASEG
lengthh dw 7 
widthh dw 7
matrix db 0,0,0,4,4,4,4,0,0,0
		db	0,0,0,4,4,4,4,0,0,0
		db	0,0,0,4,4,4,4,0,0,0
		db	0,0,0,4,4,4,4,0,0,0
		db 0,0,0,4,4,4,4,0,0,0
		db	0,4,4,4,4,4,4,4,4,0
		db	0,0,4,4,4,4,4,4,0,0
		db	0,0,0,4,4,4,4,0,0,0
		db	0,0,0,0,4,4,0,0,0,0
		db	0,0,0,0,0,0,0,0,0,0
		
color db 4

CODESEG
start:

	mov ax, @data
	mov ds, ax
	mov ax,13h
	int 10h
	mov di,11100
	mov cx,10
	mov dx,10
	call PutMatrixOnScreen
		mov di,11400
	mov cx,10
	mov dx,10
	call PutMatrixOnScreen
		mov di,11110
	mov cx,10
	mov dx,10
	call PutMatrixOnScreen

exit:
	mov ax, 4c00h
	int 21h
; in dx how many cols 
; in cx how many rows
; in matrix - the bytes
; in di start byte in screen (0 64000 -1)

proc PutMatrixOnScreen
    push es
    push ax
    push si
    
    mov ax, 0A000h
    mov es, ax
    cld
    
    push dx
    mov ax,cx
    mul dx
    mov bp,ax
    pop dx
    
    mov si, offset matrix
    
NextRow:    
    push cx
    
    mov cx, dx
    rep movsb ; Copy line to the screen
    sub di,dx
    add di, 320
    
    
    pop cx
    loop NextRow
    
    
endProc:    
    
    pop si
    pop ax
    pop es
    ret
endp PutMatrixOnScreen


;al - color
proc ClearScreen
push cx
push si
push dx
push di
mov cx,[widthh]
xor si,si
@@makemetrix:
push cx
mov cx, [lengthh]
@@makemetrix2:
mov [matrix+si],al
inc si
loop @@makemetrix2
pop cx
loop @@makemetrix
mov dx,[lengthh]
mov cx,[widthh]
mov di,11300
call PutMatrixOnScreen
pop di
pop dx
pop si
pop cx
ret 2
endp ClearScreen

proc DrawRect
	push cx
	push si
	push dx
	push di
	mov cx,[widthh]
	mov ax,0
	mov es,ax	
	mov di, offset matrix
	cld	
@@makemetrix:
	push cx
	mov cx, [lengthh]
@@makemetrix2:

	mov si , offset color
	movsb
	
	inc di
loop @@makemetrix2
	pop cx
loop @@makemetrix
	mov dx,[lengthh]
	mov cx,[widthh]
	mov di,11300
	call PutMatrixOnScreen
	pop di
	pop dx
	pop si
	pop cx
ret 2
endp DrawRect
END start


