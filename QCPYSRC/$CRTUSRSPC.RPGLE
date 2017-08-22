      /IF DEFINED($CRTUSRSPC_copied)
      /EOF
      /ELSE
      /DEFINE $CRTUSRSPC_copied
      /ENDIF
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Create User Space.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CrtUsrSpc    BEGSR
      *
      *    Default to library list.
      *
     C     USspclib      ifeq      *blanks                                      AIR
     C                   eval      USspclib = '*LIBL'
     C                   endif
      *
      *    Default size to 32,767
      *
     C     USinlsiz      ifeq      *blanks                                      AIR
     C                   eval      USinlsiz = x'00008000'
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
      *    Create user space.
      *
     C                   call      'QUSCRTUS'                                   ADJUSTMENTS
     C                   parm                    USspcnam20       20
     C                   parm                    USextatr         10
     C                   parm                    USinlsiz          4
     C                   parm      x'00'         USinlval          1
     C                   parm      '*LIBCRTAUT'  USpubaut         10
     C                   parm                    UStext           50
     C                   parm      '*YES'        USreplace        10
     C                   parm      x'00000000'   USerrcde          4
      *
     CSR   #CrtUsrSpc    ENDSR
