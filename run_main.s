# 209540731 Shoval Weinstock

  .data

  .section  .rodata

format_d: .string " %d"
format_s: .string " %s"
str_end: .string "%s"


  .text

  .globl run_main
  .type run_main, @function

run_main:
    pushq   %rbp
    movq    %rsp, %rbp

    subq    $528,%rsp           # allocating 4 bytes for opt + (256 + 4) bytes for each pstring and its size + 4 to align
    pushq   %r12               # will be used as pstring1 (before and after the change)
    pushq   %r13               # will be used as pstring2 (before and after the change)

    movq    $format_d, %rdi    # pass "%d" as the first argument of scanf
    leaq    -528(%rbp), %rsi    # save the scanned value (the size of str1)
    xor     %rax, %rax
    call    scanf              # scan the size of str1
    movq    -528(%rbp), %r9 #extracting lenght from -536(%rbp)
    movb   %r9b, -528(%rbp)

    movq    $format_s, %rdi    # pass "%s" as the first argument of scanf
    leaq    -527(%rbp), %rsi    # save the scanned value (str1)
    xor     %rax, %rax
    call    scanf              # scan "str1"

    movq    $format_d, %rdi    # pass "%d" as the first argument of scanf
    leaq    -271(%rbp), %rsi    # save the scanned value (the size of str2)
    xor     %rax, %rax
    call    scanf              # scan the size of str2
    movq    -271(%rbp), %r9 #extracting lenght from -536(%rbp)
    movb   %r9b, -271(%rbp)

    movq    $format_s, %rdi    # pass "%s" as the first argument of scanf
    leaq    -272(%rbp), %rsi    # save the scanned value (str2)
    xor     %rax, %rax
    call    scanf              # scan "str2"

    movq    $format_d, %rdi    # pass "%d" as the first argument of scanf
    leaq    -8(%rbp), %rsi    # save the scanned value (the option in the menu)
    xor     %rax, %rax
    call    scanf              # scan the option


    #setting up for calling run_func
    leaq  -528(%rbp), %rsi
    leaq  -271(%rbp), %rdx #%rdx = &pstring2
    mov   -8(%rbp), %rdi #%rdi = opt
    call  run_func

    #popppppppp
    movq    %rbp,  %rsp
    popq    %rbp
    xorq    %rax, %rax
    ret
