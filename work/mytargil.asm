IDEAL
MODEL small
STACK 100h
DATASEG
	answer db ?,?,'$'
CODESEG
start:
	mov ax, @data
	mov ds, ax
	mov bl,10h
	xor ah,ah
	div bl
	mov [answer],al
	mov [answer+1],ah	
	mov cx,2
	mov si,0
	ex14bloop:
		cmp [answer+si],0ah
		jb numbers
		add [answer+si],55
		jmp contunuee
		numbers:
		add [answer+si],'0'
		contunuee:
		inc si
		loop ex14bloop
	
	mov dx ,offset answer
	mov ah,9
	int 21h
exit:
	mov ax, 4c00h
	int 21h
	
END start