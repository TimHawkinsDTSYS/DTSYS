      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Add Dots to Text.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $AddDotTxt    BEGSR
      *
     C     *LIKE         DEFINE    AddDotTxt     Dots                           LEFT CHAR
     C     *LIKE         DEFINE    AddDotTxt     DotWork                        LEFT CHAR
     C                   MOVE      *ALL' .'      DotWork                        LEFT CHAR
      *
     C     ' '           CHECKR    AddDotTxt     AddDots           5 0          LEFT CHAR
     C                   ADD       1             AddDots                        LEFT CHAR
      *
     C                   EVAL      %SUBST(DotWork:1:AddDots) =                  LEFT CHAR
     C                             %SUBST(AddDotTxt:1:AddDots)                  LEFT CHAR
      *
     C                   MOVE      DotWork       AddDotTxt       256            LEFT CHAR
      *
     CSR   #AddDotTxt    ENDSR
