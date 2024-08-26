org $9300

; if (dy >= dx)




PUBLIC dyLarger
dyLarger:
;    jp dyLarger
;;;;;;;;;;;;;;;;;; 








DY_loop1:				;$9200
;;;;;;;;;;;;;;;;;;
;int fraction = 2 * dx - dy
;(2 * dx) - dy
;;;;;;;;;;;;;;;;;;
	ld HL, (dxABS)
	add HL, HL			; multiply HL by 2
	ld DE, (dyABS)	
	sbc HL, DE			;subtract DX
	ld (fraction), HL
						;;answer in HL and pass to variable
end_inital_fraction_calculation2:

;;;;;;;;;;;;;;;;;;
;while (y != y2)
;;;;;;;;;;;;;;;;;;
DY_while:					;$920D
	ld HL, (line_y2)	;grab value of x2
	ld DE, (gfx_y)		;grab value of X
	sbc HL, DE			;check to see if X == X2
	
	jp z, end_DY_larger	;check to see if equal
						;if equal, break out of loop
	; if not then fall through
	
;;;;;;;;;;;;;;;;;;
;y += stepy;
;;;;;;;;;;;;;;;;;;
stepY_func:				;$9219

	ld A, (stepy)
	ld HL, (gfx_y)
	add A, L
	ld L, A
	ld (gfx_y), HL
	;;answer in HL and pass to variable
	
;;;;;;;;;;;;;;;;;;
;if (fraction >= 0)
;;;;;;;;;;;;;;;;;;	
DY_fraction_funct:			;$9224
	xor A					;reset flags
	ld DE, (fraction)
	ld HL, 0000
	sbc HL, DE				;check to see if greater or equal

	;DO NOT store Fraction, only for comparasion against 0
	;Greater / Lesser or Equal
	
	jp z, DY_fraction_equal		;check to see if equal to 0
	jp m, DY_fraction_greater	;jump if greater than 0
								; sign flag IS set
	jp p, DY_fraction_lesser	;check to see if less than 0
								; sign flag is NOT set
	jp DY_fraction_lesser		;just in case
								;not really needed
;;;;;;;;;;;;;;;;
;NOW TESTING
;;;;;;;;;;;;;;;;
DY_fraction_equal:				;$9237
DY_fraction_greater:			;$9237
	
;;;;;;;;;;;;;;;;;;	
;x += stepx; <----PROBLEM? 
;;;;;;;;;;;;;;;;;;
stepY_DY:					;$9237
	;ld HL, (stepx)
	
	ld A, (stepx)
	ld H, $00
	ld L, A
	
	ld DE, (gfx_x)
	
	add HL, DE				;add Y + stepY
	ld (gfx_x), HL			;store the answer
	
;;;;;;;;;;;;;;;;;;	
	;fraction -= 2 * dy;
;;;;;;;;;;;;;;;;;;
DY_fraction:				;$9242
	ld HL, (dyABS)
	add HL, HL				;answer 2 * DY
	
	;move this to DE
	push HL
	pop DE
	
	ld HL, (fraction)
	sbc HL, DE
	ld (fraction), HL
	
	jp DY_fraction_funct	;loop back to test if fraction 
							;is greater of equal to 0

;;;;;;;;;;;;
; STOPPED
;;;;;;;;;;;;
end_DY_fraction:
	jp end_DY_fraction		;$9252
;;;;;;;;;;;;
; STOPPED
;;;;;;;;;;;;
	
;every beyond this point will change
DY_fraction_lesser:		;$9255 will change

;;;;;;;;;;;;;;;;;;	
	;fraction += 2 * dx;
;;;;;;;;;;;;;;;;;;
	ld HL, (dxABS)
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
	
	
	
	
	
	
	
	
	jp DY_while

;STOP
DY_forever_loop2:			;$9257
    jp DY_forever_loop2
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	
	
end_DY_larger:
	
	

forever_loop:
    jp forever_loop
;;;;;;;;;;;;;;;;;;




; jp nz, nnnn
	; if the Zero flag is unset, nn is copied to the PC 
; jp nnnn
; jp z, nnnn
; jp nc, nnnn
; jp c, nnnn
; jp po, nnnn
; jp (hl)
; jp pe, nnnn
; jp p, nnnn
; jp m, nnnn
; jp (ix)
; jp (iy)



