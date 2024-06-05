 
MODEL small
STACK 100h
DATASEG
	endgates11 db 32
	yes db "both 7 and 8 are false, $"
	no db "at least one of the bits 7 , 8  - true, $" 

CODESEG
start:
	mov ax, @data
	mov ds, ax
	or endgates11,159
	cmp endgates11,159
	jne @@noo
	mov dx,offset yes
	mov ah,9
	int 21h
	jmp exit
	@@noo:
	mov dx,offset no
	mov ah,9h
	int 21h
	jmp exit
	
	

exit:
	mov ax, 4c00h
	int 21h
END start


