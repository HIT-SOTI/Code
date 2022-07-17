;日历换算：天数->日期
putcrlf macro   ;回车符
        push    dx
        push    ax
        lea     dx, crlf
        mov     ah, 09h
        int     21h
        pop     ax
        push    dx
        endm

data    segment
    yrtxt   db      'Input your year (0001-2999): ','$' ;输入年提示字符串
    daytxt  db      'Input your day (001-366): ','$'    ;输入天数提示字符串
    yrwarn  db      'Your year is invalid, input again: ','$'
    daywarn db      'Your day is invalid, input again: ','$'
    lpwarn  db      'Judgement of leap error! ','$';闰年判断错误输出
    maxlen  db      8h                          ;最多允许接收的字符个数（包含回车符0DH）（缓冲区首地址）
    actlen  db      ?                           ;留空，用于自动回填实际输入字符个数（不含0DH）
    nmbuf   db      8h dup(0)                   ;预设缓冲区（真实的字符串起始地址）
    crlf    db      0dh,0ah,'$'                 ;预设回车符 换行符 结束符
    year    db      8h dup(0)                   ;TODO 多长足够
    day     db      6h dup(0)                   ;TODO 多长足够
    yrmin   db      '0001',0dh,0ah,'$'          ;最小年份
    yrmax   db      '2999',0dh,0ah,'$'          ;最大年份
    daymin  db      '001',0dh,0ah,'$'           ;最小天
    daymax  db      '366',0dh,0ah,'$'           ;最大天
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
    ;strcmp子程序
    cmprslt db      0                           ;字符串比较结果（strcmp返回值）
    stra    db      8h dup(?)                   ;参数a
    strb    db      8h dup(?)                   ;参数b
    cnt     db      4                           ;比较循环次数
    tbl     dw      4 dup(?)                    ;[tbl]:cmprslt [tbl+2]:stra [tbl+4]:strb
    e       db      "e","$"
    a       db      "a","$"
    b       db      "b","$"
    ;str2num子程序
    yrnum   dw      ?                           ;年数字
    daynum  dw      ?                           ;天数字
    tbln    dw      2 dup(?)                    ;[tbl]:year/day [tbl+2]:yrnum/daynum
    ;judleap子程序
    isleap  db      0                           ;是否是闰年标志位 1是2不是
    tbll    dw      2 dup(?)                    ;[tbl]:yrnum [tbl+2]:isleap
    ;chgfeb程序段
    lptxt   db      'Leap year set Feb. 29 days.','$';更改二月提示字符串
    ;calc程序段（计算天数）
    mthwarn db      'Overflow of days, maybe its ordinary year.','$';输入天数警告字符串（平年）
    mthnum  dw      ?                           ;月份数字
    datenum dw      ?                           ;日期数字
    ;num2str子程序
    mthstr  db      5 dup(?)                    ;月份字符
    datestr db      5 dup(?)                    ;日期字符
    tbls    dw      2 dup(?)                    ;[tbl]:num [tbl+2]:str
    ;reverse子程序
    len     db      ?                           ;要反向的字节数
    tblr    dw      2 dup(?)                    ;[tbl]:str [tbl+2]:len
    ;输出部分
    txtthe  db      "The ","$"
    suf1st  db      "st ","$"
    suf2nd  db      "nd ","$"
    suf3rd  db      "rd ","$"
    sufothr db     "th ","$"
    txtof   db      "day of the year ","$"
    txtis   db      " is ","$"
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
data    ends

code    segment
    assume  cs:code,ds:data
    main    proc    far
    start:  mov     ax, data
            mov     ds, ax                  ;装数据段
    yrtip:  mov     dx, offset yrtxt        ;提示输入年
            mov     ah, 09h
            int     21h
    yrin:   lea     dx, maxlen              ;输入年
            mov     ah, 0ah
            int     21h
            putcrlf
            mov     al, actlen              ;字符串加结束符
            mov     ah, 0                   ;清空ah
            mov     si, ax
            mov     nmbuf[si],  24h
            ; lea     dx, nmbuf               ;输出输入的字符串
            ; mov     ah, 09h
            ; int     21h
            ; putcrlf
    yrcmp1: mov     tbl,    offset cmprslt  ;送参数指针于地址表
            mov     tbl+2,  offset nmbuf
            mov     tbl+4,  offset yrmin    ;年最小值
            mov     tbl+6,  offset cnt
            mov     bx, offset tbl
            call    strcmp                  ;调用字符串比较子程序
            cmp     cmprslt, 1h             ;numbuf>yrmin
            jz      yrcmp2
            cmp     cmprslt, 3h             ;numbuf=yrmin
            jz      yrcmp2
            mov     dx, offset yrwarn       ;输出错误提示
            mov     ah, 09h
            int     21h
            jmp     yrin
    yrcmp2: mov     tbl,    offset cmprslt  ;送参数指针于地址表
            mov     tbl+2,  offset nmbuf
            mov     tbl+4,  offset yrmax    ;年最大值
            mov     tbl+6,  offset cnt
            mov     bx, offset tbl
            call    strcmp                  ;调用字符串比较子程序
            cmp     cmprslt, 2h             ;numbuf<yrmax
            jz      leapyr
            ; jz      mthtip
            cmp     cmprslt, 3h             ;numbuf=yrmax
            jz      leapyr
            ; jz      mthtip
            mov     dx, offset yrwarn       ;输出错误提示
            mov     ah, 09h
            int     21h
            jmp     yrin
    leapyr: ; copy year to year var
            mov     ax, data
            mov     es, ax                  ;装附加段
            mov     cx, 5h                  ;五个的原因是把$符也复制过去
            lea     si, nmbuf               ;设置源串指针
            lea     di, year                ;设置目的串指针
            cld                             ;DF=0地址正向增加
            rep     movsb                   ;重复5次将年挪动至year变量处
            ; str2num
            mov     tbln,offset year
            mov     tbln+2, offset yrnum
            mov     bx, offset tbln
            call    str2num
            ; judge leap year
            mov     tbll,offset yrnum
            mov     tbll+2,offset isleap
            mov     bx, offset tbll
            call    judleap
            ;根据最终的判断结果决定是否修改2月
            cmp     isleap, 1h              ;如果是闰年
            jz      chgfeb                  ;跳转至2月更改程序段
            cmp     isleap, 2h              ;如果不是闰年
            jz      mthtip                  ;直接跳转至月份输入
            mov     dx, offset lpwarn       ;提示闰年判断错误（即不满足上两种情况，保险起见）
            mov     ah, 09h
            int     21h
            putcrlf
            jmp     stop                    ;直接退出程序
    chgfeb: ;修改二月
            mov     mth+2,  29              ;改为29天
            mov     dx, offset lptxt        ;提示已经更改二月
            mov     ah, 09h
            int     21h
            putcrlf
    mthtip: mov     dx, offset daytxt       ;提示输入天
            mov     ah, 09h
            int     21h
    mthin:  lea     dx, maxlen              ;输入天
            mov     ah, 0ah
            int     21h
            putcrlf
            mov     al, actlen              ;字符串加结束符
            mov     ah, 0                   ;清空ah
            mov     si, ax
            mov     nmbuf[si],  24h
            ; lea     dx, nmbuf               ;输出输入的字符串
            ; mov     ah, 09h
            ; int     21h
            ; putcrlf
            mov     cnt,3                   ;置比较次数为3
    mthcmp1:mov     tbl,    offset cmprslt  ;送参数指针于地址表
            mov     tbl+2,  offset nmbuf
            mov     tbl+4,  offset daymin   ;天最小值
            mov     tbl+6,  offset cnt
            mov     bx, offset tbl
            call    strcmp                  ;调用字符串比较子程序
            cmp     cmprslt, 1h             ;numbuf>daymin
            jz      mthcmp2
            cmp     cmprslt, 3h             ;numbuf=daymin
            jz      mthcmp2
            mov     dx, offset daywarn      ;输出错误提示
            mov     ah, 09h
            int     21h
            jmp     mthin
    mthcmp2:mov     tbl,    offset cmprslt  ;送参数指针于地址表
            mov     tbl+2,  offset nmbuf
            mov     tbl+4,  offset daymax   ;天最大值
            mov     tbl+6,  offset cnt
            mov     bx, offset tbl
            call    strcmp                  ;调用字符串比较子程序
            cmp     cmprslt, 2h             ;numbuf<daymax
            jz      d2num                   ;跳转至天数字符串转数字
            ; jz      t
            cmp     cmprslt, 3h             ;numbuf=daymax
            jz      d2num                   ;跳转至天数字符串转数字
            ; jz      t
            mov     dx, offset daywarn      ;输出错误提示
            mov     ah, 09h
            int     21h
            jmp     mthin
    ; t:      lea     dx, nmbuf               ;输出输入的字符串
    ;         mov     ah, 09h
    ;         int     21h
    d2num:  ; copy day to day var
            mov     ax, data
            mov     es, ax                  ;装附加段
            mov     cx, 4h                  ;4个的原因是把$符也复制过去
            lea     si, nmbuf               ;设置源串指针
            lea     di, day                 ;设置目的串指针
            cld                             ;DF=0地址正向增加
            rep     movsb                   ;重复四次将年挪动至day变量处
            ;str2num
            mov     tbln,offset day
            mov     tbln+2, offset daynum
            mov     bx, offset tbln
            call    str2num
            ;计算月份和日期
            mov     cx, daynum              ;将天数转存到cx
            mov     si, 0                   ;第一次偏移量为0
    calc:   cmp     cx, mth[si]             ;比较剩余天数和本月日期
            jbe     current                 ;小于等于就是当月
            sub     cx, mth[si]             ;不是当月就减去这个月
            inc     si
            inc     si                      ;si加2（下一月dw）
            cmp     si, 24                  ;如果是13月（0-11 12*2）
            jz      mwarn                   ;如果超出月份跳转输出警告
            jnz     calc                    ;如果没超出继续计算
    current:mov     datenum,cx              ;保存日期
            inc     si
            inc     si                      ;si+2下标修正为序数(*2)
            mov     dx, 0                   ;除法准备（被除数高16位）
            mov     ax, si                  ;除法准备（被除数低16位）
            mov     bx, 2h                  ;除法准备（除数为2）
            div     bx                      ;dx_ax/2=ax...dx
            mov     mthnum, ax              ;保存月份
            jmp     n2s                     ;跳转至数字转字符串
    mwarn:  mov     dx, offset mthwarn      ;提示天数超出警告
            mov     ah, 09h
            int     21h
            jmp     stop                    ;直接退出程序
    n2s:    ;数字转字符串
            ;月份
            mov     tbls,offset mthnum
            mov     tbls+2,offset mthstr
            mov     bx, offset tbls
            call    num2str
            mov     si, 2h                  ;加$
            mov     mthstr[si], 24h
            ;日期
            mov     tbls,offset datenum
            mov     tbls+2,offset datestr
            mov     bx, offset tbls
            call    num2str
            mov     si, 2h                  ;加$
            mov     datestr[si],24h
            ;字符串反向
            mov     len,2h                  ;设置位数2
            mov     tblr,offset mthstr      ;月反向
            mov     tblr+2,offset len
            mov     bx, offset tblr
            call    reverse
            mov     tblr,offset datestr     ;日期反向
            mov     tblr+2,offset len
            mov     bx, offset tblr
            call    reverse
    outpt:  ;输出结果
            mov     dx, offset txtthe
            mov     ah, 09h
            int     21h
            mov     dx, offset day
            mov     ah, 09h
            int     21h
            ;后缀
            mov     bx, 2h
            cmp     day[bx],31h
            jz      frst
            cmp     day[bx],32h
            jz      snd
            cmp     day[bx],33h
            jz      trd
            mov     dx, offset sufothr
            mov     ah, 09h
            int     21h
            jmp     otof
    frst:   mov     dx, offset suf1st
            mov     ah, 09h
            int     21h
            jmp     otof
    snd:    mov     dx, offset suf2nd
            mov     ah, 09h
            int     21h
            jmp     otof
    trd:    mov     dx, offset suf3rd
            mov     ah, 09h
            int     21h
            jmp     otof
    otof:   mov     dx, offset txtof
            mov     ah, 09h
            int     21h
            mov     dx, offset year
            mov     ah, 09h
            int     21h
            mov     dx, offset txtis
            mov     ah, 09h
            int     21h
            ;月缩写
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
            mov     dx, offset datestr
            mov     ah, 09h
            int     21h
            mov     dx, offset period
            mov     ah, 09h
            int     21h
    stop:   mov     ax, 4c00h
            int     21h                     ;程序结束
    main    endp
    ;字符串比较子程序
    ;使用ax bx si di cx dx
    ;params stra[tbl+2],strb[tbl+4],cnt[tbl+6]
    ;ret    cmprslt[tbl]
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
    cmpe:   mov     byte ptr [bx],3h        ;相等结果为3
            ; lea     dx, e
            ; mov     ah, 09h
            ; int     21h
            jmp     ok
    cmpa:   mov     byte ptr [bx],1h        ;a>b结果为1
            ; lea     dx, a
            ; mov     ah, 09h
            ; int     21h
            jmp     ok
    cmpb:   mov     byte ptr [bx],2h        ;b>a结果为2
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
    ;秦久韶算法字符串转数字子程序
    ;使用 si cx dx ax di
    ;params strg[tbl]
    ;ret    num[tbl+2]
    str2num proc    near
            push    si
            push    cx
            push    dx
            push    ax
            push    di
            mov     si, 0                   ;初始偏移量0
            sub     ax, ax                  ;ax清零
            sub     cx, cx                  ;cx用于暂存num值，初始化为0
            mov     dx, 10                  ;秦久韶算法每次乘10
            mov     di, [bx+si]             ;strg EA
    lop:    mov     al, [di]
            cmp     al, 24h                 ;如果al为24h（$）
            je      final                   ;则退出子程序
            sub     al, 30h                 ;如果al不为0则减30h，即转化为数字
            cmp     cx, 0                   ;如果cx(num)为0
            je      do_deal                 ;直接跳转到相加的位置
            push    ax                      ;保护ax
            mov     ax, cx                  ;将之前加过的cx(num)放入ax
            mul     dx                      ;src是dx中的值(10)，则ax(cx)*10
            mov     dx, 10                  ;恢复dx为10
            mov     cx, ax                  ;将乘10后的值交给cx
            pop     ax                      ;还原ax（这一位的值）
    do_deal:add     cx, ax                  ;将ax(al)中的数加入cx(num)
            mov     ax, 0                   ;ax清零
            inc     di                      ;偏移加1
            jmp     lop                     ;无条件跳转至下一位计算
    final:  mov     di, [bx+2]              ;将num的offset给di
            mov     [di],cx                 ;cx中的值传回num(yrnum/daynum)
            pop     di
            pop     ax
            pop     dx
            pop     cx
            pop     si
            ret
    str2num endp
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
            mov     si, [bx]                ;year EA送si
            mov     ax, [si]                ;以si内容为EA的内存内容（year）送ax，用作除法
            mov     cx, ax                  ;备份年份，因为ax会被改掉
            mov     dx, 0                   ;被除数dx_ax是32位，此处dx为0
            ;判断能否被100整除
            mov     di, 100                 ;di用于存储除数
            div     di
            cmp     dx, 0                   ;判断余数是否为0
            jnz     jud4                    ;如果不能被100整除则判断能否被4整除
            ;判断能否被400整除
            mov     ax, cx                  ;将年份从cx恢复
            mov     dx, 0                   ;恢复dx为0（虽然此处一定为0，但保险）
            mov     di, 400
            div     di
            cmp     dx, 0
            jz      islp                    ;如果能被400整除则跳转至是闰年islp
            jmp     isnlp                   ;其余的不是闰年跳转至非闰年isnlp
            ;判断能否被4整除
    jud4:   mov     ax, cx                  ;将年份从cx恢复
            mov     dx, 0                   ;恢复dx为0
            mov     di, 4
            div     di
            cmp     dx, 0
            jnz     isnlp                   ;如果不能被4整除则不是闰年，是闰年的不用判断走下一步
    islp:   mov     di, [bx+2]
            mov     byte ptr [di],1h
            jmp     judok
    isnlp:  mov     di, [bx+2]
            mov     byte ptr [di],2h        ;如果不是的直接写入2走下一步不用跳转
    judok:  pop     di
            pop     dx
            pop     cx
            pop     ax
            pop     si
            ret
    judleap endp
    ;短除法数字转字符串（反向）
    ;使用 ax dx cx si
    ;params num[tbl]
    ;ret    str[tbl+2]
    num2str proc    near
            push    ax                      ;低16位
            push    dx                      ;高16位
            push    cx                      ;除数
            push    si                      ;中继 作为偏移量存str用
            mov     si, [bx]                ;num的EA
            mov     ax, [si]                ;num内容（num）送ax
            mov     cx, 10                  ;除数为10
            mov     si, 0                   ;si清零，用于字符串偏移
    rediv:  mov     dx, 0                   ;高16位为0
            div     cx                      ;dx_ax/cx=ax...dx
            add     dx, 0030h               ;余数转为字符串
            push    bx                      ;暂存bx
            mov     bx, [bx+2]              ;将目前字符的EA送bx
            mov     [bx+si],dl              ;dx低位送str[si]，高位为0
            pop     bx                      ;恢复bx
            inc     si                      ;偏移量加一
            cmp     ax, 0
            jnz     rediv                   ;如果商不为0则继续除
            pop     si
            pop     cx
            pop     dx
            pop     ax
            ret
    num2str endp
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
            mov     di, [bx+2]              ;len EA
            mov     di, [di]                ;di存len
            and     di, 00ffh               ;高位清零
            mov     dx, di                  ;保存len副本
            mov     si, [bx]                ;str EA
    nxtch:  mov     ax, [si]
            and     ax, 00ffh
            push    ax
            inc     si                      ;偏移量向后
            dec     di                      ;计数器减一
            jnz     nxtch                   ;入果计数器不是0，则下一字节
            ;如果计数器为0
    popnxt: pop     cx                      ;将入栈的字节出栈
            push    bx                      ;暂存bx
            mov     bx, [bx]
            mov     [bx+di],cl              ;将入栈的几个pop回原地址（反向）
            pop     bx                      ;恢复bx
            inc     di
            cmp     dx, di                  ;判断di是否回到len值
            jnz     popnxt                  ;没回到就继续
            pop     cx
            pop     dx
            pop     di
            pop     ax
            pop     si
            ret
    reverse endp
code    ends
        end     start