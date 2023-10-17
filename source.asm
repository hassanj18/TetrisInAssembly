[org 0x0100]
jmp start
var:db '-'
x1:db 0
x2:db 0
y1:db 50
y2:db 24
topleft:dw 0
topright:dw 0
bottomleft:dw 0
bottomright:dw 0

mess1:db 'SCORE'
mess2:db 'TIME'
mess3:db 'SHAPE'
score:dw 0

clrscr: push es
 push ax
 push di

 mov ax, 0xb800
 mov es, ax ; point es to video base
 mov di, 0 ; point di to top left column
nextloc: mov word [es:di], 0x0720 ; clear next char on screen
 add di, 2 ; move to next screen location
 cmp di, 4000 ; has the whole screen cleared
 jne nextloc ; if no clear next position
 pop di
 pop ax
 pop es
 ret

coordinate:
push bp
mov bp,sp
push ax
push bx
mov al, 80 
 mul byte [bp+6] 
 add ax, [bp+8] 
 shl ax, 1
mov bx,[bp+4]
mov [bx],ax

pop bx
pop ax
pop bp
ret 6

rectangle:
push bp
mov bp,sp
push ax
push bx
push cx
push dx
push di
push si
push es

mov ax, 0xb800 ; load video base in ax
mov es, ax
mov di,[bp+10]
mov ah,0x78
mov al,[bp+12]
mov bx,[bp+8]
mov dx,ax
lp:
mov [es:di],ax
add di,2
cmp di,bx
jna lp

mov di,[bp+6]
mov bx,[bp+4]

lp2:
mov [es:di],ax
add di,2
cmp di,bx
jna lp2

mov di,[bp+10]
mov bx,[bp+6]
add di,160
mov si,di
add si,2
mov dl,32
mov al,124
lp3:
mov [es:di],dx
mov [es:si],ax
add di,160
add si,160
cmp di,bx
jc lp3

mov di,[bp+8]
mov bx,[bp+4]
add di,160
mov si,di
sub si,2
lp4:
mov [es:di],dx
mov [es:si],ax
add di,160
add si,160
cmp di,bx
jc lp4




pop es
pop si
pop di
pop dx
pop cx
pop bx
pop ax
pop bp
ret 10

classPrint:
printMessage:
push bp
mov bp,sp
push ax
push bx
push cx
push di
push si
push es

 mov ax, 0xb800
 mov es, ax 
 mov ax,0
 mov cx,[bp+4]
 mov bx,[bp+6]
mov ah,0x3E
mov si,0
mov di,[bp+8]
printlp:
mov al,byte[bx+si]
mov [es:di],ax
add di,2
add si,1
loop printlp

pop es
pop si
pop di
pop cx
pop bx
pop ax
pop bp
ret 6


DrawBorder:
mov ax,0
mov al,byte[x1]
push ax
mov al,byte[x2]
push ax
push topleft
call coordinate
mov al,byte[y1]
push ax
mov al,byte[x2]
push ax
push topright
call coordinate
mov al,byte[x1]
push ax
mov al,byte[y2]
push ax
push bottomleft
call coordinate
mov al,byte[y1]
push ax
mov al,byte[y2]
push ax
push bottomright
call coordinate
mov al,byte[var]
push ax
push word[topleft]
push word[topright]
push word[bottomleft]
push word[bottomright]
call rectangle
ret

ScoreBoard:
 mov ax, 0xb800
 mov es, ax 
 mov di,[topright]
 add di,2
 mov bx,di
 mov cx,80
 shr bx,1
sub cx,bx
mov bx,cx
mov dx,cx
shl dx,1
sclp:
 mov word [es:di], 0x03720 
 add di, 2 
loop sclp
cmp di,4000
je exit
add di,160
sub di,dx
mov cx,bx
jmp sclp

exit:
 
 ret
DrawScoreBoard:

mov ax,620
push ax
push mess1
mov ax,5
push ax
call printMessage

mov ax,940
push ax
push mess2
mov ax,4
push ax
call printMessage

mov ax,1420
push ax
push mess3
mov ax,5
push ax
call printMessage

ret

shape:

sqaure:
push bp
mov bp,sp
push ax
push di
push si
push es

mov di,[bp+4]
 mov ax, 0xb800
 mov es, ax 
 mov ah,0x48
 mov al,32
 mov [es:di],ax
 add di,2
 mov [es:di],ax
 add di,2
 mov [es:di],ax
add di,2
 mov [es:di],ax

 add di,160
 mov [es:di],ax
 sub di,2
 mov [es:di],ax
 sub di,2
 mov [es:di],ax
 sub di,2
 mov [es:di],ax

pop es
pop si
pop di
pop ax
pop bp

ret 2

start:
call clrscr
call DrawBorder
call ScoreBoard
call DrawScoreBoard
mov ax,1640
push ax
call sqaure

mov ah,0x1
int 21h
mov ax,0x04c00
int 21h