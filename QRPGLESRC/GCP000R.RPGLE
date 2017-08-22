      /TITLE Generate Conversion Program
      *
      * P: PARMS OPTION(*NOXREF)
      *
      * S: Generates RPG ILE program source for handling                      */
      * S:  file conversions with the capability of converting                */
      * S:  6 digit dates to 8 digit dates.                                   */
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
      *
     H DATEDIT(*YMD)
     H ALWNULL(*USRCTL)
     H CVTOPT(*DATETIME:*VARCHAR)
      *
     FQADBIFLD  IF   E           K DISK    PREFIX(n)
     FQADBIATR  IF   E           K DISK    PREFIX(o)
     F                                     RENAME(QDBifld:QDBIATR)
     FQRPGLESRC O    E             DISK
     F                                     RENAME(QRPGLESRC:RPGLE)
      *
     D FldsPrc         S                   like(nDBifld) dim(500) inz
     D FldsPrcMax      S              5  0 inz
     D Found           S               n   inz
      *
     D F1              DS
     D  F1PFX                         5    INZ('F1')
     D  F1F                           1    INZ('F')
     D  F1FILE                       10
     D  F1USE                         6    INZ('IP   E')
     D  F1FIL1                       11
     D  F1K                           1
     D  F1FIL2                        1
     D  F1DEV                         8    INZ('DISK')
     D  F1KWD                        37    INZ('PREFIX(o_)')
      *
     D F2              DS
     D  F2PFX                         5    INZ('F2')
     D  F2F                           1    INZ('F')
     D  F2FILE                       10
     D  F2USE                         6    INZ('O    E')
     D  F2FIL1                       13
     D  F2DEV                         8    INZ('DISK')
     D  F2KWD                        37    INZ('PREFIX(n_)')
      *
     D F3              DS
     D  F3PFX                         5    INZ('F2')
     D  F3F                           1    INZ('F')
     D  F3FIL1                       37
     D  F3KWD                         7    INZ('RENAME(')
     D  F3FMT                        10
     D  F3NFM                        10    INZ(':NEWREC)')
      *
     D C1              DS
     D  C1PFX                         5    INZ('C1')
     D  C1C                           1    INZ('C')
     D  C1FIL1                        5
     D  C1FAC1                       14
     D  C1OP                         10
     D  C1FAC2                       14
     D  C1RES                        14
     D  C1LEN                         5
     D  C1DEC                         2
     D  C1HI                          2
     D  C1LO                          2
     D  C1EQ                          2
     D  C1FIL2                        4
     D  C1COM                        20
      *
     D C2              DS
     D  C2PFX                         5    INZ('C2')
     D  C2C                           1    INZ('C')
     D  C2FIL                        19
     D  C2OP                         10
     D  C2FAC                        45
     D  C2COM                        20
      *
     D nDBIDFT         DS
     D  NLEN                          2B 0
     D  NVAL                       2000
      *
     D nDBITXT         DS
     D  N2LEN                         2B 0
     D  N2TXT                        50
      *
     D X1              DS
     D  X1PFX                         6    INZ('X1')
     D  X1STAR                        1    INZ('*')
     D  X1DSP                         1
     D  X1COM                        92
      *
     D uppr            C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ')
      *
     D lowr            C                   CONST('abcdefghijklmnopqrst-
     D                                     uvwxyz')
      *
      *    Setup to of source.
      *
     C                   exsr      $SetTopSource
      *
      *    Write field text.
      *
     C                   dou       %eof(QADBifld)
      *
     C                   eval      X1COM = N2txt
     C                   eval      SRCDTA = X1
     C                   exsr      $Write
      *
      *    Store field name processed.
      *
     C                   eval      FldsPrcMax = FldsPrcMax + 1
     C                   eval      FldsPrc(FldsPrcMax) = nDBifld
      *
      *    Convert to lower case.
      *
     C     uppr:lowr     xlate     N2txt         N2txt
      *
      *    Retrieve new description.
      *
     C     OldFileKey    chain     QADBiatr
     C                   IF        %found
     C     nDBIITP       CASEQ     'P'           $Numeric
     C     nDBIITP       CASEQ     'S'           $Numeric
     C     nDBIITP       CASEQ     'B'           $Numeric
     C     nDBITYP       CASEQ     'CHAR'        $MoveIt
     C     nDBIITP       CASEQ     'L'           $MoveIt
     C     nDBIITP       CASEQ     'T'           $MoveIt
     C     nDBIITP       CASEQ     'Z'           $MoveIt
     C     nDBITYP       CASEQ     'VARCHAR'     $MoveIt
     C                   ENDCS
     C                   else
     C                   reset                   C1
     C                   eval      C1OP = 'clear'
     C                   eval      C1RES = 'n_' + nDBifld
     C                   eval      SRCDTA = C1
     C                   exsr      $Write
     C                   ENDIF
      *
     C     NewFileKey    READE     QADBifld
     C                   enddo
      *
      *    Fields dropped.
      *
     C                   exsr      $FieldsDropped
      *
      *    Write the record.
      *
     C                   reset                   C1
     C                   eval      C1OP   = 'write'
     C                   eval      C1FAC2 = 'newrec'
     C                   eval      SRCDTA = C1
     C                   exsr      $Write
      *
     C                   eval      *inLR = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Same type.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $MoveIt       BEGSR
      *
     C                   reset                   C2
     C                   eval      C2OP = 'eval'
     C                   eval      C2FAC = 'n_' + nDBifld
     C                                + ' = o_' + oDBifld
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
     CSR                 ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Numeric fields.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Numeric      BEGSR
      *
      *    No date handling or not a date field.
      *
     C                   if        dtehdl    = '*NONE'
     C                             or  (%scan('date':N2txt) = *zero
     C                              and %scan('year':N2txt) = *zero)
     C                   exsr      $MoveIt
     C                   else
      *
      *    Date handling specified, do it.
      *
     C                   reset                   C2
     C                   eval      C2OP  = 'if'
     C                   eval      C2FAC = 'o_' + oDBifld + ' <> *zero'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
      *                  Date field: add the century.
      *
     C                   if        dtehdl    = '*Y2K'
     C                   reset                   C2
     C                   eval      C2OP  = 'eval'
     C                   if            %scan('date':N2txt) > *zero
     C                   eval      C2FAC = 'n_' + oDBifld + ' = ' +
     C                                     'o_' + oDBifld + ' + 19000000'
     C                   else
     C                   eval      C2FAC = 'n_' + oDBifld + ' = ' +
     C                                     'o_' + oDBifld + ' + 1900'
     C                   endif
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
     C                   endif
      *
      *                  Date field: window the date/year.
      *
     C                   if        dtehdl    = '*Y2KTST'
     C                             and %scan('date':N2txt) > *zero
     C                   exsr      $dtehdl_date
     C                   endif
      *
     C                   if        dtehdl    = '*Y2KTST'
     C                             and %scan('year':N2txt) > *zero
     C                   exsr      $dtehdl_year
     C                   endif
      *
     C                   reset                   C2
     C                   eval      C2OP   = 'endif'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
     C                   endif
      *
     CSR                 ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Test mode for dates (97=1999, 98=2000, 99=2001)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $dtehdl_date  BEGSR
      *
      *    Place current value.
      *
     C                   exsr      $MoveIt
      *
      *    Append correct year (97=1999, 98=2000, 99=2001)
      *
     C                   reset                   C2
     C                   eval      C2OP  = 'select'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
      *    99=2001
     C                   reset                   C2
     C                   eval      C2OP  = 'when'
     C                   eval      C2FAC = 'o_' + oDBifld + ' >= 990101'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
     C                   reset                   C1
     C                   eval      C1OP   = 'moveL'
     C                   eval      C1FAC2 = '''2001'''
     C                   eval      C1RES  = 'n_' + oDBifld
     C                   eval      SRCDTA = C1
     C                   exsr      $Write
      *
      *    98=2000
     C                   reset                   C2
     C                   eval      C2OP  = 'when'
     C                   eval      C2FAC = 'o_' + oDBifld + ' >= 980101'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
     C                   reset                   C1
     C                   eval      C1OP   = 'moveL'
     C                   eval      C1FAC2 = '''2000'''
     C                   eval      C1RES  = 'n_' + oDBifld
     C                   eval      SRCDTA = C1
     C                   exsr      $Write
      *
      *    97=1999
     C                   reset                   C2
     C                   eval      C2OP  = 'when'
     C                   eval      C2FAC = 'o_' + oDBifld + ' >= 970101'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
     C                   reset                   C1
     C                   eval      C1OP   = 'moveL'
     C                   eval      C1FAC2 = '''1999'''
     C                   eval      C1RES  = 'n_' + oDBifld
     C                   eval      SRCDTA = C1
     C                   exsr      $Write
      *
      *    96=1998
     C                   reset                   C2
     C                   eval      C2OP  = 'when'
     C                   eval      C2FAC = 'o_' + oDBifld + ' >= 960101'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
     C                   reset                   C1
     C                   eval      C1OP   = 'moveL'
     C                   eval      C1FAC2 = '''1998'''
     C                   eval      C1RES  = 'n_' + oDBifld
     C                   eval      SRCDTA = C1
     C                   exsr      $Write
      *
      *    95=1995, 94=1994, 93=1993...
     C                   reset                   C2
     C                   eval      C2OP  = 'other'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
     C                   reset                   C1
     C                   eval      C1OP   = 'moveL'
     C                   eval      C1FAC2 = '''19'''
     C                   eval      C1RES  = 'n_' + oDBifld
     C                   eval      SRCDTA = C1
     C                   exsr      $Write
      *
     C                   reset                   C2
     C                   eval      C2OP   = 'endsl'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
     CSR   #dtehdl_date  ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Test mode for dates (97=1999, 98=2000, 99=2001)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $dtehdl_year  BEGSR
      *
      *    Place current value.
      *
     C                   exsr      $MoveIt
      *
      *    Append correct year (97=1999, 98=2000, 99=2001)
      *
     C                   reset                   C2
     C                   eval      C2OP  = 'select'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
      *    98/99=20xx
      *
     C                   reset                   C2
     C                   eval      C2OP  = 'when'
     C                   eval      C2FAC = 'o_' + oDBifld + ' >= 98'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
     C                   reset                   C1
     C                   eval      C1OP   = 'moveL'
     C                   eval      C1FAC2 = '''20'''
     C                   eval      C1RES  = 'n_' + oDBifld
     C                   eval      SRCDTA = C1
     C                   exsr      $Write
      *
      *    97/96/95/94/93=19xx...
      *
     C                   reset                   C2
     C                   eval      C2OP  = 'other'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
     C                   reset                   C1
     C                   eval      C1OP   = 'moveL'
     C                   eval      C1FAC2 = '''19'''
     C                   eval      C1RES  = 'n_' + oDBifld
     C                   eval      SRCDTA = C1
     C                   exsr      $Write
      *
     C                   reset                   C2
     C                   eval      C2OP   = 'endsl'
     C                   eval      SRCDTA = C2
     C                   exsr      $Write
      *
     CSR   #dtehdl_year  ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Write source line.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Write        BEGSR
      *
     C                   eval      srcseq = srcseq + 1
     C                   write     RPGLE
      *
     CSR   #Write        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Initial routine.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   eval      SRCDAT = UDATE
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Setup top of source.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $SetTopSource BEGSR
      *
     C                   eval      SRCDTA = '      *CMDBFR +
     C                                       OVRDBF FROMFILE ' +
     C                                       %trim(fromfilelib) +
     C                                       '/' + fromfile
     C                   exsr      $Write
      *
     C                   eval      SRCDTA = '      *CMDBFR +
     C                                       OVRDBF TOFILE   ' +
     C                                       %trim(tofilelib) +
     C                                       '/' + tofile
     C                   exsr      $Write
      *
     C                   if        Hspec <> '*NONE'
     C                   eval      SRCDTA = Hspec
     C                   exsr      $Write
     C                   endif
      *
     C                   eval      F1FILE = 'FROMFILE'
     C                   eval      SRCDTA = F1
     C                   exsr      $Write
      *
     C                   eval      F2FILE = 'TOFILE'
     C                   eval      SRCDTA = F2
     C                   exsr      $Write
      *
     C     NewFileKey    CHAIN     QADBifld
     C                   eval      F3FMT = nDBIFMT
     C                   eval      SRCDTA = F3
     C                   exsr      $Write
      *
     C                   eval      C1OP   = 'reset'
     C                   eval      C1RES  = 'newrec'
     C                   eval      SRCDTA = C1
     C                   exsr      $Write
      *
     CSR   #SetTopSource ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Fields dropped.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $FieldsDroppedBEGSR
      *
     C                   eval      X1COM = 'Fields dropped --------------'
     C                   eval      SRCDTA = X1
     C                   exsr      $Write
      *
     C     OldFileKey5   setll     QADBiatr
     C     OldFileKey5   reade     QADBiatr
      *
     C                   dow       not %eof
     C                   eval      found = *off
      *
     C                   do        FldsPrcMax    x
     C                   if        oDBifld = FldsPrc(x)
     C                   eval      found = *on
     C                   leave
     C                   endif
     C                   enddo
      *
     C                   if        not found
     C                   eval      X1COM = 'Field ' + oDBifld + ' dropped.'
     C                   eval      SRCDTA = X1
     C                   exsr      $Write
     C                   endif
      *
     C     OldFileKey5   reade     QADBiatr
     C                   enddo
      *
     CSR   #FieldsDroppedENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C                   clear                   x                 5 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    fromfile         10
     C                   PARM                    fromfilelib      10
     C                   PARM                    tofile           10
     C                   PARM                    tofilelib        10
     C                   PARM                    dtehdl           10
     C                   PARM                    Hspec            80
      *
     C     NewFileKey    KLIST
     C                   KFLD                    tofilelib
     C                   KFLD                    tofile
      *
     C     OldFileKey5   KLIST
     C                   KFLD                    nDBiatr
     C                   KFLD                    fromfilelib
     C                   KFLD                    fromfile
     C                   KFLD                    nDBifmp
     C                   KFLD                    nDBifmt
      *
     C     OldFileKey    KLIST
     C                   KFLD                    nDBiatr
     C                   KFLD                    fromfilelib
     C                   KFLD                    fromfile
     C                   KFLD                    nDBifmp
     C                   KFLD                    nDBifmt
     C                   KFLD                    nDBifld
      *
     CSR   #Define       ENDSR
