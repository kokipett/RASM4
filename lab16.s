.global _main

    .equ    NODE_SIZE,    16

    .data
str1:  .asciz "The Cat in the Hat\n"
str2:  .asciz "\n"
str3:  .asciz  "By Dr. Seuss\n"
str4:  .asciz  "\n"
str5:  .asciz "The sun did not shine.\n"
headPtr:  .quad  0                        // Head of the linked list
tailPtr:  .quad  0                        // Tail of the linked list

chLF:            .byte 0x0a                    // New line character

newNodePtr:        .quad 0                    // Used for creating a new node
currentPtr:        .quad 0                    // Used for traversing the linked list

    .text
_main:

    // Step 0: Create the newNodePtr
    MOV    X0, NODE_SIZE
    BL        malloc            // Attempt to get block of 16 bytes from the heap

    LDR    X1,= newNodePtr
    STR    X0,[X1]                // Store into newNodePtr memory from malloc

    // Step 1: Get some memory from malloc for str1
    //           Copy str1 into the newly malloc'd memory
    ldr    X0,=str1
    BL        String_copy

    LDR    X1,= newNodePtr    // Reload the newNodePtr
    LDR    X1,[X1]                // X1 contains the address of our NODE

    STR    X0,[X1]                // 

    // Step 2: Insert newNode into an Empty Linked List
    LDR    X1,= newNodePtr
    LDR    X1,[X1]                // Get the addres of the newNode

    LDR    X0,= headPtr
    STR    X1,[X0]                // headPtr = newNodePtr

    LDR    X0,= tailPtr
    STR    X1,[X0]                // tailPtr = newNodePtr
// CODE for the 2nd String //
    // Step 0: Create the newNodePtr
    MOV    X0, NODE_SIZE
    BL        malloc            // Attempt to get block of 16 bytes from the heap

    LDR    X1,= newNodePtr    // Save the address of the newNode
    STR    X0,[X1]                // Store into newNodePtr memory from malloc

    // Step 1: Get some memory from malloc for str1
    //           Copy str1 into the newly malloc'd memory
    ldr    X0,=str2
    BL        String_copy

    LDR    X1,= newNodePtr    // Reload the newNodePtr
    LDR    X1,[X1]                // X1 contains the address of our NODE

    STR    X0,[X1]                // 

    // Step 2: Insert newNode into a NonEmpty Linked List
    LDR    X1,= newNodePtr
    LDR    X1,[X1]                // Get the addres of the newNode

    LDR    X0,= headPtr
    LDR    X0,[X0]                // X0 -> Data
    ADD    X0, X0, #8            // X0 -> Next

    STR    X1,[X0]                // headPtr->next = newNodePtr

    LDR    X0,= tailPtr
    STR    X1,[X0]                // tailPtr = newNodePtr

    // CODE for the 3rd String //

    // Step 0: Create the newNodePtr
    MOV    X0, NODE_SIZE
    BL        malloc            // Attempt to get block of 16 bytes from the heap

    LDR    X1,= newNodePtr    // Save the address of the newNode
    STR    X0,[X1]                // Store into newNodePtr memory from malloc

    // Step 1: Get some memory from malloc for str1
    //           Copy str1 into the newly malloc'd memory
    ldr    X0,=str3
    BL        String_copy

    LDR    X1,= newNodePtr    // Reload the newNodePtr
    LDR    X1,[X1]                // X1 contains the address of our NODE

    STR    X0,[X1]                // 

    // Step 2: Insert newNode into a NonEmpty Linked List
    LDR    X1,= newNodePtr
    LDR    X1,[X1]                // Get the addres of the newNode

    LDR    X0,= headPtr
    LDR    X0,[X0]                // X0 -> Data
    ADD    X0, X0, #8            // X0 -> Next

    STR    X1,[X0]                // headPtr->next = newNodePtr

    LDR    X0,= tailPtr
    STR    X1,[X0]                // tailPtr = newNodePtr

    BL        traverse
exit_sequence:
    //===== EXIT =====/
    mov    X0, #0
    mov    X8, #93
    svc    0

// Pre-Requisite:
// HeadPtr points to either nullptr or a valid address
traverse:
    // Additional, we have preserve the LR due to BL MALLOC
    STR    X19, [SP, #-16]!        // PUSH X19
    STR    X30, [SP, #-16]!        // PUSH LR
    LDR    X19,=headPtr

traverse_top:
    LDR    X19,[X19]

    CMP    X19,#0                        // Checking for empty list
    BEQ    traverse_exit

    LDR    X0,[X19]                    // Double de-reference
    BL        putstring

    ADD    X19,X19,#8                    // Jump the X1 -> next field
    B        traverse_top

traverse_exit:
    LDR    X30,[SP], #16       	     // POP LR
    LDR    X19,[SP], #16            // POP LR
    RET    LR

    .end
