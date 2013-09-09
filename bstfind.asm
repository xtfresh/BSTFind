; CS 2110 HW6 Summer 2013
;
; Author: MONTEK SINGH

;-------------------------------------------------------------------------------
; Main
;-------------------------------------------------------------------------------

.orig x3000

	LD R6, STACK
	LD R1, ROOT
	LD R0, TARGET
	
	
	
	
	JSR BSTFIND	;jump to subroutine
	

	LDR R0, R6, 0	; Get the return value from the stack
	ADD R6, R6, 3	; Pop the return value and arguments off the stack
	ST R0, ANSWER	; Store the answer from BSTFIND(target, root) to lbl

	HALT

TARGET	.fill 100
ROOT	.fill x4000
STACK	.fill xF000
ANSWER	.blkw 1

;-------------------------------------------------------------------------------
; BSTFIND
;-------------------------------------------------------------------------------

BSTFIND
	ADD R6, R6, -2	;allocate 2 spaces in stack
	
	STR R0, R6, 1	;store target into stack
	STR R1, R6, 0	;store root into stack
	; Implement the function here! It must follow the calling convention.
	ADD R6, R6, -4	;make initial part of stackframe
	STR R7, R6, 2	;store return address
	STR R5, R6, 1	;store old frame pointer
	ADD R5, R6, 0	;copy stack pointer into frame pointer
	
	LDR R1, R1, 0	;load the value store in node
	STR R1, R6, 0	;store the value of node into stack

	ADD R6, R6, -1	
	STR R2, R6, 0	;save value of node in r5

	LDR R2, R5, 4	;put the node adress in r2
	LDR R1, R2, 0	;put value of node in r2
	
	NOT R1, R1 	;negate R1 (node)
	ADD R1, R1, 1	;2s complement
	ADD R1, R1, R0 	;node - target's value
	BRz FOUND	;if 0, then found target, branch to found
	BRp RIGHT	;if target is smaller than node, go left
	BRn LEFT	;if target is larger than node, go right
	BR TERMIN
LEFT	ADD R2, R2, 1		
	LDR R1, R2, 0 	;node = node.left
	BRz ZERO
	JSR BSTFIND
	LDR R2, R6, 0	;load teh return value
	STR R2, R5, 3	;store the return value into previous stack
	ADD R6, R6, 3	;move stack pointer to top of previous stack
	BR TERMIN
	
RIGHT	ADD R2, R2, 2	
	LDR R1, R2, 0	;node = node.right
	BRz ZERO
	JSR BSTFIND
	LDR R2, R6, 0	;load teh return value
	STR R2, R5, 3	;store the return value into previous stack
	ADD R6, R6, 3	;move stack pointer to top of previous stack
	BR TERMIN

FOUND	AND R2, R2, 0	;clear r2
	ADD R2, R2, 1	;put 1 into r2
	STR R2, R5, 3	;store r2 (1) into ret value
	BR TERMIN

ZERO	AND R2, R2, 0	;clear r2
	STR R2, R5, 3	;store 0 in rv (return 0)
	
TERMIN	
	LDR R2, R6, 0
	ADD R6, R6, 1	;pop
	ADD R6, R6, 1	;pop
	LDR R5, R6, 0	;load ofp
	ADD R6, R6, 1	;pop
	LDR R7, R6, 0	;load Return address
	ADD R6, R6, 1	;pop



	;LDR R0,R5,0	;restore R0
	;LDR R1,R5,-1	;restore R1
	;LDR R7,R5,2	;restore RA
	;ADD R6,R5,1	;stack pointer points to OLD FP
	;LDR R5,R6,0	;R5 = old FP
	;ADD R6,R6,2	;R6 points to RV
	RET
.end

;-------------------------------------------------------------------------------
; BST DATA
;-------------------------------------------------------------------------------

.orig x4000

	.fill 34	; x4000
	.fill x4003
	.fill x4006

	.fill 23	; x4003
	.fill x4009
	.fill x400C

	.fill 41	; x4006
	.fill x400F
	.fill x4012

	.fill 17	; x4009
	.fill 0
	.fill 0

	.fill 30	; x400C
	.fill x4015
	.fill 0

	.fill 38	; x400F
	.fill 0
	.fill x4018

	.fill 50	; x4012
	.fill 0
	.fill 0

	.fill 25	; x4015
	.fill 0
	.fill 0

	.fill 39	; x4018
	.fill 0
	.fill 0

.end
