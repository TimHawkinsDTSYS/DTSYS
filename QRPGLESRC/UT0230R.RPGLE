      /TITLE Determine if a RCLRSC has Reclaimed this Level
      *PARMS OPTION(*NOXREF) USRPRF(*OWNER)
      *****************************************************************
      *
      *   PROGRAMMER:    TIM HAWKINS
      *   CREATION DATE: MM/DD/YY
      *   REMARKS:       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      *   REVISED:       MM/DD/YY  BY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *   REVISED DESC:                XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *                                  XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      *
      *
      ************************************************************************
      /EJECT
      *
      *
     C     EXCPGM        IFEQ      *BLANKS
     C                   MOVE      *ON           RCLRSC
     C                   MOVE      *ON           EXCPGM
     C                   ELSE
     C                   MOVE      *OFF          RCLRSC
     C                   ENDIF
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   INITIALIZE PROGRAM
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    RCLRSC            1            I/O
      *
     C     *LIKE         DEFINE    RCLRSC        EXCPGM                         I/O
      *
     CSR   #INZSR        ENDSR
