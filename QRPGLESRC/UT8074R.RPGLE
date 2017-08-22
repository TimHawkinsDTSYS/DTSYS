      /TITLE Utility, Data area (SrvPgm)
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
      /define DSpgm
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8074S
      * *********************************************************
      * ChgDtaAra() -- Change data area.
      * *********************************************************
     P ChgDtaAra       B                   Export
      *
     D ChgDtaAra       PI                  like(StdInd)
     D  DtaAraNam                          like(StdNam) const
     D  StrPos                             like(StdInt) const
     D  Len                                like(StdInt) const
     D  Value                              like(StdStr) const
      /free
       // --------------------------------------------------------
       //   Change data area.

       eval CmdStg = 'chgdtaara dtaara(' + %trim(DtaAraNam) +
                      ' (' + %char(StrPos) + ' ' + %char(Len) +
                      ')) value(''' + %trim(Value) + ''')';
       eval msgid  = ExecCmd(CmdStg);
       if   msgid <> *blanks;
            return   *off;
       endif;

       return *on;

      /end-free
      *
     P ChgDtaAra       E
      * *********************************************************
      * SetCurTskGDA() -- Set current task into GDA.
      * *********************************************************
     P SetCurTskGDA    B                   Export
      *
     D SetCurTskGDA    PI
     D  Value                              like(StdStr) const
      *
     D ZZpgm           s                   like(StdNam) inz('UT8074R')
      /free
       // --------------------------------------------------------
       //   Change group jobs data area.

       eval CmdStg = 'chgdtaara dtaara(*GDA) (401 50)) +
                      value(''' + %trim(Value) + ''')';
       eval msgid  = ExecCmd(CmdStg);
       if   msgid <> *blanks;
            exsr     $PMrcv;
       endif;

       return;

      /end-free
      *
      /undefine $PMRCV_copied
      /COPY QCPYSRC,$PMrcv
      *
     P SetCurTskGDA    E
