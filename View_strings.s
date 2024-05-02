// Author  : Victor Ponce
// Program : Rasm-4 View all strings
// Class   : CS3B
// Subroutine View_strings
// X0         : points to the head of the link list
// @return    : Copied string into dynamiclly allocated memory
//					 thats pointing to X1
// @ All AAPCS registers are preserved,  r19-r29 and SP.
	.data

//	szHelpers: .asciz "HELP"

	.global	View_strings

	.text
View_strings:
	// Push registers
	STP	X19, X20, [SP, #-16]! // Push X19 and X20 to the stack
	STP	X21, X22, [SP, #-16]! // Push X21 and X22 to the stack
	STP	X23, X24, [SP, #-16]! // Push X23 and X24 to the stack
	STP	X25, X26, [SP, #-16]! // Push X25 and X26 to the stack
	STP	X27, X28, [SP, #-16]! // Push X27 and X28 to the stack
	STP	X29, X30, [SP, #-16]! // Push X29 and X30 to the stack

	/*===== View_strings =====*/

	MOV    X19, X0

traverse_top:
    LDR    X19,[X19]

    CMP    X19,#0                        // Checking for empty list
    BEQ    traverse_exit

    LDR    X0,[X19]                    // Double de-reference
    BL     putstring

    ADD    X19,X19,#8                    // Jump the X1 -> next field
    B      traverse_top

	/*===== View_strings =====*/
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
