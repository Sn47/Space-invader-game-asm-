[org 0x0100] 
 jmp start 
msg1: db 'press ENTER to play', 0
msgintro: db 'S  P  A  C  E       I  N  V  A  D  E  R',0
TEXT1: db '   _____ ____  ___   ____________   _____   ___    _____    ____  __________ ',0
TEXT2: db '  / ___// __ \/   | / ____/ ____/  /  _/ | / / |  / /   |  / __ \/ ____/ __ \',0
TEXT3: db '  \__ \/ /_/ / /| |/ /   / __/     / //  |/ /| | / / /| | / / / / __/ / /_/ /',0
TEXT4: db ' ___/ / ____/ ___ / /___/ /___   _/ // /|  / | |/ / ___ |/ /_/ / /___/ _, _/ ',0
TEXT5: db '/____/_/   /_/  |_\____/_____/  /___/_/ |_/  |___/_/  |_/_____/_____/_/ |_|  ',0
OVER1 : db '_____________________  ____________   __________    __________________ ',0
OVER2 : db '_ / ____/__    |__   |/  /__  ____/   __  __ \_ |  / /__  ____/__  __ \',0
OVER3 : db '_/ / __ _   /| |_  /|_/ /__  __/      _  / / /_ | / /__  __/  __  /_/ /',0
OVER4 : db '/ /_/ /_   ___ |  /  / / _  /___      / /_/ /__ |/ / _  /___  _  _, _/ ',0
OVER5 : db '\____/  /_/  |_/_/  /_/  /_____/      \____/ _____/  /_____/  /_/ |_|  ',0

five: dw 0
ten: dw 0
fifteen: dw 0
fivet: dw 'FIVE', 0
tent: dw 'TENS', 0
fivett: dw 'FIFTEENS', 0                                                       
message: db 'SCORE :', 0 
msg2: db 'TIME : ', 0
ship1: db  ' * ', 0 
ship2:     db'*"*"*', 0
ship3:     db' " " " ', 0
spaceship: db 'SPACESHIP',0
alein: db 'DEADLY ALIEN',0
perk1: db '10 POINT PERK',0
perk2: db '15 POINT PERK',0
perk3: db '5 POINT PERK',0

endmsg: db 'Time is up',0
star: db '.'
tickcount: dw 0
ntick: dw 2
current: dw 500
height : dw 2	
pos : dw 45
oldisr: dd 0
end: db 0
seconds: dw 0
nextseconds: dw 4
sec: dw 32
starpos: db 0
spawnedobj: db 0
randval: db 0
obj1: dw 0,0,0
obj2: dw 0,0,0
score: dw 0


                                                        


spawnobj:
	push ax
    push cx
    push dx

    mov ax,0
    push ax
    mov ax,4
    push ax
    call randomSpawn
   
    
    mov bl,dl

	mov ax,0
    push ax
    mov ax,75
    push ax
    call randomSpawn
	mov bh,dl
    cmp bl,0
	mov bh,dl

	mov [obj1+2],bh
    jne nextSpawn
	xor cx,cx
	mov cl,bh
	push cx 
	push 4
	mov word[obj1],0
	call coin2
    mov byte[spawnedobj],0
    jmp finishSpawn
    
    nextSpawn:
    cmp bl,1
    jne nextSpawn1
    xor cx,cx
	mov cl,bh
	push cx ;left
	push 4
	mov word[obj1],1
	call coin1
    mov byte[spawnedobj],1
    jmp finishSpawn
    

    nextSpawn1:
    cmp bl,2
    jne nextSpawn2
      xor cx,cx
	mov cl,bh
	push cx ;left
	push 4
	mov word[obj1],2
	call coin3
    mov byte[spawnedobj],2
    jmp finishSpawn
    

    nextSpawn2:
      xor cx,cx
	mov cl,bh
	push cx ;left
	push 4
	mov word[obj1],3
	call alien1
    mov byte[spawnedobj],3
    finishSpawn:
	mov word[obj1+4],2
    pop dx
    pop cx
    pop ax

    ret


randomSpawn:

    push bp
    mov bp,sp
    push ax
    push bx

    MOV AH, 00h  ; interrupts to get system time        
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

    mov  ax, dx

    add al,[randval]
    add ah,[tickcount]
    
    xor dx,dx
    mov  cx, [bp+4]
    div  cx       
    add dl,[bp+6]
    mov [randval],al
    
    

    pop bx
    pop ax
    pop bp
    RET    4

randomNumber: 
	push ax
	push cx
	MOV ah,07h
    mov [starpos],ah
	INT 1ah
	mov ax,dx
	xor dx,dx
	mov cx,4000
	div cx
	add dx,'0'
	
	pop cx
	pop ax
	ret

	

showstar:
	push cx
	push bx
	push ax
	push si
	push dx
	push di
	mov ax,0xB800
	mov es,ax
	mov bx,300
	
	l1:
	call randomNumber
	
	mov ah,0x07
	mov si,'.'
	mov cx,bx
	shr cx,6
	sub dx,cx
	mov di,dx
	mov al,[si]
	stosw
	dec bx
	jnz l1

	pop di
	pop dx
	pop si
	pop ax
	pop bx
	pop cx

	ret 4
	
againstar:
    push cx
	push bx
	push ax
	push si
	push dx
	push di
	mov ax,0xB800
	mov es,ax
	mov bx,300
	
	l2:
	push ax
	push cx
    mov dx,[starpos]
	INT 1ah
	mov ax,dx
	xor dx,dx
	mov cx,4000
	div cx
	add dx,'0'
	
	pop cx
	pop ax
	ret

	
	mov ah,0x07
	mov si,'.'
	mov cx,bx
	shr cx,6
	sub dx,cx
	mov di,dx
    mov [starpos],di
	mov al,[si]
	stosw
	dec bx
	jnz l2

	pop di
	pop dx
	pop si
	pop ax
	pop bx
	pop cx

	ret
	
    

clrscr: 
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 xor di, di ; point di to top left column 
 mov ax, 0x0720 ; space char in normal attribute 
 mov cx, 2000 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear the whole screen 
 pop di 
 pop cx 
 pop ax 
 pop es 
 ret 


strlen:
 push bp 
 mov bp,sp 
 push es 
 push cx 
 push di 
 les di, [bp+4] 
 mov cx, 0xffff 
 xor al, al 
 repne scasb 
 mov ax, 0xffff 
 sub ax, cx 
 dec ax 
 pop di 
 pop cx 
 pop es 
 pop bp 
 ret 4 

printstr: 
 push bp 
 mov bp, sp 
 push es 
 push ax 
 push cx 
 push si 
 push di 
 push ds
 mov ax, [bp+4] 
 push ax 
 call strlen 
 cmp ax, 0 
 jz exit
 mov cx, ax 
 mov dx,cx 
 shr dx,1
 mov ax, 0xb800 
 mov es, ax 
 mov al, 80 
 mul byte [bp+8] 
 add ax, [bp+10] 
 sub ax,dx 
 shl ax, 1 
 mov di,ax 
 mov si, [bp+4] 
 mov ah, [bp+6] 
 cld 
nextchar: 
 lodsb 
 stosw
 loop nextchar 
exit: 
 pop di 
 pop si 
 pop cx 
 pop ax 
 pop es
 pop bp 
 ret 8


 


ship: 
 push bp 
 mov bp,sp
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
 xor di, di 
 mov al,80
 mul byte [bp+4] 
 add ax, [bp+6]  
 shl ax,1
 mov di,ax 
 mov ah,0x07
 mov al, " "
 stosw
 add di,2 
  mov ah,0x03
 mov al,"*"
 stosw
 add di,2 
 mov ah,0x07
 mov al, ' '
 stosw
 add di ,150
 mov ah,0x05
 mov al, '*'
 stosw
 add di,2
 mov ah,0x05
 mov al, '*'
 stosw
 add di,2
 mov ah,0x05
 mov al, '*'
 stosw
 add di ,150
 mov ah,0x04
 mov al, '"'
 stosw
 add di,2
 mov ah,0x04
 mov al, '"'
 stosw
 add di,2
 mov ah,0x04
 mov al, '"'
 stosw


 pop di 
 pop cx 
 pop ax 
 pop es
 pop bp
 ret 4



coin5:
  push bp 
 mov bp,sp
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
 xor di, di 
 mov al,80
 mul byte [bp+4] 
 add ax,[bp+6]  
 shl ax,1
 mov di,ax 
 mov ah,0x07
 mov al, " "
 mov cx,2
 rep stosw 
 mov ah,0x77
 mov al," "
 mov cx,2
 rep stosw
 mov ah,0x07
 mov al, " "
 mov cx,2
 rep stosw 
  
 ;___________________

 
 add di,144
 mov ah,0x07
 mov al, " "
 mov cx,3
 rep stosw 
 mov ah,0x77
 mov al," "
 stosw
 mov ah,0x37
 mov al, " "
 mov cx,2
 rep stosw 
  mov ah,0x77
 mov al," "
 mov cx,1
 rep stosw
  mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 ;________________________________
 
 add di,146
 
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x37
 mov al," "
 mov cx,4
 rep stosw
 mov ah,0x77
 mov al, " "
 mov cx,1   
 rep stosw 

 
 ;_____________
 
 add di,146
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x37
 mov al," "
 mov cx,4
 rep stosw
 mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw 
  
 ;______________________'


 add di,144
 mov ah,0x07
 mov al, " "
 mov cx,3
 rep stosw 
 mov ah,0x77
 mov al," "
 stosw
 mov ah,0x37
 mov al, " "
 mov cx,2
 rep stosw 
  mov ah,0x77
 mov al," "
 mov cx,1
 rep stosw
  mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 

 ;________________________

 add di,146
  mov ah,0x07
 mov al, " "
 mov cx,3
 rep stosw 
 mov ah,0x77
 mov al," "
 mov cx,2
 rep stosw
 mov ah,0x07
 mov al, " "
 mov cx,2
 rep stosw 
    

 pop di 
 pop cx 
 pop ax 
 pop es
 pop bp
 ret 4


coin:
  push bp 
 mov bp,sp
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
 xor di, di 
 mov al,80
 mul byte [bp+4] 
 add ax,[bp+6]  
 shl ax,1
 mov di,ax 
 mov ah,0x07
 mov al, " "
 mov cx,2
 rep stosw 
 mov ah,0x27
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x07
 mov al, " "
 mov cx,2
 rep stosw 
  
 ;___________________

 
 add di,148
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x07
 mov al," "
 stosw
 mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw 
  mov ah,0x27
 mov al," "
 mov cx,1
 rep stosw
  mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw
  mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 ;________________________________
 add di,148
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x27
 mov al," "
 stosw
 mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw
 
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw
 
 mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw
  mov ah,0x27
 mov al," "
 mov cx,1
 rep stosw
  
 
 ;_____________

 add di,148
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x07
 mov al," "
 stosw
 mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw 
  mov ah,0x27
 mov al," "
 mov cx,1
 rep stosw
  mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw
  mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 

 ;______________________'


 add di,148
  mov ah,0x07
 mov al, " "
 mov cx,3
 rep stosw 
 mov ah,0x27
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x07
 mov al, " "
 mov cx,2
 rep stosw 
    

 pop di 
 pop cx 
 pop ax 
 pop es
 pop bp
 ret 4



coin15:
  push bp 
 mov bp,sp
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
 xor di, di 
 mov al,80
 mul byte [bp+4] 
 add ax,[bp+6]  
 shl ax,1
 mov di,ax 
 mov ah,0x07
 mov al, " "
 mov cx,2
 rep stosw 
 mov ah,0x77
 mov al," "
 mov cx,2
 rep stosw
 mov ah,0x07
 mov al, " "
 mov cx,2
 rep stosw 
  
 ;___________________

 
 add di,144
 mov ah,0x07
 mov al, " "
 mov cx,3
 rep stosw 
 mov ah,0x77
 mov al," "
 stosw
 mov ah,0x37
 mov al, " "
 mov cx,2
 rep stosw 
  mov ah,0x77
 mov al," "
 mov cx,1
 rep stosw
  mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 ;________________________________
 
 add di,146
 
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x37
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x27
 mov al," "
 mov cx,2
 rep stosw
 mov ah,0x37
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw 

 
 ;_____________
  add di,146
 
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x37
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x27
 mov al," "
 mov cx,2
 rep stosw
 mov ah,0x37
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw  
 ;______________________'


 add di,144
 mov ah,0x07
 mov al, " "
 mov cx,3
 rep stosw 
 mov ah,0x77
 mov al," "
 stosw
 mov ah,0x37
 mov al, " "
 mov cx,2
 rep stosw 
  mov ah,0x77
 mov al," "
 mov cx,1
 rep stosw
  mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 ;________________________

 add di,146
  mov ah,0x07
 mov al, " "
 mov cx,3
 rep stosw 
 mov ah,0x77
 mov al," "
 mov cx,2
 rep stosw
 mov ah,0x07
 mov al, " "
 mov cx,2
 rep stosw 
    

 pop di 
 pop cx 
 pop ax 
 pop es
 pop bp
 ret 4

alien: 
 push bp 
 mov bp,sp
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
 xor di, di 
 mov al,80
 mul byte [bp+4] 
 add ax,[bp+6]  
 shl ax,1
 mov di,ax 
 mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x07
 mov al," "
 mov cx,3
 rep stosw
 mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw 
  
 ;___________________

 
 add di,150
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x77
 mov al,"*"
 stosw
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
  mov ah,0x77
 mov al,"*"
 stosw
  mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 

 ;________________________________

 add di,150
 mov ah,0x77
 mov al, " "
 mov cx,5
 rep stosw 

 ;______________________

 add di,150
 mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x47
 mov al," "
 stosw
 mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw 
  mov ah,0x47
 mov al," "
 stosw
  mov ah,0x77
 mov al, " "
 mov cx,1
 rep stosw 


 ;________________

  add di,150
 mov ah,0x77
 mov al, " "
 mov cx,5
 rep stosw

 ;________________

  add di,150
 mov ah,0x77
 mov al, " "
  stosw
  mov ah,0x07
 mov al, " "
 mov cx,3
  rep stosw
  mov ah,0x77
 mov al, " "
  stosw

  ;___________________

  add di,150
 mov ah,0x07
 mov al, " "
  stosw
  mov ah,0x47
 mov al, " "
 mov cx,1
  rep stosw
  mov ah,0x07
 mov al, " "
  stosw
  mov ah,0x47
 mov al, " "
 mov cx,1
  rep stosw
  mov ah,0x07
 mov al, " "
  stosw

 pop di 
 pop cx 
 pop ax 
 pop es
 pop bp
 ret 4


coin1:
 push bp 
 mov bp,sp
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
 xor di, di 
 mov al,80
 mul byte [bp+4] 
 add ax,[bp+6]  
 shl ax,1
 mov di,ax 
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x37
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw
 
 add di,154
 mov ah,0x37
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x37
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x37
 mov al, " "
 mov cx,1
 rep stosw
 
 add di,152
 mov ah,0x07
 mov al, " "
 mov cx,2
 rep stosw 
 mov ah,0x37
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 
 pop di 
 pop cx 
 pop ax 
 pop es
 pop bp
 ret 4


coin2:
 push bp 
 mov bp,sp
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
 xor di, di 
 mov al,80
 mul byte [bp+4] 
 add ax,[bp+6]  
 shl ax,1
 mov di,ax 
 mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x37
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw
 
 add di,154
 mov ah,0x37
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x37
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x37
 mov al, " "
 mov cx,1
 rep stosw
 
 add di,152
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw
 mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x37
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw 
 
 pop di 
 pop cx 
 pop ax 
 pop es
 pop bp
 ret 4


coin3:
 push bp 
 mov bp,sp
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
 xor di, di 
 mov al,80
 mul byte [bp+4] 
 add ax,[bp+6]  
 shl ax,1
 mov di,ax 
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x27
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw
 
 add di,154
 mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x27
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x27
 mov al, " "
 mov cx,1
 rep stosw
 
 add di,152
 mov ah,0x07
 mov al, " "
 mov cx,2
 rep stosw 
 mov ah,0x27
 mov al," "
 mov cx,1
 rep stosw
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw 
 
 pop di 
 pop cx 
 pop ax 
 pop es
 pop bp
 ret 4


alien1:
 push bp 
 mov bp,sp
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
 xor di, di 
 mov al,80
 mul byte [bp+4] 
 add ax,[bp+6]  
 shl ax,1
 mov di,ax 
 mov ah,0x47
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x07
 mov al,"*"
 mov cx,1
 rep stosw
 mov ah,0x47
 mov al, " "
 mov cx,1
 rep stosw
 
 add di,154
 mov ah,0x07
 mov al, "*"
 mov cx,1
 rep stosw 
 mov ah,0x07
 mov al,"*"
 mov cx,1
 rep stosw
 mov ah,0x07
 mov al, "*"
 mov cx,1
 rep stosw
 
 add di,152
 mov ah,0x07
 mov al, " "
 mov cx,1
 rep stosw
 mov ah,0x47
 mov al, " "
 mov cx,1
 rep stosw 
 mov ah,0x07
 mov al,"*"
 mov cx,1
 rep stosw
 mov ah,0x47
 mov al, " "
 mov cx,1
 rep stosw 
 
 pop di 
 pop cx 
 pop ax 
 pop es
 pop bp
 ret 4



scroll:
 call clrscr

 mov ax, 4
 push ax 
 mov ax, 2
 push ax 
 mov ax, 0x70 
 push ax 
 mov ax, message
 push ax 
 call printstr
  
 mov ax, 60 
 push ax 
 mov ax, 2
 push ax 
 mov ax, 0x70
 push ax 
 mov ax, msg2
 push ax 


 call printstr


 mov ax, [pos]
 push ax 
 mov ax, 22
 push ax 

 call ship


 mov ax, [obj1+2]
 push ax 
 mov ax, [obj1+4]
 add ax,3
 push ax 
 call coin3
 mov [obj1+4],ax
 
 ret

 ;_____________________________________________
 ;__________________________________

printnum:
 push bp 
 mov bp, sp 
 push es 
 push ax 
 push bx 
 push cx 
 push dx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov ax, [bp+4] ; load number in ax 
 mov bx, 10 ; use base 10 for division 
 mov cx, 0 ; initialize count of digits 
 nextdigit: mov dx, 0 ; zero upper half of dividend 
 div bx ; divide by 10 
 add dl, 0x30 ; convert digit into ascii value 
 push dx ; save ascii value on stack 
 inc cx ; increment count of values 
 cmp ax, 0 ; is the quotient zero 
 jnz nextdigit ; if no divide it again 
 mov di, [bp+6] ; point di to 70th column 
 nextpos: pop dx ; remove a digit from the stack 
 mov dh, 0x07 ; use normal attribute 
 mov [es:di], dx ; print char on screen 
 add di, 2 ; move to next screen location 
 loop nextpos ; repeat for all digits on stack 
 pop di 
 pop dx 
 pop cx 
 pop bx 
 pop ax
 pop es 
 pop bp 
 ret 4 



timer:
 push ax 
 inc word [cs:tickcount]; increment tick count 
 push word [cs:tickcount] 
 call printnum 
 mov ax,18
 mov bx,[cs:tickcount]
 mov [cs:tickcount],bx
 no:
 mov al, 0x20 
 out 0x20, al ; end of interrupt 
 pop ax 
 iret
 
 

scrollright:
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov di,3360  ; point di to top left column 
 mov ax, 0x0720 ; space char in normal attribute 
 mov cx, 640 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear the whole screen 


 mov ax, [pos]
 cmp ax,42h
 je notright
 add ax,1
 mov [pos],ax
 notright:
 push ax 
 mov ax, 22
 push ax 

 call ship


 pop di 
 pop cx 
 pop ax 
 pop es 
 ret 
 

scroleft:
 push es 
 push ax 
 push cx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov di,3360  ; point di to top left column 
 mov ax, 0x0720 ; space char in normal attribute 
 mov cx, 640 ; number of screen locations 
 cld ; auto increment mode 
 rep stosw ; clear the whole screen 


 mov ax, [pos]
 cmp ax,4h
 je notleft
 sub ax,1
 mov [pos],ax
 notleft:
 push ax 
 mov ax, 22
 push ax 

 call ship
 
 pop di 
 pop cx 
 pop ax 
 pop es 
 ret 



  ;______________________________________

moveship:

 kbisr: push ax 
 push es 
 mov ax, 0xb800 
 mov es, ax ; point es to video memory 
 in al, 0x60 ; read a char from keyboard port 
 cmp al, 0x4b ; has the left shift pressed 
 jne nextcmp ; no, try next comparison 
 mov byte [es:0], 'L' ; yes, print L at first column 
 call scroleft
 jmp exit1 ; leave interrupt routine 
 nextcmp: cmp al, 0x4d ; has the right shift pressed 
 jne nextcmp2 ; no, try next comparison 
 mov byte [es:0], 'R' ; yes, print R at second column 
 call scrollright
 jmp exit1 ; leave interrupt routine 
 nextcmp2: cmp al, 0xaa ; has the left shift released 
 jne nextcmp3 ; no, try next comparison 
 mov byte [es:0], ' ' ; yes, clear the first column 
 jmp exit1 ; leave interrupt routine 
 nextcmp3: cmp al, 0xb6 ; has the right shift released 
 jne nomatch ; no, chain to old ISR 
 mov byte [es:2], ' ' ; yes, clear the second column 
 jmp exit1 ; leave interrupt routine 
 nomatch: pop es 
 pop ax 
 jmp far [cs:oldisr] ; call the original ISR 
 exit1: mov al, 0x20 
 out 0x20, al ; send EOI to PIC 
 pop es 
 pop ax 
 iret


 ;______________________________________________________
 
 ;__________________________________________________________________






gamesc:

 call clrscr 

 
 mov ax,star
 push ax
 mov ax,1
 push ax
 call showstar
 


 mov ax, 4
 push ax 
 mov ax, 0
 push ax 
 mov ax, 0x70 
 push ax 
 mov ax, message
 push ax 
 call printstr
  
 mov ax, 60 
 push ax 
 mov ax, 0 
 push ax 
 mov ax, 0x70
 push ax 
 mov ax, msg2
 push ax 


 call printstr


  
 mov ax, 45
 push ax 
 mov ax, 22
 push ax 

 call ship
 call clock
 call keyboard
 
 ret


clock:
 xor ax, ax 
 mov es, ax ; point es to IVT base 
 cli ; disable interrupts
 mov word [es:8*4], Timer; store offset at n*4 
 mov [es:8*4+2], cs ; store segment at n*4+2 
 sti ; enable interrupts 
 mov dx, start ; end of resident portion 
 add dx, 15 ; round up to next para 
 mov cl, 4 
 shr dx, cl ; number of paras 
 ret
keyboard:
    xor ax, ax 
	mov es, ax ; point es to IVT base 

	mov ax, [es:9*4] 
	mov [oldisr], ax ; save offset of old routine 
	mov ax, [es:9*4+2] 
	mov [oldisr+2], ax ; save segment of old routine 
	cli ; disable interrupts 
	mov word [es:9*4], moveship ; store offset at n*4 
	mov [es:9*4+2], cs ; store segment at n*4+2 
	sti ; enable interrupts
   

    ret


Timer: 
	push ax 
	cmp byte [end],1
	je timeend
	push cs
	pop ds
 	inc word [tickcount]; increment tick count 
 	mov ax,[tickcount]
	xor dx,dx  
	mov cx,19		;Time counter
	div cx
	mov word[seconds],ax
	cmp word [seconds],120
	jne dontEnd
		mov byte[end],1
		jmp timeend
	dontEnd:
	

	mov ax,140
	push ax
    mov ax,[seconds]
	push ax
	call printnum

	mov ax,16
	push ax
    mov ax,[score]
	push ax
	call printnum
						

	call timerthings
	



	jmp nottimeend
	timeend:
		call clrscr
    	mov ax, 30
		push ax ; push x position 
		mov ax, 7
		push ax ; push y position 
		mov ax, endmsg 
		push ax ; push address of message 
		call printstr
		call endscr
		jmp endgame




	nottimeend:
	

 	mov al, 0x20 
 	out 0x20, al ; end of interrupt 
 	pop ax 
 	iret


timerthings:
   mov ax,[tickcount]
	cmp ax,[ntick]
	jne notscroll
		cmp ax,[sec]
		jne notspawn
		add word[sec],36 		;Control Fall Object time
		call spawnobj
		
	notspawn:
        call collioncheck
		scrolll:
		mov ax,0xB800
		mov es,ax
		add word[ntick],2
		mov ax,1
		push ax
		call scrolldown1
		
		
		
	
	notscroll:



	ret 

collioncheck:
        mov ax,[obj1+4]
		cmp ax,18
		jbe returncheck
		mov al,[pos]
		mov ah,[obj1+2]
		sub al,ah
		cmp al,3
		jbe scoreup
		mov al,[pos]
		mov ah,[obj1+2]
		sub ah,al
		cmp ah,3
		jbe scoreup
		returncheck:
		ret

scoreup:
		mov ax,[obj1]
		cmp ax,0
		jne o2 
		mov ax,15
		add [score],ax
		add word[fifteen],1
		call soundsweet
		jmp returncheck
		o2:
		mov ax,[obj1]
		cmp ax,1
		jne o3
		mov ax,10
		add [score],ax
		add word[ten],1
		call soundsweet
		jmp returncheck
		o3:
		mov ax,[obj1]
		cmp ax,2
		jne o4 
		mov ax,5
		add [score],ax
		add word[five],1
		call soundsweet
		jmp returncheck
		o4:
		call soundbad
        call endscr
		jmp endscr
		ret
		

soundsweet:
mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 205        ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 2   ; Pause for duration of note.
.pause1:
        mov     cx, 65535
.pause2:
        dec     cx
        jne     .pause2
        dec     bx
        jne     .pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.
ret


soundbad:
mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, 1140     ; Frequency number (in decimal)
                                ;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 5    ; Pause for duration of note.
.pause1:
        mov     cx, 65535
.pause2:
        dec     cx
        jne     .pause2
        dec     bx
        jne     .pause1
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.
ret

scrolldown1: 
 	push bp 
 	mov bp,sp 
 	push ax 
 	push cx 
 	push si 
 	push di 
 	push es 
 	push ds 
	mov ax,[obj1+4]
	    add ax,1
	    mov [obj1+4],ax
 	mov ax, 80 ; load chars per row in ax 
 	mul byte [bp+4] ; calculate source position 
 	push ax ; save position for later use 
 	shl ax, 1 ; convert to byte offset 
 	mov si, 3520 ; last location on the screen 
 	sub si, ax ; load source position in si 
 	mov cx, 1760 ; number of screen locations 
 	sub cx, ax ; count of words to move 
 	mov ax, 0xb800 
 	mov es, ax ; point es to video base 
 	mov ds, ax ; point ds to video base y
 	mov di, 3520 ; point di to lower right column 
 	std ; set auto decrement mode 
 	rep movsw ; scroll up 
 	mov ax, 0x0720 ; space in normal attribute 
 	pop cx ; count of positions to clear 
 	rep stosw ; clear the scrolled space 
	
 	pop ds 
 	pop es 
 	pop di 
 	pop si 
 	pop cx 
 	pop ax 
 	pop bp 
 	ret 2 

intro:



 call clrscr 
 
 mov ax,star
 push ax
 mov ax,1
 push ax
 call showstar
 
 
 
  mov ax, 40
  push ax 
  mov ax, 7 
  push ax 
  mov ax, 0x7 
  push ax 
  mov ax, TEXT1
  push ax 
 
  call printstr
  
  
  mov ax, 40
  push ax 
  mov ax, 8
  push ax 
  mov ax, 0x7 
  push ax 
  mov ax, TEXT2
  push ax 
 
  call printstr
 
  
  mov ax, 40
  push ax 
  mov ax, 9
  push ax 
  mov ax, 0x7 
  push ax 
  mov ax, TEXT3
  push ax 
 
  call printstr
 
  
  mov ax, 40
  push ax 
 mov ax, 10
 push ax 
 mov ax, 0x7 
 push ax 
 mov ax, TEXT4
 push ax 

 call printstr

 
 mov ax, 40
 push ax 
 mov ax, 11
 push ax 
 mov ax, 0x7 
 push ax 
 mov ax, TEXT5
 push ax 

 call printstr


 mov ax, 40 
 push ax 
 mov ax, 20 
 push ax 
 mov ax, 0x8F
 push ax 
 mov ax, msg1
 push ax 


 call printstr
 ret
 

intro2:


  call clrscr 

 


 mov ax, 40
 push ax 
 mov ax, 2
 push ax 
 mov ax, 0x07 
 push ax 
 mov ax, msgintro
 push ax 
 call printstr


 mov ax, 30
 push ax 
 mov ax, 6
 push ax 
 call ship

 mov ax, 45
 push ax 
 mov ax, 7
 push ax 
 mov ax, 0x70 
 push ax 
 mov ax, spaceship
 push ax 
 call printstr


 mov ax, 6
 push ax 
 mov ax, 10
 push ax 
 call alien1

 mov ax, 16
 push ax 
 mov ax, 11
 push ax 
 mov ax, 0x07 
 push ax 
 mov ax, alein
 push ax 
 call printstr


 mov ax, 6
 push ax 
 mov ax, 20
 push ax 
 call coin1

 mov ax, 16
 push ax 
 mov ax, 21
 push ax 
 mov ax, 0x07 
 push ax 
 mov ax, perk1
 push ax 
 call printstr

 mov ax, 50
 push ax 
 mov ax, 10
 push ax 
 call coin2

 mov ax, 60
 push ax 
 mov ax, 11
 push ax 
 mov ax, 0x07 
 push ax 
 mov ax, perk2
 push ax 
 call printstr

 mov ax, 50
 push ax 
 mov ax, 20
 push ax 
 call coin3

 mov ax, 60
 push ax 
 mov ax, 21
 push ax 
 mov ax, 0x07 
 push ax 
 mov ax, perk3
 push ax 
 call printstr

 ret 
 
endscr:


 call clrscr 

 mov ax,star
 push ax
 mov ax,1
 push ax
 call showstar




 mov ax, 40
 push ax 
 mov ax, 7 
 push ax 
 mov ax, 0x7 
 push ax 
 mov ax, OVER1
 push ax 

 call printstr
 
 
 mov ax, 40
 push ax 
 mov ax, 8
 push ax 
 mov ax, 0x7 
 push ax 
 mov ax, OVER2
 push ax 

 call printstr

 
 mov ax, 40
 push ax 
 mov ax, 9
 push ax 
 mov ax, 0x7 
 push ax 
 mov ax, OVER3
 push ax 

 call printstr

 
 mov ax, 40
 push ax 
 mov ax, 10
 push ax 
 mov ax, 0x7 
 push ax 
 mov ax, OVER4
 push ax 

 call printstr

 
 mov ax, 40
 push ax 
 mov ax, 11
 push ax 
 mov ax, 0x7 
 push ax 
 mov ax, OVER5
 push ax 

 call printstr

 mov ax, 40 
 push ax 
 mov ax, 14
 push ax 
 mov ax, 0x07
 push ax 
 mov ax, message
 push ax 

 
 call printstr



 push 2330
 push word[score]
 call printnum



 mov ax, 40 
 push ax 
 mov ax, 16
 push ax 
 mov ax, 0x07
 push ax 
 mov ax, fivet
 push ax 

 
 call printstr

 push 2650
 push word[five]
 call printnum


 mov ax, 40 
 push ax 
 mov ax, 18
 push ax 
 mov ax, 0x07
 push ax 
 mov ax, tent
 push ax 

 
 call printstr


push 2970
 push word[ten]
 call printnum


 mov ax, 40 
 push ax 
 mov ax, 20
 push ax 
 mov ax, 0x07
 push ax 
 mov ax, fivett
 push ax 

 
 call printstr
 
push 3290
 push word[fifteen]
 call printnum


 
 
 jmp endgame
 ret



start:
 call intro
 s1:
 mov	ah,		0
 int 	16h
 cmp 	ah,28
 jne s1

  call clrscr

  
  call intro2
 s2:
 mov	ah,		0
 int 	16h
 cmp 	ah,28
 jne s2

 call gamesc

endgame:
	s3:
     mov	ah,		0
    int 	16h
    cmp 	ah,28
    jne s3
 mov ax, 0x4c00 ; terminate and stay resident 
 int 0x21
