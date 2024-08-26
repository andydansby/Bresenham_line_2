


include "variables.asm"
include "routines.asm"
include "dx_larger.asm"
include "plot.asm"
include "plot2.asm"

org	$8000
start:


    ;PLOT FIRST PIXEL
    ;gfx_x = x1;
    ;gfx_y = y1;
	; gfx_y1		gfx_x1
;	ld (_buffer_plotY),
;	ld (_buffer_plotX),
	
	;ld DE, (gfx_y1)
	;ld BC, (gfx_x1)
	
;;;;;;;;;;;;
;plot the first pixel x1, y1
;;;;;;;;;;;;
	ld A, (gfx_y1)
	ld (gfx_y), A
	
	ld A, (gfx_x1)
	ld (gfx_x), A
    ;rtunes_pixel();
	call _joffa_pixel2
;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	ld A, (gfx_y1)
;	ld D, A
	
;	ld A, (gfx_x1)
;	ld E, A
	;DE now contains our start point
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	ld A, (gfx_y2)
;	ld H, A
	
;	ld A, (gfx_x2)
;	ld L, A
	;HL now contains our end point
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;dy = y2 - y1;

;since answer could be negative, use 16 bits
;place in answer in variable
;	ld (dx), A
dy_step_start:
	ld HL, (gfx_y2) ; load point Y2
    ld DE, (gfx_y1) ; load point Y1
    sbc HL, DE      ; y2 - y1 answer in HL

;;;; check to see if DY is negative or not
    ;if (dy < 0) { stepy = -1;   }
    jp m, negativeDY
;;;;;;;;;;;;;;;;;;
    ;if (dy > 0) { stepy = 1;    }
    jp positiveDY
;;;;;;;;;;;;;;;;;;


test_DX:
	jp test_DX




;dy = y2 - y1;
; load gfx_y2 into A
	ld A, H
; gfx_y2 is currently in A
; gfx_y1 is currently in D	
	sub D
;answer is in A

;since answer could be negative, use 16 bits
;place in answer in variable
	ld (dy), A



endless_love:
	jp endless_love





;;;;;;;;;;;;;;;;;;
;int dy = y2 - y1;
    ld HL, (gfx_y2) ; load point Y2
    ld DE, (gfx_y1) ; load point Y1
    sbc HL, DE      ; y2 - y1 answer in HL
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
    ;;;; check to see if DY is negative or not
    ;if (dy < 0) { stepy = -1;   }
    jp m, negativeDY
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
    ;if (dy > 0) { stepy = 1;    }
    jp positiveDY
;;;;;;;;;;;;;;;;;;


dy_step_end:

;;;;;;;;;;;;;;;;;;    
    ;dy = ABS(dy);
    ;; now obtain the ABS of HL
    call absHL
    ld (dy), HL     ;load answer to variable
;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;
;int dx = x2 - x1;
    ld HL, (gfx_x2) ; load point X2
    ld DE, (gfx_x1) ; load point X1
    sbc HL, DE      ; x2 - x1 answer in HL
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
    ;;;; check to see if DX is negative or not
    ;if (dx < 0) { stepx = -1;   }
    jp m, negativeDX
;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
    ;if (dx > 0) { stepx = 1;    }
    jp positiveDX
;;;;;;;;;;;;;;;;;;

dx_step_end:

;;;;;;;;;;;;;;;;;;    
    ;dx = ABS(dx);
    ;; now obtain the ABS of HL
    call absHL
    ld (dx), HL     ;load answer to variable
;;;;;;;;;;;;;;;;;;
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;PLOT FIRST PIXEL
    ;gfx_x = x1;
    ;gfx_y = y1;
	; gfx_y1		gfx_x1
;	ld (_buffer_plotY),
;	ld (_buffer_plotX),
	
;;;;;;;;;;;;	
	ld A, (gfx_y1)
	ld (gfx_y), A
	
	ld A, (gfx_x1)
	ld (gfx_x), A
    ;rtunes_pixel();
	call _joffa_pixel2

;rtunes_pixel();
;	call _buffer_plot
;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;
    ;if (dx > dy)
    
    ;determine if DX is greater than DY
    ld HL, (dy)
    ld DE, (dx)
    sbc HL, DE      ; DX - DY answer in HL
;;;;;;;;;;;;;;;;;;
    
    
    
;;;;;;;;;;;;;;;;;;
    ;if (dx > dy)
    jp m, dxLarger;currently working on
;;;;;;;;;;;;;;;;;;  
    
    
    
    
;;;;;;;;;;;;;;;;;; 
    ;else
    ;jp dyLarger
;;;;;;;;;;;;;;;;;;    
    
    
    
    
end
    jp end
ret






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
dyLarger:
    jp dyLarger
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    





    










