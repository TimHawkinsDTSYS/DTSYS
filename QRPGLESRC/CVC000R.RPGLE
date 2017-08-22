      /TITLE Convert Case
      *
      * P: PARMS OPTION(*NOXREF)
      *
      * S: Converts the case of the passed string into all upper              */
      * S:  case, all lower case, title case, or sentence case.               */
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *
     D uppr            C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ')
      *
     D lowr            C                   CONST('abcdefghijklmnopqrst-
     D                                     uvwxyz')
      *
      /EJECT
     C                   select
     C                   when      option = '*UPPER'
     C     lowr:uppr     xlate     String        RtnString
      *
     C                   when      option = '*LOWER'
     C     uppr:lowr     xlate     String        RtnString
      *
     C                   when      option = '*TITLE'
     C                   exsr      $Title
      *
     C                   when      option = '*SENTENCE'
     C                   exsr      $Sentence
     C                   endsl
      *
     C                   return
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Title case.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Title        BEGSR
      *
     C     uppr:lowr     xlate     String        RtnString
      *
     C                   eval      wk001a = %subst(RtnString:1:1)
     C     lowr:uppr     xlate     wk001a        wk001a
     C                   eval      %subst(RtnString:1:1) = wk001a
      *
     C                   do        1023          x
      *
     C                   if            %subst(string:x:1)    = ' '
     C                             and %subst(string:x+1:1) <> ' '
      *
     C                   eval      wk001a = %subst(string:x+1:1)
     C     lowr:uppr     xlate     wk001a        wk001a
     C                   eval      %subst(RtnString:x+1:1) = wk001a
      *
     C                   endif
     C                   enddo
      *
     CSR   #Title        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Sentence case.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Sentence     BEGSR
      *
     C     uppr:lowr     xlate     String        RtnString
      *
     C                   eval      wk001a = %subst(Rtnstring:1:1)
     C     lowr:uppr     xlate     wk001a        wk001a
     C                   eval      %subst(RtnString:1:1) = wk001a
      *
     CSR   #Sentence     ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Initial routine.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C                   clear                   wk001a            1
     C                   clear                   x                 5 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    string         1024
     C                   PARM                    RtnString      1024
     C                   PARM                    option           10
      *
     CSR   #Define       ENDSR
