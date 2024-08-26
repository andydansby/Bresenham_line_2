
include "variables.asm"
include "routines.asm"
include "dx_larger.asm"
include "dy_larger.asm"
include "plot.asm"
include "plot2.asm"

org	$8000
start:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; in variables.asm
; you will find x1, y1, x2 and y2
; as
; gfx_x1, gfx_y1, gfx_x2, gfx_y1
; gfx_x, gfx_y as used exclusively for
; _joffa_pixel2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;plot the first pixel x1, y1
;was here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int deltaX = abs(xx2 - xx1);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ld HL, (line_x2) ; Load xx2 into register pair HL
    ld DE, (line_x1) ; Load xx1 into register pair DE
    or A         ; Clear the carry flag
    sbc HL, DE   ; Subtract DE from HL with borrow
    ;;;;;;
    ;answer in HL

    ;now calculate the absolete value
    call absHL
    ;answer in HL
    ld (deltaX), HL ; Store the result in deltaX

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int deltaY = abs(yy2 - yy1);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ld HL, (line_y2) ; Load xx2 into register pair HL
    ld DE, (line_y1) ; Load xx1 into register pair DE
    or A         ; Clear the carry flag
    sbc HL, DE   ; Subtract DE from HL with borrow
    ;;;;;;
    ;answer in HL

    ;now calculate the absolete value
    call absHL
    ;answer in HL
    ld (deltaY), HL ; Store the result in deltaX

;part1:
;jp part1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;now we are calculating STEPS to determine the direction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int stepx = (xx1 < xx2) ? 1 : -1;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dx_step_start:		;#8020
    or A                ;clear carry flag
	ld HL, (line_x2)    ; load point X2
    ld DE, (line_x1)    ; load point X1

    sbc HL, DE          ; x2 - x1 answer in HL
    ld A, 1             ; Default to 1
    jr z, stepX_equal
    jr nc, stepX_answer

stepX_equal:
    ld A, -1            ; otherwise -1

stepX_answer:
    ld (stepx), A
dx_step_end:

;<---------------------
; stepx has answer -1 if X2 is larger
; stepx has answer  1 if X1 is larger or equal


;;;;;;;;;;;;
;int stepy = (yy1 < yy2) ? 1 : -1;
;;;;;;;;;;;;
dy_step_start:
    or a                ;clear carry flag
	ld HL, (line_y2)    ; load point X2
    ld DE, (line_y1)    ; load point X1

    sbc HL, DE          ; x2 - x1 answer in HL
	ld A, 1             ; Default to 1
	jr z, stepY_equal
    jr nc, stepY_answer

stepY_equal:
    ld A, -1            ; otherwise -1

stepY_answer:
    ld (stepy), A
dy_step_end:
;<---------------------
; stepy has answer -1 if Y2 is larger
; stepy has answer  1 if Y1 is larger or equal


; now we check to see if DX or DY is larger

;x1=0	y1=0	x2=5	y2=0	DX Larger W  to E
;x1=5	y1=0	x2=0	y2=0	DX Larger E  to W
;x1=0	y1=5	x2=0	y2=0	DY Larger S  to N
;x1=0	y1=0	x2=0	y2=5	DY Larger N  to S
;x1=0	y1=5	x2=5	y2=0	DY == DX  SW to NE
;x1=5	y1=0	x2=0	y2=5	DY == DX  NE to SW
;x1=5	y1=5	x2=0	y2=0	DY == DX  SE to NW
;x1=0	y1=0	x2=5	y2=5	DY == DX  NW to SE


;test
;stepx  080A2H
;stepy  080A3H

;-1 =
; 1 =



part2:
jp part2


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int steps = (deltaX > deltaY) ? deltaX : deltaY;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;if (deltaX > deltaY) {
;    steps = deltaX;
;} else {
;    steps = deltaY;
;}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DYorDY_start:		;$805D
	xor a				;clear flags
	ld HL, (deltaY)
	ld DE, (deltaX)
	sbc HL, DE          ; DX - DY answer in HL

	jp m, dxLarger			;check to see if greater
							; sign flag IS set
							;$9200

	jp p, dyLarger			;check to see if lesser
							; sign flag NOT set
							;$9300

	jp z, dyLarger			;check to see if equal
							;if so the DY larger
							;$9300

PUBLIC endless
endless:
jr endless




	;jp c, dxLarger
	;Carry flag
;;;;;;;;;;;;
;if (dx > dy)
; goto DX larger loop
;;;;;;;;;;;;

;;;;;;;;;;;;
; STOPPED
;;;;;;;;;;;;
	jp dxLarger		;temp for testing  ATTENTION!
;;;;;;;;;;;;
; STOPPED
;;;;;;;;;;;;





	jp z, dyLarger ;if equal
	jp dyLarger
;;;;;;;;;;;;
;else
; goto DY larger loop
;;;;;;;;;;;;
DYorDY_end:
	jp DYorDY_end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;currently working on
	;if (dy >= dx)
;	jp c, dyLarger
;	jp z, dyLarger



	;jp nc, dyLarger
    ;jp m, dyLarger		;if (dx > dy)
	;else
	;if (dx > dy)
;	jp dxLarger
	;currently working on
;;;;;;;;;;;;

;;;;;;;;;;;;
    ;currently working on
;	jp m, dxLarger		;if (dx > dy)
	;else
;	jp dyLarger
	;currently working on
;;;;;;;;;;;;






;PUBLIC test_DX
;test_DX:
;	jp test_DX




;dy = y2 - y1;
; load gfx_y2 into A
	ld A, H
; gfx_y2 is currently in A
; gfx_y1 is currently in D
;	sub D
;answer is in A

;since answer could be negative, use 16 bits
;place in answer in variable
;	ld (dy), A;



;endless_love:
;	jp endless_love





;;;;;;;;;;;;;;;;;;
;int dy = y2 - y1;
;    ld HL, (gfx_y2) ; load point Y2
;    ld DE, (gfx_y1) ; load point Y1
;    sbc HL, DE      ; y2 - y1 answer in HL
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
    ;;;; check to see if DY is negative or not
    ;if (dy < 0) { stepy = -1;   }
;    jp m, negativeDY
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
    ;if (dy > 0) { stepy = 1;    }
;    jp positiveDY
;;;;;;;;;;;;;;;;;;


;dy_step_end:

;;;;;;;;;;;;;;;;;;
    ;dy = ABS(dy);
    ;; now obtain the ABS of HL
;    call absHL
;    ld (dy), HL     ;load answer to variable
;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;
;int dx = x2 - x1;
;    ld HL, (gfx_x2) ; load point X2
;    ld DE, (gfx_x1) ; load point X1
;    sbc HL, DE      ; x2 - x1 answer in HL
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
    ;;;; check to see if DX is negative or not
    ;if (dx < 0) { stepx = -1;   }
;    jp m, negativeDX
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
    ;if (dx > 0) { stepx = 1;    }
;    jp positiveDX
;;;;;;;;;;;;;;;;;;

;dx_step_end:

;;;;;;;;;;;;;;;;;;
    ;dx = ABS(dx);
    ;; now obtain the ABS of HL
;    call absHL
;    ld (dx), HL     ;load answer to variable
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;PLOT FIRST PIXEL
    ;gfx_x = x1;
    ;gfx_y = y1;
	; gfx_y1		gfx_x1
;	ld (_buffer_plotY),
;	ld (_buffer_plotX),

;;;;;;;;;;;;
;	ld A, (gfx_y1)
;	ld (gfx_y), A

;	ld A, (gfx_x1)
;	ld (gfx_x), A
    ;rtunes_pixel();
;	call _joffa_pixel2

;rtunes_pixel();
;	call _buffer_plot
;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
    ;if (dx > dy)

    ;determine if DX is greater than DY
;    ld HL, (dy)
;    ld DE, (dx)
;    sbc HL, DE      ; DX - DY answer in HL
;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;
    ;if (dx > dy)
;    jp m, dxLarger;currently working on
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
    ;else
;    jp dyLarger
;;;;;;;;;;;;;;;;;;




;end
;    jp end
ret
























