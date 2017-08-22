      /TITLE Utility, Group job (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8075S
      * *********************************************************
      * ChgGrpA() -- Change group attributes.
      * *********************************************************
     P ChgGrpA         B                   Export
      *
     D ChgGrpA         PI
     D  text                               like(StdTxt) const
      /free
       // --------------------------------------------------------
       //Change group attributes.

       CmdStg = 'chggrpa text(''' + %trim(text) + ''')';
       msgid  = ExecCmd(CmdStg:'*YES');
       if msgid <> *blanks;
          RcvPgmMsg('*':*omit:'*LAST');
       endif;

       return;

      /end-free
      *
      /undefine $PMRCV_copied
      /COPY QCPYSRC,$PMrcv
      *
     P ChgGrpA         E
