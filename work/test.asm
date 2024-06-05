IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
RndCurrentPos dw 0
x dw 0
y dw 0
target_x dw 0
target_y dw 0
len dw 15
wid dw 15
speed dw 3
direction dw 0
timer dw 0
TargetCollision db 0
; --------------------------

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
	mov ax, 13h
	int 10h
	mov bh, 0h
	mov di, 0
; --------------------------
	call GenerateTarget
	WaitForInput:
	; cmp [TargetExists], 1
	; je cont
	push 50
	call LoopDelay1Sec
	add di, 50 ; DI holds the counter for when to add a second
	call CheckCounter
	call MovePlayer
	mov ah, 1 ; check Key.avalible
	int 16h
	jz WaitForInput
	mov ah, 0 ; Check what is the pressed key
	int 16h
	
	cmp ah, 4Dh ; Check for right arrow
	je RightDirection
	
	cmp ah, 4Bh ; Check for left arrow
	je LeftDirection
	
	cmp ah, 48h
	je UpDirection
	
	cmp ah, 50h
	je DownDirection
	
	cmp ah, 01h
	je mid_exit
	
	jmp WaitForInput
	
	mid_exit:
	jmp exit
	
	RightDirection:
	mov [direction], 0
	jmp WaitForInput
	
	LeftDirection:
	mov [direction], 1
	jmp WaitForInput
	
	DownDirection:
	mov [direction], 2
	jmp WaitForInput
	
	UpDirection:
	mov [direction], 3
	jmp WaitForInput

exit:
	mov ax, 4c00h
	int 21h
	
proc DrawDot ; Parameters: x, y, color
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push ds
	
	mov ax, 320
	mov bx, [bp+6]
	mul bx
	mov bx, ax
	add bx, [bp+8]
	mov dx, [bp+4]
	mov ax, 0A000h
	mov ds, ax
	mov [bx], dx
	
	pop ds
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
endp

proc DrawHorizontalLine ; Paramters: x, y, length, color
	push bp
	mov bp, sp
	push cx
	mov cx, [bp+6]
	@@DrawLine:
	push [bp+10]
	push [bp+8]
	push [bp+4]
	call DrawDot
	inc [bp+10]
	loop @@DrawLine
	
	pop cx
	pop bp
	ret 8
endp

proc DrawVerticalLine ; Paramters: x, y, length, color
	push bp
	mov bp, sp
	push cx
	mov cx, [bp+6]
	@@DrawLine:
	push [bp+10]
	push [bp+8]
	push [bp+4]
	call DrawDot
	inc [bp+8]
	loop @@DrawLine
	
	pop cx
	pop bp
	ret 8
endp

proc DrawRect ; Parameters: x, y, length, width, color
	push bp
	mov bp, sp
	push ax

; ================Left side line===================
	push [bp+12] ; X
	push [bp+10] ; Y
	push [bp+8] ; length
	push [bp+4] ; color
	call DrawVerticalLine
; ================Upper line=====================
	push [bp+12] ; X
	push [bp+10] ; Y
	push [bp+6] ; width
	push [bp+4] ; color
	call DrawHorizontalLine
; ================Right side line===================
	mov ax, [bp+6]
	add [bp+12], ax
	push [bp+12] ; X
	push [bp+10] ; Y
	push [bp+8] ; length
	push [bp+4] ; color
	call DrawVerticalLine
	sub [bp+12], ax
; ================Bottom line=========================
	mov ax, [bp+8]
	add [bp+10], ax
	inc [bp+6]
	push [bp+12] ; X
	push [bp+10] ; Y
	push [bp+6] ; width
	push [bp+4] ; color
	call DrawHorizontalLine
	
	pop ax
	pop bp
	ret 10
endp 

proc DrawFullRect ; Parameters: x, y, length, width, color
	push bp
	mov bp, sp
	push cx
	
	mov cx, [bp+6]
	@@FillRectLoop:
	push [bp+12]
	push [bp+10]
	push [bp+8]
	push [bp+4]
	call DrawVerticalLine
	inc [bp+12]
	loop @@FillRectLoop
	
	
	pop cx
	pop bp
	ret 10
endp



proc LoopDelay1Sec
	push bp
	mov bp, sp
	push cx
	mov cx, [bp+4]
@@Self1:
	push cx
	mov cx,3000
@@Self2:
	loop @@Self2
	pop cx
	loop @@Self1
	pop bp
	pop cx
	ret 2
endp LoopDelay1Sec

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

proc PrintNum
    push bp
    mov bp, sp
    push ax ; | Prevent
    push bx ; | Ruining
    push cx ; | Outside
    push dx ; | Values
    
    xor dx, dx
    mov dx, [bp+4]
    mov ax, dx ; The number to print
    mov cx, 0
    @@myLoop:
    xor bh, bh
    xor dx, dx ; Reset DX because it affects the division result
    mov bl, 10 
    div bx ; al = ax / bl , ah = ax % bl
    push dx ; Save the most right digit
    inc cx ; Increase the counter of digits
    cmp ax, 0 ; Check if we have reached 0
    jne @@myLoop ; If we didn't - keep on going, if we did - Print
    
    @@Print:
    mov ah, 02h
    xor dx, dx 
    pop dx ; Get the last digit we pushed (most left digit)
    add dl, 30h ; Transform to ascii
    int 21h 
    loop @@Print
    
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2
endp PrintNum

proc CheckCounter ; Checks if the counter got to 1000, if it did - reset it and add to increase the Timer
	cmp di, 1000
	jne @@exit_func ; If not 1000 on the counter, leave the function
	mov di, 0
	inc [timer] ; Adds second to the timer
	call PrintTimer ; Prints the timer
	@@exit_func:
	ret
endp

proc PrintTimer
	push ax
	push bx
	push dx
; ---------------------- Moves the pointer to the start
	mov ah, 2
	mov bh, 0
	mov dl, 0
	mov dh, 0
	int 10h
; ----------------------
	push [Timer]
	call PrintNum
	
	pop dx
	pop bx
	pop ax
	ret 
endp

proc MovePlayer ; Erases the player from its current position and according to the saved direction, moves to new location
	push bp
	mov bp, sp
	
	
	cmp [direction], 0
	je @@MoveRight
	
	cmp [direction], 1
	je @@MoveLeft
	
	cmp [direction], 2
	je @@MoveDown
	
	cmp [direction], 3
	je @@MoveUp
	
	@@MoveRight:
	call ErasePlayer
	mov ax, [speed]
	add [x], ax
	call DrawPlayer
	jmp @@exit_func
	
	@@MoveLeft:
	call ErasePlayer
	mov ax, [speed]
	sub [x], ax
	call DrawPlayer
	jmp @@exit_func
	
	@@MoveUp:
	call ErasePlayer
	mov ax, [speed]
	sub [y], ax
	call DrawPlayer
	jmp @@exit_func
	
	@@MoveDown:
	call ErasePlayer
	mov ax, [speed]
	add [y], ax
	call DrawPlayer
	jmp @@exit_func
	
	@@exit_func:
	pop bp
	ret
endp 

proc ErasePlayer
	push [x]
	push [y]
	push [len]
	push [wid]
	push 0
	call DrawFullRect
	ret
endp

proc DrawPlayer
	push [x]
	push [y]
	push [len]
	push [wid]
	push 1
	call DrawFullRect
	ret
endp

proc GenerateTarget
	push ax
	push bx
	push cx
	push dx
	
; ------------------- Generate Random X
	mov bl, 0
	mov bh, 255
	xor ax, ax
	call RandomByCs
	mov [target_x], ax
	push ax
; -------------------
; ------------------- Generate Random Y
	mov bl, 0
	mov bh, 255
	xor ax, ax
	call RandomByCs
	mov [target_y], ax
	push ax
; -------------------

	push 5
	push 5
	push 6
	call DrawFullRect
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp
EndOfCsLbl:
END start





