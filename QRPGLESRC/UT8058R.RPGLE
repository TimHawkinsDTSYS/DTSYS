      /TITLE Utility, IFS (SrvPgm)
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
      * *********************************************************
      * Check IFS object.
      * *********************************************************
     P ChkIfsObj       B                   Export
      *
     D ChkIfsObj       PI                  like(StdInd)
     D  InpFile                            like(StdStr) const
      /free
       // -------------------------------------------------------
       //Check IFS object.

       if access(%trim(InpFile)+ifsNull:F_OK) = *zero;
          return *on;
       else;
          DiagErrno(errno());
          return *off;
       endif;

      /end-free

     P ChkIfsObj       E
      * *********************************************************
      * ExtDirPth( -- Extract directory from a path
      * *********************************************************
     P ExtDirPth       B                   Export
      *
     D ExtDirPth       PI                  like(t_ExtDirPth)
     D  InpPath                            like(StdStr) const
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
     D Dirs            ds                  likeds(t_ExtWords)
     D                                     based(pDirs)
      *
     D WrkPath         s                   like(StdStr) inz
     D x               s                   like(StdInt) inz
      * ---------------------------------------------------------
      *
      *   Return if nothing passed.
      *
     c                   if        InpPath = *blanks
     c                   return    PthDS   = *blanks
     c                   endif
      *
      *   Remove 'null'.
      *
     c                   eval      WrkPath = %xlate(ifsNULL:' ':InpPath)
      *
      *   Remove quotes.
      *
     c                   eval      WrkPath = %xlate('''':'':InpPath)
      * ---------------------------------------------------------
      *
      *   Extract file name.
      *
     c                   if        %scan('.':WrkPath) > *zero
      *
     c                   for       x = %len(%trim(WrkPath)) downto 1
     c                   if        %subst(WrkPath:x:1) = '/'
     c                   leave
     c                   endif
     c                   endfor
      *
     c                   if        x > 2
     c                   eval      PthDS.IFSfile = %subst(WrkPath:x+1)
     c                   eval      %subst(WrkPath:x) = *blanks
     c                   endif
     c                   endif
      * ---------------------------------------------------------
      *
      *   Extract directory names.
      *
     C                   eval      pDirs = ExtWords(WrkPath:'/\')
     c
     c                   for       x = 1 to Dirs.WordsMax
     c                   eval      PthDS.IFSdircnt     = x
     c                   eval      PthDS.IFSdirlist(x) = Dirs.words(x)
     c                   endfor
      *
     c                   return    PthDS
      *
     P ExtDirPth       E
      * *********************************************************
      * CrtDirPth( -- Create directories in a path
      * *********************************************************
     P CrtDirPth       B                   Export
      *
     D CrtDirPth       PI                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*nopass)
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
     D statDS          ds                  likeds(t_statDS)
      *
     D WrkBgnDir       s                   like(StdStr) inz
     D path            s                   like(StdStr) inz
     D BgnDir          s                   like(StdInt) inz(1)
     D ModeSet         s                   like(StdInd) inz
     D mode            s                   like(StdUns) inz
     D x               s                   like(StdInt) inz
      /free
       // --------------------------------------------------------
       //Return if nothing passed.

       if InpPath = *blanks;
         return *off;
       endif;

       // --------------------------------------------------------
       //Handle optional parameters.

       if %parms >= 2;
         callp   CEETSTA(ParmPassed:2:*omit);
         if ParmPassed = 1;
            WrkBgnDir = InpBgnDir;
         endif;
       endif;

       // --------------------------------------------------------
       //Extract directories.

       PthDS = ExtDirPth(InpPath);

       // -------------------------------------------------------
       //Set begin directory.

       if WrkBgnDir <> *blanks  and
          WrkBgnDir <> '*NONE';

          for BgnDir = 1 to PthDS.IFSdircnt;
              if WrkBgnDir = PthDS.IFSdirlist(BgnDir);
                 leave;
              endif;

              path = %trim(path) + '/' + PthDS.IFSdirlist(BgnDir);

              // Get mode of the parent directory,
              // then turn off non-permission bits.

              if not ModeSet;
                 if stat(%trim(path):%addr(statDS)) = ifsFalse;
                    EscErrno(errno());
                 endif;

                 ModeSet = *on;
                 mode = %bitand(statDS.st_mode: x'000003FF');
              endif;
          endfor;
       endif;

       // -------------------------------------------------------
       //Make directories.

       for x = BgnDir to PthDS.IFSdircnt;
         path = %trim(path) + '/' + PthDS.IFSdirlist(x);

         //Make directory.

         if not ChkIfsObj(%trim(path));

            // create directory.

            if mkdir(%trim(path):mode) = ifsFalse;
               EscErrno(errno());
            endif;

            // set the owner of the directory to match parent.

         // if  chown(%trim(path):statDS.st_uid:statDS.st_gid) = ifsFalse;
         //     EscErrno(errno());
         // endif;
         endif;
       endfor;

       return *on;

      /end-free
      *
     P CrtDirPth       E
      * *********************************************************
      * ClnIFSnam( -- Cleanup IFS filename.
      * *********************************************************
     P ClnIFSnam       B                   Export
      *
     D ClnIFSnam       PI                  like(StdStr)
     D  InpIFSnam                          like(StdStr) const
      *
     D RtnIFSnam       s                   like(StdStr) inz
      * ---------------------------------------------------------
      *   Remove offending characters.
      *
     C                   eval      RtnIFSnam = InpIFSnam
     C                   eval      RtnIFSnam = %xlate('"' :' ':RtnIFSnam)
     C                   eval      RtnIFSnam = %xlate('''':' ':RtnIFSnam)
     C                   eval      RtnIFSnam = %xlate('.' :' ':RtnIFSnam)
     C                   eval      RtnIFSnam = %xlate('/' :' ':RtnIFSnam)
     C                   eval      RtnIFSnam = %xlate('\' :' ':RtnIFSnam)
      *
     c                   return    RtnIFSnam
      *
     P ClnIFSnam       E
      * *********************************************************
      * ChgIFSown() -- Change IFS ownership.
      * -- option can be *ALL, *ALLDIR, *LASTDIR or *FILE.
      * *********************************************************
     P ChgIFSown       B                   Export
      *
     D ChgIFSown       PI                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpUser                            like(StdNam) const
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*omit:*nopass)
     D  InpOption                          like(StdStr) const
     D                                     options(*nopass)
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
     D WrkPath         s                   like(StdStr) inz
     D WrkBgnDir       s                   like(StdStr) inz
     D WrkUser         s                   like(StdNam) inz
     D WrkOption       s                   like(StdNam) inz
     D path            s                   like(StdStr) inz
     D BgnDir          s                   like(StdInt) inz(1)
     D error           s                   like(StdInd) inz
     D x               s                   like(StdInt) inz
      /free
       // -------------------------------------------------------
       //   Return if nothing passed.

       if InpPath = *blanks;
         return *off;
       endif;

       // -------------------------------------------------------
       //   Strip-off null characters.
       //    -- NULL is a C end-of-string delimiter.

       WrkPath = %xlate(ifsNull:' ':InpPath);

       // -------------------------------------------------------
       //   Handle optional parameters.

       if %parms        >= 2;
         callp CEETSTA(ParmPassed:2:*omit);
         if ParmPassed = 1;
            WrkUser = InpUser;
         endif;
       endif;

       if %parms        >= 3;
         callp CEETSTA(ParmPassed:3:*omit);
         if ParmPassed = 1;
            WrkBgnDir = InpBgnDir;
         endif;
       endif;

       if %parms        >= 4;
         callp CEETSTA(ParmPassed:4:*omit);
         if ParmPassed = 1;
            WrkOption = InpOption;
         endif;
       endif;

       // --------------------------------------------------------
       //   Set defaults.

       if WrkUser = *blanks;
          WrkUser = RtvObjOwn();
       endif;

       if WrkOption = *blanks;
          WrkOption = '*ALL';
       endif;

       // -------------------------------------------------------
       //   Extract directories and file.

       PthDS = ExtDirPth(WrkPath);

       // -------------------------------------------------------
       //   Set begin directory.

       if  WrkBgnDir <> *blanks  and
           WrkBgnDir <> '*NONE';
         for BgnDir = 1 to PthDS.IFSdircnt;
           if  WrkBgnDir = PthDS.IFSdirlist(BgnDir);
             leave;
           endif;

           path = %trim(path) + '/' + PthDS.IFSdirlist(BgnDir);
         endfor;
       endif;

       // -------------------------------------------------------
       //   Process directories.

       if  WrkOption = '*ALL'   or
           WrkOption = '*ALLDIR';
           for  x = BgnDir to PthDS.IFSdircnt;
                path = %trim(path) + '/' + PthDS.IFSdirlist(x);
                UT8058C(path: WrkUser);
           endfor;
       endif;

       if  WrkOption = '*LASTDIR';
           for  x = BgnDir to PthDS.IFSdircnt;
                path = %trim(path) + '/' + PthDS.IFSdirlist(x);
           endfor;

           UT8058C(path: WrkUser);
       endif;

       // -------------------------------------------------------
       //   Process files.

       if  (WrkOption      = '*ALL'   or
            WrkOption      = '*FILE') and
            PthDS.IFSfile <> *blanks;

            path = %trim(WrkPath);
            UT8058C(path: WrkUser);
       endif;

       if error;
         return *off;
       else;
         return *on;
       endif;

      /end-free
     P ChgIFSown       E
      * *********************************************************
      * ChgIFSaut() -- Change IFS authority.
      * -- option can be *ALL, *ALLDIR, *LASTDIR or *FILE.
      * *********************************************************
     P ChgIFSaut       B                   Export
      *
     D ChgIFSaut       PI                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpUser                            like(StdNam) const
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*omit:*nopass)
     D  InpOption                          like(StdStr) const
     D                                     options(*nopass)
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
     D WrkPath         s                   like(StdStr) inz
     D WrkBgnDir       s                   like(StdStr) inz
     D WrkUser         s                   like(StdNam) inz
     D WrkOption       s                   like(StdNam) inz
     D path            s                   like(StdStr) inz
     D BgnDir          s                   like(StdInt) inz(1)
     D error           s                   like(StdInd) inz
     D x               s                   like(StdInt) inz
      /free
       // --------------------------------------------------------
       //   Return if nothing passed.

       if InpPath = *blanks;
         return *off;
       endif;

       // -------------------------------------------------------
       //   Strip-off null characters.
       //    -- NULL is a C end-of-string delimiter.

       WrkPath = %xlate(ifsNull:' ':InpPath);

       // --------------------------------------------------------
       //   Handle optional parameters.

       if %parms        >= 2;
         callp     CEETSTA(ParmPassed:2:*omit);
         if ParmPassed = 1;
            WrkUser    = InpUser;
         endif;
       endif;

       if %parms        >= 3;
         callp     CEETSTA(ParmPassed:3:*omit);
         if ParmPassed = 1;
            WrkBgnDir  = InpBgnDir;
         endif;
       endif;

       if %parms        >= 4;
         callp     CEETSTA(ParmPassed:4:*omit);
         if ParmPassed = 1;
            WrkOption  = InpOption;
         endif;
       endif;

       // --------------------------------------------------------
       //   Set defaults.

       if WrkUser = *blanks;
          WrkUser = RtvObjOwn();
       endif;

       if WrkOption = *blanks;
          WrkOption = '*ALL';
       endif;

       // --------------------------------------------------------
       //   Extract directories and file.

       PthDS = ExtDirPth(WrkPath);

       // -------------------------------------------------------
       //   Set begin directory.

       if  WrkBgnDir <> *blanks  and
           WrkBgnDir <> '*NONE';
         for BgnDir = 1 to PthDS.IFSdircnt;
           if  WrkBgnDir = PthDS.IFSdirlist(BgnDir);
             leave;
           endif;

           path = %trim(path) + '/' + PthDS.IFSdirlist(BgnDir);
         endfor;
       endif;

       // --------------------------------------------------------
       //   Process directories.

       if  WrkOption = '*ALL'   or
           WrkOption = '*ALLDIR';
         for x = BgnDir to PthDS.IFSdircnt;
           path = %trim(path) + '/' + PthDS.IFSdirlist(x);
           exsr ChgAut;
         endfor;
       endif;

       if  WrkOption = '*LASTDIR';
         for x = BgnDir to PthDS.IFSdircnt;
           path = %trim(path) + '/' + PthDS.IFSdirlist(x);
         endfor;

         exsr ChgAut;
       endif;

       // --------------------------------------------------------
       //   Process files.

       if  (WrkOption      = '*ALL'   or
            WrkOption      = '*FILE') and
            PthDS.IFSfile <> *blanks;
         path = %trim(WrkPath);
         exsr ChgAut;
       endif;

       if error;
         return *off;
       else;
         return *on;
       endif;

       // ========================================================
       //   Change authority.

       begsr ChgAut;

         CmdStg = 'chgaut obj(''' + %trim(path) + ''') +
                          user(' + %trim(InpUser) + ') +
                          dtaaut(*RWX) +
                          objaut(*ALL)';
         msgid  = ExecCmd(CmdStg);
         if msgid <> *blanks;
            error  = *on;
         endif;

       endsr;

      /end-free
      *
     P ChgIFSaut       E
      * *********************************************************
      * ChgIFSautl() -- Change IFS authority list.
      * -- option can be *ALL, *ALLDIR, *LASTDIR or *FILE.
      * *********************************************************
     P ChgIFSautl      B                   Export
      *
     D ChgIFSautl      PI                  like(StdInd)
     D  InpPath                            like(StdStr) const
     D  InpAutl                            like(StdNam) const
     D  InpBgnDir                          like(StdStr) const
     D                                     options(*omit:*nopass)
     D  InpOption                          like(StdStr) const
     D                                     options(*nopass)
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
     D WrkPath         s                   like(StdStr) inz
     D WrkBgnDir       s                   like(StdStr) inz
     D WrkAutl         s                   like(StdNam) inz
     D WrkOption       s                   like(StdNam) inz
     D path            s                   like(StdStr) inz
     D BgnDir          s                   like(StdInt) inz(1)
     D error           s                   like(StdInd) inz
     D x               s                   like(StdInt) inz
      /free
       // --------------------------------------------------------
       //   Return if nothing passed.

       if InpPath = *blanks  or
          InpAutl = *blanks;
         return *off;
       endif;

       // -------------------------------------------------------
       //   Strip-off null characters.
       //    -- NULL is a C end-of-string delimiter.

       WrkPath = %xlate(ifsNull:' ':InpPath);

       // --------------------------------------------------------
       //   Handle optional parameters.

       if %parms        >= 3;
         callp     CEETSTA(ParmPassed:3:*omit);
         if ParmPassed = 1;
            WrkBgnDir = InpBgnDir;
         endif;
       endif;

       if %parms        >= 4;
         callp     CEETSTA(ParmPassed:4:*omit);
         if ParmPassed = 1;
            WrkOption = InpOption;
         endif;
       endif;

       // --------------------------------------------------------
       //   Set defaults.

       if WrkOption = *blanks;
          WrkOption = '*ALL';
       endif;

       // --------------------------------------------------------
       //   Extract directories and file.

       PthDS = ExtDirPth(WrkPath);

       // -------------------------------------------------------
       //   Set begin directory.

       if  WrkBgnDir <> *blanks  and
           WrkBgnDir <> '*NONE';
         for BgnDir = 1 to PthDS.IFSdircnt;
           if  WrkBgnDir = PthDS.IFSdirlist(BgnDir);
             leave;
           endif;

           path = %trim(path) + '/' + PthDS.IFSdirlist(BgnDir);
         endfor;
       endif;

       // --------------------------------------------------------
       //   Process directories.

       if  WrkOption = '*ALL'   or
           WrkOption = '*ALLDIR';
         for x = BgnDir to PthDS.IFSdircnt;
           path = %trim(path) + '/' + PthDS.IFSdirlist(x);
           exsr ChgAutl;
         endfor;
       endif;

       if  WrkOption = '*LASTDIR';
         for x = BgnDir to PthDS.IFSdircnt;
           path = %trim(path) + '/' + PthDS.IFSdirlist(x);
         endfor;

         exsr ChgAutl;
       endif;

       // --------------------------------------------------------
       //   Process files.

       if  (WrkOption      = '*ALL'   or
            WrkOption      = '*FILE') and
            PthDS.IFSfile <> *blanks;
         path = %trim(WrkPath);
         exsr ChgAutl;
       endif;

       if error;
         return *off;
       else;
         return *on;
       endif;

       // ========================================================
       //   Change authority list.

       begsr ChgAutl;

         CmdStg = 'chgaut obj(''' + %trim(path) + ''') +
                          Autl(' + %trim(InpAutl) + ')';
         msgid  = ExecCmd(CmdStg);
         if msgid <> *blanks;
            error = *on;
         endif;

       endsr;

      /end-free
      *
     P ChgIFSautl      E
      * **********************************************************
      *  Copy DB file to streamfile.
      * **********************************************************
     P CpyDBtoStmf     B                   Export

     D CpyDBtoStmf     PI                  like(StdInd)
     D  InFile                             like(StdNam) const
     D  InStreamFile                       like(StdStr) const

      /free
       //-------------------------------------------------------
       //
       //  Remove link.
       //
       CmdStg = 'rmvlnk objlnk(''' + %trim(InStreamFile) + ''')';

       msgid  = ExecCmd(CmdStg);
       msgid  = *blanks;
       //--------------------------------------------------------
       //
       //   Write CSV database file.
       //
       CmdStg = 'wrtcsvdbf fromfile(' + %trim(InFile) + ') +
                 tostmf(''' + %trim(InStreamFile) + ''')';

       msgid  = ExecCmd(CmdStg);

       if msgid <> *blanks;
         torel = '*PRV';
         exsr   $PMsnd;
         return *off;
       endif;

       return *on;
       //--------------------------------------------------------
       //
       //   Support code.
       //
      /undefine $PMSND_copied
      /copy qcpysrc,$PMsnd

      /end-free

     P CpyDBtoStmf     E
      * *********************************************************
      * Delete IFS directories.
      * *********************************************************
     P DltIFSdir       B                   Export
      *
     D DltIFSdir       PI
     D  InPath                             like(StdStr) const
      *
     D WKpath          s                   like(StdStr)
      * ---------------------------------------------------------
      *
      *   Return if nothing passed.
      *
     c                   if        InPath  = *blanks
     c                   return
     c                   endif
      * ---------------------------------------------------------
      *
      *   Delete the IFS directory.
      *
     c                   call      'UT1340C'
     c                   parm      InPath        WKpath
      *
     P DltIFSdir       E
      * *********************************************************
      * Clear IFS object.
      * *********************************************************
     P ClrIfsObj       B                   Export
      *
     D ClrIfsObj       PI
     D  InpFile                            like(StdStr) const
      *
     D QSHcmd          s                   like(StdStr) inz
      * ---------------------------------------------------------
      *
      *   Clear IFS object.
      *
     c                   eval      QSHcmd = ':>' + %trim(InpFile)
      *
     c                   call      'UT0010C'
     c                   parm                    QSHcmd
      *
     P ClrIfsObj       E
      * *********************************************************
      * readline() -- Read text from an IFS file line by line.
      * *********************************************************
     P readline        B                   export

     D readline        PI                  like(StdInt)
     D   fd                                like(StdInt) value
     D   text                              like(StdPtr) value
     D   maxlen                            like(StdInt) value

     D rdbuf           S           1024A   static
     D rdpos           S                   like(StdInt) static
     D rdlen           S                   like(StdInt) static

     D p_retstr        S                   like(StdPtr)
     D RetStr          S          32766A   based(p_retstr)
     D len             S                   like(StdInt)
      * ---------------------------------------------------------
      *
      *   Read text from the IFS file.
      *
     c                   eval      len = *zero
     c                   eval      p_retstr = text
     c                   eval      %subst(RetStr:1:MaxLen) = *blanks

     c                   dow       1 = 1

     C* Load the buffer
     c                   if        rdpos >= rdlen
     c                   eval      rdpos  = *zero
     c                   eval      rdlen  =
     c                             read(fd:%addr(rdbuf):%size(rdbuf))

     c                   if        rdlen < 1
     c                   return    -1
     c                   endif
     c                   endif

     C* Is this the end of the line?
     c                   eval      rdpos += 1
     c                   if        %subst(rdbuf:rdpos:1) = x'25'
     c                   return    len
     c                   endif

     C* Otherwise, add it to the text string.
     c                   if        %subst(rdbuf:rdpos:1) <> x'0d'
     c                               and len <> maxlen
     c                   eval      len += 1
     c                   eval      %subst(retstr:len:1) =
     c                             %subst(rdbuf:rdpos:1)
     c                   endif
     c                   enddo

     c                   return    len

     P readline        E
      * *********************************************************
      * ReportError():  Send an escape message explaining any errors
      *                 that occurred.
      * *********************************************************
     P ReportError     B                   Export

     D ReportError     PI

     D get_errno       PR              *   ExtProc('__errno')

     D errno           s             10I 0 based(p_errno)

     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   Const
     D   QualMsgF                    20A   Const
     D   MsgData                  32767A   Const options(*varsize)
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStkEnt                  10A   Const
     D   CallStkCnt                  10I 0 Const
     D   MessageKey                   4A
     D   ErrorCode                 8192A   options(*varsize)

     D ErrorCode       DS                  qualified
     D  BytesProv                    10I 0 inz(0)
     D  BytesAvail                   10I 0 inz(0)

     D MsgKey          S              4A
     D MsgID           s              7A

      /free

       p_errno = get_errno();

       MsgID = 'CPE' + %editc( %dec(errno:4:0) : 'X');

       QMHSNDPM(MsgID
               :'QCPFMSG   *LIBL'
               :' '
               :0
               :'*ESCAPE'
               :'*PGMBDY'
               :1
               :MsgKey
               :ErrorCode);

      /end-free

     P ReportError     E
      * *********************************************************
      * ExtDir() -- Extract directories from path.
      * *********************************************************
     P ExtDir          B                   Export
      *
     D ExtDir          PI                  like(StdStr)
     D  InpPath                            like(StdStr) const
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
     D RtnDir          s                   like(StdStr) inz
     D x               s                   like(StdInt) inz
      *
      /free
       // --------------------------------------------------------
       //Return if nothing passed.

       if InpPath = *blanks;
         return *blanks;
       endif;

       // --------------------------------------------------------
       //Extract directories.

       PthDS = ExtDirPth(InpPath);

       // -------------------------------------------------------
       //Set return directory.

       RtnDir = PthDS.IFSdirlist(1);

       for x = 2 to PthDS.IFSdircnt;
           RtnDir = %trim(RtnDir) + '/' + PthDS.IFSdirlist(x);
       endfor;

       return RtnDir;

      /end-free
      *
     P ExtDir          E
      * *********************************************************
      * ExtFile() -- Extract file name from path.
      * *********************************************************
     P ExtFile         B                   Export
      *
     D ExtFile         PI                  like(StdStr)
     D  InpPath                            like(StdStr) const
      *
     D PthDS           ds                  likeds(t_ExtDirPth)
      *
      /free
       // --------------------------------------------------------
       //Return if nothing passed.

       if InpPath = *blanks;
         return *blanks;
       endif;

       // --------------------------------------------------------
       //Extract file name.

       PthDS = ExtDirPth(InpPath);

       return PthDS.IFSfile;

      /end-free
      *
     P Extfile         E
