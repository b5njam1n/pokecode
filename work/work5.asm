IDEAL
MODEL small
STACK 100h
DATASEG
	firstname db 'Benjamin'
	age db 15
	age2 dw 15
	lastname db 'segre'
	myarry dw 40 dup(0a504h)
CODESEG
start:
	mov ax, @data
	mov ds, ax
	mov bx, 0bfbbh
	mov ah, bh
	mov bh, bl
	mov bl, ah
	mov ah, [byte 16h]
	mov [byte 6h] ,ah
	mov ah, [byte 5]
	mov [byte 5],ah
	mov [byte 1], 41h
	mov [byte 16], 11110000b
	mov [byte 0ah], 240
	mov [byte 0bh], -16
	mov al , [byte 100h]
	mov [byte 101h],0aah
	mov ch, [ds:50h]
	mov al ,[ds:50h]
	mov bx, 30h
	mov dx, bx
	add bx,2
	mov cx,bx
	mov ah, [byte lastname]
	mov [ds:30h] ,ah
exit:
	mov ax, 4c00h
	int 21h
END start