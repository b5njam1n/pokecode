IDEAL
MODEL small
STACK 100h
DATASEG
	num1 db 10
	num2 db 20
	sum db 0

CODESEG
start:
	mov ax, @data
	mov ds, ax
	xor ax,ax
	add al, [num1]
	add al, [num2]
	mov [sum], al
exit:
	mov ax, 4c00h
	int 21h
END start


