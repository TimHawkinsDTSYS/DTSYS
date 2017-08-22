      /TITLE Utility, Pax Array (SrvPgm)
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
      ***********************************************************
      * Set passenger array.
      ***********************************************************
     P SetPaxAry       B                   Export
      *
     D SetPaxAry       PI                  like(BLpary)
     D  WPpary                             like(BLpary) value
     D  WPpcnt                             like(BMpcnt) value
      *
      *  Data structures for definitions only.
      *
     D bkgma         e ds                  extname(bkgmap01) based(StdNulPtr)
     D bkgls         e ds                  extname(bkglsp01) based(StdNulPtr)
      *
     D  Idx            s                   like(StdInt) inz
     D  WKpary         s                   like(BLpary) inz
      * ---------------------------------------------------------
      *
      *    Insert position indicator for each passenger.
      *
     C                   if        WPpary  = *blanks and
     C                             WPpcnt <= 8
     C                   for       idx = 1 to WPpcnt
     C                   eval      %subst(WPpary:idx:1) = %char(idx)
     C                   endfor
     C                   endif
      * ---------------------------------------------------------
      *
      *    Assure that the number corresponds with the position.
      *
     C                   eval      WKpary = *blanks
      *
     C                   if            WPpary <> *blanks
     C                             and WPpcnt <= 8
     C                             and WPpary <> 'GROUP'
      *
     C                   for       idx = 1 to 8
     C                   if        %scan(%trim(%editc(idx:'Z')):WPpary)
     C                             <> *zero
     C                   eval      %subst(WKpary:idx:1) = %char(idx)
     C                   endif
     C                   endfor
      *
     C                   eval      WPpary = WKpary
     C                   endif
      * ---------------------------------------------------------
      *
      *    Group booking, set to group.
      *
     C                   if        WPpcnt > 8
     C                   eval      WPpary = 'GROUP'
     C                   endif
      *
     C                   return    WPpary
      *
     P SetPaxAry       E
      ***********************************************************
      * Edit passenger array.
      ***********************************************************
     P EdtPaxAry       B                   Export
      *
     D EdtPaxAry       PI                  like(msgid)
     D  WKpary                             like(BLpary) value
     D  WKpcnt                             like(BMpcnt) value
      *
      *  Data structures for definitions only.
      *
     D bkgma         e ds                  extname(bkgmap01) based(StdNulPtr)
     D bkgls         e ds                  extname(bkglsp01) based(StdNulPtr)
      *
     D  NamAry         s                   like(WKpary)
     D  Idx            s                   like(StdInt)
      * ---------------------------------------------------------
      *
      *    If already set to GROUP ignore.
      *
     C                   if        WKpary = 'GROUP'
     C                   return    *blanks
     C                   endif
      *
      *    Check for proper values in array.
      *
     C                   if        %check(' 12345678':WKpary) <> *zero
     C                   return    'RES0066'
     C                   endif
      *
      *    If more than 8 passengers, array is not valid.
      *
     C                   if        WKpary <> *blanks  and
     C                             WKpcnt  > 8
     C                   return    'RES0222'
     C                   endif
      *
      *    Set passengers in booking into an array.
      *
     C                   eval      NamAry = SetPaxAry(NamAry:WKpcnt)
      *
      *    Compare name arrays.
      *
     C                   do        8             idx
     C                   if        %subst(WKpary:idx:1) <> *blanks and
     C                             %subst(NamAry:idx:1)  = *blanks
     C                   return    'RES0060'
     C                   endif
     C                   enddo
      *
     C                   return    *blanks
      *
     P EdtPaxAry       E
      ***********************************************************
      * Count passenger array.
      ***********************************************************
     P CntPaxAry       B                   Export
      *
     D CntPaxAry       PI                  like(BLpcnt)
     D  WPpary                             like(BLpary) value
     D  WPpcnt                             like(BMpcnt) value
      *
      *  Data structures for definitions only.
      *
     D bkgma         e ds                  extname(bkgmap01) based(StdNulPtr)
     D bkgls         e ds                  extname(bkglsp01) based(StdNulPtr)
      *
     D  Idx            s                   like(StdInt) inz
     D  WKpary         s                   like(StdChr) inz dim(8)
     D  WKpcnt         s                   like(BLpcnt) inz
      * ---------------------------------------------------------
      *
     C                   moveA     WPpary        WKpary
     C                   eval      WKpcnt      = *zero
      *
      *    Count number of passengers assigned to segment.
      *
     C                   if        WPpary  = *blanks or
     C                             WPpcnt  > 8
     C                   return    WPpcnt
     C                   endif
      *
     C                   for       idx = 1 to WPpcnt
     C                   if        WKpary(idx) <> *blanks
     C                   eval      WKpcnt += 1
     C                   endif
     C                   endfor
      *
     C                   return    WKpcnt
      *
     P CntPaxAry       E
      ***********************************************************
      * Cleanup passenger array.
      ***********************************************************
     P ClnPaxAry       B                   Export
      *
     D ClnPaxAry       PI                  like(BLpary)
     D  WPpary                             like(BLpary) value
     D  WPpcnt                             like(BMpcnt) value
      *
      *  Data structures for definitions only.
      *
     D bkgma         e ds                  extname(bkgmap01) based(StdNulPtr)
     D bkgls         e ds                  extname(bkglsp01) based(StdNulPtr)
      *
     D  WKpary         s                   like(BLpary) inz
      * ---------------------------------------------------------
      *
     C                   if        WPpary = *blanks
     C                   eval      WKpary = *blanks
     C                   else
     C                   eval      WKpary = SetPaxAry(WPpary:WPpcnt)
     C                   endif
      *
     C                   return    WKpary
      *
     P ClnPaxAry       E
      ***********************************************************
      * Check passenger array for entry.
      ***********************************************************
     P ChkPary         B                   Export
      *
     D ChkPary         PI                  like(StdInd)
     D  PLpseq                             like(DFNpnpseq) value
     D  PLpary                             like(DFNblpary) value
      * ---------------------------------------------------------
      *
      *    Check passenger array for entry.
      *
     C                   if        PLpseq                  <= *zero   or
     C                             PLpseq                   > 8       or
     C                             PLpary                   = *blanks or
     C                             %subst(PLpary:PLpseq:1) <> *blanks
     C                   return    *on
     C                   else
     C                   return    *off
     C                   endif
      *
     P ChkPary         E
