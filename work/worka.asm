IDEAL
MODEL small
STACK 100h
DATASEG

CODESEG
start:
	mov ax, @data
	mov ds, ax
	mov [word cs:1h] ,0fec4h
	mov [word cs:5h] ,0fec4h
exit:
	mov ax, 4c00h
	int 21h
END start


