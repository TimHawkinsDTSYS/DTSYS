      /TITLE Utility, Phone number (SrvPgm)
      *PARMS
      *xxxxxx CRTOBJ OBJ(MSKPHN) SRCFILE(QSQLFUN)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      ***********************************************************
      * Validate phone number.
      ***********************************************************
     P ChkPhn          B                   Export
      *
     D ChkPhn          PI                  like(d_ChkPhn)
     D  PhoneNumber                        like(PhnNbr) value
      *
      *  Standalone fields
      *
     D AlwChr          C                   const('0123456789/-()AB:')
      *
     D                 DS
     Dw1_22                    1     22
     Dw10_22                  10     22
     Dw1_3                     1      3
     Dw4_4                     4      4
     Dw5_7                     5      7
     Dw8_8                     8      8
     Dw9_12                    9     12
     Dw13_13                  13     13
     Dw1_10                    1     10
      * ---------------------------------------------------------
      *
     C                   clear                   d_ChkPhn
      *
      *    **************** Disabled. ****************
      *
     C                   return    d_ChkPhn
      *
      *    Test for no input.
      *
     C                   if        PhoneNumber = *blanks
     C                   return    d_ChkPhn
     C                   endif
      *
      *    If foreign phone number don't do anything.
      *
     C                   if        %subst(PhoneNumber:1:3) = '011'
     C                   return    d_ChkPhn
     C                   endif
      *
      *    Edit for incorrect characters.
      *
     C                   eval      w1_22  =  PhoneNumber
      *
     C     w10_22        ifEq      *blank
     C                   eval      ChkPhn_MSGID  = 'GNL0065'
     C                   return    d_ChkPhn
     C                   endif
      *
     C                   testN                   w1_3                 81
      *
     C     *in81         ifEq      *OFF
     C                   eval      ChkPhn_MSGID  = 'GNL0065'
     C                   return    d_ChkPhn
     C                   endif
      *
     C     w4_4          ifEq      *blank
     C     w4_4          orEq      '-'
     C                   testN                   w5_7                 81
     C     *in81         ifEq      *ON
     C     w8_8          ifEq      *blank
     C     w8_8          orEq      '-'
     C                   testN                   w9_12                82
     C     *in82         ifEq      *ON
     C     w13_13        ifEq      *blank
     C     w13_13        orEq      '-'
     C                   return    d_ChkPhn
     C                   endif
     C                   endif
     C                   endif
     C                   endif
     C                   endif
      *
     C                   testN                   w1_10                81
      *
     C     *in81         ifEq      *OFF
     C                   eval      ChkPhn_MSGID  = 'GNL0065'
     C                   return    d_ChkPhn
     C                   endif
      *
     C                   return    d_ChkPhn
      *
     P ChkPhn          E
      ***********************************************************
      * Validate fax number.
      ***********************************************************
     P ChkFax          B                   Export
      *
     D ChkFax          PI                  like(d_ChkPhn)
     D  PhoneNumber                        like(PhnNbr) value
      *
      *  Standalone fields
      *
     D                 DS
     Dw1_22                    1     22
     Dw10_22                  10     22
     Dw1_3                     1      3
     Dw4_4                     4      4
     Dw5_7                     5      7
     Dw8_8                     8      8
     Dw9_12                    9     12
     Dw13_22                  13     22
     Dw1_10                    1     10
     Dw11_22                  11     22
      * ---------------------------------------------------------
      *
      * this procedure is similar to ChkPhn - see above
      *
     C                   clear                   d_ChkPhn
      *
      *    **************** Disabled. ****************
      *
     C                   return    d_ChkPhn
      *
      *    Test for no input.
      *
     C                   if        PhoneNumber = *blanks
     C                   return    d_ChkPhn
     C                   endif
      *
      *    If foreign phone number don't do anything.
      *
     C                   if        %subst(PhoneNumber:1:3) = '011'
     C                   return    d_ChkPhn
     C                   endif
      *
      *    Edit for incorrect characters.
      *
     C                   eval      w1_22  =  PhoneNumber
      *
     C     w10_22        ifEq      *blank
     C                   eval      ChkPhn_MSGID  = 'GNL0066'
     C                   return    d_ChkPhn
     C                   endif
      *
     C                   testN                   w1_3                 81
      *
     C     *in81         ifEq      *OFF
     C                   eval      ChkPhn_MSGID  = 'GNL0066'
     C                   return    d_ChkPhn
     C                   endif
      *
     C     w4_4          ifEq      *blank
     C     w4_4          orEq      '-'
     C                   testN                   w5_7                 81
     C     *in81         ifEq      *ON
     C     w8_8          ifEq      *blank
     C     w8_8          orEq      '-'
     C                   testN                   w9_12                82
     C     *in82         ifEq      *ON
     C     w13_22        andEq     *blank
     C                   return    d_ChkPhn
     C                   endif
     C                   endif
     C                   endif
     C                   endif
      *
     C                   testN                   w1_10                81
      *
     C     *in81         ifEq      *OFF
     C                   eval      ChkPhn_MSGID  = 'GNL0066'
     C                   return    d_ChkPhn
     C                   endif
      *
     C     w11_22        ifNE      *blank
     C                   eval      ChkPhn_MSGID  = 'GNL0066'
     C                   return    d_ChkPhn
     C                   endif
      *
     C                   return    d_ChkPhn
      *
     P ChkFax          E
      ***********************************************************
      * Reformat phone number or fax number
      ***********************************************************
     P EdtPhn          B                   Export
      *
     D EdtPhn          PI                  like(PhnNbr)
     D  PhoneNumber                        like(PhnNbr) value
      *
      *  Standalone fields
      *
     D RtnPhn          S                   like(PhnNbr) inz
     D AlwChr          C                   const('0123456789/-()AB:')
     D NoPhon          C                   const('000-000-0000')
      *
     D                 DS
     Dw1_22                    1     22
     Dw1_3                     1      3
     Dw4_4                     4      4
     Dw5_7                     5      7
     Dw8_8                     8      8
     Dw9_12                    9     12
     Dw13_13                  13     13
     Dw14_22                  14     22
     Dw1_10                    1     10
     Dw4_6                     4      6
     Dw7_10                    7     10
     Dw11_22                  11     22
      *
      *    **************** Disabled. ****************
      *
     C                   return    PhoneNumber
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
     C                   if        PhoneNumber = *blanks
     C                   return    *blanks
     C                   endif
      *
      *    If foreign phone number don't do anything.
      *
     C                   if        %subst(PhoneNumber:1:3) = '011'
     C                   return    PhoneNumber
     C                   endif
      *
      *    Edit for incorrect characters.
      *
     C                   eval      w1_22  =  PhoneNumber
      *
     C                   testN                   w1_3                 81
      *
     C     *in81         ifEq      *OFF
     C                   return    PhoneNumber
     C                   endif
      *
     C     w4_4          ifEq      *blank
     C     w4_4          orEq      '-'
     C                   testN                   w5_7                 81
     C     *in81         ifEq      *ON
     C     w8_8          ifEq      *blank
     C     w8_8          orEq      '-'
     C                   testN                   w9_12                82
     C     *in82         ifEq      *ON
     C     w13_13        ifEq      *blank
     C     w13_13        orEq      '-'
     C                   eval      RtnPhn =  w1_3  +  '-'  +  w5_7  +  '-' +
     C                                       w9_12 +  ' '  +  w14_22
     C                   return    RtnPhn
     C                   endif
     C                   endif
     C                   endif
     C                   endif
     C                   endif
      *
     C                   testN                   w1_10                81
      *
     C     *in81         ifEq      *OFF
     C                   return    PhoneNumber
     C                   endif
      *
     C                   eval      RtnPhn =  w1_3  +  '-'  +  w4_6  +  '-' +
     C                                       w7_10 +  ' '  +  w11_22
      *
     C                   return    RtnPhn
      *
     P EdtPhn          E
      ***********************************************************
      * Reformat phone number or fax number
      ***********************************************************
     P MskPhn          B                   Export
      *
     D MskPhn          PI                  like(PhnNbr)
     D  PLphn                              like(PhnNbr)
      *
      *  Standalone fields
      *
     D DomFormat       s                   like(StdInd) inz
     D IntFormat       s                   like(StdInd) inz
     D RtnPhn          s                   like(PhnNbr) inz
     D WKphn           s                   like(PhnNbr) inz
     D NumPhn          s             22  0              inz
     D AlwChr          c                   const('0123456789/-()AB:')
     D NrmChr          c                   const('0123456789- ')
     D NumChr          c                   const('0123456789')
     D SplChr          c                   const('()AB:')
     D StrNbrs         s                   like(StdInt) inz
     D EndNbrs         s                   like(StdInt) inz
     D x               s                   like(StdInt) inz
      *
      *    **************** Disabled. ****************
      *
     C                   eval      RtnPhn = PLphn
     C                   return    RtnPhn
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
     C                   if        PLphn = *blanks
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Determine if foreign, domestic, special characters.
      *
     C                   select
     C                   when      %check(NrmChr:PLphn) <> *zero
     C                   eval      IntFormat = *off
     C                   eval      DomFormat = *off
      *
     C                   when      %subst(PLphn:1:3) = '011'
     C                   eval      IntFormat = *on
     C                   eval      DomFormat = *off
      *
     C                   other
     C                   eval      DomFormat = *on
     C                   eval      IntFormat = *off
     C                   endsl
      * ---------------------------------------------------------
      *
      *    Count numbers.
      *
     C                   for       x = 1 to %len(PLphn)
     C                   if        %subst(PLphn:x:1) >= '0' and
     C                             %subst(PLphn:x:1) <= '9'
     C                   eval      StrNbrs += 1
     C                   endif
     C                   endfor
      * ---------------------------------------------------------
      *
      *    Format consistantly.
      *
     C                   select
     C                   when      DomFormat
     C                   eval      NumPhn = num(PLphn)
     C                   eval      WKphn  = %char(NumPhn)
      *
     C                   when       IntFormat                and
     C                             (%subst(PLphn:4:1) = ' '  or
     C                              %subst(PLphn:4:1) = '-')
     C                   eval      WKphn = %subst(PLphn:1:3) +
     C                                     %subst(PLphn:5:18)
      *
     C                   when      IntFormat                 and
     C                             %subst(PLphn:4:1) >= '0'  and
     C                             %subst(PLphn:4:1) <= '9'
     C                   eval      WKphn = %subst(PLphn:1:3) +
     C                                     %subst(PLphn:4:19)
      *
     C                   other
     C                   eval      WKphn = PLphn
     C                   endsl
      * ---------------------------------------------------------
      *
      *    Mask domestic format.
      *
     C                   select
     C                   when      DomFormat
     C                   eval      RtnPhn = %subst(WKphn:1:3) + '-' +
     C                                      %subst(WKphn:4:3) + '-' +
     C                                      %subst(WKphn:7:4)
      *
      *    Mask international format.
      *
     C                   when      IntFormat
     C                   eval      RtnPhn = %subst(WKphn:1:3) + '-' +
     C                                      %subst(WKphn:4:19)
      *
      *    Mask nothing, this one has special characters.
      *
     C                   other
     C                   eval      RtnPhn = WKphn
     C                   endsl
      * ---------------------------------------------------------
      *
      *    Re-count numbers.
      *
     C                   for       x = 1 to %len(PLphn)
     C                   if        %subst(RtnPhn:x:1) >= '0' and
     C                             %subst(RtnPhn:x:1) <= '9'
     C                   eval      EndNbrs += 1
     C                   endif
     C                   endfor
      * ---------------------------------------------------------
      *
      *    If numbers lost, restore inbound parameter.
      *
     C                   if        StrNbrs <> EndNbrs
     C                   eval      RtnPhn   = PLphn
     C                   endif
      * ---------------------------------------------------------
      *
      *    Return masked phone number.
      *
     C                   return    RtnPhn
      *
     P MskPhn          E
      ***********************************************************
      * Reformat phone number or fax number
      ***********************************************************
     P MskPhnX         B                   Export
      *
     D MskPhnX         PI                  like(PhnNbr)
     D  PLphn                              like(PhnNbr) const
      *
      *  Standalone fields
      *
     D DomFormat       s                   like(StdInd) inz
     D IntFormat       s                   like(StdInd) inz
     D RtnPhn          s                   like(PhnNbr) inz
     D WKphn           s                   like(PhnNbr) inz
     D NumPhn          s             22  0              inz
     D AlwChr          c                   const('0123456789/-()AB:')
     D NrmChr          c                   const('0123456789()-. ')
     D NumChr          c                   const('0123456789')
     D SplChr          c                   const('()AB:')
     D StrNbrs         s                   like(StdInt) inz
     D EndNbrs         s                   like(StdInt) inz
     D x               s                   like(StdInt) inz
      *
      *    **************** Disabled. ****************
      *
     C                   eval      RtnPhn = PLphn
     C                   return    RtnPhn
      * ---------------------------------------------------------
      *
      *    Test for no input.
      *
     C                   if        PLphn = *blanks
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Determine if foreign, domestic, special characters.
      *
     C                   select
     C                   when      %check(NrmChr:PLphn) <> *zero
     C                   eval      IntFormat = *off
     C                   eval      DomFormat = *off
      *
     C                   when      %subst(PLphn:1:3) = '011'
     C                   eval      IntFormat = *on
     C                   eval      DomFormat = *off
      *
     C                   other
     C                   eval      DomFormat = *on
     C                   eval      IntFormat = *off
     C                   endsl
      * ---------------------------------------------------------
      *
      *    Count numbers.
      *
     C                   for       x = 1 to %len(PLphn)
     C                   if        %subst(PLphn:x:1) >= '0' and
     C                             %subst(PLphn:x:1) <= '9'
     C                   eval      StrNbrs += 1
     C                   endif
     C                   endfor
      * ---------------------------------------------------------
      *
      *    Format consistantly.
      *
     C                   select
     C                   when      DomFormat
     C                   eval      NumPhn = num(PLphn)
     C                   eval      WKphn  = %char(NumPhn)
      *
     C                   when       IntFormat                and
     C                             (%subst(PLphn:4:1) = ' '  or
     C                              %subst(PLphn:4:1) = '-')
     C                   eval      WKphn = %subst(PLphn:1:3) +
     C                                     %subst(PLphn:5:18)
      *
     C                   when      IntFormat                 and
     C                             %subst(PLphn:4:1) >= '0'  and
     C                             %subst(PLphn:4:1) <= '9'
     C                   eval      WKphn = %subst(PLphn:1:3) +
     C                                     %subst(PLphn:4:19)
      *
     C                   other
     C                   eval      WKphn = PLphn
     C                   endsl
      * ---------------------------------------------------------
      *
      *    Mask domestic format.
      *
     C                   select
     C                   when      DomFormat
     C                   eval      RtnPhn = %subst(WKphn:1:3) + '-' +
     C                                      %subst(WKphn:4:3) + '-' +
     C                                      %subst(WKphn:7:4)
      *
      *    Mask international format.
      *
     C                   when      IntFormat
     C                   eval      RtnPhn = %subst(WKphn:1:3) + '-' +
     C                                      %subst(WKphn:4:19)
      *
      *    Mask nothing, this one has special characters.
      *
     C                   other
     C                   eval      RtnPhn = WKphn
     C                   endsl
      * ---------------------------------------------------------
      *
      *    Re-count numbers.
      *
     C                   for       x = 1 to %len(PLphn)
     C                   if        %subst(RtnPhn:x:1) >= '0' and
     C                             %subst(RtnPhn:x:1) <= '9'
     C                   eval      EndNbrs += 1
     C                   endif
     C                   endfor
      * ---------------------------------------------------------
      *
      *    If numbers lost, restore inbound parameter.
      *
     C                   if        StrNbrs <> EndNbrs
     C                   eval      RtnPhn   = PLphn
     C                   endif
      * ---------------------------------------------------------
      *
      *    Return masked phone number.
      *
     C                   return    RtnPhn
      *
     P MskPhnX         E
