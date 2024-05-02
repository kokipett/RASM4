//Koki Pettigrew
.global search

   .data
//  X0: address to search substring 
//  X1: headPointer
//  X2: tailPointer
//  X7: Node Count
	szTest:	.asciz	"same string found\n"
	szTest2:	.asciz "looping\n"

	szPar1:	.asciz	"["
	szBuf:	.skip	512
	szPar2:	.asciz	"]: "


	chLF:	.byte	0x0a
   .text
search:
   stp   x19, x20, [sp, #-16]!   // Push x19 and x20, then move SP down 16 bytes
   stp   x21, x22, [sp, #-16]!   // Push x21 and x22, then move SP down 16 bytes
   stp   x23, x24, [sp, #-16]!   // Push x23 and x24, then move SP down 16 bytes
   stp   x25, x26, [sp, #-16]!   // Push x25 and x26, then move SP down 16 bytes
   stp   x27, x28, [sp, #-16]!   // Push x27 and x28, then move SP down 16 bytes
   stp   x29, x30, [sp, #-16]!   // Push x29 and x30, then move SP down 16 bytes

	//x21: node counter
	MOV	x21,#0

	MOV	X20,X0	//store search string ptr in x20

      MOV    X19,X1

   traverse_top:
	ADD	X21,X21,#1	//increment node counter
//	LDR	X0,=szTest2
//	BL	putstring

	LDR    X19,[X19]

      CMP    X19,#0                        // Checking for empty list
      BEQ    exit

      LDR    X0,[X19]                    // Double de-reference
      B		Check

     // ADD    X19,X19,#8                    // Jump the X1 -> next field
	     // B        traverse_top

   traverse_exit:
      //LDR    X30,[SP], #16       	     // POP LR
      //LDR    X19,[SP], #16            // POP LR
      B		exit

	Check:
		//LDR	X19,[x19]//deref pointer to data


		MOV	X0,X19	//X19 contains ptr to string, mov into x0 to check against x20
		MOV	X1,X20	//X20 contains ptr to substring, mov into x1 to check against x0

		LDR	X0,[X0]
//		LDR	X1,[X1]	//deref

		BL	String_indexOf_3	//returns -1 if substring is not within string
		CMP	X0,#-1	//if the substring is not within the string
		BEQ	Next	//else, check next pointer
		B	Print	//print the string


		Print:
			//print node number
			B	printNodeNum
			printcont:
			MOV	X0,X19
			LDR	X0,[X0]
			BL	putstring
			MOV	X0,chLF
			BL	putch

		Next:
			ADD     X19,X19,#8                    // Jump the X1 -> next field
      			B        traverse_top

	printNodeNum:
		LDR	X0,=szPar1
		bl	putstring

		mov	x0,x21
		ldr	x1,=szBuf
		bl	int64asc

		ldr	x0,=szBuf
		bl	putstring

		LDR	X0,=szPar2
		bl	putstring

		b	printcont

exit:

   ldp   x29, x30, [sp], #16     // Pop x29 and x30, then move SP up 16 bytes
   ldp   x27, x28, [sp], #16     // Pop x27 and x28, then move SP up 16 bytes
   ldp   x25, x26, [sp], #16     // Pop x25 and x26, then move SP up 16 bytes
   ldp   x23, x24, [sp], #16     // Pop x23 and x24, then move SP up 16 bytes
   ldp   x21, x22, [sp], #16     // Pop x21 and x22, then move SP up 16 bytes
   ldp   x19, x20, [sp], #16     // Pop x19 and x20, then move SP up 16 bytes

   RET                           // Return to caller

   .end
