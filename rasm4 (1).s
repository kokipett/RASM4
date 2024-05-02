.global _main

.equ	BUFFER,	21
.equ	NODE_SIZE,	16

	.data

szMsg1:	.asciz "		MASM4 TEXT EDITOR"
szMsg2:	.asciz "	Data Structure Heap Memory Consumption: "
szMsg3:	.asciz "	Number of Nodes:"
szMsg4:	.asciz "<1> View all strings"
szMsg5:	.asciz "<2> Add string"
szMsg6:	.asciz "	<a> from Keyboard"
szMsg7:	.asciz "	<b> from File. Static file named input.txt"
szMsg8:	.asciz "<3> Delete string. Given an index #, delete the entire string and de-allocate memory (including the node)."
szMsg9:	.asciz "<4> Edit string. Given an index #, replace old string w/ new string. Allocate/De-allocate as needed. "
szMsg10: .asciz	"<5> String search. Regardless of case, return all strings that match the substring given."
szMsg11: .asciz	"<6> Save File (output.txt)"
szMsg12: .asciz	"<7> Quit"

szInv:	.asciz	"Invalid input. Enter a number 1-9: "

szSelect: .skip 	BUFFER
dbSelect: .quad		0

str1:  			.asciz "The Cat in the Hat\n"
str2:  			.asciz "\n"
str3:  			.asciz  "By Dr. Seuss\n"

szMsgEnter:		.asciz "ENTER:"
szMsgOp1:		.asciz "Option 1"
szMsgOp2a:		.asciz "Option 2"


sz2a:			.asciz "Input: "
strInput:	.skip BUFFER

headPtr:  .quad  0                        // Head of the linked list
tailPtr:  .quad  0                        // Tail of the linked list
newNodePtr: .quad 0 // Used for creating a new node

szHelper:	.asciz "something"

chLF:	.byte	0x0a

.text

_main:

//**********************************MENU************************************//
MenuLoop:
	//========================print menu========================
	LDR	X0,=szMsg1	//print "MASM4 TEXT EDITOR"
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg2	//print "Data Structure Heap Memory Consumption: "
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg3	//print "Number of Nodes:"
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg4	//print "<1> View all strings"
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch
	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg5	//print "<2> Add string"
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg6	//print "<a> from Keyboard"
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg7	//print "<b> from File. Static file named input.txt"
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch
	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg8	//print "<3> Delete string. Given..."
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch
	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg9	//print "<4> Edit string. Given..."
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch
	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg10	//print "<5> String search. Regardless..."
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch
	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg11	//print "<6> Save File (output.txt)"
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch
	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg12	//print "<7> Quit"
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch
	LDR	X0,=chLF	//print line feed
	BL	putch

	//========================Get user input========================
InputLoop:
	ldr	x0,= szMsgEnter
	bl		putstring

	LDR	X0, =szSelect	//Load buffer for input into X0 
	MOV	X1, BUFFER	//Load buffer size into X1
	BL	getstring	//call getstring
	LDR	X0, =szSelect	//load x0 with address of input
	LDR	X0,[X0]

	//check if ascii value is between 49 and 57 (1 and 7)
	CMP 	X0, #49
	BLT	Invalid
	CMP 	X0, #57
	BGT	Invalid

	B	SwitchStatement

	//tell user to re-enter if not valid
	Invalid:
		LDR	X0,=szInv
		BL	putstring
		B	SwitchStatement

	//BL	ascint64	//
	//LDR	X1, =dbSelect

SwitchStatement:
	CMP	X0, #50
	BEQ	checking_2

	CMP	X0, #49
	BEQ	body_1

//	CMP	X0, #54
//	BEQ	body_6

	B		end

checking_2:
	LDR	X0, =szSelect	//Load buffer for input into X0 
	MOV	X1, BUFFER	//Load buffer size into X1
	BL	getstring	//call getstring
	LDR	X0, =szSelect	//load x0 with address of input
	LDR	X0,[X0]

	CMP	X0, #97
	BEQ	body_2a

	CMP	X0, #98
	BEQ	body_2b

	B		end

body_2a:
	ldr	x0,= sz2a
	bl		putstring

	LDR	X0,= strInput
	MOV	X1, BUFFER
	BL		getstring
	LDR	X0,= strInput
	LDR	X0,[X0]

	LDR	X0,= strInput
	LDR	X1,= headPtr
	LDR	X2,= tailPtr
	LDR	X3,= newNodePtr

	BL		Input_keyboard

	LDR	X2,= headPtr
	STR	X0,[X2]

	LDR	X3,= tailPtr
	STR	X1,[X3]

	B		InputLoop

body_2b:
	LDR	X1,= headPtr
	LDR	X2,= tailPtr
	LDR	X3,= newNodePtr
	BL		Input_textFile

	ldr	X0,=szHelper
	bl		putstring

	B		InputLoop

body_1:
	LDR	X0,= szMsgOp1
	bl		putstring

	LDR	X0,= chLF
	bl		putch

	LDR	X0,= headPtr
	BL		View_strings

	B		InputLoop

	CMP	X0,#0
	BEQ	end

body_6:
//	BL		Save_file

end:
	MOV	X0, #0
	MOV	X8, #93
	SVC	0

.end
