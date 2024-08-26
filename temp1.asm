

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














