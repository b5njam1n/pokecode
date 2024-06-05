IDEAL
MODEL small
STACK 100h
DATASEG
	nname db "Benjamin"
	surname db "segre"

CODESEG
start:
	mov ax, @data
	mov ds, ax
	mov [0], 4dh
	mov [surname], 5ah
	mov bh, 68h
	mov [nname+3],bh
exit:
	mov ax, 4c00h
	int 21h
END start


