      /TITLE Utility, Queuing (SrvPgm)
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
      *  09/26/07  TimH        Changed to not continue the routines if there
      *                         was no text to write.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      /COPY QCPYSRC,UT8301S
      * **********************************************************
      * WrtQuema() -- Write queue master.
      * **********************************************************
     P WrtQuema        B                   Export
      *
     Fquemap01  o    e             disk    block(*no) static

     D WrtQuema        PI
     D  i_quema                            like(dfnquema) const

     D ZZusr           s                   like(StdNam) inz(*user)

     D quema           ds                  likerec(quema01r:*output) inz
      * ---------------------------------------------------------
      *
      *    Set inbound parameter.
      *
     C                   eval      quema = i_quema
      * ---------------------------------------------------------
      *
      *    Set defaults.
      *
     C                   if        quema.QMstat = *blanks
     C                   eval      quema.QMstat = 'OPN'
     C                   endif
     C                   if        quema.QMfque = *blanks
     C                   eval      quema.QMfque = ZZusr
     C                   endif
     C                   if        quema.QMtque = *blanks
     C                   eval      quema.QMtque = quema.QMfque
     C                   endif
      *
     C                   eval      quema.QMquedte = TodaysDate()
     C                   eval      quema.QMquetim = CurrentTime()
     C                   eval      quema.QMrcid   = RtvRecID('QUEMAP01')
      * ---------------------------------------------------------
      *
      *    Write the master record.
      *
     C                   write     quema01r      quema
      *
      *    Save the record ID as a global value.
      *
     C                   eval      GVquemaid   = quema.QMrcid
     C                   eval      GVquetxseqn = *zero
      *
     C                   return
      *
      /copy qcpysrc,$PSSR
      *
     P WrtQuema        E
      * **********************************************************
      * WrtQuetx() -- Write queue text.
      * **********************************************************
     P WrtQuetx        B                   Export
      *
     Fquetxp01  o    e             disk    block(*no) static
      *
     D WrtQuetx        PI
     D  i_text                             like(dfnQTtext) const
      *
     D quetx           ds                  likerec(quetx01r:*output) inz
      * ---------------------------------------------------------
      *
      *    Set record ID, and sequence from the global values.
      *
     C                   eval      GVquetxseqn += 1
      *
     C                   eval      quetx.QTrcid = GVquemaid
     C                   eval      quetx.QTseqn = GVquetxseqn
     C                   eval      quetx.QTtext = %trim(i_text)
      *
     C                   write     quetx01r      quetx
      *
     C                   return
      *
      /copy qcpysrc,$PSSR
      *
     P WrtQuetx        E
      * **********************************************************
      * WrtQuetxSeclvl() -- Write queue text from second-level.
      * **********************************************************
     P WrtQuetxSeclvl  B                   Export

     D WrtQuetxSeclvl  PI
     D  i_text                             like(seclvl)    const

     D quetx         e ds                  extname(quetxp01) inz

     D y               s                   like(StdInt)      inz
      * ---------------------------------------------------------
      *
      *    Escape if no text to write.
      *
     C                   if        i_text = *blanks
     C                   return
     C                   endif
      *
      *    Set record ID, and sequence from the global values.
      *
     C                   eval      QTrcid = GVquemaid
     C                   eval      QTseqn = GVquetxseqn
      *
      *    Extract seperate print lines.
      *
     C                   eval      d_ChrSetPrtLin =
     C                             ChrSetPrtLin(i_text:
     C                             RMchrset:%len(QTtext))
      *
      *   Write queue text record(s).
      *
     C                   for       y = 1 to AYrmklin
     C                   callp     WrtQuetx(AYrmktxt(y))
     C                   endfor
      *
     C                   return
      *
      /copy qcpysrc,$PSSR
      *
     P WrtQuetxSeclvl  E
