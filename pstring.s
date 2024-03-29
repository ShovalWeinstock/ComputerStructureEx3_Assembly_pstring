
        .file "pstrings.s"

        .data
        .section  .rodata

invalid_input: .string "invalid input!\n"

        .text

        .global pstrlen
	    .type  pstrlen, @function

pstrlen:
# rdi = pstr
# returns the size of the pstring

    pushq   %rbp
    movq    %rsp, %rbp

    movzbq    (%rdi), %rax            # rax = pstring[0] (the length of the pstring)

    movq    %rbp,  %rsp
    popq    %rbp
    ret


        .global replaceChar
        .type  replaceChar, @function

replaceChar:
# rdi = pstr, %rsi = oldChar, %rdx = newChar
# returns pstr, after replacing oldChar with newChar

    pushq    %rbp
    movq     %rsp, %rbp

    leaq    (%rdi),%r10            	 # backup the pstring begginig
    movzbq  (%rdi), %r9           	 # %r9 = the size of the pstring
    incq    %rdi                     # %rdi = the beggining string of the pstring

.FOR_LOOP1:
    cmpb    (%rdi), %sil           	 # compare the current char with old char
    je     .REPLACE1               	 # if the chars are equal - replace the current char
.CONTINUE1:
    incq    %rdi                  	 # %rdi = the the next char in the string
    subq    $1,%r9                	 # next iteration
    jns    .FOR_LOOP1
    jmp    .END_LOOP1

.REPLACE1:
    movb   %dl, (%rdi)           	 # replace current char with new char
    jmp   .CONTINUE1

.END_LOOP1:
    movq    %r10, %rax             	 # return r10 (the pstring)
    movq    %rbp,  %rsp
    popq    %rbp
    ret


        .global pstrijcpy
        .type pstrijcpy @function

pstrijcpy:
# rdi = dst (pstr1), %rsi = src (pstr2), %rdx = i (start index), %rcx = j (end index)
# inserts src from index i to index j, into dst from index i to index j. returns dst.

    pushq    %rbp
    movq     %rsp, %rbp
    pushq    %r12                       # will be used to backup dst pstring beggining

    movzbq    (%rdi), %r9               # r9 = the length of the pstring1
    cmpq      %r9, %rdx                 # compare the lengh of pstring1 to i
    jge       .INVALID_INPUT2           # if the length of pastring1 < i , the input is invalid
    cmpq      %r9, %rcx                 # compare the lengh of pstring1 to j
    jge       .INVALID_INPUT2           # if the length of pastring1 < j , the input is invalid

    movzbq    (%rsi), %r9               # r9 = the length of the pstring2
    cmpq      %r9, %rdx                 # compare the lengh of pstring2 to i
    jge       .INVALID_INPUT2           # if the lengh of pastring2 < i , the input is invalid
    cmpq      %r9, %rcx                 # compare the lengh of pstring2 to j
    jge       .INVALID_INPUT2           # if the lengh of pastring2 < j , the input is invalid

    leaq    (%rdi),%r12                 # backup the dest pstring begginig

    incq    %rdi                        # %rdi = the beggining of the string of dst pstring
    incq    %rsi                        # %rsi = the beggining of the string of src pstring

    leaq    (%rdi,%rdx), %rdi           # %rdi = dst pstring from index i
    leaq    (%rsi,%rdx), %rsi           # %rsi = src pstring from index i

.FOR_LOOP2:
    movzbq  (%rsi),%r8                  # r8 = the current char of src pstring
    movb    %r8b, (%rdi)                # replace the current char of dst pstring with the current char of src pstring
    incq    %rdi                        # %rdi = the next char in the dst pstring
    incq    %rsi                        # %rsi = the next char in the src pstring
    incq    %rdx                        # next iteration
    cmpq    %rcx, %rdx
    jle     .FOR_LOOP2
    jmp     .END_LOOP2

.END_LOOP2:
    movq    %r12, %rax                  # return r12 (dst)
    popq    %r12
    movq    %rbp,  %rsp
    popq    %rbp
    ret

.INVALID_INPUT2:
    movq    %rdi, %r12                  # r12 holds dst pstring with no change
    xor     %rax, %rax
    movq    $invalid_input, %rdi
    call    printf                      # prints "invalid input!"
    jmp     .END_LOOP2


        .global swapCase
        .type swapCase @function

swapCase:
# rdi = pstr
# replaces lower case letters to upper case, and upper case letters to lower case

   pushq    %rbp
   movq     %rsp, %rbp

   leaq     (%rdi), %rax                # backup the pstring begginig (this will be the returned value)
   movzbq   (%rdi), %r8                 # r8 = the length of the pstring
   incq     %rdi                        # %rdi = the beggining of the string of the pstring

.FOR_LOOP3:
   movzbq   (%rdi), %r10                # %r10 = the current char of the pstring
   cmpq     $97, %r10                   # check if the char ASCII value >= 97
   jge     .CHECK_LOWER_CASE
   cmpq     $65, %r10                   # check if the char ASCII value >= 65
   jge     .CHECK_UPPER_CASE
   jmp     .NEXT_ITER

.CHECK_LOWER_CASE:
   cmpq     $122, %r10                  # check if the char ASCII value <= 122
   jle      .IS_LOWER_CASE
   jmp      .NEXT_ITER

.IS_LOWER_CASE:
    subq    $32, %r10                   # lower case to upper case
    movb    %r10b, (%rdi)
    jmp     .NEXT_ITER

.CHECK_UPPER_CASE:
    cmpq     $90, %r10                  # check if the char ASCII value <= 90
    jle      .IS_UPPER_CASE
    jmp      .NEXT_ITER

.IS_UPPER_CASE:
    addq    $32, %r10                   # upper case to lower case
    movb    %r10b, (%rdi)
    jmp     .NEXT_ITER

.NEXT_ITER:
    subq   $1, %r8                      # "i++"
    cmpq   $0, %r8                      # check if there are no iterations left
    je     .END_LOOP3
    incq   %rdi                         # if there is iteration left - move to the next char
    jmp    .FOR_LOOP3

.END_LOOP3:
    movq    %rbp,  %rsp
    popq    %rbp
    ret


      .global pstrijcmp
      .type pstrijcmp @function

pstrijcmp:
# rdi = pstr1, %rsi = pstr2, %rdx = i (start index), %rcx = j (end index)
# copmares lexicografically between pstr1 to pstr2, from index i to index j.
# returns 1 if pstr1>pstr2, -1 if pstr2>pstr1, 0 if they are equal, and -2 in case of invalid input

    pushq    %rbp
    movq     %rsp, %rbp
    pushq    %r12                       # will be used to backup dst pstring beggining

    movzbq    (%rdi), %r9               # r9 = the length of the pstring1
    cmpq      %r9, %rdx                 # compare the lengh of pstring1 to i
    jge       .INVALID_INPUT4           # if the lengh of pastring1 < i , the input is invalid
    cmpq      %r9, %rcx                 # compare the lengh of pstring1 to j
    jge       .INVALID_INPUT4           # if the lengh of pastring1 < j , the input is invalid

    movzbq    (%rsi), %r9               # r9 = the length of the pstring2
    cmpq      %r9, %rdx                 # compare the lengh of pstring2 to i
    jge       .INVALID_INPUT4           # if the lengh of pastring2 < i , the input is invalid
    cmpq      %r9, %rcx                 # compare the lengh of pstring2 to j
    jge       .INVALID_INPUT4           # if the lengh of pastring2 < j , the input is invalid

    incq    %rdi                        # %rdi = the beggining of the string of dst pstring
    incq    %rsi                        # %rsi = the beggining of the string of src pstring

    leaq    (%rdi,%rdx), %rdi           # %rdi = dst pstring from index i
    leaq    (%rsi,%rdx), %rsi           # %rsi = src pstring from index i

.FOR_LOOP4:
    movzbq  (%rdi), %r8                 # r8 = the current char of pstring1
    movzbq  (%rsi), %r9                 # r9 = the current char of pstring2
    cmpq    %r8, %r9
    jl      .PSTR1_GREATER
    jg      .PSTR2_GREATER
    incq    %rdi                        # %rdi = the next char in the dst pstring
    incq    %rsi                        # %rsi = the next char in the src pstring
    incq    %rdx                        # next iteration
    cmpq    %rcx, %rdx
    jle     .FOR_LOOP4
    movq    $0, %rax
    jmp     .END_LOOP4

.PSTR1_GREATER:
    movq    $1, %rax                    # return 1
    jmp     .END_LOOP4

.PSTR2_GREATER:
    movq    $-1, %rax                   # return -1
    jmp     .END_LOOP4

.END_LOOP4:
    movq    %rbp,  %rsp
    popq    %rbp
    ret

.INVALID_INPUT4:
    xor     %rax, %rax
    movq    $invalid_input, %rdi
    call    printf                      # prints "invalid input!"
    movq    $-2, %rax                   # return -2
    jmp     .END_LOOP4






