      /TITLE Utility, Seat assignment (SrvPgm)
      *PARMS
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
      * **********************************************************
      * SetSeatAssign() -- Set seat assignments.
      * **********************************************************
     P SetSeatAssign   B                   Export
      *
     D SetSeatAssign   PI                  like(dfnBAseat)
     D  i_seat                             like(dfnAYseat) dim(20) const
      *
     D RTseat          s                   like(dfnAYseat) inz
     D WKseat          s                   like(dfnAYseat) inz
     D WKrow           s                   like(dfnAYseat) inz
     D WKsea           s                   like(dfnAYseat) inz
     D SVrow           s                   like(dfnAYseat) inz
     D x               s                   like(StdInt)    inz
      * ---------------------------------------------------------
      *
      *   Return if nothing passed.
      *
     C                   if        i_seat(1) = *blanks
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Process each element.
      *
     C                   for       x = 1 to %elem(i_seat)
     C                   eval      WKseat = i_seat(x)
     C                   if        WKseat = *blanks
     C                   leave
     C                   endif
      *
      *    Extract row and seat, then concatenate back.
      *
     C                   eval      WKrow = %char(num(WKseat))
     C                   eval      WKsea = ExtAlpha(WKseat)
      *
     C                   if        WKrow <> SVrow
     C                   eval      SVrow  = WKrow
     C                   eval      RTseat = %trim(RTseat) + WKrow
     C                   endif
      *
     C                   eval      RTseat = %trim(RTseat) + WKsea
     C                   endfor
      *
     C                   return    RTseat
      *
      /copy qcpysrc,$PSSR
      *
     P SetSeatAssign   E
      * **********************************************************
      * ExtSeatAssign() -- Extract seat assignments.
      * **********************************************************
     P ExtSeatAssign   B                   Export
      *
     D ExtSeatAssign   PI                  like(dfnAYseat)  dim(20)
     D  i_seat                             like(dfnBAseat)  const
     D  i_options                          like(StdStr)     const
     D                                     options(*nopass)
      *
     D AYseat          s                   like(dfnAYseat)  inz dim(20)
     D AYidx           s                   like(StdInt)     inz
      *
     D RightAdj        s                   like(StdInd)     inz
     D WKrow           s                   like(dfnAYseat)  inz
     D x               s                   like(StdInt)     inz
      * ---------------------------------------------------------
      *
      *   Return if nothing passed.
      *
     C                   if        i_seat  = *blanks
     C                   return    *blanks
     C                   endif
      *
      *    Test for options.
      *
     C                   if        %parms >= 2 and
     C                             %scan('*RIGHTADJ':i_options) > *zero
     C                   eval      RightAdj = *on
     C                   endif
      * ---------------------------------------------------------
      *
      *    Process each character.
      *
     C                   for       x = 1 to %len(i_seat)
     C                   if        %subst(i_seat:x:1) <> *blanks
      *
      *    Determine if character is a row.
      *
     C                   if        %subst(i_seat:x:1) >= '0' and
     C                             %subst(i_seat:x:1) <= '9'
     C                   eval      WKrow = *blanks
      *
     C                   dow       x  <= %len(i_seat)        and
     C                             %subst(i_seat:x:1) >= '0' and
     C                             %subst(i_seat:x:1) <= '9'
     C                   eval      WKrow = %trim(WKrow) +
     C                                     %subst(i_seat:x:1)
     C                   eval      x += 1
     C                   enddo
     C                   endif
      *
      *    Determine if character is a seat.
      *
     C                   if        x  <= %len(i_seat)        and
     C                             %subst(i_seat:x:1) >= 'A' and
     C                             %subst(i_seat:x:1) <= 'Z'
     C                   eval      AYidx        += 1
     C                   eval      AYseat(AYidx) = WKrow
     C                   eval      AYseat(AYidx) = %trim(AYseat(AYidx)) +
     C                                             %subst(i_seat:x:1)
      *
     C                   if        RightAdj
     C                   evalR     AYseat(AYidx) = %trim(AYseat(AYidx))
     C                   endif
     C                   endif
      *
     C                   endif
     C                   endfor
      *
     C                   return    AYseat
      *
      /copy qcpysrc,$PSSR
      *
     P ExtSeatAssign   E
