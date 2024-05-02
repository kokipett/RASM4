.global save

//  X0: headPtr


// file modes
.equ    W, 0101                         // creates if does not exist, for writing only

// file permissions
.equ    RW_RW____,0660  // chmod permissions
.equ    AT_FDCWD, -100 // File Descriptor Current Working Directory
.equ    BUFFER, 512

.data            // Start of .data memory
szFile:         .asciz  "output.txt"                    // file to be written to
iFD:            .byte           0                                                       // byte initialized to 0
szBuf:          .skip   BUFFER

   .text
save:
   stp   x19, x20, [sp, #-16]!   // Push x19 and x20, then move SP down 16 bytes
   stp   x21, x22, [sp, #-16]!   // Push x21 and x22, then move SP down 16 bytes
   stp   x23, x24, [sp, #-16]!   // Push x23 and x24, then move SP down 16 bytes
   stp   x25, x26, [sp, #-16]!   // Push x25 and x26, then move SP down 16 bytes
   stp   x27, x28, [sp, #-16]!   // Push x27 and x28, then move SP down 16 bytes
   stp   x29, x30, [sp, #-16]!   // Push x29 and x30, then move SP down 16 bytes
      //save x0(headptr into x20)
	MOV	x20,x0


	  // open file
        mov     x0, #AT_FDCWD           // local directory
        mov     x8, #56                         // OPENAT
        ldr     x1,=szFile                      // file name

        mov     x2, #W                          // Flags write-only, create if doesnt exist
        mov     x3, #RW_RW____          // Permissions ...
        SVC     0                                               // Service call

        ldr     x1,=iFD                         // point to iFD
        strb    w0,[x1]                         // store w0 in iFD

        // At this point x0/w0 contains, the fd
        mov     x8, #64                         // mov 64 in x8
        ldr     x1,=szBuf                       // load address into x1
        mov     x2, #BUFFER                     // strlength of text + 1 for CR
        svc     0                               // service call


last:           // branch label

//      mov X8, #57 // Service code 57
  //    svc 0 // Call Linux to terminate

      // Setup the parameters to exit the program
      // and then call linux to do it.

	//==================================traverse==================================
// Pre-Requisite:
// HeadPtr points to either nullptr or a valid address
traverse:
    // Additional, we have preserve the LR due to BL MALLOC
    //STR    X19, [SP, #-16]!        // PUSH X19
    STR    X30, [SP, #-16]!        // PUSH LR
    //MOV    X20,X20		//load headPtr into x20

traverse_top:
	LDR    X20,[X20]	//deref =headptr

	CMP    X20,#0                        // Checking for empty list
	BEQ    end				//jump to end if empty
		//STR   X20, [SP,#-16]!

	LDR    X0,[X20]                    //derefrence, Load string of ptr into x0
	MOV    X1,X0			  //load string into x1

	BL	String_length
	MOV	X2,X0			//Move string length into x2
	//ADD	x1,x1,#1		//
	//MOV	X1,#0

	LDR    X0,=iFD                    //load file descriptor
    	//MOV    X0,X9

	MOV X8, #64
//	MOV X2, #BUFFER
	SVC 0


   //LDR    X20,[SP],#16

    ADD    X20,X20,#8                    // Jump the X1 -> next field
    B        traverse_top

//==================================traverse==================================


end:

	mov	x8,#57
	ldr	x0,=iFD
	ldrb	w0,[x0]
	svc	0

	ldr	x30,[sp],#16

   ldp   x29, x30, [sp], #16     // Pop x29 and x30, then move SP up 16 bytes
   ldp   x27, x28, [sp], #16     // Pop x27 and x28, then move SP up 16 bytes  
   ldp   x25, x26, [sp], #16     // Pop x25 and x26, then move SP up 16 bytes
   ldp   x23, x24, [sp], #16     // Pop x23 and x24, then move SP up 16 bytes
   ldp   x21, x22, [sp], #16     // Pop x21 and x22, then move SP up 16 bytes
   ldp   x19, x20, [sp], #16     // Pop x19 and x20, then move SP up 16 bytes

   RET                           // Return to caller

   .end
