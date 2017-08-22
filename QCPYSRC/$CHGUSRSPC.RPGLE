      /IF DEFINED($CHGUSRSPC_copied)
      /EOF
      /ELSE
      /DEFINE $CHGUSRSPC_copied
      /ENDIF
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Change User Space.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ChgUsrSpc    BEGSR
      *
      *    Default to library list.
      *
     C     USspclib      ifeq      *blanks                                      AIR
     C                   eval      USspclib = '*LIBL'
     C                   endif
      *
      *    Default start position to 1
      *
     C     USstrpos      ifeq      *blanks                                      AIR
     C                   eval      USstrpos = x'00000001'
     C                   endif
      *
      *    Default data length to 32,767
      *
     C     USdtalen      ifeq      *blanks                                      AIR
     C                   eval      USdtalen = x'00008000'
     C                   endif
      *
      *    Default force to no.
      *
     C     USfrcdsk      ifeq      *blanks                                      AIR
     C                   eval      USfrcdsk = *off
     C                   endif
      *
      *    Define space name and library.
      *
     C                   move      USspcnam      USspcnam         10
     C                   move      USspclib      USspclib         10
      *
      *    Setup qualified name.
      *
     C                   movel     USspcnam      USspcnam20
     C                   move      USspclib      USspcnam20
      *
      *    Change user space.
      *
     C                   call      'QUSCHGUS'                                   ADJUSTMENTS
     C                   parm                    USspcnam20       20
     C                   parm                    USstrpos          4
     C                   parm                    USdtalen          4
     C                   parm                    USdta         32767
     C                   parm                    USfrcdsk          1
     C                   parm      x'00000000'   USerrcde          4
      *
     CSR   #ChgUsrSpc    ENDSR
