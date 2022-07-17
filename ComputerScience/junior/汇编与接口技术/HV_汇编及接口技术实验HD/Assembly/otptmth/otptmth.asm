;月份输出
    .model small
    .data
mthnum  dw      12
mjan    db      "Jan. ","$"
mfeb    db      "Feb. ","$"
mmar    db      "Mar. ","$"
mapr    db      "Apr. ","$"
mmay    db      "May ","$"
mjun    db      "June ","$"
mjul    db      "July ","$"
maug    db      "Aug. ","$"
msep    db      "Sept. ","$"
moct    db      "Oct. ","$"
mnov    db      "Nov. ","$"
mdec    db      "Dec. ","$"
period  db      ".","$"
tblm    dw      12 dup(?)                   ;为解决月份缩写长度不一样的问题而使用类似地址表传参的方法
    .code
main    proc    far
begin:  mov     ax, @data
        mov     ds, ax
        ;装月份地址表
        mov     tblm,offset mjan
        mov     tblm+2,offset mfeb
        mov     tblm+4,offset mmar
        mov     tblm+6,offset mapr
        mov     tblm+8,offset mmay
        mov     tblm+10,offset mjun
        mov     tblm+12,offset mjul
        mov     tblm+14,offset maug
        mov     tblm+16,offset msep
        mov     tblm+18,offset moct
        mov     tblm+20,offset mnov
        mov     tblm+22,offset mdec
        mov     ax, mthnum
        dec     ax;月份转下标
        mov     bx, 2h
        mul     bx
        mov     bx, ax
        mov     dx, tblm[bx]
        mov     ah, 09h
        int     21h
        mov     ax, 4c00h
        int     21h
main    endp
    end begin