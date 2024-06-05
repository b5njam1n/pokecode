IDEAL
MODEL small
STACK 100h
DATASEG
	 RndCurrentPos dw start
x dw 270
y dw 22
lengthh dw 5
widthh dw 5
color db 4
CODESEG
start:
	mov ax, @data
	mov ds, ax
	mov ax,13h
	int 10h
	rndloop:
	
	call LoopDelay1Sec
	
	mov bx,0
	mov dx,319
	call RandomByCsWord
	mov [x],ax
	
	mov bx,0
	mov dx,199
	call RandomByCsWord
	mov [y],ax
	
	mov bl,0
	mov bh,10
	call RandomByCs
	mov [color],al
	call fullrec
	 mov ah, 1		; check if key was pressed
  	 int 16h
 	 jz Delay 		; if zero flag on – no key was pressed
  				; zero flag is 0 so key was pressed 
 	 mov ah,0		; check which key was pressed
     int 16h

	 cmp ah,1		; Esc was pressed
 	 je Exit
	 Delay:
	 jmp rndloop
	 Exit:

exit:
	mov ax, 4c00h
	int 21h
proc colum
	mov bp,sp
	push bp
	push ax
	push bx
	push cx
	push dx
	mov cx, [lengthh]
	mov dx,[y]	
	@@columloop:
	push cx
	mov bh,0h
	mov cx,[x]
	mov al,[color]
	mov ah,0ch
	int 10h
	inc dx
	pop cx
	loop @@columloop
	pop dx	
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
endp colum
proc line
mov bp,sp
push bp
push ax
push bx
push cx
push dx
push si
xor si,si
mov cx,[widthh]
@@printloop:
push cx
mov bh,0h
mov cx,[x]
add cx,si
mov dx,[y]
mov al,[color]
mov ah,0ch
int 10h
inc si
pop cx
loop @@printloop
pop si
pop dx
pop cx
pop bx
pop ax
pop bp
ret 
endp line
proc drawrect
push bx
call line
call colum
mov bx,[lengthh]
add [y],bx
call line
sub [y],bx
mov bx,[widthh]
add [x],bx
call colum
pop bx
ret
endp drawrect

proc fullrec
push cx
mov cx,[widthh]
@@loopfullrect:
call colum
add [x],1
loop @@loopfullrect
pop cx
ret
endp fullrec
; Description  : get RND between any bl and bh includs (max 0 - 65535)
; Input        : 1. BX = min (from 0) , DX, Max (till 64k -1)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        AX - rnd num from bx to dx  (example 50 - 1550)
; More Info:
; 	BX  must be less than DX 
; 	in order to get good random value again and again the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCsWord
    push es
	push si
	push di
 
	
	mov ax, 40h
	mov	es, ax
	
	sub dx,bx  ; we will make rnd number between 0 to the delta between bx and dx
			   ; Now dx holds only the delta
	cmp dx,0
	jz @@ExitP
	
	push bx
	
	mov di, [word RndCurrentPos]
	call MakeMaskWord ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
@@RandLoop: ;  generate random number 
	mov bx, [es:06ch] ; read timer counter
	
	mov ax, [word cs:di] ; read one word from memory (from semi random bytes at cs)
	xor ax, bx ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	inc di
	cmp di,(EndOfCsLbl - start - 2)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	
	cmp ax,dx    ;do again if  above the delta
	ja @@RandLoop
	pop bx
	add ax,bx  ; add the lower limit to the rnd num
		 
@@ExitP:
	
	pop di
	pop si
	pop es
	ret
endp RandomByCsWord

; Description  : get RND between any bl and bh includs (max 0 -255)
; Input        : 1. Bl = min (from 0) , BH , Max (till 255)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        Al - rnd num from bl to bh  (example 50 - 150)
; More Info:
; 	Bl must be less than Bh 
; 	in order to get good random value again and agin the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCs
    push es
	push si
	push di
	
	mov ax, 40h
	mov	es, ax
	
	sub bh,bl  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp bh,0
	jz @@ExitP
 
	mov di, [word RndCurrentPos]
	call MakeMask ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
RandLoop: ;  generate random number 
	mov ax, [es:06ch] ; read timer counter
	mov ah, [byte cs:di] ; read one byte from memory (from semi random byte at cs)
	xor al, ah ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	cmp di,(EndOfCsLbl - start - 1)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	cmp al,bh    ;do again if  above the delta
	ja RandLoop
	
	add al,bl  ; add the lower limit to the rnd num
		 
@@ExitP:	
	pop di
	pop si
	pop es
	ret
endp RandomByCs
Proc MakeMask    
    push bx

	mov si,1
    
@@again:
	shr bh,1
	cmp bh,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop bx
	ret
endp  MakeMask


Proc MakeMaskWord    
    push dx
	
	mov si,1
    
@@again:
	shr dx,1
	cmp dx,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop dx
	ret
endp  MakeMaskWord

proc LoopDelay1Sec
	push cx
	mov cx ,1000 
@@Self1:
	  push cx
	mov cx,3000   
@@Self2:	
	loop @@Self2
	pop cx
	loop @@Self1
	pop cx
	ret
endp LoopDelay1Sec

EndOfCsLbl:
END start


