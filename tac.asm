;	Brian Rigney
;	ECE 109
;	Program 3
;	This program will allow 2 users to play a game of tic-tac-toe
;	using the LC-3 graphics display. An illegal entry (outside 0-8)
;	will prompt the same user for a valid input, and q will halt the program.
; 	Entering a number of a block already occupied is also considered an illegal move.
;

	.ORIG x3000

CLEARS	JSR CLEARSCREEN			; clear the screen
;
; Draw the grid
;		
DRAWBOX LD R1 COLONEORIG		; column one origin
		JSR DRAWV
		LD R1, COLTWOORIG		; column two origin
		JSR DRAWV
		LD R1, ROWONEORIG		; row one origin
		JSR DRAWH
		LD R1, ROWTWOORIG		; row two origin
		JSR DRAWH
;
; Main program
;

MAIN	
XUSER	LEA R0, PROMPTXSTRING	; beginning of main program loop
		PUTS				
		JSR GETMOV
		AND R1, R1, #0			; clear R1
		ADD R1, R1, R0			; store R0
		ADD R0, R0, #0
		BRn XUSER				; illegal move, back to prompt XUSER
		ADD R1, R1, #-9			; testing for q in GETMOVE
		BRz QQUIT
		ST R0, LASTMOVE			; store move of user
		JSR CHKBLOCK
		ADD R2, R2, #0			; to evaluate CHKBLOCK subroutine
		BRp XUSER				; block was occupied, start over
		AND R3, R3, #0			; clear R3 for DRAWB subroutine
		JSR DRAWB
		BRnz OUSER
		
OUSER	LEA R0, PROMPTOSTRING
		PUTS
		JSR GETMOV
		AND R1, R1, #0			; clear R1
		ADD R1, R1, R0			; store R0
		ADD R0, R0, #0
		BRn OUSER				; illegal move, back to prompt OUSER
		ADD R1, R1, #-9			; testing for q in GETMOVE
		BRz QQUIT
		ST R0, LASTMOVE			; store move of user
		JSR CHKBLOCK
		ADD R2, R2, #0			; to evaluate CHKBLOCK subroutine
		BRp OUSER				; block was occupied, start over		
		AND R3, R3, #0			; clear R3
		ADD R3, R3, #1			; set R3 to 1 for DRAWB subroutine
		JSR DRAWB
		BRnzp XUSER
QQUIT
		HALT
		
PROMPTXSTRING .STRINGZ "\nX move: "
PROMPTOSTRING .STRINGZ "\nO move: "	
COLONEORIG .FILL xC01D
COLTWOORIG .FILL xC03C
ROWONEORIG .FILL xCF00
ROWTWOORIG .FILL xDE00
LASTMOVE .BLKW 1
OCCUPY .BLKW 9

;
; Subroutines
;

; Drawb subroutine

DRAWB	LD R1, LASTMOVE				; load last move into R1
		ADD R1, R1, #0
		BRz SET0
		ADD R1, R1, #-1
		BRz SET1
		ADD R1, R1, #-1
		BRz SET2
		ADD R1, R1, #-1
		BRz SET3
		ADD R1, R1, #-1
		BRz SET4
		ADD R1, R1, #-1
		BRz SET5
		ADD R1, R1, #-1
		BRz SET6		
		ADD R1, R1, #-1
		BRz SET7
		ADD R1, R1, #-1
		BRz SET8
;
; occupying blocks, setting graphics origin
;

SET0	LD R1, BLKCHECK			; load R1 with block check word
		LD R2, BLKZERCHK		; load r2 with word occupying bit 0
		ADD R2, R1, R2			; add 1 to bit 0 in block check word
		ST R2, BLKCHECK			; store new block check word
		LD R0, BLCK0ORIG		; set R0 to block 0 origin
		BRnzp DRAWLETTER		; jump to draw letter
SET1 	LD R1, BLKCHECK			
		LD R2, BLKZERCHK
		ADD R2, R1, R2
		ST R2, BLKCHECK			
		LD R0, BLCK1ORIG		
		BRnzp DRAWLETTER
SET2	LD R1, BLKCHECK
		LD R2, BLKTWOCHK
		ADD R2, R1, R2
		ST R2, BLKCHECK			
		LD R0, BLCK2ORIG		
		BRnzp DRAWLETTER
SET3	LD R1, BLKCHECK
		LD R2, BLKTHRCHK
		ADD R2, R1, R2
		ST R2, BLKCHECK
		LD R0, BLCK3ORIG
		BRnzp DRAWLETTER
SET4 	LD R1, BLKCHECK
		LD R2, BLKFOUCHK
		ADD R2, R1, R2
		ST R2, BLKCHECK
		LD R0, BLCK4ORIG
		BRnzp DRAWLETTER
SET5 	LD R1, BLKCHECK
		LD R2, BLKFIVCHK
		ADD R2, R1, R2
		ST R2, BLKCHECK
		LD R0, BLCK5ORIG
		BRnzp DRAWLETTER
SET6 	LD R1, BLKCHECK
		LD R2, BLKSIXCHK
		ADD R2, R1, R2
		ST R2, BLKCHECK
		LD R0, BLCK6ORIG
		BRnzp DRAWLETTER
SET7 	LD R1, BLKCHECK
		LD R2, BLKSEVCHK
		ADD R2, R1, R2
		ST R2, BLKCHECK
		LD R0, BLCK7ORIG
		BRnzp DRAWLETTER
SET8 	LD R1, BLKCHECK
		LD R2, BLKEIGCHK
		ADD R2, R1, R2
		ST R2, BLKCHECK
		LD R0, BLCK8ORIG
		BRnzp DRAWLETTER
		
DRAWLETTER	ADD R3, R3, #0			; to determine if x or o
			BRz DRAWX
			BRp DRAWO

DRAWX		LD R1, BLOCKX			; origin of block x data
			LD R2, XCOLOR			; color for X
			LD R3, ROWCOUNTER		; row counter for block
			LD R4, ROWJUMP 			; to jump to next row in graphics
MAINDRAWXLOOP LD R6, PXCT			; px counter for each row
XROWLOOP 	AND R5, R5, #0			; clear R5
			LDR R5, R1, #0			; read data out of blockx address
			BRz SKIPXPX				; if 0, skip pixel
			STR R2, R0, #0			; write pixel
SKIPXPX		ADD R1, R1, #1			; increment data address
			ADD R0, R0, #1			; increment graphics display
			ADD R6, R6, #-1			; decrement px counter for each row
			BRp XROWLOOP				; until row is done
			ADD R0, R0, R4			; jump to next row of block data
			ADD R3, R3, #-1			; decrement total row counter
			BRp MAINDRAWXLOOP		; until entire block is written
			BRz DONEB
		
DRAWO		LD R1, BLOCKO
			LD R2, OCOLOR
			LD R3, ROWCOUNTER
			LD R4, ROWJUMP
MAINDRAWOLOOP LD R6, PXCT			; px counter for each row
OROWLOOP 	AND R5, R5, #0			; clear R5
			LDR R5, R1, #0			; read data out of blocko address
			BRz SKIPOPX				; if 0, skip pixel
			STR R2, R0, #0			; write pixel
SKIPOPX		ADD R1, R1, #1			; increment data address
			ADD R0, R0, #1			; increment graphics display
			ADD R6, R6, #-1			; decrement px counter for each row
			BRp OROWLOOP				; until row is done
			ADD R0, R0, R4			; jump to next row of block data
			ADD R3, R3, #-1			; decrement total row counter
			BRp MAINDRAWOLOOP		; until entire block is written
			BRz DONEB
DONEB			
			RET

;
; random .FILLs
;
			
QTEST .FILL #-113
BLCK0ORIG .FILL xC285	; block 0 origin
BLCK1ORIG .FILL xC2A3 	; block 1 origin
BLCK2ORIG .FILL xC2C1	; block 2 origin
BLCK3ORIG .FILL xD185	; block 3 origin
BLCK4ORIG .FILL xD1A3	; block 4 origin
BLCK5ORIG .FILL xD1C1	; block 5 origin
BLCK6ORIG .FILL xE085	; block 6 origin
BLCK7ORIG .FILL xE0A3	; block 7 origin
BLCK8ORIG .FILL xE0C1	; block 8 origin
BLOCKX .FILL xA000
BLOCKO .FILL xA200
XCOLOR .FILL x03E0
OCOLOR .FILL x7FED
ROWCOUNTER .FILL #20
PXCT .FILL #20
ROWJUMP .FILL #108
USERMOVE .BLKW 1
BLKCHECK 	.BLKW 1				; to check if blocks are occupied

;
; Subroutine to check if block is occupied
;

CHKBLOCK	ST R7, CHKBLOCKPC	; store R7 to return to correct PC
			LD R1, USERMOVE		; load move of last user
			BRz CHECKZERO		; user move is 0
			ADD R1, R1, #-1		; decrement move
			BRz CHECKONE		; user move is 1
			ADD R1, R1, #-1		; decrement move
			BRz CHECKTWO		; user move is 2
			ADD R1, R1, #-1		; decrement move
			BRz CHECKTHREE		; user move is 3
			ADD R1, R1, #-1		; decrement move
			BRz CHECKFOUR		; user move is 4
			ADD R1, R1, #-1		; decrement move
			BRz CHECKFIVE		; user move is 5
			ADD R1, R1, #-1		; decrement move
			BRz CHECKSIX		; user move is 6
			ADD R1, R1, #-1		; decrement move
			BRz CHECKSEVEN		; user move is 7
			BRp CHECKEIGHT		; user move is 8		
CHECKZERO	LD R2, BLKCHECK 	; load block-check word
			LD R1, BLKZERCHK	; word with bit 0 filled
			AND R1, R1, R2		; compare two words
			BRz BLKFREE			; if zero, block bit is 0, thus unoccupied
			BRp	BLKOCCUPIED		; if one, block bit is 1, thus occupied
CHECKONE	LD R2, BLKCHECK 	; load block-check word
			LD R1, BLKONECHK	; word with bit 1 filled
			AND R1, R1, R2		; compare two words
			BRz BLKFREE			; if zero, block bit is 0, thus unoccupied
			BRp	BLKOCCUPIED		; if one, block bit is 1, thus occupied
CHECKTWO	LD R2, BLKCHECK 	; load block-check word
			LD R1, BLKTWOCHK	; word with bit 2 filled
			AND R1, R1, R2		; compare two words
			BRz BLKFREE			; if zero, block bit is 0, thus unoccupied
			BRp	BLKOCCUPIED		; if one, block bit is 1, thus occupied
CHECKTHREE	LD R2, BLKCHECK 	; load block-check word
			LD R1, BLKTHRCHK	; word with bit 3 filled
			AND R1, R1, R2		; compare two words
			BRz BLKFREE			; if zero, block bit is 0, thus unoccupied
			BRp	BLKOCCUPIED		; if one, block bit is 1, thus occupied
CHECKFOUR	LD R2, BLKCHECK 	; load block-check word
			LD R1, BLKFOUCHK	; word with bit 4 filled
			AND R1, R1, R2		; compare two words
			BRz BLKFREE			; if zero, block bit is 0, thus unoccupied
			BRp	BLKOCCUPIED		; if one, block bit is 1, thus occupied
CHECKFIVE	LD R2, BLKCHECK 	; load block-check word
			LD R1, BLKFIVCHK	; word with bit 5 filled
			AND R1, R1, R2		; compare two words
			BRz BLKFREE			; if zero, block bit is 0, thus unoccupied
			BRp	BLKOCCUPIED		; if one, block bit is 1, thus occupied
CHECKSIX	LD R2, BLKCHECK 	; load block-check word
			LD R1, BLKSIXCHK	; word with bit 6 filled
			AND R1, R1, R2		; compare two words
			BRz BLKFREE			; if zero, block bit is 0, thus unoccupied
			BRp	BLKOCCUPIED		; if one, block bit is 1, thus occupied
CHECKSEVEN	LD R2, BLKCHECK 	; load block-check word
			LD R1, BLKSEVCHK	; word with bit 7 filled
			AND R1, R1, R2		; compare two words
			BRz BLKFREE			; if zero, block bit is 0, thus unoccupied
			BRp	BLKOCCUPIED		; if one, block bit is 1, thus occupied
CHECKEIGHT	LD R2, BLKCHECK 	; load block-check word
			LD R1, BLKEIGCHK	; word with bit 8 filled
			AND R1, R1, R2		; compare two words
			BRz BLKFREE			; if zero, block bit is 0, thus unoccupied
			BRp	BLKOCCUPIED		; if one, block bit is 1, thus occupied
BLKFREE		AND R2, R2, #0		; clear R2
			BRnzp CHKDONE
BLKOCCUPIED	AND R2, R2, #0		; clear R2
			ADD R2, R2, #1		; set to one
			BRnzp CHKDONE
CHKDONE		LD R7, CHKBLOCKPC	; set R7 to correct PC
			RET

GETMOVPC .BLKW 1
BLKZERCHK .FILL #1		; to check block 0
BLKONECHK .FILL #2		; to check block 1
BLKTWOCHK .FILL #4		; to check block 2
BLKTHRCHK .FILL #8		; to check block 3
BLKFOUCHK .FILL #16		; to check block 4
BLKFIVCHK .FILL #32		; to check block 5
BLKSIXCHK .FILL #64		; to check block 6
BLKSEVCHK .FILL #128	; to check block 7
BLKEIGCHK .FILL #256	; to check block 8
CHKBLOCKPC .BLKW 1
NEGASCII .FILL #-48
		
;
; Getmov subroutine, this checks for legal input
;

GETMOV	ST R7, GETMOVPC		; store R7 to return to correct PC
		GETC				; get first char
		OUT					; echo
		LD R3, QTEST		; to check for Q
		LD R2, NEGASCII		; strip ASCII
		AND R1, R1, #0		; clear R1
		AND R4, R4, #0		; clear R4
		ADD R1, R1, R0		; store char in R1
		ADD R0, R0, R3		; test for 'q'
		BRz	QMOVE			; if q
		ADD R1, R1, R2		; remove ASCII
		BRn	ILLEGALMOVE		; illegal first char, onto loop waiting for return
		ADD R1, R1, #-9		; limiting to 0-8
		BRp ILLEGALMOVE		; if not, legal char
		ADD R1, R1, #9		; restore R1
		ST R1, USERMOVE		; store valid move for safekeeping		
		GETC				; get second char
		OUT					; echo
		AND R1, R1, #0		; clear R1
		ADD R1, R1, R0		; store char in R1
		ADD R0, R0, R3		; test for 'q'
		BRz	QMOVE			; if q
		ADD R1, R1, #-10	; check for return
		BRz LEGALMOVE
			
ILLEGALMOVE	GETC			; get next char
		OUT					; echo
		LD R3, QTEST		; to check for Q
		AND R1, R1, #0		; clear R1
		ADD R1, R1, R0		; store char in R1
		ADD R0, R0, R3		; test for 'q'
		BRz	QMOVE			; if q
		ADD R1, R1, #-10	; check for return
		BRz ILLEGALDONE		; done getting chars, return to main to repeat getmov
		BRnp ILLEGALMOVE	; loop until q or return is entered by user
ILLEGALDONE		AND R0, R0, #0		; clear R0
		ADD R0, R0, #-1		; set R0 to -1 for illegal move
		BRnzp GETMOVDONE		
QMOVE	AND R0, R0, #0		; clear R0
		ADD R0, R0, #9		; set to 9 when user enters 'q'
		BRnzp GETMOVDONE
LEGALMOVE	LD R0, USERMOVE ; set R0
		BRnzp GETMOVDONE
GETMOVDONE 		LD R7, GETMOVPC	; to return to correct PC	
		RET

;
; Subroutines for drawing the grid
;

DRAWV	LD R0, WHITECOLOR	; 
		LD R3, LPIXELCT		; load pixel counter
		LD R4, VROWINCR		; load row incrementer
VLLOOP	STR R0, R1, #0		; write pixel
		ADD R1, R1, R4		; increment pixel to next row
		ADD R3, R3, #-1		; decrement pixel counter
		BRp VLLOOP			; loop until px counter for column is zero
		RET

DRAWH	LD R0, WHITECOLOR
		LD R3, LPIXELCT	
HLLOOP	STR R0, R1, #0		; write pixel
		ADD R1, R1, #1		; increment to next pixel
		ADD R3, R3, #-1		; decrement pixel counter
		BRp HLLOOP			; loop until 90 pixels written
		RET
				
WHITECOLOR 	.FILL x7FFF		; white color for lines
LPIXELCT	.FILL #90		; pixel count for horizontal and vertical lines
VROWINCR	.FILL #128		; to increment the row for a vertical line	
GRAPHICSORIGIN .FILL xC000
CLRCOLOR .FILL x0000
TOTALGRAPHICSPX .FILL x3E00	; graphics pixel count		

CLEARSCREEN LD R1, GRAPHICSORIGIN		; set R1 to graphics origin
			LD R0, CLRCOLOR
			LD R2, TOTALGRAPHICSPX	
CLRLOOP		STR R0, R1, #0		; write pixel
			ADD R1, R1, #1		; increment px location
			ADD R2, R2, #-1		; decrement px counter
			BRp CLRLOOP
			RET	
			
		.END