;闰年判断子程序
    .model small
    .data
year    dw      2021
isleap  db      0;1是2不是
tbl     dw      2 dup(?)

    .code
main    proc    far
begin:  mov     ax, @data
        mov     ds, ax
        mov     tbl,offset year
        mov     tbl+2,  offset isleap
        mov     bx, offset tbl
        call    judleap
        mov     ax, 4c00h
        int     21h
main    endp
;判断闰年子程序
;使用 si ax cx dx di
;params year[tbl]
;ret    isleap[tbl+2]
judleap proc    near
        push    si
        push    ax
        push    cx
        push    dx
        push    di
        ;数据准备
        mov     si, [bx];year EA送si
        mov     ax, [si];以si内容为EA的内存内容（year）送ax，用作除法
        mov     cx, ax;备份年份，因为ax会被改掉
        mov     dx, 0;被除数dx_ax是32位，此处dx为0
        ;判断能否被100整除
        mov     di, 100;di用于存储除数
        div     di
        cmp     dx, 0;判断余数是否为0
        jnz     jud4;如果不能被100整除则判断能否被4整除
        ;判断能否被400整除
        mov     ax, cx;将年份从cx恢复
        mov     dx, 0;恢复dx为0（虽然此处一定为0，但保险）
        mov     di, 400
        div     di
        cmp     dx, 0
        jz      islp;如果能被400整除则跳转至是闰年islp
        jmp     isnlp;其余的不是闰年跳转至非闰年isnlp
        ;判断能否被4整除
jud4:   mov     ax, cx;将年份从cx恢复
        mov     dx, 0;恢复dx为0
        mov     di, 4
        div     di
        cmp     dx, 0
        jnz     isnlp;如果不能被4整除则不是闰年，是闰年的不用判断走下一步
islp:   mov     di, [bx+2]
        mov     byte ptr [di],1h
        jmp     judok
isnlp:  mov     di, [bx+2]
        mov     byte ptr [di],2h;如果不是的直接写入2走下一步不用跳转
judok:  pop     di
        pop     dx
        pop     cx
        pop     ax
        pop     si
        ret
judleap endp
    end begin