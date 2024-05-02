// Author  : Victor Ponce
// Program : Rasm-3 String copy Function
// Class   : CS3B
// Subroutine String_copy
// @param  X0 : Points to a null terminated string
// @param  X1 : Pointer that holds enough memory for string
// @return    : Copied string into dynamiclly allocated memory
//					 thats pointing to X1
// @ All AAPCS registers are preserved,  r19-r29 and SP.
	.equ	R, 	00										// Read only
		.equ	W, 	01										// Write only
		.equ  RW,   02										// Read Write
		.equ	T_RW, 01002						 			// Truncate Read Write
		.equ	C_W,	0101									// Create file if does not exits

		.equ		RW_RW____, 0660							// chmod permision
		.equ		RW_______, 0600
		.equ		AT_FDCWD, -100
	.data
szFile:		.asciz	"input.txt"					// File name
fileBuf:		.skip		512								// Buffer
bFD:			.byte		0									// File Descriptor
szEOF:		.asciz "Reached the end of file\n"	// Output message for file end reached
szERROR:		.asciz "FILE READ ERROR\n"				// Output message for error

	.global	Input_textFile

	.text
Input_textFile:
	// Push registers
	STP	X19, X20, [SP, #-16]! // Push X19 and X20 to the stack
	STP	X21, X22, [SP, #-16]! // Push X21 and X22 to the stack
	STP	X23, X24, [SP, #-16]! // Push X23 and X24 to the stack
	STP	X25, X26, [SP, #-16]! // Push X25 and X26 to the stack
	STP	X27, X28, [SP, #-16]! // Push X27 and X28 to the stack
	STP	X29, X30, [SP, #-16]! // Push X29 and X30 to the stack

	MOV	X21, X1
	MOV	X22, X2
	MOV	X23, X3
	/*===== String_copy =====*/
	// Open File
	MOV	X0, #AT_FDCWD		// Local directory
	MOV	X8, #56				// OPENAT
	LDR	X1,= szFile			// File name

	MOV	X2, #R				// FLAGS Write-only, create if it doesn't exitst
	MOV	X3, #RW_______		// Permissions . . .
	SVC	0						// Service call

	LDR	X4,= bFD				// Point to iFD
	STRB	W0,[X4]				// Store a byte into X1

top1:
	LDR	X1,=fileBuf			// Load the address of fileBuf into X1

	BL		getline				// Branch and link to getline
	CMP	X0,#0					// Compare X0 to 0
	BEQ	last					// Branch to last if equal to

	LDR	X0,=fileBuf			// Load the address of fileBuf into X0
	MOV	X1, X21
	MOV	X2, X22
	MOV	X3, X23
	BL		Input_keyboard
	//BL		putstring			// Branch and link to putstring

	LDR	X0,= bFD				// Load the address of bFD into X0
	LDRB	W0,[X0]				// Load a sinble byte from X0 into W0

	B		top1					// Branch to top1

last1:
	LDR	X0,=fileBuf			// Load the address of fileBuf into X0
	MOV	X1, X21
	MOV	X2, X22
	MOV	X3, X23
	BL		Input_keyboard

//	LDR	X0,= bFD				// Load the address of bFD into X0
//	LDRB	W0,[X0]				// Load a sinble byte from X0 into W0


last:
	LDR	X0,=bFD				// Load the address of bFD into X0
	LDRB	W0,[X0]				// Load a byte from X0 into W0

	MOV	X8, #57				// Move 57 into X8
	SVC	0						// Service call

exit:
	B		end
// GETCHAR
getchar:
	MOV	X2, #1				// Move 1 into X2

	MOV	X8, #63				// Move 63 into X8
	SVC	0						// Service call

	RET							// Return

// GETLINE
getline:
	STR	X30, [SP, #-16]!	// Store X30 onto the stack

top:
	BL		getchar				// Branch and link to getchar
	LDRB	W2,[X1]				// Load a byte from X1 into W2
	CMP	W2,#0xa				// Compare W2 to NL

	BEQ	EOLINE				// Branch to EOLINE if equal to

	CMP	W0,#0x0				// Compare W0 to 0
	BEQ	EOF					// Branch to EOF if equal to

	ADD	X1,X1,#1				// Increment X1

	LDR	X0,=bFD				// Load the address of bFD into X0
	LDRB	W0,[X0]				// Load a byte from X0 into W0
	B		top					// Branch to top

EOLINE:
	ADD	X1,X1,#1				// Increment X1
	MOV	W2,#0					// Move 0 into W2
	STRB	W2,[X1]				// Store a byte from X1 into W2
	B		skip					// Branch to skio

EOF:
	MOV	X19,X0				// Move X0 into X19
	LDR	X0,=szEOF			// Load the address of szEOF into X0
	BL		putstring			// Branch and link to putstring
	MOV	X0,X19				// Move X19 into X0
	B		skip					// Branch to skip

ERROR:
	MOV	X19,X0				// Move X0 into X19
	LDR	X0,=szERROR			// Load the address of szERROR into X0
	BL		putstring			// Branch and link to putstring
	MOV	X0,X19				// Move X19 into X0
	B		skip					// Branch to skip

skip:
	LDR	X30,[SP],#16		// Load X30 to the stack

	RET							// Return
	/*===== String_copy =====*/
end:
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
