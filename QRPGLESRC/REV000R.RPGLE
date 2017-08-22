      /TITLE Retrieve Environment Variable
      *
      * P: PARMS OPTION(*NOXREF) USRPRF(*OWNER) AUT(*ALL)
      *
      * S:
      *
      * C: T.HAWKINS   07/08/93
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
     H OPTION(*NODEBUGIO:*SRCSTMT) DFTACTGRP(*NO) BNDDIR('QC2LE')
      *
     D dummy           DS
     D  nLen                          5I 0
     D  Data                      32766A
      *
     D Qp0zGetEnv      PR              *   ExtProc('Qp0zGetEnv')
     D  envvar                         *   VALUE OPTIONS(*STRING)
     D  nCCSID                       10I 0
      *
     D  pEnv           S               *   Inz
     D  nCCSID         S             10I 0 Inz(0)
      *
     C                   eval      pEnv =
     C                             Qp0zGetEnv(%trimr(envvar):nCCSID)
      *
     C                   if        pEnv <> *NULL
     C                   eval      %subst(Data:1:nLen) = %str(pEnv)
     C                   eval      rtnvar = data
     C                   endif
      *
     C                   eval      *inLR = *on
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *entry        plist
     C                   parm                    envvar          128
     C                   parm                    rtnvar         1024
      *
     CSR   #Define       ENDSR
