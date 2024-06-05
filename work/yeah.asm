IDEAL

MODEL small

STACK 100h

DATASEG


CODESEG
IsExit db 0
x dw 270
y dw 22
lengthh dw 10
widthh dw 10
color db 4
Direction db 0
speed dw 1
gameover dw 'g','a','m','e',' ','o','v','e','r','$'
start:

mov ax, @data
mov ds, ax
mov ax,13h
int 10h

mainloop:

	mov [color],4
	call fullrec
	call LoopDelay1Sec

	starttt:
	cmp [Direction],0
	je Down1
	cmp [Direction],1
	je Up1
	cmp [Direction],2
	je Right1
	cmp [Direction],3
	je Left1
	
	Up1:
	mov bx,[speed]
	sub [y],bx
	mov [color],0
	call fullrec
	add [y],bx
	mov [color],0
	call fullrec
	jmp strt
	
	Down1:
	mov bx,[speed]
	add [y],bx
	mov [color],0
	call fullrec
	sub [y],bx
		mov [color],0
	call fullrec
	jmp strt
	
	Right1:
	mov bx,[speed]
	sub [x],bx
	mov [color],0
	call fullrec
	add [x],bx
		mov [color],0
	call fullrec
	jmp strt

	
	Left1:
	mov bx,[speed]
	add [x],bx
	mov [color],0
	call fullrec
	sub [x],bx
	mov [color],0
	call fullrec	
	jmp strt

	
	strt:
	cmp [IsExit],1
	je pp

	mov ah, 1	
  	 int 16h
 	 jz Delay 	
 	 mov ah,0		
      	 int 16h
	cmp ah,  48h		
 	 je DownArrow
	 cmp ah,  50h	
 	 je UpArrow
  	 cmp ah, 4Dh 		
 	 je RightArrow
 	 cmp ah, 4Bh
  	 je LeftArrow
	 cmp ah,39h
	 je Space
	 cmp ah,1		
 	 je Exitt
	 pp:
	 jmp exittt
	Space:
	mov ax,3
	mul [speed]
	mov [speed],ax
	jmp mainloop
	DownArrow:
	mov [Direction],0
	jmp Delay
	UpArrow:
	mov [Direction],1	
	jmp Delay
	RightArrow:
	mov [Direction],2
	jmp Delay
	LeftArrow:
	mov [Direction],3
	jmp Delay
	Exitt:
	mov [IsExit],1
	jmp strt
	
	Delay:
	cmp [x],309
	je rightt
	cmp [x],0
	je leftt
	cmp [y],189
	je upp
	cmp [y],0
	je downn
	jmp bing
	
	rightt:
	mov [Direction],3
	jmp bing
	leftt:
	mov [Direction],2
	jmp bing
	upp:
	mov [Direction],0
	jmp bing
	downn:
	mov [Direction],1
	
	bing:
	cmp [Direction],0
	je Down
	cmp [Direction],1
	je Up
	cmp [Direction],2
	je Right
	cmp [Direction],3
	je Left
	
	Up:
	mov bx,[speed]
	add [y],bx
	jmp mainloop
	
	Down:
	mov bx,[speed]
	sub [y],bx
	jmp mainloop
	
	Right:
	mov bx,[speed]	
	add [x],bx
	jmp mainloop
	Left:
	mov bx,[speed]
	sub [x],bx
	jmp mainloop
	
	exittt:


	mov dx,offset gameover
	mov ah,9
	int 21h
	
	exitttttttttt:
	mov ah, 1	
  	 int 16h
 	 jz exitttttttttt	
 	 mov ah,0		
     int 16h
	cmp ah,  01ch		
 	 je done
	jmp exitttttttttt
	done:



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
push bx
mov cx,[widthh]
@@loopfullrect:
call colum
add [x],1
loop @@loopfullrect
mov bx,[widthh]
sub [x],bx
pop bx
pop cx
ret
endp fullrec

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

END start


