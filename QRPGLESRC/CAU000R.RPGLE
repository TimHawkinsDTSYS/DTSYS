      /TITLE Copy Application User
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  01/08/97  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,Hspec
      *
      *
     FAPP100P   IF A E           K DISK
     FAPP110P   IF A E           K DISK
     FDUB000P   IF A E           K DISK
      *
      /copy qcpysrc,Dspec
      *
     C                   EXSR      $ChkUsr
      *
      *    Create the new user as it has not been setup yet.
      *
     C                   EXSR      $CrtUsr
     C                   EXSR      $UsrInf
     C                   EXSR      $UsrBbd
      *
     C                   MOVE      'DTC0001'     MSGID
     C                   MOVEL     NEWUSR        MSGDTA
     C                   MOVEL     '*PRV'        TOREL
     C                   EXSR      $PMSND
     C                   MOVE      *ON           *INLR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Check the users.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ChkUsr       BEGSR
      *
     C     CPYUSR        SETLL     APP110R                                99
     C     *IN99         IFEQ      *OFF
     C                   MOVE      'DTD0288'     MSGID
     C                   MOVEL     CPYUSR        MSGDTA
     C                   MOVEL     '*PRV'        TOREL
     C                   MOVEL     '*COMP'       MSGTYP
     C                   EXSR      $PMSND
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C     NEWUSR        SETLL     APP110R                                99
     C     *IN99         IFEQ      *On
     C                   MOVE      'DTD0289'     MSGID
     C                   MOVEL     NEWUSR        MSGDTA
     C                   MOVEL     '*PRV'        TOREL
     C                   MOVEL     '*COMP'       MSGTYP
     C                   EXSR      $PMSND
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     CSR   #ChkUsr       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Insert User Data into File APP100P.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $CrtUsr       BEGSR
      *
     C     CPYUSR        SETLL     APP100R
      *
     C     *IN99         DOUEQ     *ON
     C     CPYUSR        READE     APP100R                                99
     C     *IN99         IFEQ      *OFF
     C                   MOVE      NEWUSR        AUUSER
     C                   WRITE     APP100R
     C                   ENDIF
     C                   ENDDO
      *
     CSR   #CrtUsr       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Insert User Information into APP110P.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $UsrInf       BEGSR
      *
     C     NEWUSR        SETLL     APP110R                                99
     C     *IN99         IFEQ      *OFF
      *
     C     CPYUSR        CHAIN     APP110R                            99
     C     *IN99         IFEQ      *OFF
     C                   MOVE      NEWUSR        AIUSER
     C                   MOVEL     USRNAM        AINAME
     C                   CLEAR                   AIOUTP
     C                   CLEAR                   AITIEP
     C                   CLEAR                   AICITY
     C                   CLEAR                   AIUPDD
     C                   WRITE     APP110R
     C                   ENDIF
      *
     C                   ENDIF
      *
     CSR   #UsrInf       ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *    Insert Bullitin Boards For New User into DUB000P.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $UsrBbd       BEGSR
      *
     C     NEWUSR        SETLL     DUB000R                                99
     C     *IN99         IFEQ      *OFF
      *
     C     CPYUSR        SETLL     DUB000R
      *
     C     *IN99         DOUEQ     *ON
     C     CPYUSR        READE     DUB000R                                99
     C     *IN99         IFEQ      *OFF
     C                   MOVE      NEWUSR        UBUSER
     C                   WRITE     DUB000R
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     CSR   #UsrBbd       ENDSR
      /SPACE 3
      /COPY QCPYSRC,$PMSND
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  INITIALIZE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *INZSR        BEGSR
      *
     C                   MOVE      *OFF          CrtUsr            1
      *
     CSR   #INZSR        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  DEFINE VARIABLES.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $DEFN         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    CPYUSR
     C                   PARM                    NEWUSR
     C                   PARM                    USRNAM           45
      *
     C     *LIKE         DEFINE    AUUSER        CPYUSR
     C     *LIKE         DEFINE    AUUSER        NEWUSR
      *
     CSR   #DEFN         ENDSR
