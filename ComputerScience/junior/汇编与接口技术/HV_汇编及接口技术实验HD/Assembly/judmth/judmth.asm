;天数转日期测试
    .model small
    .data
mthwarn db      'Overflow of days','$'      ;输入天数警告字符串（保险起见）
mth     dw      31                          ;平年
        dw      28                          ;如果闰年就加一
        dw      31
        dw      30
        dw      31
        dw      30
        dw      31
        dw      31
        dw      30
        dw      31
        dw      30
        dw      31
daynum  dw      364                         ;天数字
mthnum  dw      ?                           ;月份数字
datenum dw      ?                           ;日期数字

    .code
main    proc    far
begin:  mov     ax, @data
        mov     ds, ax
        mov     cx, daynum;将天数转存到cx
        mov     si, 0;第一次偏移量为0
calc:   cmp     cx, mth[si];比较剩余天数和本月日期
        jbe     current;小于等于就是当月
        sub     cx, mth[si];不是当月就减去这个月
        inc     si
        inc     si;si加2（下一月dw）
        cmp     si, 24;如果是13月（0-11 12*2）
        jz      mwarn;如果超出月份跳转输出警告
        jnz     calc;如果没超出继续计算
current:mov     datenum,cx;保存日期
        inc     si
        inc     si;si+2下标修正为序数(*2)
        mov     dx, 0;除法准备（被除数高16位）
        mov     ax, si;除法准备（被除数低16位）
        mov     bx, 2h;除法准备（除数为2）
        div     bx;dx_ax/2=ax...dx
        mov     mthnum, ax;保存月份
        jmp     ok
mwarn:  mov     dx, offset mthwarn          ;提示天数超出警告
        mov     ah, 09h
        int     21h
        jmp     ok
ok:     mov     ax, 4c00h
        int     21h
main    endp
    end begin