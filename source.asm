[org 0x100]
jmp start

;variables
Border_x1: dw 0
Border_y1: dw 0
Border_x2: dw 41
Border_y2: dw 24

score: dw 0



DrawRectangle
push bp
mov bp,sp
sub sp,8

push ax
push bx
push cx
push dx
push si
push di

;Calcuating Upper address
mov ax,[bp+8]
mov bl,80
mul bl
add ax,[bp+10]
shl ax,1

mov [bp-2],ax;StartingAdresss(x1,y1)

;Calcuating (x2,y1)
mov ax,[bp+8]
mov bl,80
mul bl
add ax,[bp+6];adding x2
shl ax,1

mov [bp-4],ax;StartingAdresss(x2,y1)

;Calcuating (x1,y2)
mov ax,[bp+4]
mov bl,80
mul bl
add ax,[bp+10]
shl ax,1

mov [bp-6],ax;StartingAdresss(x1,y2)

;Calcuating (x2,y2)
mov ax,[bp+4]
mov bl,80
mul bl
add ax,[bp+6]
shl ax,1

mov [bp-8],ax;StartingAdresss(x2,y1)

mov ax,0xb800
mov es,ax

;charector to draw
mov dx,0x7020

;drawing firstline

mov di,[bp-2];(x1,y1)

loop1:
mov [es:di],dx
add di,2
cmp word[bp-4],di
jne loop1


;drawing secondline
mov di,[bp-2];(x1,y1)

loop2:
mov [es:di],dx
add di,160
cmp word[bp-6],di
jne loop2

;drawing thirdline
mov di,[bp-4];(x1,y1)

loop3:
mov [es:di],dx
add di,160
cmp word[bp-8],di
jne loop3


;drawing forthline

mov di,[bp-6]

loop4:
mov [es:di],dx
add di,2
cmp word[bp-8],di
jne loop4

mov di,[bp-8]

mov [es:di],dx
pop  ax
pop  bx
pop cx
pop dx
pop si
pop di
mov sp,bp
pop bp
ret 8

clearscreen:
push ax
push es
push di

mov ax,0xb800
mov es,ax
mov di,0

nextchar:
mov word[es:di],0x0720
add di,2
cmp di,4000
jne nextchar

pop di
pop es
pop ax
ret




DrawBorder:
push ax

mov ax,0
push ax
push ax
mov ax,41
push ax
mov ax,24
push ax
call DrawRectangle


pop ax
ret


start:
call clearscreen;
call DrawBorder

mov ah,0x1
int 21h
mov ax,0x4c00
int 21h
