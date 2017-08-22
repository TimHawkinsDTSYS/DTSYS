      /TITLE Receive Journal Receiver List
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
     H COPYRIGHT('Tim Hawkins 1998') OPTION(*NOXREF)
     H DFTACTGRP(*NO) ENBPFRCOL(*FULL)
     H CVTOPT(*DATETIME:*VARCHAR) ALWNULL(*USRCTL)
      *
     FTAA132    uf   e             disk    rename(taa132:taa132r)
      *
     ITAA132r
     I              taa132                      spldta
      *
      *    Read next record.
      *
     C                   exsr      $ReadNext
      *
     C                   eval      *inLR = *on
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Read next spoolfile entry.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ReadNext     BEGSR
      * ---------------------------------------------------------
      *
      *    Read until journal receiver name found.
      *
     C                   read      taa132r
      *
     C                   dow       not %eof
     C                   delete    taa132r
     C                   if        %subst(spldta:69:10) = 'ATTACHED'    or
     C                             %subst(spldta:69:10) = 'ONLINE  '    or
     C                             %subst(spldta:69:10) = 'SAVED   '    or
     C                             %subst(spldta:69:10) = 'FREED   '    or
     C                             %subst(spldta:69:10) = 'PARTIAL '    or
     C                             %subst(spldta:69:10) = 'DELETED '
     C                   exsr      $RtnJrnRcvDta
     C                   endif
      *
     C                   read      taa132r
     C                   enddo
      * ---------------------------------------------------------
      *
      *    If not found, return blanks.
      *
     C                   eval      rtnjrnrcv  = *blanks
     C                   eval      rtnjrnrcvl = *blanks
     C                   eval      rtnattdat  = *blanks
     C                   eval      rtnsavdat  = *blanks
     C                   eval      rtnsts     = *blanks
     C                   eval      *inLR      = *on
     C                   return
      *
     CSR   #ReadNext     ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Return journal receiver data.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $RtnJrnRcvDta BEGSR
      *
     C                   eval      rtnjrnrcv  = %subst(spldta:13)
     C                   eval      rtnjrnrcvl = %subst(spldta:28)
     C                   eval      rtnattdat  = '20'                +
     C                                          %subst(spldta:49:2) +
     C                                          %subst(spldta:43:2) +
     C                                          %subst(spldta:46:2)
     C                   eval      rtnsavdat  = '20'                +
     C                                          %subst(spldta:62:2) +
     C                                          %subst(spldta:56:2) +
     C                                          %subst(spldta:59:2)
     C                   eval      rtnsts     = %subst(spldta:69)
      *
     C                   eval      *inLR = *on
     C                   return
      *
     CSR   #RtnJrnRcvDta ENDSR
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
     C                   parm                    rtnjrnrcv        10
     C                   parm                    rtnjrnrcvl       10
     C                   parm                    rtnattdat         8
     C                   parm                    rtnsavdat         8
     C                   parm                    rtnsts           10
      *
     CSR   #DEFN         ENDSR
