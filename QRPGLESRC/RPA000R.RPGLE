      /TITLE Retrieve Physical File Attributes
      *
      * P: PARMS
      *
      * S:
      *
      * C: 91/12/03  RCTHAWK
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      /copy qcpysrc,Hspec
      *
     Fqafdmbr   if   e             disk
     Fqafdphy   if   e             disk
      *
     D ctldj         e ds                  extname(ctldjp01) inz
      *
     D P_dbfn          s                   like(DJdbfn)
     D P_dbln          s                   like(DJdbln)
     D P_jrnnam        s                   like(DJjrnnam)
     D P_jrnlib        s                   like(DJjrnlib)
     D P_jrnact        s                   like(DJjrnact)
     D P_jrnimg        s                   like(DJjrnimg)
     D P_jrnomt        s                   like(DJjrnomt)
     D P_jrndte        s                   like(DJjrndte)
     D P_nbrmbr        s                   like(DJnbrmbr)
     D P_rcdlen        s                   like(DJrcdlen)
     D P_currcd        s                   like(DJcurrcd)
     D P_dltrcd        s                   like(DJdltrcd)
     D P_opnclo        s                   like(DJopnclo)
     D P_rcdred        s                   like(DJrcdred)
     D P_rcdupd        s                   like(DJrcdupd)
     D P_crtdte        s                   like(DJcrtdte)
     D P_lusdte        s                   like(DJlusdte)
     D P_resdte        s                   like(DJresdte)
     D P_frcrat        s                   like(DJfrcrat)
     D P_usedlt        s                   like(DJusedlt)
     D P_text          s                   like(StdTxt)
      *
     D WKdateYMD       ds                  qualified inz
     D  YY                            2  0
     D  MM                            2  0
     D  DD                            2  0
      *
     D WKdateISO       ds                  qualified inz
     D  CC                            2  0 inz(20)
     D  YY                            2  0
     D  MM                            2  0
     D  DD                            2  0
      *
     D WKdateISOn      s                   like(NumISO)
      *
      /copy qcpysrc,Dspec
      * ---------------------------------------------------------
      *
      *    Process the returned data.
      *
     C                   exsr      $ProcRtn
      *
     C                   eval      *inLR = *on
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Process the returned data.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ProcRtn      BEGSR
      * ---------------------------------------------------------
      *
      *    Retrieve DSPFD records.
      *
     C                   read      Qwhfdmbr
     C                   read      qwhfdphy
     C                   if        %eof(qafdmbr) or
     C                             %eof(qafdphy)
     C                   leavesr
     C                   endif
      * ---------------------------------------------------------
      *    Various.
      *
     C                   eval      P_dbfn     = MBfile
     C                   eval      P_dbln     = MBlib
     C                   eval      P_nbrmbr   = MBnomb
     C                   eval      P_rcdlen   = MBmxrl
     C                   eval      P_currcd   = MBnrcd
     C                   eval      P_dltrcd   = MBndtr
     C                   eval      P_rcdred   = MBlrds + MBprds
     C                   eval      P_rcdupd   = MBwrop + MBupop + MBdlop
      *
     C                   if        MBfcdt = *blanks
     C                   eval      MBfcdt = *zero
     C                   endif
      *
     C                   monitor
     C                   eval      WKdateYMD    = MBfcdt
     C                   eval      WKdateISO.YY = WKdateYMD.YY
     C                   eval      WKdateISO.MM = WKdateYMD.MM
     C                   eval      WKdateISO.DD = WKdateYMD.DD
     C                   move      WKdateISO     WKdateISOn
     C                   eval      P_crtdte     = WKdateISOn
     C                   on-error
     C                   eval      P_crtdte     = *zero
     C                   endmon
      *
     C                   if        MBudat = *blanks
     C                   eval      MBudat = *zero
     C                   endif
      *
     C                   monitor
     C                   eval      WKdateYMD    = MBudat
     C                   eval      WKdateISO.YY = WKdateYMD.YY
     C                   eval      WKdateISO.MM = WKdateYMD.MM
     C                   eval      WKdateISO.DD = WKdateYMD.DD
     C                   move      WKdateISO     WKdateISOn
     C                   eval      P_lusdte     = WKdateISOn
     C                   on-error
     C                   eval      P_lusdte     = *zero
     C                   endmon
      *
     C                   if        MBtdat = *blanks
     C                   eval      MBtdat = *zero
     C                   endif
      *
     C                   monitor
     C                   eval      WKdateYMD    = MBtdat
     C                   eval      WKdateISO.YY = WKdateYMD.YY
     C                   eval      WKdateISO.MM = WKdateYMD.MM
     C                   eval      WKdateISO.DD = WKdateYMD.DD
     C                   move      WKdateISO     WKdateISOn
     C                   eval      P_resdte     = WKdateISOn
     C                   on-error
     C                   eval      P_resdte     = *zero
     C                   endmon
      *
     C                   eval      P_text     = MBtxt
      *
     C                   select
     C                   when      MBfrcr     = *zero
     C                   eval      P_frcrat   = '*NONE'
      *
     C                   other
     C                   eval      P_frcrat   = %char(MBfrcr)
     C                   endsl
      *
     C                   select
     C                   when      PHruse     = 'Y'
     C                   eval      P_usedlt   = '*YES'
      *
     C                   when      PHruse     = 'N'
     C                   eval      P_usedlt   = '*NO'
     C                   endsl
      * ---------------------------------------------------------
      *
      *    Journaling.
      *
     C                   eval      P_jrnnam   = MBjrnm
     C                   eval      P_jrnlib   = MBjrlb
      *
     C                   select
     C                   when      MBjrnl     = 'Y'
     C                   eval      P_jrnact   = '*YES'
      *
     C                   when      MBjrnl     = 'N'
     C                   eval      P_jrnact   = '*NO'
     C                   endsl
      *
     C                   select
     C                   when      MBjrim     = 'A'
     C                   eval      P_jrnimg   = '*AFTER'
      *
     C                   when      MBjrim     = 'B'
     C                   eval      P_jrnimg   = '*BOTH'
     C                   endsl
      *
     C                   select
     C                   when      MBjrom     = 'O'
     C                   eval      P_jrnomt   = '*OPNCLO'
      *
     C                   when      MBjrom     = 'N'
     C                   eval      P_jrnomt   = '*NONE'
     C                   endsl
      *
     C                   if        MBjrsd = *blanks
     C                   eval      MBjrsd = *zero
     C                   endif
      *
     C                   monitor
     C                   eval      WKdateYMD    = MBjrsd
     C                   eval      WKdateISO.YY = WKdateYMD.YY
     C                   eval      WKdateISO.MM = WKdateYMD.MM
     C                   eval      WKdateISO.DD = WKdateYMD.DD
     C                   move      WKdateISO     WKdateISOn
     C                   eval      P_jrndte     = WKdateISOn
     C                   on-error
     C                   eval      P_jrndte     = *zero
     C                   endmon
      *
     C                   eval      *inLR = *on
     C                   return
      *
     CSR   #PrcRtn       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *entry        plist
     C                   parm                    P_dbfn
     C                   parm                    P_dbln
     C                   parm                    P_jrnnam
     C                   parm                    P_jrnlib
     C                   parm                    P_jrnact
     C                   parm                    P_jrnimg
     C                   parm                    P_jrnomt
     C                   parm                    P_jrndte
     C                   parm                    P_nbrmbr
     C                   parm                    P_rcdlen
     C                   parm                    P_currcd
     C                   parm                    P_dltrcd
     C                   parm                    P_opnclo
     C                   parm                    P_rcdred
     C                   parm                    P_rcdupd
     C                   parm                    P_crtdte
     C                   parm                    P_lusdte
     C                   parm                    P_resdte
     C                   parm                    P_frcrat
     C                   parm                    P_usedlt
     C                   parm                    P_text
      *
     CSR   #DEFN         ENDSR
