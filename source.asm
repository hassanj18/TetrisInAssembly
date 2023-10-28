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

mess1:db 'SCORE:'
mess2:db 'TIME'
mess3:db 'SHAPE'
mess4: db 'G A M E  O V E R!'
score:dw  10
time: dw 20
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
PrintNum:
push bp
mov bp,sp
push bx
push cx
push ax
push si
push dx
push di

mov ax,0xb800
mov es,ax
mov ax,[bp+4]
mov ah,0

mov bl,10
div bl
add ah,30h
add al,30h


mov dh,3Eh

mov dl,al
mov word[es:di],dx
add di,2

mov dl,ah
mov word[es:di],dx

pop di
pop dx
pop si
pop ax
pop cx
pop bx
pop bp
ret 2
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
mov ax,[bp+10]
mov ah,al
mov al,0
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
ret 8


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
push di
push ax
mov ax,0
mov ax,0x3E
push ax
mov ax,620
push ax
push mess1
mov ax,6
push ax
call printMessage

mov di,634
mov ax,[score]
push ax;
call PrintNum

mov ax,0x3E
push ax
mov ax,940
push ax
push mess2
mov ax,4
push ax
call printMessage

mov di,954
mov ax,[score]
push ax;
call PrintNum


mov ax,0x3E
push ax
mov ax,1420
push ax
push mess3
mov ax,5
push ax
call printMessage
pop ax
pop di
ret 

shape:
Ishape:
push bp
mov bp,sp
push ax
push di

mov ax,0x4820;red
push ax
mov di,[bp+4]
push di
call sqaure

mov ax,0x2820;green
push ax
add di,320
push di
call sqaure

mov ax,0x1820;blue
push ax
add di,320
push di
call sqaure

mov ax,0x6820
push ax
add di,320
push di
call sqaure

pop di
pop ax
pop bp
ret 2
LShape:
push bp
mov bp,sp
push ax
push di

mov ax,0x4820;red
push ax
mov di,[bp+4]
push di
call sqaure

mov ax,0x2820;green
push ax
add di,320
push di
call sqaure

mov ax,0x1820;blue
push ax
add di,320
push di
call sqaure

mov ax,0x6820
push ax
sub di,8
push di
call sqaure

pop di
pop ax
pop bp
ret 2

TShape:
push bp
mov bp,sp
push ax
push di

mov ax,0x4820
push ax
mov di,[bp+4]
push di
call sqaure

mov ax,0x2820;green
push ax
add di,8
push di
call sqaure

mov ax,0x1820;blue
push ax
add di,8
push di
call sqaure

mov ax,0x6820
push ax
add di,312
push di
call sqaure

pop di
pop ax
pop bp
ret 2

sqaure:;first paraemeter is attribute byte(color), second is di address
push bp
mov bp,sp
push ax
push di
push si
push es

mov di,[bp+4]
 mov ax, 0xb800
 mov es, ax 
 mov ax,[bp+6]
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

ret 4

DrawEndScreen:
push ax
push di
call clrscr
mov ax,0x07
push ax
mov ax,1660
push ax
push mess4
mov ax,17
push ax
call printMessage


mov ax,0x07
push ax
mov ax,1986
push ax
push mess1
mov ax,6
push ax
call printMessage

mov di,2000
mov ax,[score]
push ax;
call PrintNum

pop di
pop ax
ret

start:
call clrscr
call DrawBorder
call ScoreBoard
call DrawScoreBoard

 mov ax,0x4820
push ax
mov ax,1640
push ax
call sqaure

mov ax,400
push ax
call LShape

mov ax,2270
push ax
call TShape


mov ax,500
push ax

call Ishape

mov ah,0x1
int 21h
cmp al,'0'
jne end
call DrawEndScreen
end:

mov ah,0x1
int 21h
mov ax,0x04c00
int 21h