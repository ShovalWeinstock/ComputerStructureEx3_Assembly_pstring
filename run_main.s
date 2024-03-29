# Shoval Weinstock

        .file "run_main.s"

        .section  .rodata

format_d: .string " %d"
format_s: .string " %s"
str_end: .string "\0"

        .text

        .globl run_main
        .type run_main, @function

run_main:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $528,%rsp          # allocating 4 bytes for opt + (256 + 4) bytes for each pstring and its size + align to 16

    movq    $format_d, %rdi    # pass "%d" as the first argument of scanf
    leaq    -528(%rbp), %rsi   # save the scanned value (the size of str1)
    xor     %rax, %rax
    call    scanf              # scan the size of str1
    movq    -528(%rbp), %r9
    movb    %r9b, -528(%rbp)

    movq    $format_s, %rdi    # pass "%s" as the first argument of scanf
    leaq    -527(%rbp), %rsi   # save the scanned value (str1)
    xor     %rax, %rax
    call    scanf              # scan "str1"

    movq    $format_d, %rdi    # pass "%d" as the first argument of scanf
    leaq    -271(%rbp), %rsi   # save the scanned value (the size of str2)
    xor     %rax, %rax
    call    scanf              # scan the size of str2
    movq    -271(%rbp), %r9
    movb   %r9b, -271(%rbp)

    movq    $format_s, %rdi    # pass "%s" as the first argument of scanf
    leaq    -270(%rbp), %rsi   # save the scanned value (str2)
    xor     %rax, %rax
    call    scanf              # scan "str2"

    movq    $format_d, %rdi    # pass "%d" as the first argument of scanf
    leaq    -8(%rbp), %rsi     # save the scanned value (the option in the menu)
    xor     %rax, %rax
    call    scanf              # scan the option

    movq    -8(%rbp), %rdi     # pass arguments to "run_func"
    leaq    -528(%rbp), %rsi
    leaq    -271(%rbp), %rdx
    call    run_func

    movq    %rbp,  %rsp
    popq    %rbp
    xorq    %rax, %rax
    ret

