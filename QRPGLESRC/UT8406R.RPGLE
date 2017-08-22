      /TITLE Utility, Date/Time edit (SrvPgm)
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
      * EdtDMfromISO - Edit alpha date DDMMM from ISO.
      ***********************************************************
     P EdtDMfromISO    B                   Export
      *
     D EdtDMfromISO    PI                  like(EdtDM  )
     D  InpISO                             like(NumISO ) value
      *
      * Standalone fields
      *
     D RtnDM           S                   like(EdtDM  ) Inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from ISO to DM.
      *
     C                   eval      AlpISO   = %editc(InpISO:'X')
     C                   eval      AlpYYYY  = %subst(AlpISO:1)
     C                   eval      AlpYY    = %subst(AlpISO:3)
     C                   eval      AlpMM    = %subst(AlpISO:5)
     C                   eval      AlpDD    = %subst(AlpISO:7)
      *
     C                   eval      AlpMMM   = AlphaMonth(Num(AlpMM))
      *
     C                   eval      AlpDM    = AlpDD + AlpMMM
     C                   return    AlpDM
      *
     P EdtDMfromISO    E
      *
      ***********************************************************
      * EdtDMYfromISO - Edit alpha date DDMMMYY from ISO.
      ***********************************************************
     P EdtDMYfromISO   B                   Export
      *
     D EdtDMYfromISO   PI                  like(EdtDMY )
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from ISO to DMY.
      *
     C                   eval      AlpISO   = %editc(InpISO:'X')
     C                   eval      AlpYYYY  = %subst(AlpISO:1)
     C                   eval      AlpYY    = %subst(AlpISO:3)
     C                   eval      AlpMM    = %subst(AlpISO:5)
     C                   eval      AlpDD    = %subst(AlpISO:7)
      *
     C                   eval      AlpMMM   = AlphaMonth(Num(AlpMM))
      *
     C                   eval      AlpDMY   = AlpDD + AlpMMM + AlpYY
     C                   return    AlpDMY
      *
     P EdtDMYfromISO   E
      *
      ***********************************************************
      * EdtDMYYfromISO - Edit alpha date DDMMMYYYY from ISO.
      ***********************************************************
     P EdtDMYYfromISO  B                   Export
      *
     D EdtDMYYfromISO  PI                  like(EdtDMYY)
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Extract date.
      *
     C                   eval      AlpISO   = %editc(InpISO:'X')
     C                   eval      AlpYYYY  = %subst(AlpISO:1)
     C                   eval      AlpYY    = %subst(AlpISO:3)
     C                   eval      AlpMM    = %subst(AlpISO:5)
     C                   eval      AlpDD    = %subst(AlpISO:7)
      *
     C                   eval      AlpMMM   = AlphaMonth(Num(AlpMM))
      *
      *   Concatenate the alpha date (ddmmmyyyy).
      *
     C                   return    AlpDD + AlpMMM + AlpYYYY
      *
     P EdtDMYYfromISO  E
      *
      ***********************************************************
      * EdtHMSfromHMS - Edit HMS from HMS.
      ***********************************************************
     P EdtHMSfromHMS   B                   Export
      *
     D EdtHMSfromHMS   PI                  like(EdtHMS )
     D  InpHMS                             like(NumHMS ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpHMS = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Edit HMS to hh:mm:ss.
      *
     C                   return    %editw(InpHMS:'  :  : 0')
      *
     P EdtHMSfromHMS   E
      *
      ***********************************************************
      * EdtHMfromHMS - Edit HM from HMS.
      ***********************************************************
     P EdtHMfromHMS    B                   Export
      *
      * Input values
      *
     D EdtHMfromHMS    PI                  like(EdtHM  )
     D  InpHMS                             like(NumHMS ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpHMS = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Edit HMS to hh:mm.
      *
     C                   eval      NumHM = InpHMS / 100
     C                   return    %editw(NumHM:'  : 0')
     C**                 moveL     InpHMS        NumHM
      *
     P EdtHMfromHMS    E
      *
      ***********************************************************
      * EdtHMfromHM  - Edit HM from HM.
      ***********************************************************
     P EdtHMfromHM     B                   Export
      *
     D EdtHMfromHM     PI                  like(EdtHM  )
     D  InpHM                              like(NumHM  ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpHM = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Edit HM to hh:mm.
      *
     C                   return    %editw(InpHM:'  : 0')
      *
     P EdtHMfromHM     E
      *
      ***********************************************************
      * EdtHMmed - Edit HM from HM and meridian.
      ***********************************************************
     P EdtHMmed        B                   Export
      *
     D EdtHMmed        PI                  like(EdtHMm )
     D  InpHM                              like(NumHM  ) value
     D  Inpmed                             like(Alpmed ) value
      *
      * Standalone fields
      *
     D RtnEdtHMm       s                   like(EdtHMm ) inz
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpHM = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Edit HM to hh:mmx.
      *
     C                   eval      RtnEdtHMm = %editw(InpHM:'  : 0') +
     C                             %xlate(uppr:lowr:Inpmed)
      *
     C                   return    RtnEdtHMm
      *
     P EdtHMmed        E
      *
      ***********************************************************
      * EdtMDYfromMDY - Edit MDY from MDY.
      ***********************************************************
     P EdtMDYfromMDY   B                   Export
      *
     D EdtMDYfromMDY   PI                  like(EdtMDY )
     D  InpMDY                             like(NumMDY ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpMDY = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Edit MDY to mm/dd/yy.
      *
     C                   return     %editw(InpMDY:'  /  / 0')
      *
     P EdtMDYfromMDY   E
      ***********************************************************
      * EdtMDYfromISO - Edit MDY from ISO.
      ***********************************************************
     P EdtMDYfromISO   B                   Export
      *
     D EdtMDYfromISO   PI                  like(EdtMDY )
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from ISO to MDY.
      *
     C                   eval      NumMDY   = CvtISOtoMDY(InpISO)
      *
      *   Edit MDY to mm/dd/yy.
      *
     C                   return    %editw(NumMDY:'  /  / 0')
      *
     P EdtMDYfromISO   E
      *
      ***********************************************************
      * EdtMDYfromYMD - Edit MDY from YMD.
      ***********************************************************
     P EdtMDYfromYMD   B                   Export
      *
     D EdtMDYfromYMD   PI                  like(EdtMDY )
     D  InpYMD                             like(NumYMD ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpYMD = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from YMD to MDY.
      *
     C                   eval      NumISO = CvtYMDtoISO(InpYMD)
     C                   eval      NumMDY = CvtISOtoMDY(NumISO)
      *
      *   Edit MDY to mm/dd/yy.
      *
     C                   return    %editw(NumMDY:'  /  / 0')
      *
     P EdtMDYfromYMD   E
      ***********************************************************
      * EdtMDfromISO - Edit MD from ISO.
      ***********************************************************
     P EdtMDfromISO    B                   Export
      *
     D EdtMDfromISO    PI                  like(EdtMD  )
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from ISO to MD.
      *
     C                   move      InpISO        NumMD
      *
      *   Edit MD to mm/dd.
      *
     C                   return    %editw(NumMD:'  / 0')
      *
     P EdtMDfromISO    E
      *
      ***********************************************************
      * EdtUSAfromISO - Edit USA from ISO.
      ***********************************************************
     P EdtUSAfromISO   B                   Export
      *
     D EdtUSAfromISO   PI                  like(EdtUSA )
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *   Test for zero value input.
      *
     C                   if        InpISO = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Convert from ISO to USA.
      *
     C                   eval      NumUSA = CvtISOtoUSA(InpISO)
      *
      *   Edit USA to mm/dd/yyyy.
      *
     C                   return     %editw(NumUSA:'  /  /   0')
      *
     P EdtUSAfromISO   E
