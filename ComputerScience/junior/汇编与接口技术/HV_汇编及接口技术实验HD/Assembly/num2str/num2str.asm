;数字转字符串子程序
    .model small
    .data
mthnum  dw      12
mthstr  db      5 dup(?)
tbl     dw      2 dup(?)
    .code
main    proc    far
begin:  mov     ax, @data
        mov     ds, ax
        mov     tbl,offset mthnum
        mov     tbl+2,offset mthstr
        mov     bx, offset tbl
        call    num2str
        mov     ax, 4c00h
        int     21h
main    endp
;短除法数字转字符串（反向）
;使用 ax dx cx si
;params num[tbl]
;ret    str[tbl+2]
num2str proc    near
        push    ax;低16位
        push    dx;高16位
        push    cx;除数
        push    si;中继 作为偏移量存str用
        mov     si, [bx];num的EA
        mov     ax, [si];num内容（num）送ax
        mov     cx, 10;除数为10
        mov     si, 0;si清零，用于字符串偏移
rediv:  mov     dx, 0;高16位为0
        div     cx;dx_ax/cx=ax...dx
        add     dx, 0030h;余数转为字符串
        push    bx;暂存bx
        mov     bx, [bx+2];将目前字符的EA送bx
        mov     [bx+si],dl;dx低位送str[si]，高位为0
        pop     bx;恢复bx
        inc     si;偏移量加一
        cmp     ax, 0
        jnz     rediv;如果商不为0则继续除
        pop     si
        pop     cx
        pop     dx
        pop     ax
        ret
num2str endp
    end begin