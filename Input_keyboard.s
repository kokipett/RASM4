// Author  : Victor Ponce
// Program : Rasm-3 String copy Function
// Class   : CS3B
// Subroutine String_copy
// @param  X0 : Points to a null terminated string
// @param  X1 : Pointer that holds enough memory for string
// @return    : Copied string into dynamiclly allocated memory
//					 thats pointing to X1
// @ All AAPCS registers are preserved,  r19-r29 and SP.
	.equ	NODE_SIZE, 16

	.data
	szHelper: .asciz "Wrong"
	.global	Input_keyboard

	.text
Input_keyboard:
	// Push registers
	STP	X19, X20, [SP, #-16]! // Push X19 and X20 to the stack
	STP	X21, X22, [SP, #-16]! // Push X21 and X22 to the stack
	STP	X23, X24, [SP, #-16]! // Push X23 and X24 to the stack
	STP	X25, X26, [SP, #-16]! // Push X25 and X26 to the stack
	STP	X27, X28, [SP, #-16]! // Push X27 and X28 to the stack
	STP	X29, X30, [SP, #-16]! // Push X29 and X30 to the stack

	MOV	X19, X0			// Move string into X19
	MOV	X20, X1
	MOV	X21, X2
	MOV	X22, X3
	MOV	X26, X4			// Number of nodes
	MOV	X27, X5			// Number of memory used

	ldr	X1,[X1]
	CMP	X1, #0
	BEQ	emptyList
	B		nonEmptyList
	/*===== Emptry linked list =====*/
emptyList:
	//ldr	x0,=szHelper
	//bl		putstring

	// Step 0: Create the newNodePtr
    MOV    X0, NODE_SIZE
    BL     malloc            // Attempt to get block of 16 bytes from the heap

	MOV	X1, X22
    STR    X0,[X1]                // Store into newNodePtr memory from malloc

	MOV	X22, X1
    // Step 1: Get some memory from malloc for str1
    //           Copy str1 into the newly malloc'd memory
	MOV	X0, X19
    BL     String_copy

	MOV	X1, X22
    LDR    X1,[X1]                // X1 contains the address of our NODE

    STR    X0,[X1]                // 

	// Step 2: Insert newNode into an Empty Linked List
	MOV	X1, X22
    LDR    X1,[X1]                // Get the addres of the newNode

	MOV	X0, X20
    STR    X1,[X0]                // headPtr = newNodePtr
	MOV	X20, X0

	MOV	X0, X21
    STR    X1,[X0]                // tailPtr = newNodePtr
	MOV	X21, X0
	B		final
	/*===== Non-Empty linked list =====*/

nonEmptyList:
	// Step 0: Create the newNodePtr
    MOV    X0, NODE_SIZE
    BL     malloc            // Attempt to get block of 16 bytes from the heap

	MOV	X1, X22
    STR    X0,[X1]                // Store into newNodePtr memory from malloc

	MOV	X1, X22
    // Step 1: Get some memory from malloc for str1
    //           Copy str1 into the newly malloc'd memory
	MOV	X0, X19
    BL     String_copy

	MOV	X1, X22
    LDR    X1,[X1]                // X1 contains the address of our NODE

    STR    X0,[X1]                // 

	// Step 2: Insert newNode into an Empty Linked List
	MOV	X1, X22
    LDR    X1,[X1]                // Get the addres of the newNode

	MOV	X0, X21
	LDR	X0,[X0]
	ADD	X0, X0, #8
   STR    X1,[X0]                // headPtr = newNodePtr
//	MOV	X20, X0

	MOV	X0, X21
   STR    X1,[X0]                // tailPtr = newNodePtr
	MOV	X21, X0

final:

	// New Step:
	MOV	X0, X20
	LDR	X0,[X0]

	MOV	X1, X21
	LDR	X1,[X1]

	MOV	X4, X26
	LDR	X4,[X4]
	ADD	X4, X4, #1
	STR	X4,[X26]

	MOV	X5, X27
	LDR	X5,[X5]
	ADD	X5, X5, #16
	STR	X5,[X27]
	/*===== String_copy =====*/

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
