      /TITLE Display Bulletin Board
      *PARMS OPTION(*NOXREF)
      *---------------------------------------------------------------
      * Description : Display Bulletin Board
      * Author      : Tim Hawkins
      * Date        : 10/01/97
      * Synopsis    : Allows for display of bulletin board information
      *               member.
      *
      * Notes       :
      * --------------------------------------------------------------
      * Modified Programmer Description
      * DD/MM/YY xxxxxxxxxx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *---------------------------------------------------------------
      /EJECT
      *
      *
     FDBB000D   CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:CurSflRcd)
     FSYSBBD    IF   E             DISK    USROPN
     F                                     RENAME(SYSBBD:SYSBBDR)
      *
      /EJECT
      *
     C                   EXSR      $Main
     C                   MOVE      *ON           *INLR
      *
     C                   RETURN
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Main routine.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Main         BEGSR
      *
      *    Load the subfile with DB records.
      *
     C                   EXSR      $LodDBrcd
      *
      *    Display the screen until exit.
      *
     C     DspBBD        IFEQ      *ON
     C                   EXSR      $DspScreen
     C                   ENDIF
      *
      *    Process user PF keys.
      *
     C                   EXSR      $PrcUsrKey
      *
     CSR   #Main         ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Display the screen.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DspScreen    BEGSR
      *
     C                   WRITE     #CLRSCN
     C                   WRITE     #MSGCTL
     C                   WRITE     #PFKEYS
     C                   EXFMT     #SFLCTL
      *
     CSR   #DspScreen    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Load DB records into subfile.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $LodDBrcd     BEGSR
      *
     C                   OPEN      SYSBBD
      *
     C     *IN52         DOUEQ     *ON
     C                   READ      SYSBBDR                                52
      *
     C     *IN52         IFEQ      *OFF
     C     SRCDTA        IFNE      *BLANKS
     C                   MOVE      *ON           DspBBD
     C                   ENDIF
      *
     C                   MOVEL(P)  SRCDTA        SRCDTA75
     C                   ADD       1             CurSflRcd
     C                   WRITE     #SFLRCD
     C                   ENDIF
     C                   ENDDO
      *
     C                   CLOSE     SYSBBD
      *
     CSR   #LodDBrcd     ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Process user PF keys.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PrcUsrKey    BEGSR
      *
      *    Process F3=Exit.
      *
     C     *INKC         IFEQ      *ON
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
      *    Process F12=Cancel.
      *
     C     *INKL         IFEQ      *ON
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     CSR   #PrcUsrKey    ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *OFF          Error             1
     C                   MOVE      *OFF          DspBBD            1
     C                   MOVEL     '*'           ZZPGM
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C                   CLEAR                   X                 5 0
     C                   CLEAR                   CurSflRcd         5 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    MBR
      *
     CSR   #Define       ENDSR
