IDEAL

MODEL small
STACK 256

DATASEG
	
	myArea db ?,?,?,?,'A','b','c'
	
CODESEG
   	
start:
	 mov ax, @data
	 mov ds,ax
	
    	
	 
	mov ax, 5
	mov bx, 5
	mov cl, 5
	mov ch, 5
	mov dx, 5
	mov bp, 5
	mov si, 5
	mov di, 5
	
	mov [myArea],    5
	mov [myArea +1], 5
	mov [myArea +2], 5
	mov [myArea +3], 5
	
	
	
	sub ax, 4                   ;?
	add bx, -3                  ;?
	xor ch, ch
	dec cl        
	dec cl                      ;?
	and dx, 1111111111111110b   ;?
	and bp , -1                 ;?
	inc si                      ;?
	or di, 0000000000000010b    ;?
	
		
	shr [byte ptr bx -2], 1   
	shl [byte ptr bx -2], 2         ;?
	xor [byte ptr bx -1], 0Ch       ;?
	shl [byte ptr bx], 1            ;?
	add cl, [byte ptr 0]      
	mov [bx +1 ], cl
	sub cl,[byte ptr 0]             ;?
	
	
	
	 
   
	
EXIT:
    
	mov ax, 4C00h ; returns control to dos
  	int 21h
  
  
;--------------------------
; Procudures area
;--------------------------
 

END start