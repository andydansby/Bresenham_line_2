org $9200

; if (dx > dy)

PUBLIC dxLarger         ;$9200
dxLarger:
;jp dxLarger
;;;;;;;;;;;;;;;;;;



DX_loop1:				;$9200
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;fraction = deltaY - (deltaX >> 1);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;first we divide deltaX
    ld DE, (deltaX)
; Shift the high byte (H) right by 1
    srl D  ; Logical shift right high byte of HL
; Rotate the low byte (L) right through carry
    rr E   ; Rotate right low byte of HL through carry

;now subtract out deltaY
    ld HL, (deltaY)
    or A
    sbc HL, DE

;answer in HL
    ld (fraction), HL


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;for (iterations = 0; iterations <= steps; iterations++)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;ld A, 00
    xor A
    ld (iterations), A
    ;set iterations to 0

DX_iteration:

;PLOT ROUTINE
; loading a 16 bit variable into 8 bits
; only because buffer will be 16 bits
; for right now nothing over 191
;ld A, (line_y1)
;ld (plot_y), A
;ld A, (line_x1)
;ld (plot_x), A
;call _joffa_pixel2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;if (fraction >= 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ld HL, (fraction)
    ; to check if fraction is larger than 0 only need to check high byte
    ld A, H
    or A
    jp p, DX_less_than_0
;end IF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;yy1 += stepy;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ld HL, (line_y1)
    ld D, 0
    ld E, (stepy)

;fraction -= deltaX;






DX_less_than_0:






; iteration step
; Increment iterations
    ld A, (iterations)
    inc A
    ld (iterations), A
; iteration step
; Compare iterations with steps
    ld E, A
    ld A, (steps)
    sbc A, E
    jp z, finished
    jp DX_iteration

finished:







test_stop:
    jp test_stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;















;;;;;;;;;;;;;;;;;;
;while (x != x2)
;;;;;;;;;;;;;;;;;;
DX_while:					;$920D
	ld HL, (line_x2)	;grab value of x2
	ld DE, (gfx_x)		;grab value of X
	sbc HL, DE			;check to see if X == X2

	jp z, end_DX_larger	;check to see if equal
						;if equal, break out of loop
	; if not then fall through

;;;;;;;;;;;;;;;;;;
;x += stepx;
;;;;;;;;;;;;;;;;;;
stepX_func:				;$9219

	ld A, (stepx)
	ld HL, (gfx_x)
	add A, L
	ld L, A
	ld (gfx_x), HL
	;;answer in HL and pass to variable

;;;;;;;;;;;;;;;;;;
;if (fraction >= 0)
;;;;;;;;;;;;;;;;;;
DX_fraction_funct:			;$9224
	xor A					;reset flags
	ld DE, (fraction)
	ld HL, 0000
	sbc HL, DE				;check to see if greater or equal

	;DO NOT store Fraction, only for comparasion against 0
	;Greater / Lesser or Equal

	jp z, DX_fraction_equal		;check to see if equal to 0
	jp m, DX_fraction_greater	;jump if greater than 0
								; sign flag IS set
	jp p, DX_fraction_lesser	;check to see if less than 0
								; sign flag is NOT set
	jp DX_fraction_lesser		;just in case
								;not really needed
;;;;;;;;;;;;;;;;
;NOW TESTING
;;;;;;;;;;;;;;;;
DX_fraction_equal:				;$9237
DX_fraction_greater:			;$9237

;;;;;;;;;;;;;;;;;;
;y += stepy; <----PROBLEM? 	$9237 ?
;;;;;;;;;;;;;;;;;;
stepY_DX:					;$9237
	;ld HL, (stepy)

	ld A, (stepy)
	ld H, $00
	ld L, A

	ld DE, (gfx_y)

	add HL, DE				;add Y + stepY
	ld (gfx_y), HL			;store the answer

;;;;;;;;;;;;;;;;;;
	;fraction -= 2 * dx;
;;;;;;;;;;;;;;;;;;
DX_fraction:				;$9242
	ld HL, (dxABS)
	add HL, HL				;answer 2 * DX

	;move this to DE
	push HL
	pop DE

	ld HL, (fraction)
	sbc HL, DE
	ld (fraction), HL

	jp DX_fraction_funct	;loop back to test if fraction
							;is greater of equal to 0

;;;;;;;;;;;;
; STOPPED
;;;;;;;;;;;;
end_DX_fraction:
	jp DX_fraction_funct
;;;;;;;;;;;;
; STOPPED
;;;;;;;;;;;;

;every beyond this point will change
DX_fraction_lesser:		;$9255 will change

;;;;;;;;;;;;;;;;;;
	;fraction += 2 * dy;
;;;;;;;;;;;;;;;;;;
	ld HL, (dyABS)
	add HL, HL			;answer 2 * DY
	ld DE, (fraction)

	add HL, DE			; add fraction answer in HL

	ld (fraction), HL



	;;insert PLOT function here
	; loading a 16 bit variable into 8 bits
	; only because buffer will be 16 bits
	; for right now nothing over 191
	ld A, (gfx_y)
	ld (plot_y), A

	; loading a 16 bit variable into 8 bits
	; only because buffer will be 16 bits
	; for right now nothing over 191
	ld A, (gfx_x)
	ld (plot_x), A
    ;rtunes_pixel();
	call _joffa_pixel2

	jp DX_while				;loop around again to check
							;if x = x2

;STOP
DX_forever_loop1:			;$9257
    jp DX_forever_loop1




end_DX_larger:
	jp end_DX_larger


;jp endless
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








PUBLIC gfx_x			;$9264
gfx_x:		defw 0000

PUBLIC gfx_y			;$9266
gfx_y:		defw 0000





;x1 5	y1 0	x2 0	y2 0 goes to fraction_lesser
;x1 5	y1 5	x2 0	y2 5 goes to fraction_lesser
;x1 0	y1 0	x2 5	y2 2 goes to fraction_lesser
;x1 5	y1 0	x2 1	y2 0 goes to fraction_lesser


;S Z Y H X P N C
; S = Sign
; Z = Zero
; Y = No use
; H = Half -Carry
; X = No use
; P = Parity / Overflow
; N = Add / Subtract
; C = Carry

;with +5 and 0 SzYHXpNC
;with -5 and 0 szyHxpNC











;;just obsolete
org $92C0
obsolete:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;PLOT PIXEL
    ;gfx_x = x1
    ;gfx_y = y1;
    ;rtunes_pixel();
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;
;if (fraction >= 0)
;    ld HL, (fraction)
;    ld A, 0
;    cp (HL)
;    jr C, lessThan_HL_1   ; A was less than the operand.
;    jr Z, equalTo_HL_1   ; A was exactly equal to the operand
;;        checks to see if FRACTION is less than 0
;;        jump if it is less than 0
;;        otherwise fall through


;;        if we get here then FRACTION is greater than 0
greaterThanHL_1:
    ; A was not less than the operand, and was not
    ; equal to the operand. Therefore it must have
    ; been greater than the operand.



;;;;;;;;;;;;;;;;;;
;            x1 += stepx;
;    ld HL, (x1)
;    ld DE, (stepx)
;    add HL, DE
;    ld (x1), HL
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
;            fraction += dy;
;    ld HL, (fraction)
;    ld DE, (dy)
;    add HL, DE
;    ld (fraction), HL
;;;;;;;;;;;;;;;;;;


;jp loop_again  ;; check to see if we need another iteration


;;        if we get here then FRACTION is less than 0
;lessThan_HL_1:
;;        if we get here then FRACTION is equal to  0
;equalTo_HL_1:

;;;;;;;;;;;;;;;;;;
;                y1 += stepy;
;    ld HL, (y1)
;    ld DE, (stepy)
;    add HL, DE
;    ld (y1), HL
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
;                fraction -= dx;
;    ld HL, (fraction)
;    ld DE, (dx)
;    sbc HL, DE
;    ld (fraction), HL
;;;;;;;;;;;;;;;;;;


loop_again:
    ;check to see if x1 and x2 are equal
;    cp A ;reset zero flags
;    ld HL, (x1)
;    ld DE, (x2)
;    sbc HL, DE


    ;check to see if x1 and x2 are equal
    ;if they are not equal loop
    ;jr nz, DX_loop  ;jp nz, DX_loop
;   } while (x1 != x2)
;working on





