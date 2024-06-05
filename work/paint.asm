IDEAL
MODEL small
STACK 100h
DATASEG
titleee db "Paint$"
widthh dw 319
lengthh dw 140
y dw 30
x dw 0
color db 15
exitfalg db 0
endmsg db "exited proc enter any key to continue...$"
CODESEG
start:
	mov ax, @data
	mov ds, ax
	mov ax,13h
	int 10h

	call fullrec
	call titlee
call pallete
mov color,15	
mouselp:
	cmp [exitfalg],1
	je exit
	mov ax,1h
	int 33h
	mov ax,3h
	int 33h
	cmp bx,01h
	je draw
	cmp bx,02h
	je changecolor
	mov ah, 1	
  	int 16h
 	jz mouselp 
	mov ah,0		
    int 16h
	cmp ah,1
	jne mouselp
	mov [exitfalg],1
	jmp mouselp
	draw:
	shr cx,1
	sub dx,1
	cmp dx,30
	jl mouselp
	cmp dx,169
	jg mouselp
	mov bh,0h
	mov al,[color]
	mov ah,0ch
	int 10h
	jmp mouselp
	changecolor:
	shr cx,1
	sub dx,1
	mov bh,0h
	mov ah,0dh
	int 10h
	cmp dx,170
	jl mouselp
	cmp dx,175
	jg mouselp
	mov [color],al
	jmp mouselp

exit:
call clearscreen
    mov ah, 2
    mov bh, 0
    mov dh, 2 ; line number
    mov dl, 0 ; column number
    int 10h
mov dx,offset endmsg
mov ah,9
int 21h
	mov ah,7
	int 21h
	
	mov ax,2
	int 10h
	mov ax, 4c00h
	int 21h

proc titlee
    mov ah, 2
    mov bh, 0
    mov dh, 2 ; line number
    mov dl, 17 ; column number
    int 10h
mov dx,offset titleee
mov ah,9
int 21h
ret
endp titlee


proc pallete
push [x]
push [y]
push [widthh]
push [lengthh]
mov [color],1
mov [x],0
mov [y],170
mov [widthh],5
mov [lengthh],5
mov cx,64
@@looop:
call fullrec
add [x],5
inc [color]
loop @@looop
pop [lengthh]
pop [widthh]
pop [y]
pop [x]
ret
endp pallete

proc clearscreen
push [x]
push [y]
push [widthh]
push [lengthh]
mov [x],0
mov [y],0
mov [color],0
mov [widthh],319
mov [lengthh],199
call fullrec
pop [lengthh]
pop [widthh]
pop [y]
pop [x]
ret
endp clearscreen

proc colum
	mov bp,sp
	push bp
	push ax
	push bx
	push cx
	push dx
	mov cx, [lengthh]
	mov dx,[y]	
	@@columloop:
	push cx
	mov bh,0h
	mov cx,[x]
	mov al,[color]
	mov ah,0ch
	int 10h
	inc dx
	pop cx
	loop @@columloop
	pop dx	
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
endp colum


proc fullrec
push cx
push bx
mov cx,[widthh]
@@loopfullrect:
call colum
add [x],1
loop @@loopfullrect
mov bx,[widthh]
sub [x],bx
pop bx
pop cx
ret
endp fullrec

proc DrawDot ; Parameters: x, y, color
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    
    mov cx, [bp+8] ; Put X coordinate in CX
    mov dx, [bp+6] ; Put Y coordinate in DX
    mov ax, [bp+4] ; Put Color in AL (AX because it is a word)
    mov ah, 0ch
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
endp DrawDot


END start


