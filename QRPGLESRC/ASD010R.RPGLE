      /TITLE Archive Spoolfiles to Domino, log update
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Archive spoolfiles with their RJS log information
      *              to a domino email-based document folder.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  02/27/04  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /COPY qcpysrc,Hspec
      *
     Ferslog00  uf   e             disk    usropn
      *
      /copy qcpysrc,Dspec
      *
      /free
       // -------------------------------------------------------
       // Assign seperate fields.
        exsr    $AsgSepFld;

       // -------------------------------------------------------
       // Delete unused reords.
        exsr    $DltUnuRcd;

        eval    *inLR = *on;
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       // Assign seperate fields.
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        begsr   $AsgSepFld;

        open    erslog00;

        read    erl00r;

        dow     not %eof;

          if      LGjob       = *blanks;
            eval    LGstatus  = erl001;
            eval    LGjob     = ExtRsp('Job:':erl002);
            eval    LGspool   = ExtRsp('Report:':erl002);
            eval    LGUserID  = ExtRsp('User:':erl002);
            eval    LGjobnbr  = ExtRsp('JobNbr:':erl002);
            eval    LGspnum   = ExtRsp('Spool#:':erl002);
            eval    LGusrdfn  = ExtRsp('User Def:':erl002);
            eval    LGusrdta  = ExtRsp('User Data:':erl002);
            eval    LGform    = ExtRsp('Form:':erl002);
            eval    LGddate   = %date(Erl003);
            eval    LGdtime   = %time(Erl003);

            if      LGspool  = 'QSYSPRT';
              eval  LGspool  = LGusrdta;
              eval  LGusrdta = 'QSYSPRT';
            endif;

            update  erl00r;
          endif;

          read    erl00r;
        enddo;

        close   erslog00;

        endsr;

       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       // Delete unusable records.
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
        begsr   $DltUnuRcd;

        open    erslog00;

        read    erl00r;

        dow     not %eof;

          if      LGjob     = 'User:'      or
                  erl001    = 'MAILOUTQ'   or
                  LGprogram = 'MAILOUTQ'   or
                  %scan('DELETE':erl002) > *zero;
            delete  erl00r;
          endif;

        enddo;

        close   erslog00;

        endsr;

      /end-free
