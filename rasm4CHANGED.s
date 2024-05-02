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

szClr: .asciz	"\n \n \n \n \n \n \n"



szSelect: .skip 	BUFFER
dbSelect: .quad		0

str1:  			.asciz "The Cat in the Hat\n"
str2:  			.asciz "\n"
str3:  			.asciz  "By Dr. Seuss\n"

szMsgEnter:		.asciz "\n \n \n \n \n \n \n \n \n \n \nENTER:"
szMsgOp1:		.asciz "Option 1"
szMsgOp2a:		.asciz "Option 2"


sz2a:			.asciz "Input: "
strInput:	.skip BUFFER

sz4a:		.asciz "Enter # node to edit: "
szEdInd:	.skip	BUFFER
dbEdInd:	.quad	0

sz4b:		.asciz "Enter string for replacement: "
szEdStr:	.skip	BUFFER

sz5:		.asciz "Search for: "
szSearch:	.skip	BUFFER

sz6:		.asciz "List saved to file. "

headPtr:  .quad  0                        // Head of the linked list
tailPtr:  .quad  0                        // Tail of the linked list
newNodePtr: .quad 0 // Used for creating a new node

szAnswer:		.skip BUFFER

numNodes:		.quad 0
numMemory:		.quad 0
szNodes:		.skip BUFFER
szMemory:		.skip BUFFER

sz0:	.asciz "0"

szHelper:	.asciz "something"

chLF:	.byte	0x0a

.text

_main:


//**********************************MENU************************************//
MenuLoop:
	//========================print menu========================
	LDR	X0,=szClr	//clear screen
	BL	putstring

	LDR	X0,=szMsg1	//print "MASM4 TEXT EDITOR"
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg2	//print "Data Structure Heap Memory Consumption: "
	BL	putstring

	LDR	X0,= numMemory
	LDR	X0,[X0]
	LDR	X1,= szMemory
	BL	int64asc

	LDR	X0,= szMemory
	BL	putstring

	LDR	X0,=chLF	//print line feed
	BL	putch

	LDR	X0,=szMsg3	//print "Number of Nodes:"
	BL	putstring

	LDR	X0,= numNodes
	LDR	X0,[X0]
	LDR	X1,= szNodes
	BL	int64asc

	LDR	X0,= szNodes
	BL	putstring

	LDR	X0,= chLF
	BL	putch

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
		B	InputLoop

	//BL	ascint64	//
	//LDR	X1, =dbSelect

SwitchStatement:
	CMP	X0, #50
	BEQ	checking_2

	CMP	X0, #49
	BEQ	body_1

	CMP	X0, #51
	BEQ	body_3

	CMP	X0, #52
	BEQ	body_4

	CMP	X0, #53
	BEQ	body_5

	CMP	X0, #54
	BEQ	body_6

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


body_1:
	LDR	X0,= szMsgOp1
	bl		putstring

	LDR	X0,= chLF
	bl		putch

	LDR	X0,= headPtr
	BL		View_strings

	B	MenuLoop

	CMP	X0,#0
	BEQ	end

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
	LDR	X4,= numNodes
	LDR	X5,= numMemory

	BL	Input_keyboard

	LDR	X6,= headPtr
	STR	X0,[X6]

	LDR	X7,=tailPtr
	STR	X1,[X7]

	LDR	X8,= numNodes
	STR	X4,[X8]

	LDR	X9,= numMemory
	STR	X5,[X9]

	LDR	X0,= numNodes
	LDR	X0,[X0]
	LDR	X1,= szNodes
	BL	int64asc

	LDR	X0,= szNodes
	BL	putstring

	LDR	X0,= chLF
	BL	putch

	LDR	X0,= numMemory
	LDR	X0,[X0]
	LDR	X1,= szMemory
	BL	int64asc

	LDR	X0,= szMemory
	BL	putstring

	LDR	X0,= chLF
	BL	putch

	B	MenuLoop



body_2b:
	LDR	X1,= headPtr
	LDR	X2,= tailPtr
	LDR	X3,= newNodePtr
	LDR	X4,= numNodes
	LDR	X5,= numMemory
	BL		Input_textFile

	LDR	X8,= numNodes
	STR	X4,[X8]

	LDR	X9,= numMemory
	STR	X5,[X9]

	LDR	X0,= numNodes
	LDR	X0,[X0]
	LDR	X1,= szNodes
	BL		int64asc

	LDR	X0,= szNodes
	BL		putstring

	LDR	X0,= chLF
	BL		putch

	LDR	X0,= numMemory
	LDR	X0,[X0]
	LDR	X1,= szMemory
	BL		int64asc

	LDR	X0,= szMemory
	BL		putstring

	LDR	X0,= chLF
	BL		putch


	B	MenuLoop


body_3:
	LDR	X0,= szAnswer
	MOV	X1, BUFFER
	BL	getstring
	LDR	X0, =szAnswer	//load x0 with address of input
	LDR	X0,[X0]


	LDR	X0,= headPtr
	LDR	X1,= szAnswer
	BL	Delete_string
	B	MenuLoop


body_4:
	//load x0 with headPtr, x1 with index, x2 with new string

	LDR	X0,=sz4a	//Load input prompt
	BL	putstring	//

	LDR	X0,=szEdInd	//Get input
	MOV	X1,BUFFER	//
	BL	getstring	//

	LDR	x0,=szEdInd	//convert to int, store in dbEdInd
//	LDR	X0,[X0]
	BL	ascint64	//
	LDR	X1,=dbEdInd	//
	STR	X0,[X1]		// Store index int into dbEdInd

//	CMP	X

	LDR	X0,=sz4b	//
	BL	putstring	//

	LDR	X0,=szEdStr	//
	MOV	X1,#BUFFER	//
	BL	getstring	//

	LDR	X0,=headPtr	//
	LDR	X1,=dbEdInd	//
	LDR	X2,=szEdStr	//

	BL	edit_String

	B	MenuLoop

body_5:
	//load x0 with searching substring, x1 with headptr

	LDR	X0,=sz5
	BL	putstring

	LDR	X0,=szSearch
	MOV	X1,#BUFFER
	BL	getstring


	LDR	X0,=szSearch	//search string passed into X0
	LDR	X1,=headPtr	//pass in headPointer
	BL	search		//

	B	MenuLoop


body_6:
	LDR	X0,= headPtr
	BL		save

	LDR	X0,=sz6
	BL	putstring

	B	MenuLoop

/*printZero:
	LDR	X0,=sz0
	BL	putstring*/

end:
	LDR	x0,=headPtr
	BL	FreeNodes

	MOV	X0, #0
	MOV	X8, #93
	SVC	0

.end
