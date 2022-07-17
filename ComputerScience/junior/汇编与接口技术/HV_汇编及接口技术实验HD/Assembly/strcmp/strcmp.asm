;strcmp子程序
    .model  small
    .data
cmprslt db      0h                           ;字符串比较结果（strcmp返回值）
cnt     db      4h
stra    db      "2789","$"                   ;参数a
strb    db      "2021","$"                   ;参数b
tbl     dw      4 dup(?)                    ;[tbl]:cmprslt [tbl+2]:stra [tbl+4]:strb
e       db      "e","$"
a       db      "a","$"
b       db      "b","$"
    .code
main    proc    far
begin:  mov     ax, @data
        mov     ds, ax                  ;装数据段
        mov     tbl,    offset cmprslt  ;送参数指针于地址表
        mov     tbl+2,  offset stra
        mov     tbl+4,  offset strb
        mov     tbl+6,  offset cnt
        mov     bx, offset tbl
        call    strcmp
        mov     ax, 4c00h
        int     21h                     ;程序结束
main    endp
strcmp  proc    near
        push    ax
        push    bx
        push    si
        push    di
        push    cx
        push    dx
        sub     cx, cx                  ;cx清零，为存放cnt做准备
        mov     si, [bx+6]              ;cnt EA
        mov     cl, [si]
        mov     si, [bx+2]              ;stra EA
        mov     di, [bx+4]              ;strb EA
        mov     bx, [bx]                ;将bx的内容为地址的内存单元送bx
        sub     ax, ax                  ;ax清零
cmpst:  mov     ah, [si]
        mov     al, [di]
        mov     dh, ah
        mov     dl, al
        cmp     ah, al                  ;两者都没结束，进一步比较大小
        ja      cmpa
        jb      cmpb
        inc     si
        inc     di
        dec     cx
        jz      cmpe                    ;如果cx减为0就跳转相等
        jmp     cmpst                   ;循环
cmpe:   mov     byte ptr [bx],3h
        ; lea     dx, e
        ; mov     ah, 09h
        ; int     21h
        jmp     ok
cmpa:   mov     byte ptr [bx],1h
        ; lea     dx, a
        ; mov     ah, 09h
        ; int     21h
        jmp     ok
cmpb:   mov     byte ptr [bx],2h
        ; lea     dx, b
        ; mov     ah, 09h
        ; int     21h
        jmp     ok
ok:     pop     dx
        pop     cx
        pop     di
        pop     si
        pop     bx
        pop     ax
        ret
strcmp  endp
        end     begin