      /TITLE Run Dynamic SQL
      *PARMS ALWCPYDTA(*OPTIMIZE) COMMIT(*NONE)
      *PARMS RPGPPOPT(*lvl2)
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Run the passed dynamic SQL statement.
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  04/09/02  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /COPY QCPYSRC,Hspec
      *
      *
      /copy qcpysrc,Dspec
      *
     C                   exsr      $Execute
      *
     C                   eval      *inLR = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Execute SQL statement.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $Execute      begsr
      *
      *  Execute the SQL statement.
      *
     C/EXEC SQL EXECUTE IMMEDIATE :SQLstm
     C/END-EXEC
     C                   exsr      $ChkError
      *
     Csr   #Execute      endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Check for errors.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ChkError     begsr
      *                                          n records processed
š1b€ C                   select
š1x€ C                   when      sqlcod  = *zero
     C                   eval      msgid   = 'DTD0303'
     C                   eval      msgdta  = %trim(%editc(SQLer3:'Z'))
     C                   eval      %subst(msgdta:16) = SQLstm
      *
      *                                          no records processed
š1x€ C                   when      sqlcod  = 100
     C                   eval      msgid   = 'DTD0304'
     C                   eval      msgdta  = SQLstm
      *
      *                                          SQL warning
š1x€ C                   when      sqlcod  > *zero  or
     C                             sqlwn0 <> *blanks
     C                   eval      msgid   = 'DTD0305'
     C                   eval      msgdta  = SQLstm
      *
      *                                          SQL error
š1x€ C                   when      sqlcod  < *zero
     C                   eval      msgid   = 'DTD0306'
     C                   eval      msgdta  = SQLstm
š1e€ C                   endsl
      *
     C                   eval      torel = '*PRV'
     C                   exsr      $pmsnd
      *
     CSR   #ChkError     endsr
      /SPACE 3
      /COPY QCPYSRC,$PMSND
      /SPACE 3
      /COPY QCPYSRC,$PSSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Initialize variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *inzsr        begsr
      *
     CSR   #inzsr        endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       begsr
      *
     C     *entry        plist
     C                   parm                    SQLstm         5000
      *
     CSR   #Define       endsr
