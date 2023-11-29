[org 0x0100]
jmp start
var:db '-'
x1:db 0
x2:db 0
y1:db 59
y2:db 24
topleft:dw 0
topright:dw 0
bottomleft:dw 0
bottomright:dw 0

mess1:db 'SCORE:'
mess2:db 'TIME'
mess3:db 'SHAPE'
mess4: db 'G A M E  O V E R!'
score:dw  0
time: dw 0
BoolTime:dw 0

min: dw 4
sec: dw 59
Tcounts: dw 0
oldtimer:dd 0

oldksr: dd 0

CurrShapeType: dw 1
CurrShape_Address: dw 212
Offset_Address:dw 0
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
mov ax,610
push ax
push mess1
mov ax,6
push ax
call printMessage

mov di,624
mov ax,[score]
push ax;
call PrintNum

mov ax,0x3E
push ax
mov ax,930
push ax
push mess2
mov ax,4
push ax
call printMessage

; mov di,944
; mov ax,[time]
; push ax;
; call PrintNum


mov ax,0x3E
push ax
mov ax,1416
push ax
push mess3
mov ax,5
push ax
call printMessage
pop ax
pop di
ret 

DrawCurrShape:
push bp
mov bp,sp
push ax

mov ax,[bp+4]
cmp word[CurrShapeType],1
je PrintI
cmp word[CurrShapeType],2
je PrintL
cmp word[CurrShapeType],3
je PrintT
cmp word[CurrShapeType],4
je PrintS
jmp return

PrintI:
push ax
push word[CurrShape_Address]
call Ishape
jmp return
PrintL:
push ax
push word[CurrShape_Address]
call LShape      
jmp return
PrintT:
push ax
push word[CurrShape_Address]
call TShape
jmp return
PrintS:
push ax
push word[CurrShape_Address]
call Sshape

return:
pop ax
pop bp
ret 2

shape:
Ishape:
push bp
mov bp,sp
push ax
push di
cmp word[bp+6],0;O means print blank
je draw_BG_Ishape
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

jmp end_Ishape

draw_BG_Ishape:
mov ax,0x0720;red
push ax
mov di,[bp+4]
push di
call sqaure


push ax
add di,320
push di
call sqaure

push ax
add di,320
push di
call sqaure


push ax
add di,320
push di
call sqaure

end_Ishape:
pop di
pop ax
pop bp
ret 4


LShape:
push bp
mov bp,sp
push ax
push di


cmp word[bp+6],0;O means print blank
je draw_BG_Lshape
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

jmp end_Lshape

draw_BG_Lshape:
mov ax,0x0720;black
push ax
mov di,[bp+4]
push di
call sqaure

mov ax,0x0720;black
push ax
add di,320
push di
call sqaure

mov ax,0x0720;black
push ax
add di,320
push di
call sqaure

mov ax,0x0720
push ax
sub di,8
push di
call sqaure

end_Lshape:
pop di
pop ax
pop bp
ret 4

TShape:
push bp
mov bp,sp
push ax
push di


cmp word[bp+6],0;O means print blank
je draw_BG_Tshape
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
jmp end_Tshape
draw_BG_Tshape:
mov ax,0x0720
push ax
mov di,[bp+4]
push di
call sqaure

mov ax,0x0720;
push ax
add di,8
push di
call sqaure

mov ax,0x0720;
push ax
add di,8
push di
call sqaure

mov ax,0x0720
push ax
add di,312
push di
call sqaure

end_Tshape:
pop di
pop ax
pop bp
ret 4

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

Sshape:
push bp
mov bp,sp
push ax
push di
cmp word[bp+6],0
je draw_BG_Sshape

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
mov di,[bp+4]
add di,8
push di
call sqaure

mov ax,0x6820
push ax
add di,320
push di
call sqaure
jmp end_BG_Sshape
draw_BG_Sshape:

mov ax,0x0720;red
push ax
mov di,[bp+4]
push di
call sqaure

mov ax,0x0720;green
push ax
add di,320
push di
call sqaure

mov ax,0x0720;blue
push ax
mov di,[bp+4]
add di,8
push di
call sqaure

mov ax,0x0720
push ax
add di,320
push di
call sqaure

end_BG_Sshape:


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

delay:
push cx
mov cx, 0xffff
delaying:
loop delaying
pop cx
ret

KeyInt:
push ax
mov word[Offset_Address],0
in al,0x60
cmp al,0x1e
jne ISright
sub word[Offset_Address],8
jmp nomatch

ISright:
cmp al,0x20
jne nomatch
add word[Offset_Address],8

 
nomatch: 
pop ax
jmp far [cs:oldksr]

CheckSqaureCollision:
push ax
push bx
push cx
push es


mov ax,0xb800
push ax

pop es

mov dx,0
mov ax,0x0720
mov cx,2
mov bx,0

Detection:

mov cx,4

repe scasw
cmp cx,0
jne exitSqaureCollsion

mov dx,1
exitSqaureCollsion:


pop es
pop cx
pop bx
pop ax

ret


CheckLeftRightCollision:
push ax

push cx
push es


mov ax,0xb800
push ax

pop es


mov ax,0x0720

mov bx,0
mov cx,2
Check:
push cx
push di
mov cx,4
repe scasw
cmp cx,0
pop di
pop cx
jne exitLeftRight
add di,160
loop Check


mov bx,1
exitLeftRight:



pop es
pop cx

pop ax

ret

CollisionDetection:
push bx
push cx
push dx
push si
push di
push es
push ds 

mov ax,0
cmp word[CurrShapeType],1
je CheckIShapeCollision
cmp word[CurrShapeType],2
je CheckLShapeCollision
cmp word[CurrShapeType],3
je near CheckTShapCollision
cmp word[CurrShapeType],4
je near CheckSShapCollision


CheckIShapeCollision:
mov bx,[CurrShape_Address]
mov di,bx
add di,1280
call CheckSqaureCollision
cmp dx,0
je near CollisionDetectionFailed
RightCheckI:
cmp word[Offset_Address],0
jle LeftCheckI

mov di,[CurrShape_Address]
add di,8
mov cx,4
ICollisionloopRight:
push di
call CheckLeftRightCollision
pop di
cmp bx,0
je near reset
add di,320
loop ICollisionloopRight
jmp endDet

LeftCheckI:
cmp word[Offset_Address],0
je near endDet
mov di,[CurrShape_Address]
sub di,8
mov cx,4
ICollisionloopLeft:
push di
call CheckLeftRightCollision
pop di
cmp bx,0
je near reset
add di,320
loop ICollisionloopLeft

jmp endDet


CheckLShapeCollision:
mov bx,[CurrShape_Address]
mov di,bx
add di,960
mov bx,di
call CheckSqaureCollision
cmp dx,0
je near CollisionDetectionFailed
mov di,bx
sub di,8
call CheckSqaureCollision
cmp dx,0
je near CollisionDetectionFailed


RightCheckL:
cmp word[Offset_Address],0
jle LeftCheckL

mov di,[CurrShape_Address]
add di,8
mov cx,3
LCollisionloopRight:
push di
call CheckLeftRightCollision
pop di
cmp bx,0
je near reset
add di,320
loop LCollisionloopRight
jmp endDet



LeftCheckL:
cmp word[Offset_Address],0
je near endDet
mov di,[CurrShape_Address]
sub di,8
mov cx,2
LCollisionloopLeft:
push di
call CheckLeftRightCollision
pop di
cmp bx,0
je near reset
add di,320
loop LCollisionloopLeft

sub di,8
call CheckLeftRightCollision
cmp bx,0
je near reset

jmp endDet



CheckTShapCollision:
mov bx,[CurrShape_Address]
mov di,bx
add di,320
call CheckSqaureCollision
cmp dx,0
je near CollisionDetectionFailed
mov di,bx
add di,336
call CheckSqaureCollision
cmp dx,0
je near CollisionDetectionFailed
mov di,bx
add di,648
call CheckSqaureCollision
cmp dx,0
je near CollisionDetectionFailed
RightCheck:
cmp word[Offset_Address],0
jle LeftCheck


mov di,[CurrShape_Address]
add di,24
call CheckLeftRightCollision
cmp bx,0
je near reset

mov di,[CurrShape_Address]
add di,336
call CheckLeftRightCollision
cmp bx,0
je near reset

jmp endDet
LeftCheck:
cmp word[Offset_Address],0
je near endDet
mov di,[CurrShape_Address]
sub di,8
call CheckLeftRightCollision
cmp bx,0
je near reset
mov di,[CurrShape_Address]
add di,320
call CheckLeftRightCollision
cmp bx,0
je reset
jmp endDet


CheckSShapCollision:
mov bx,[CurrShape_Address]
mov di,bx
add di,640
call CheckSqaureCollision
cmp dx,0
je CollisionDetectionFailed
mov di,bx
add di,648
call CheckSqaureCollision
cmp dx,0
je CollisionDetectionFailed

RightCheckS:
cmp word[Offset_Address],0
jle LeftCheckI

mov di,[CurrShape_Address]
add di,16
mov cx,2
SCollisionloopRight:
push di
call CheckLeftRightCollision
pop di
cmp bx,0
je reset
add di,320
loop SCollisionloopRight
jmp endDet

LeftCheckS:
cmp word[Offset_Address],0
je endDet
mov di,[CurrShape_Address]
sub di,8
mov cx,2
SCollisionloopLeft:
push di
call CheckLeftRightCollision
pop di
cmp bx,0
je reset
add di,320
loop SCollisionloopLeft

jmp endDet


reset:
mov word[Offset_Address],0



endDet:
cmp dx,0
je CollisionDetectionFailed



mov ax,1
jmp endend


CollisionDetectionFailed:
mov word[Offset_Address],0

endend:

pop ds
pop es
pop di 
pop si
pop dx
pop cx
pop bx
ret




CheckEndGameCollision:
push ax
push cx
push di
push es
mov cx,13
mov di,164
mov ax,0xb800
push ax
pop es
mov bx,0
EndGameLoop:
mov ax,0x0720
cmp word[es:di],ax
jne Check2
add di,8
loop EndGameLoop
jcxz EndCheck


Check2:
mov cx,5

CheckEndGameCollisionLoop:
cmp word[es:di],ax
je EndCheck
add di,320
loop CheckEndGameCollisionLoop
mov bx,1

EndCheck:

pop es
pop di
pop cx
pop ax
ret

Debug:
push di
push es
push ax
mov ax,0xb800
push ax
pop es
mov di,[CurrShape_Address]
mov word[es:di],0x0131
pop ax
pop es

pop di
ret

blink:
push es
push ax
push cx
mov ax,0xb800
mov es,ax

push di
mov cx,56
mov si,di
sub si,160
mov ax,0x0720
BlinkL1:
mov word[es:di],ax
mov word[es:si],ax
add di,2
add si,2
call delay
loop BlinkL1
pop di
pop cx
pop ax
pop es
ret
ScrollUp:
push cx
push di
push es
push ds
push si
push ax
mov ax,0xb800
mov es,ax
mov ds,ax
shl cx,1
cld
mov si,di
sub si,320
ScrollLoop:
push cx
push di 

mov cx,56
rep movsw
pop di
pop cx
sub di,160
mov si,di
sub si,320
loop ScrollLoop
pop ax
pop si
pop ds
pop es
pop di
pop cx
ret
RowCheck:

push di
push cx
push ax
push es

mov ax,0xb800
mov es,ax
mov cx,12
mov di,3684
RLoop:
push cx
push di
mov cx,14
Cloop:

mov ax,[es:di]
cmp ax,0x0720
je CheckNextRow
mov [es:di],ax
add di,8
loop Cloop

mov di,624
add word[score],10
push word[score]
call PrintNum

pop di 
pop cx
call blink
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay


call ScrollUp

push cx
push di

CheckNextRow:
pop di
pop cx
sub di,160
sub di,160
loop RLoop

pop es
pop ax
pop cx
pop di
ret


Timer: 
push di
cmp word[BoolTime],1
je skipall
inc word [cs:Tcounts] ; increment tick count
cmp word [cs:Tcounts],18
jne skipall


;add word[CurrShape_Address],160

;printing

mov di,946
push word[min]
call PrintNum


add di,6
push word[sec]
call PrintNum

;
mov word[cs:Tcounts],0
dec word[cs:sec]
cmp word[cs:sec],0
jne skipall
mov word[cs:sec],59
dec word[cs:min]
cmp word[cs:min],0
;je end
skipall: 
mov al, 0x20
out 0x20, al ; send EOI to PIC
pop di
iret

UpdateCurrentShape:
push bx
cmp word[CurrShapeType],4
jne StartPosition2
mov word[CurrShape_Address],2054
jmp StartPosition
StartPosition2:
cmp word[CurrShapeType],3
jne SetPostition
mov word[CurrShape_Address],2048
jmp StartPosition
SetPostition:
mov word[CurrShape_Address],2056
StartPosition:
mov bx,1
push bx
call DrawCurrShape
pop bx
ret

ClearCanvas:
push di
push es
push cx
push ax

mov ax,0xb800
push ax
pop es
mov cx,8
mov di,2048
mov ax,0x03720
clearCanvasLoop:
push cx
push di
mov cx,12
rep stosw
pop di
pop cx
add di,160
loop clearCanvasLoop

pop ax
pop cx
pop es
pop di

ret


clearTop:
push es
 push ax
 push di
push cx
 mov ax, 0xb800
 sub ax,80
 mov es, ax 
 mov di, 0
 mov cx,640
 mov ax,0x0720
loc: 
cld
rep stosw

 mov ax, 0xb800
 mov es, ax
mov di,4
mov cx,56
mov ax,0x0720
loc2:
cld
rep stosw

mov di,164
mov cx,56
mov ax,0x0720

cld
rep stosw

 pop cx
 pop di
 pop ax
 pop es
 ret

GenerateNewBlock:

cmp word[CurrShapeType],1
jne CheckShape
mov word[CurrShape_Address],-1228
CheckShape:
cmp word[CurrShapeType],2
jne CheckShape2
mov word[CurrShape_Address],-908
CheckShape2:
cmp word[CurrShapeType],3
jne Check3
mov word[CurrShape_Address],-268
Check3:
cmp word[CurrShapeType],4
jne Check4
mov word[CurrShape_Address],-588
Check4:
ret

GenerateRandom:
push ax
push dx
push bx
xor dx,dx
cmp word[sec],0
je randomend
mov ax,3
;xor ax,ax
mov bx,word[sec]
div bx


randomend:
inc dx
mov word[CurrShapeType],dx
pop bx
pop dx
pop ax
ret

;-----------------------------------------------------------------------
;START
;-----------------------------------------------------------------------
start:

;hooking Keyboard Interupt

xor ax,ax
mov es,ax

mov ax, [es:9*4]
mov [oldksr],ax
mov ax,[es:9*4+2]
mov [oldksr+2],ax
cli 
mov word[es:9*4],KeyInt
mov word[es:9*4+2],cs
sti 

xor ax,ax
mov es,ax

mov ax,[es:8*4]
mov [oldtimer],ax
mov ax,[es:8*4+2]
mov [oldtimer],ax

cli
mov word[es:8*4],Timer
mov word[es:8*4+2],cs
sti

call clrscr
call DrawBorder
call ScoreBoard
call DrawScoreBoard
call clearTop

mov cx,5
mov ax,0xb800
push ax
pop es
mov word[CurrShapeType],0
mov ax,0
jmp NewBlock
GameLoop:

cmp word[min],0
je Game_end

call CollisionDetection
cmp ax,0 
je NewBlock


mov bx,0
 push bx
 call DrawCurrShape

add word[CurrShape_Address],160
mov ax,[Offset_Address]
add [CurrShape_Address],ax
mov bx,1
push bx
call DrawCurrShape

call CheckEndGameCollision
cmp bx,1
je Game_end

call delay
call delay
call delay
call delay
call delay
call delay
call delay
call delay


jmp GameLoop

NewBlock:
;add word[CurrShapeType],1
call RowCheck
;cmp word[CurrShapeType],5
;je ResetBlock
call GenerateNewBlock
continue:
call clearTop
call ClearCanvas
call UpdateCurrentShape
call GenerateNewBlock

mov bx,1
push bx
call DrawCurrShape
jmp GameLoop

ResetBlock:
mov word[CurrShapeType],1
jmp continue



Game_end:
mov word[BoolTime],1
mov ax,[oldksr]
mov bx,[oldksr+2]
cli 
mov word[es:9*4],ax
mov word[es:9*4+2],bx
sti 
mov ax,[oldtimer]
mov bx,[oldtimer+2]
cli 
mov word[es:8*4],ax
mov word[es:8*4+2],bx
sti 
call DrawEndScreen
call DrawEndScreen




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