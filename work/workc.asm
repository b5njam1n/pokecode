IDEAL
MODEL small
STACK 100h
DATASEG
	number db 8 dup(?),'$'

CODESEG
start:
	mov ax, @data
	mov ds, ax
	mov al ,125
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

exit:
	mov ax, 4c00h
	int 21h
END start

