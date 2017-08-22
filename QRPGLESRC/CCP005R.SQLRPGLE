      /TITLE Command Parm Validity Checker (SrvPgm)
      *PARMS ALWCPYDTA(*optimize) COMMIT(*none)
      *PARMS RPGPPOPT(*lvl2)
      *===============================================================
      *  Source Name: cmdvldchk  - Command Parm Validity Checker
      *
      *  Desc:     This module contains procedures used to check
      *             validity of command parms.
      *
      *===============================================================

      /copy qcpysrc,Hspec

     d command         s                   like(StdNam)
     d keyword         s                   like(StdNam)
     d value           s             32a
     d success_ind     s                   like(StdInd)
      *
     d quote           c                   ''''
      *
     d sqlstmt         s            200a   inz
     d success_val     s                   like(StdChr) inz
      *
     d choiceds      e ds                  extname(CCP000P)

      /copy qcpysrc,StdTypD
      *===============================================================
      /free

         // Set Values
         reset success_ind;

         // Retrieve Command/Keyword Data

             exec sql
                select *
                  into :choiceDS
                  from ccp000p
                 where ckcommand = :command
                   and ckkeyword = :keyword;

        // Build Select Statement
                   sqlstmt = 'select '
                           + quote
                           + '1'
                           + quote
                           + ' from '
                           + %trim(cklib)
                           + '/'
                           + %trim(ckfile)
                           + ' where '
                           + %trim(ckfield)
                           + ' = '
                           + quote
                           + %trim(value)
                           + quote;

             exec sql
               prepare sqlstmt from :sqlstmt;

             exec sql
              declare sqlcsr cursor for sqlstmt;

             exec sql
               open sqlcsr;

             exec sql
              fetch next
               from sqlcsr
               into :success_val;

         // Set Success Indicator
             success_ind = (sqlstt = *zeros);

             exec sql
               close sqlcsr;

         // Return Success Indicator
             eval   *inLR = *on;

      /end-free

      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Define variables.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Define       BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    command
     C                   PARM                    keyword
     C                   PARM                    value
     C                   PARM                    success_ind
      *
     CSR   #Define       ENDSR
