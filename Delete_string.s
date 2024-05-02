// Author  : Victor Ponce
// Program : Rasm-3 String charAt Function
// Class   : CS3B
// Subroutine String_charAt
// @param  X0 : Points to a null terminated string
// @param  X1 : Index
// @return    : Char in X0
// @ All AAPCS registers are preserved,  r19-r29 and SP.
	.data

	.global	Delete_string

	.text
Delete_string:
	// Push registers
	STP	X19, X20, [SP, #-16]! // Push X19 and X20 to the stack
	STP	X21, X22, [SP, #-16]! // Push X21 and X22 to the stack
	STP	X23, X24, [SP, #-16]! // Push X23 and X24 to the stack
	STP	X25, X26, [SP, #-16]! // Push X25 and X26 to the stack
	STP	X27, X28, [SP, #-16]! // Push X27 and X28 to the stack
	STP	X29, X30, [SP, #-16]! // Push X29 and X30 to the stack

	/*===== String_substring_1 =====*/
	MOV	X19, X0		// Pass head to X19
	MOV	X20, X1		// Pass index to X20
	LDR	X20,[X20]
	MOV	X21, 0x30		// Index to iterate

	LDR	X19, [X19]
traverse_top:

	CMP	X19, #0
	BEQ	traverse_exit

	CMP	X20, X21
	ADD	X21, X21, #1
	BEQ	output

	ADD	X19, X19, #8
	MOV	X22, X19
	LDR	X19, [X19]
	B		traverse_top
output:
	LDR	X0,[X19]
	BL		free

	MOV	X0, X19
	ADD	X19, X19, #8
	LDR	X19,[X19]
	BL		free

	STR	X19, [X22]

	/*===== String_substring_1 =====*/
traverse_exit:
	// Pop Registers
	LDP X29, X30, [SP], #16		// Pop X29 and X30 off the stack
	LDP X27, X28, [SP], #16		// Pop X27 and X28 off the stack
	LDP X25, X26, [SP], #16		// Pop X25 and X26 off the stack
	LDP X23, X24, [SP], #16		// Pop X23 and X24 off the stack
	LDP X21, X22, [SP], #16		// Pop X21 and X22 off the stack
	LDP X19, X20, [SP], #16		// Pop X19 and X20 off the stack

	// Return
	RET	LR
	.end
