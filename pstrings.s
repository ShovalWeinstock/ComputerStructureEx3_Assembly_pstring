# 209540731 Shoval Weinstock

        .file "pstrings.s"

        .data
        .section  .rodata

invalid_input: .string "invalid input!\n"

        .text

        .global pstrlen
	    .type  pstrlen, @function

pstrlen:
# rdi = pstr

    pushq   %rbp
    movq    %rsp, %rbp

    movzbq    (%rdi), %rax           # rax = pstring[0] (the length of the pstring)

    movq    %rbp,  %rsp
    popq    %rbp
    ret


        .global replaceChar
        .type  replaceChar, @function

replaceChar:
# rdi = pstr, %rsi = oldChar, %rdx = newChar

    pushq    %rbp
    movq     %rsp, %rbp

    leaq    (%rdi),%r10        # backup the pstring begginig
    movzbq  (%rdi), %r9        # %r9 = the size of the pstring
    incq    %rdi               # %rdi = the beggining string of the pstring

.FOR_LOOP1:
    cmpb    (%rdi), %sil       # compare the current char with old char
    je     .REPLACE1           # if the chars are equal - replace the current char
.CONTINUE1:
    incq    %rdi               # %rdi = the the next char in the string
    subq    $1,%r9             # next iteration
    jns    .FOR_LOOP1
    jmp    .END_LOOP1

.REPLACE1:
    movb   %dl, (%rdi)        # replace current char with new char
    jmp   .CONTINUE1

.END_LOOP1:
    movq    %r10, %rax
    movq    %rbp,  %rsp
    popq    %rbp
    ret


  .global pstrijcpy
  .type pstrijcpy @function

pstrijcpy:
# rdi = *dst (pstr1), %rsi = *src (pstr2), %rdx = i (start index), %rcx = j (end index)

    pushq    %rbp
    movq     %rsp, %rbp
    pushq    %r12                       # will be used to backup dst pstring beggining

    movzbq    (%rdi), %r9               # r9 = the length of the pstring1
    cmpq      %r9, %rdx                 # compare the lengh of pstring1 to i
    jge       .INVALID_INPUT            # if the lengh of pastring1 < i , the input is invalid
    cmpq      %r9, %rcx                 # compare the lengh of pstring1 to j
    jge       .INVALID_INPUT            # if the lengh of pastring1 < j , the input is invalid

    movzbq    (%rsi), %r9               # r9 = the length of the pstring2
    cmpq      %r9, %rdx                 # compare the lengh of pstring2 to i
    jge       .INVALID_INPUT            # if the lengh of pastring2 < i , the input is invalid
    cmpq      %r9, %rcx                 # compare the lengh of pstring2 to j
    jge       .INVALID_INPUT            # if the lengh of pastring2 < j , the input is invalid

    leaq    (%rdi),%r12                 # backup the dest pstring begginig

    incq    %rdi                        # %rdi = the beggining of the string of dst pstring
    incq    %rsi                        # %rsi = the beggining of the string of src pstring

    leaq    (%rdi,%rdx), %rdi           # %rdi = dst pstring from index i
    leaq    (%rsi,%rdx), %rsi           # %rsi = src pstring from index i

.FOR_LOOP2:
    movzbq  (%rsi),%r8                  # r8 = the current char of src pstring
    movb    %r8b, (%rdi)                # replace the current char of dst pstring with the current char of src pstring
    incq    %rdi                        # %rdi = the the next char in the dst pstring
    incq    %rsi                        # %rsi = the the next char in the src pstring
    incq    %rdx                        # next iteration
    cmpq    %rcx, %rdx
    jle     .FOR_LOOP2
    jmp     .END_LOOP2

.END_LOOP2:
    movq    %r12, %rax
    popq    %r12
    movq    %rbp,  %rsp
    popq    %rbp
    ret

.INVALID_INPUT:
    movq    %rdi, %r12                  # r12 holds dst pstring with no change, befor printf overrides it
    xor     %rax, %rax
    movq    $invalid_input, %rdi
    call    printf                      # prints "invalid input!"
    jmp     .END_LOOP2



  .global swapCase
  .type swapCase @function
swapCase:
# rdi = pstr
   pushq    %rbp
   movq     %rsp, %rbp
   pushq    %r12                       # will be used to backup pstring beggining

   leaq     (%rdi),%r9                  # backup the pstring begginig
   movzbq   (%rdi),%r8                 # r8 = the length of the pstring
   incq     %rdi                        # %rdi = the beggining of the string of the pstring

   movzbq   (%rdi), %r10










.END:
    movq    %r12, %rax
    popq    %r12
    movq    %rbp,  %rsp
    popq    %rbp
    ret



  #setup
  push  %rbp
  movq  %rsp,%rbp
  push  %r12
  push  %r13
  push  %r14
  push  %r15
  # moving data to registers (calle saver - will resotre in the end)
  movq  %rdi, %r12 #%r12 = str
  movzbq (%r12), %r13  #%r13 = str->len
  addq  $1, %r12  #moving r12 one address forward
  xor   %r14, %r14 # int i = 0
  jmp .cmp_loop

.a_case:
  movzbq (%r12), %rax #%rax = current char in src str
  cmpq   $97, %rax #checking if char is bigger case
  jge    .z_case #if ascii is bigger than 97 ('a' = 97) check if smaller than 122('z'= 122)
  cmpq   $90, %rax #if ascii is not bigger than 97. check if smaller than 90 ('Z' = 90)
  jle    .A_case  #if smaller than 90, check if bigger than 65 ('A' = 65)
  jg     .incq_i

.z_case:
  cmpq  $122, %rax #if ascii bigger than 123 not a letter in english, increase i, and continue loop
  jge   .incq_i
  subq  $32, %rax  #else, lower case - converting char to bigger case
  movb  %al, (%r12) # swapping to bigger case in char
  jmp   .incq_i #increase i

.A_case:
  cmpq  $65, %rax #if ascii less than 64 not a letter in english, increase i, and continue
  jl    .incq_i
  addq  $32, %rax     #else, bigger case - converting char to lower case
  movb  %al, (%r12) # swapping char in str to lower case
  jmp  .incq_i

.incq_i:
  addq  $1, %r14 # increas i - i++
  incq  %r12     #moving r12 one address forward to next char

.cmp_loop:
  cmp   %r14, %r13 # checking if str->len > i
  ja    .a_case
  #return r12 to original address and putting it in rax
  subq  %r13, %r12
  subq  $1, %r12
  movq  %r12, %rax #retrun *dst str
  #finish
  pop   %r15
  pop   %r14
  pop   %r13
  pop   %r12
  movq  %rbp, %rsp
  pop   %rbp
  retq








