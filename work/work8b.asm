IDEAL
MODEL small
STACK 100h
DATASEG

CODESEG
start:
	mov ax, @data
	mov ds, ax
	mov [byte cs:90h],?

exit:
	mov ax, 4c00h
	int 21h
END start


