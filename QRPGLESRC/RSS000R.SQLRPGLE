      *PARMS OBJTYPE(*PGM) DLYPRP(*YES) COMMIT(*NONE)
      *PARMS CLOSQLCSR(*ENDMOD)
      *
     H option(*srcstmt:*nodebugio)
      *
     D QryStr          s           2000a
     D BUFFER          s            512a
      *
     D MessageTxt      s           1024a
     D MessageLen      s             10i 0
      *
      *================================================================
      * Exception message feed back
     D ApiErrDs        ds                   inz
     D  EXMbpr                       10i 0 inz(%len(ApiErrDs))
     D  EXMbav                       10i 0
     D  EXMsid                        7a
     D  EXMrsv                        1a
     D  EXMdta                      256a

      *================================================================
      * Display Long Text API
     DQUILNGTX         pr                  extpgm('QUILNGTX')
     D MessageTxt                   512a   const
     D MessageLen                    10i 0 const
     D MessageIde                     7a   const
     D MessageFil                    20a   const
     D ApiErr                              like(ApiErrDs)

      *================================================================
      *
     C     *entry        plist
     C                   parm                    QryStr
      *
      * Prepare and execute the SQL Statement
      *
     C/EXEC SQL
     C+ SET TRANSACTION ISOLATION LEVEL NO COMMIT
     C/END-EXEC
      *
     C/EXEC SQL
     C+ DECLARE CRSR02 SCROLL CURSOR FOR STMT02
     C/END-EXEC
      *
     C/EXEC SQL
     C+ CLOSE CRSR02
     C/END-EXEC
      *
     C/EXEC SQL
     C+ PREPARE STMT02 FROM :QryStr
     C/END-EXEC
      *
     C/EXEC SQL
     C+ OPEN CRSR02
     C/END-EXEC
      *
     C/EXEC SQL FETCH NEXT FROM CRSR02 INTO :BUFFER
     C/END-EXEC
      *
     C/EXEC SQL
     C+ CLOSE CRSR02
     C/END-EXEC
      *
      * Edit and show the result
      *
     C                   Eval      MessageTxt =
     C                               'The result of ' +
     C                               %trim(QryStr) + ' is ' +
     C                               %trim(BUFFER) + '.'
      *
     C                   Eval      MessageLen = %len(%trim(MessageTxt))
      *
     C                   callp     QUILNGTX(
     C                               MessageTxt :
     C                               MessageLen :
     C                               *blank     :
     C                               *blank     :
     C                               ApiErrDs)
      *
     C                   eval      *inlr = *on
