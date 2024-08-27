

;;;;;;;;;;;;
;plot the first pixel x1, y1
;;;;;;;;;;;;
	; loading a 16 bit variable into 8 bits
	; only because buffer will be 16 bits
	; for right now nothing over 191
	ld A, (line_y1)
	ld (plot_y), A

	; loading a 16 bit variable into 8 bits
	; only because buffer will be 16 bits
	; for right now nothing over 191
	ld A, (line_x1)
	ld (plot_x), A
    ;rtunes_pixel();
	call _joffa_pixel2

;;;;;;;;;;;;
;plot the first pixel x1, y1
;;;;;;;;;;;;



;;;;;;;;;;;;
;int stepy = (yy1 < yy2) ? 1 : -1;
;;;;;;;;;;;;
dy_step_start:
	ld HL, (line_y2)     ; load point X2
    ld DE, (line_y1)     ; load point X1
    xor a				;clear flags
    sbc HL, DE          ; x2 - x1 answer in HL

	;if carry flag is set, then Y2 is larger
	jp nc, negativeDY

	;else Y1 is larger or equal
	jp positiveDY
dy_step_end:
;<---------------------






DX_loop1:				;$9200
;;;;;;;;;;;;;;;;;;
;fraction = deltaY - (deltaX >> 1);








;first we divide deltaX
    ld HL, (deltaX)
; Shift the high byte (H) right by 1
    srl H  ; Logical shift right high byte of HL
; Rotate the low byte (L) right through carry
    rr L   ; Rotate right low byte of HL through carry

;now subtract out deltaY
    ld DE, (deltaY)
    or A
    sbc HL, DE

;answer in HL


endless_loop1:
    jp endless_loop1


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




