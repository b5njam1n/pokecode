IDEAL
MODEL small
STACK 100h
DATASEG
 string db "'attack'"

CODESEG
start:
	mov ax, @data
	mov ds, ax
	mov ax,0B800h
	mov es,ax
	mov di,3840
	mov al, [string]
	mov ah,00100100b 
	mov [es:di] ,ax
	mov ax,0B800h
	mov es,ax
	mov di,3842
	mov al, [string+1]
	mov ah,00100100b 
	mov [es:di] ,ax
	mov ax,0B800h
	mov es,ax
	mov di,3844
	mov al, [string+2]
	mov ah,00100100b 
	mov [es:di] ,ax
	mov ax,0B800h
	mov es,ax
	mov di,3846
	mov al, [string+3]
	mov ah,00100100b 
	mov [es:di] ,ax
	mov ax,0B800h
	mov es,ax
	mov di,3848
	mov al, [string+4]
	mov ah,00100100b 
	mov [es:di] ,ax
	mov ax,0B800h
	mov es,ax
	mov di,3850
	mov al, [string+5]
	mov ah,00100100b 
	mov [es:di] ,ax
	mov ax,0B800h
	mov es,ax
	mov di,3852
	mov al, [string+6]
	mov ah,00100100b 
	mov [es:di] ,ax
	mov ax,0B800h
	mov es,ax
	mov di,3854
	mov al, [string+7]
	mov ah,00100100b 
	mov [es:di] ,ax

exit:
	mov ax, 4c00h
	int 21h
END start


