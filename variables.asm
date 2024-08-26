org $8080





;input variables
line_x1:	defw 1 		;$8080	line start point X
line_y1:	defw 5 		;$8082	line start point Y
line_x2:	defw 4 	;$8084	line end point X
line_y2:	defw 0		;$8086	line end point Y

;dx larger $9200
;dy larger $9300


PUBLIC dxABS
	dxABS:      defw 0000;$808C
PUBLIC dyAB
	dyABS:      defw 0000;$808E

x2x1: defw 0000			;$8090
y2y1: defw 0000			;$8092

PUBLIC fraction			;$8094
fraction:	defw 0000

x1:	defw 0000			;$8094
x2:	defw 0000			;$8096
y1:	defw 0000			;$8098
y2:	defw 0000			;$809A

PUBLIC plot_x			;$809C
plot_x:		defb 00

PUBLIC plot_y			;$809D
plot_y:		defb 00



;;;;;
; Version 2 Variables

PUBLIC deltaX
	deltaX:			defw 0000;$8088
PUBLIC deltaY
	deltaY:			defw 0000;$808A


pixel_sum:	defb 00
iterations:	defb 00


stepx:		defb 00		;$80A2
stepy:		defb 00		;$80A3


PUBLIC X_PositionBits	;$80A4
X_PositionBits:
defb 128,64,32,16,8,4,2,1

;-----------------------------------------
;;test case 00		x1 0	y1 0	x2 0	y2 5	dy larger
;;test case 04		x1 5	y1 5	x2 0	y2 0	dx == dy
;;test case 08		x1 5	y1 0	x2 0	y2 0	dx larger
;;bug case ??		x1 0	y1 0	x2 0	y2 0	dx larger
;;prior test 43		x1 5	y1 5	x2 0	y2 5	dx larger

;;WE test case	x1 0	y1 0	x2 5	y2 5	DX == DY 1
;;EW test case	x1 5	y1 5	x2 0	y2 0	DX == DY 2
;;EW test case	x1 5	y1 0	x2 0	y2 5	DX == DY 3
;;WE test case 	x1 0	y1 5	x2 5	y2 0	DX == DY 4

;WE case 5		x1 0	y1 0	x2 5	y2 2	dx larger OK
;EW case 		x1 5	y1 2	x2 0	y2 0	dx larger OK
;SN case 10		x1 1	y1 5	x2 3	y2 0	dy larger OK
;SN case 		x1 3	y1 0	x2 1	y2 5	dy larger OK

;case test
;bresenham (    00,     05,     05,     05);//case 1
;gfx_x1:		defw 0128
;gfx_x2:		defw $0000
;gfx_y1:		defw 0096
;gfx_y2:		defw $0000



;case 1  DX larger
;bresenham (    00,     05,     05,     05);//case 1
;gfx_x1:		defw $0000
;gfx_x2:		defw $0005
;gfx_y1:		defw $0005
;gfx_y2:		defw $0005
;FLAGS = sz5h3v(N)c
;ans supposed to be #9200
;jp nc = #9300 err
;jp c & jp z = #9200

;case 2  DX larger
;bresenham (    05,     00,     05,     05);//case 2
;gfx_x1:			defw $0005
;gfx_x2:			defw $0000
;gfx_y1:			defw $0005
;gfx_y2:			defw $0005
;FLAGS = sz5h3v(N)c
;ans supposed to be #9200
;jp nc = #9300 err
;jp c & jp z = #9200

;case 3  DY larger
;bresenham (    05,     05,     00,     05);//case 3
;gfx_x1:				defw $0005
;gfx_x2:				defw $0005
;gfx_y1:				defw $0000
;gfx_y2:				defw $0005
;FLAGS = (S)z(5)(H)(3)v(N)(C)
;ans supposed to be #9300
;jp nc = #9200 err
;jp c & jp z = #9300

;case 4  DY larger
;bresenham (    05,     05,     05,     00);//case 4
;gfx_x1:				defw $0005
;gfx_x2:				defw $0005
;gfx_y1:				defw $0005
;gfx_y2:				defw $0000
;FLAGS = (S)z(5)(H)(3)v(N)(C)
;ans supposed to be #9300
;jp nc = #9200 err
;jp c & jp z = #9300

;case 5  DY larger
;bresenham (    00,     05,     00,     05);//case 5
;gfx_x1:	defw $0000
;gfx_x2:	defw $0005
;gfx_y1:	defw $0000
;gfx_y2:	defw $0005
;FLAGS = s(Z)5h3v(N)c
;ans supposed to be #9300
;jp nc = #9300 ok
;jp c & jp z = #9300

;case 6  DY larger
;bresenham (    00,     05,     05,     00);//case 6
;gfx_x1:	defw $0000
;gfx_x2:	defw $0005
;gfx_y1:	defw $0005
;gfx_y2:	defw $0000
;FLAGS = s(Z)5h3v(N)c
;ans supposed to be #9300
;jp nc = #9300 ok
;jp c & jp z = #9300

;case 7  DY larger
;bresenham (    05,     00,     00,     05);//case 7
;gfx_x1:	defw $0005
;gfx_x2:	defw $0000
;gfx_y1:	defw $0000
;gfx_y2:	defw $0005
;FLAGS = s(Z)5h3v(N)c
;ans supposed to be #9300
;jp nc = #9300 ok
;jp c & jp z = #9300

;case 8  DY larger
;bresenham (    05,     00,     05,     00);//case 8
;gfx_x1:	defw $0005
;gfx_x2:	defw $0000
;gfx_y1:	defw $0005
;gfx_y2:	defw $0000
;FLAGS = s(Z)5h3v(N)c
;ans supposed to be #9300
;jp nc = #9300
;jp c & jp z = #9300




;case 1  DX larger
;bresenham (    00,     05,     05,     05);//case 1
;gfx_x1:		defw $000a
;gfx_x2:		defw $0014
;gfx_y1:		defw $0014
;gfx_y2:		defw $0014
;FLAGS = sz5h3v(N)c  check
;ans supposed to be #9200
;jp nc = #9300 err
;jp c & jp z = #9200

;case 2  DX larger
;bresenham (    05,     00,     05,     05);//case 2
;gfx_x1:			defw $0014
;gfx_x2:			defw $000a
;gfx_y1:			defw $0014
;gfx_y2:			defw $0014
;FLAGS = sz5h3v(N)c check
;ans supposed to be #9200
;jp nc = #9300 err
;jp c & jp z = #9200

;case 3  DY larger
;bresenham (    05,     05,     00,     05);//case 3
;gfx_x1:				defw $0014
;gfx_x2:				defw $0014
;gfx_y1:				defw $000a
;gfx_y2:				defw $0014
;FLAGS = (S)z(5)(H)(3)v(N)(C) check
;ans supposed to be #9300
;jp nc = #9200 err
;jp c & jp z = #9300

;case 4  DY larger
;bresenham (    05,     05,     05,     00);//case 4
;gfx_x1:				defw $0005
;gfx_x2:				defw $0005
;gfx_y1:				defw $0005
;gfx_y2:				defw $0014
;FLAGS = (S)z(5)(H)(3)v(N)(C) check
;ans supposed to be #9300
;jp nc = #9200 err
;jp c & jp z = #9300

;case 5  DY larger
;bresenham (    00,     05,     00,     05);//case 5
;gfx_x1:	defw $000a
;gfx_x2:	defw $0014
;gfx_y1:	defw $000a
;gfx_y2:	defw $0014
;FLAGS = s(Z)5h3v(N)c check
;ans supposed to be #9300
;jp nc = #9300 ok
;jp c & jp z = #9300

;case 6  DY larger
;bresenham (    00,     05,     05,     00);//case 6
;gfx_x1:	defw $000a
;gfx_x2:	defw $0014
;gfx_y1:	defw $0014
;gfx_y2:	defw $000a
;FLAGS = s(Z)5h3v(N)c check
;ans supposed to be #9300
;jp nc = #9300 ok
;jp c & jp z = #9300

;case 7  DY larger
;bresenham (    05,     00,     00,     05);//case 7
;gfx_x1:	defw $0014
;gfx_x2:	defw $000a
;gfx_y1:	defw $000a
;gfx_y2:	defw $0014
;FLAGS = s(Z)5h3v(N)c check
;ans supposed to be #9300
;jp nc = #9300 ok
;jp c & jp z = #9300

;case 8  DY larger
;bresenham (    05,     00,     05,     00);//case 8
;gfx_x1:	defw $0014
;gfx_x2:	defw $000a
;gfx_y1:	defw $0014
;gfx_y2:	defw $000a
;FLAGS = s(Z)5h3v(N)c check
;ans supposed to be #9300
;jp nc = #9300
;jp c & jp z = #9300


