;内存字节逆序函数
    .model small
    .data
str     db      "21","$"
len     db      2h
tbl     dw      2 dup(?)
    .code
main    proc    far
begin:  mov     ax, @data
        mov     ds, ax
        mov     tbl,offset str
        mov     tbl+2,offset len
        mov     bx, offset tbl
        call    reverse
        mov     ax, 4c00h
        int     21h
main    endp
;内存字节逆序函数
;使用 si ax di dx cx
;params str[tbl]
;       length[tbl+2]
reverse proc    near
        push    si
        push    ax
        push    di
        push    dx
        push    cx
        mov     di, [bx+2];len EA
        mov     di, [di];di存len
        and     di, 00ffh;高位清零
        mov     dx, di;保存len副本
        mov     si, [bx];str EA
nxtch:  mov     ax, [si]
        and     ax, 00ffh
        push    ax
        inc     si;偏移量向后
        dec     di;计数器减一
        jnz     nxtch;入果计数器不是0，则下一字节
        ;如果计数器为0
popnxt: pop     cx;将入栈的字节出栈
        push    bx;暂存bx
        mov     bx, [bx]
        mov     [bx+di],cl;将入栈的几个pop回原地址（反向）
        pop     bx;恢复bx
        inc     di
        cmp     dx, di;判断di是否回到len值
        jnz     popnxt;没回到就继续
        pop     cx
        pop     dx
        pop     di
        pop     ax
        pop     si
        ret
reverse endp
    end begin