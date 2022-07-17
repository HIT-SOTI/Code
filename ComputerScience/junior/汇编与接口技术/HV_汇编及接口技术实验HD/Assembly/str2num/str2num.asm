;str2num子程序（秦久韶算法）
    .model small
    .data
strg    db      "2021",0dh,"$"
num     dw      ?
tbl     dw      2 dup(?)
    .code
main    proc    far
begin:  mov     ax, @data
        mov     ds, ax
        ; mov     dx, offset strg
        ; mov     ah, 09h
        ; int     21h
        mov     tbl,offset strg
        mov     tbl+2,  offset num
        mov     bx, offset tbl
        call    str2num
        mov     ax, 4c00h
        int     21h
main    endp
;秦久韶算法字符串转数字
;使用 si cx dx ax di
;params strg[tbl]
;ret    num[tbl+2]
str2num proc    near
        push    si
        push    cx
        push    dx
        push    ax
        push    di
        mov     si, 0;初始偏移量0
        sub     ax, ax;ax清零
        sub     cx, cx;cx用于暂存num值，初始化为0
        mov     dx, 10;秦久韶算法每次乘10
        mov     di, [bx+si];strg EA
lop:    mov     al, [di]
        cmp     al, 0dh;如果al为0dh（回车）
        je      final;则退出子程序
        sub     al, 30h;如果al不为0则减30h，即转化为数字
        cmp     cx, 0;如果cx(num)为0
        je      do_deal;直接跳转到相加的位置
        push    ax;保护ax
        mov     ax, cx;将之前加过的cx(num)放入ax
        mul     dx;src是dx中的值(10)，则ax(cx)*10
        mov     dx, 10;恢复dx为10
        mov     cx, ax;将乘10后的值交给cx
        pop     ax;还原ax（这一位的值）
do_deal:add     cx, ax;将ax(al)中的数加入cx(num)
        mov     ax, 0;ax清零
        inc     di;偏移加1
        jmp     lop;无条件跳转至下一位计算
final:  mov     di, [bx+2];将num的offset给di
        mov     [di],cx;cx中的值传回num
        pop     di
        pop     ax
        pop     dx
        pop     cx
        pop     si
        ret
str2num endp
    end begin
