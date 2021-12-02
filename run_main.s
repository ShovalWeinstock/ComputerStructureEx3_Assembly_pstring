# 209540731 Shoval Weinstock

  .data

  .section  .rodata

format_d: .string " %d"
format_s: .string " %s"

  .text

  .globl run_main
  .type run_main, @function

run_main:
    subq    $32,%rsp                # allocating space todo 16??????????????
    pushq   %r12                    # will be used as pstring1 (before and after the change)
    pushq   %r13                    # will be used as pstring2 (before and after the change)
    pushq   %r14                    # will be used as oldChar
    pushq   %r15                    # will be used as newChar

    movq    $format_d, %rdi         # pass "%d" as the first argument of scanf
    leaq    -32(%rbp), %rsi         # save the scanned value (i) in %rbp-16
    xor     %rax, %rax
    call    scanf                   # scan "i"
    movzbq  -32(%rbp), %r14         # backup "i" in %r14
