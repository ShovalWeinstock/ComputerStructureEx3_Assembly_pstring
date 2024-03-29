
        .file "func_select.s"

        .section  .rodata

format_d: .string " %d"
format_s: .string " %s"
format_c: .string " %c"
L5060_str: .string "first pstring length: %d, second pstring length: %d\n"
L52_str: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
L53_54_str: .string "length: %d, string: %s\n"
L55_str: .string "compare result: %d\n"
DEF_str: .string "invalid option!\n"

.align 8
.MENU:
    .quad .L5060                     # print length
    .quad .DEF                       # default
    .quad .L52                       # replace char
    .quad .L53                       # pstr ij copy
    .quad .L54                       # swap case
    .quad .L55                       # pstr ij compare

        .text

        .globl run_func
        .type run_func, @function

run_func:
    pushq   %rbp
    movq    %rsp, %rbp
    leaq    -50(%rdi),%r8            # rdi = x (input). rsi = x - 50
    cmpq    $10,%r8
    je      .L5060                   # if x - 50 = 10  -> x = 60 -> go to L5060
    cmpq    $5,%r8
    jg      .DEF                     # if x - 50 > 10, go to default
    cmpq    $0,%r8
    jl      .DEF                     # if x - 50 < 0, go to default
    jmp *.MENU(,%r8,8)               # else- go to MENU + 8*(x-50)

# case 50 / 60
.L5060:
    movq    %rsi, %rdi               # pass pstring1 as the first argument to "pstrlen"
    call    pstrlen
    movq    %rax, %rsi               # pass the result of pstrlen for pstring1, as the second argument to "printf"
    movq    %rdx, %rdi               # pass pstring2 as the first argument to "pstrlen"
    call    pstrlen
    movq    %rax, %rdx               # pass the result of pstrlen for pstring2, as the third argument to "printf"
    movq    $L5060_str, %rdi         # pass L5060_str as the first argument to "printf"
    xor     %rax, %rax
    call    printf                   # prints: "first pstring length: _, second pstring length: _\n"
    jmp     .END

# case 52
  .L52:
      subq    $16,%rsp               # allocating space
      pushq   %r12                   # will be used as pstring1 (before and after the change)
      pushq   %r13                   # will be used as pstring2 (before and after the change)
      pushq   %r14                   # will be used as oldChar
      pushq   %r15                   # will be used as newChar

      movq    %rsi, %r12             # backup pstring1 in r12
      movq    %rdx, %r13             # backup pstring2 in r13

      movq    $format_c, %rdi        # pass "%c" as the first argument of scanf
      leaq    -16(%rbp), %rsi        # save the scanned value (oldChar) in %rbp-8
      xor     %rax, %rax
      call    scanf                  # scan "oldChar"
      movzbq  -16(%rbp), %r14        # backup "oldChar" in %r14

      movq    $format_c, %rdi        # pass "%c" as the first argument of scanf
      leaq    -8(%rbp), %rsi         # save the scanned value (newChar) in %rbp-16
      xor     %rax, %rax
      call    scanf                  # scan "newChar"
      movzbq  -8(%rbp), %r15         # backup "newChar" in %r15

      movq    %r12, %rdi             # pass pstring1 as the first argument for "replaceChar"
      movq    %r14, %rsi             # pass oldChar as the second argument for "replaceChar"
      movq    %r15, %rdx             # pass newChar as the third argument for "replaceChar"
      call    replaceChar
      movq    %rax, %r12             # backup the result (pstring1 after the change) in r12

      movq    %r13, %rdi             # pass pstring2 as the first argument for "replaceChar"
      movq    %r14, %rsi             # pass oldChar as the second argument for "replaceChar"
      movq    %r15, %rdx             # pass newChar as the third argument for "replaceChar"
      call    replaceChar
      movq    %rax, %r13             # backup the result (pstring2 after the change) in r13

      movq    $L52_str, %rdi         # send parameters to printf
      movq    %r14, %rsi
      movq    %r15, %rdx
      leaq    1(%r12), %rcx
      leaq    1(%r13), %r8
      xor     %rax, %rax
      call    printf                 # prints "old char: _, new char: _, first string: _, second string: _\n"

      popq    %r15                   # pop callee save registers
      popq    %r14
      popq    %r13
      popq    %r12
      jmp  .END

# case 53
.L53:
     subq    $16,%rsp                # allocating space
     pushq   %r12                    # will be used as pstring1 (before and after the change)
     pushq   %r13                    # will be used as pstring2 (before and after the change)
     pushq   %r14                    # will be used as i (beggining index)
     pushq   %r15                    # will be used as j (end index)

     movq    %rsi, %r12              # backup pstring1 in r12
     movq    %rdx, %r13              # backup pstring2 in r13

     movq    $format_d, %rdi         # pass "%d" as the first argument of scanf
     leaq    -16(%rbp), %rsi         # save the scanned value (i) in %rbp-16
     xor     %rax, %rax
     call    scanf                   # scan "i"
     movzbq  -16(%rbp), %r14         # backup "i" in %r14

     movq    $format_d, %rdi         # pass "%d" as the first argument of scanf
     leaq    -8(%rbp), %rsi          # save the scanned value (j) in %rbp-8
     xor     %rax, %rax
     call    scanf                   # scan "j"
     movzbq  -8(%rbp), %r15          # backup "j" in %r15

     movq    %r12, %rdi              # pass pstring1 as the first argument for "pstrijcpy"
     movq    %r13, %rsi              # pass pstring2 as the second argument for "pstrijcpy"
     movq    %r14, %rdx              # pass i as the third argument for "pstrijcpy"
     movq    %r15, %rcx              # pass j as the forth argument for "pstrijcpy"

     call    pstrijcpy
     movq    %rax, %r12              # backup the result (pstring1 after the change) in r12

     movq    $L53_54_str, %rdi
     movzbq  (%r12), %r9             # r9 = the length of psring1
     movq     %r9, %rsi
     leaq    1(%r12), %rdx
     xor     %rax, %rax
     call    printf                  # prints "length: _, string: _\n" for pstring1

     movq    $L53_54_str, %rdi
     movzbq  (%r13), %r9             # r9 = the length of psring1
     movq     %r9, %rsi
     leaq    1(%r13), %rdx
     xor     %rax, %rax
     call    printf                  # prints "length: _, string: _\n" for pstring2

     popq    %r15                    # pop callee save registers
     popq    %r14
     popq    %r13
     popq    %r12
     jmp     .END

# case 54
.L54:
    pushq   %r12                     # will be used as pstring1 (before and after the change)
    pushq   %r13                     # will be used as pstring2 (before and after the change)

    movq    %rsi, %r12               # backup pstring1 in r12
    movq    %rdx, %r13               # backup pstring2 in r13

    movq    %r12, %rdi               # pass pstring1 as the first argument for "swapCase"
    call    swapCase
    movq    %rax, %r12               # backup the result (pstring1 after the change) in r12

    movq    %r13, %rdi               # pass pstring2 as the first argument for "swapCase"
    call    swapCase
    movq    %rax, %r13               # backup the result (pstring2 after the change) in r12

    movq    $L53_54_str, %rdi
    movzbq  (%r12), %r9              # r9 = the length of psring1
    movq     %r9, %rsi
    leaq    1(%r12), %rdx
    xor     %rax, %rax
    call    printf                   # prints "length: _, string: _\n" for pstring1

    movq    $L53_54_str, %rdi
    movzbq  (%r13), %r9              # r9 = the length of psring1
    movq     %r9, %rsi
    leaq    1(%r13), %rdx
    xor     %rax, %rax
    call    printf                   # prints "length: _, string: _\n" for pstring2

    popq    %r13                     # pop callee save registers
    popq    %r12
    jmp     .END


# case 55
.L55:
     subq    $16,%rsp                # allocating space
     pushq   %r12                    # will be used as pstring1 (before and after the change)
     pushq   %r13                    # will be used as pstring2 (before and after the change)
     pushq   %r14                    # will be used as i (beggining index)
     pushq   %r15                    # will be used as j (end index)

     movq    %rsi, %r12              # backup pstring1 in r12
     movq    %rdx, %r13              # backup pstring2 in r13

     movq    $format_d, %rdi         # pass "%d" as the first argument of scanf
     leaq    -16(%rbp), %rsi         # save the scanned value (i) in %rbp-16
     xor     %rax, %rax
     call    scanf                   # scan "i"
     movzbq  -16(%rbp), %r14         # backup "i" in %r14

     movq    $format_d, %rdi         # pass "%d" as the first argument of scanf
     leaq    -8(%rbp), %rsi          # save the scanned value (j) in %rbp-8
     xor     %rax, %rax
     call    scanf                   # scan "j"
     movzbq  -8(%rbp), %r15          # backup "j" in %r15

     movq    %r12, %rdi              # pass pstring1 as the first argument for "pstrijcmp"
     movq    %r13, %rsi              # pass pstring2 as the second argument for "pstrijcmp"
     movq    %r14, %rdx              # pass i as the third argument for "pstrijcmp"
     movq    %r15, %rcx              # pass j as the forth argument for "pstrijcmp"

     call    pstrijcmp
     movq    %rax, %rsi              # backup the result
     movq    $L55_str, %rdi
     xor     %rax, %rax
     call    printf

     popq    %r15                    # pop callee save registers
     popq    %r14
     popq    %r13
     popq    %r12
     jmp     .END

# default case
.DEF:
     movq    $DEF_str, %rdi
     xor     %rax, %rax
     call    printf                 # prints "invalid option!\n"

.END:
    movq    %rbp,  %rsp
    popq    %rbp
    xorq    %rax, %rax
    ret
