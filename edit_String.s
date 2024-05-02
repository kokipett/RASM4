.global edit_String
//x0: =headptr
//x1: =index of node
//x2: =replacement string


//x25: nodeCounter
   .data
hi: .asciz "hi "
hi1: .asciz "hi1 "

hi2: .asciz "hi2 "
chLF: .byte 0x0a

dbTest:	.quad	1

	szBuf: .skip 21
	szBuf2: .skip 21

   .text
edit_String:
   stp   x19, x20, [sp, #-16]!   // Push x19 and x20, then move SP down 16 bytes
   stp   x21, x22, [sp, #-16]!   // Push x21 and x22, then move SP down 16 bytes
   stp   x23, x24, [sp, #-16]!   // Push x23 and x24, then move SP down 16 bytes
   stp   x25, x26, [sp, #-16]!   // Push x25 and x26, then move SP down 16 bytes
   stp   x27, x28, [sp, #-16]!   // Push x27 and x28, then move SP down 16 bytes
   stp   x29, x30, [sp, #-16]!   // Push x29 and x30, then move SP down 16 bytes


    traverse:
	MOV X19,#0	//move 0 into x19
	MOV X25,#1	//move 1 into 25 (counter)
	MOV X20,X0	//move &headptr into x20

    MOV X21,X1	//load index into x21
    LDR X21,[X21]//deref


    MOV X22, X2 //X22 holds ptr to replacement string
  //  LDR	X22,[x22]//load string into x22

    MOV X0, X22
    BL add_newLine
    MOV x22,x0


    traverse_top:
        LDR    X20,[X20]	//deref =headptr

        CMP    X20, #0                        // Checking for empty list
        BEQ    end				//jump to end if empty

        CMP X25, X21		//compare counter and index
        BEQ replace		//jump to replace if equal to each other

        ADD    X20,X20,#8                    // Jump the X1 -> next field
        ADD    X25,X25,#1
        B        traverse_top

    replace:

	ldr	x0,=hi1
	bl putstring

        // add new string's number of bytes
        /*MOV     X0, X22                          // load address new string
        BL      String_length

        ADD     x0, x0, #1                       // add null
	MOV	X19,X0*/

        // delete old string's address from the link list
        LDR     x0,[X20]
        BL      free

        // add the new string to the node
        MOV     X0,X22
        BL      String_copy

        STR     X0,[X20]


        b end



   end:

   ldp   x29, x30, [sp], #16     // Pop x29 and x30, then move SP up 16 bytes
   ldp   x27, x28, [sp], #16     // Pop x27 and x28, then move SP up 16 bytes  
   ldp   x25, x26, [sp], #16     // Pop x25 and x26, then move SP up 16 bytes
   ldp   x23, x24, [sp], #16     // Pop x23 and x24, then move SP up 16 bytes
   ldp   x21, x22, [sp], #16     // Pop x21 and x22, then move SP up 16 bytes
   ldp   x19, x20, [sp], #16     // Pop x19 and x20, then move SP up 16 bytes

   RET                           // Return to caller


add_newLine:

        str     x30,[sp,#-16]!
         mov     x23,#0
        mov     x24,x0                                          // Store address of string in x24

traverse_string:
        ldrb    w1,[x0,x23]                             // Load contents of string

        cmp     w1,#0                                                   // Compare the indexed byte to null
        beq     end_of_string                           // branch to end_of_string if null

        add     x23,x23,#1                                      // Add 1 to counter

        b               traverse_string                 // Loop back
end_of_string:
        mov     x2,#0
        add     x2,x0,x23                                       // Address of null into x2
        mov     w3,#0x0a                                         // Move line feed into x3

        strb    w3,[x2]                                         // Store line feed into address that has null

        add     x2,x2,#1                                                // Add 1 to the address of line feed (replaced null)

        mov     w3,#0                                                   // Move null into x3
        strb    w3,[x2]                                         // Store null into address after line feed

        mov     x2,x0
	mov	x0,x2

        ldr     x30, [sp], #16

        ret

   .end
