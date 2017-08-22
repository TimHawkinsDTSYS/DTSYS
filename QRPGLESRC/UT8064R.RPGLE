      /TITLE Utility, Command (SrvPgm)
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
      ***********************************************************
      * Execute Command.
      ***********************************************************
     P ExecCmd         B                   export
      *
     D ExecCmd         PI                  like(msgid )
     D   CmdString                         like(CmdStg) const
     D   RmvErrMsg_p                  4    const options(*nopass)
      *
     D CmdLength       s                   like(StdInt) inz
     D RmvErrMsg       s                   like(RmvErrMsg_p) inz
     D ZZpgm           s                   like(StdNam) inz('UT8064R')
      *
     D OCBLen          s                   like(StdInt) inz(20)
     D OCBFmt          s                   like(StdFmt) inz('CPOP0100')
     D ChgCmdStr       s                   like(StdStr) inz
     D LenAvailCS      s                   like(StdInt) inz
     D LenOfChgCS      s                   like(StdInt) inz
      *
     D OptCtlBlk       ds
     D  TypOfCmdP                          like(StdInt) inz
     D  DBCS                               like(StdChr) inz('0')
     D  Prompt                             like(StdChr) inz('2')
     D  CmdStrSyn                          like(StdChr) inz('0')
     D  MsgKey                 8     11    inz
     D  Resvd1                12     20    inz(*loval)
      * ---------------------------------------------------------
      *
      *    Check for omitted parameters.
      *
     C                   if        %parms    >= 2
     C**                 callp     CEETSTA(ParmPassed:2:*omit)
     C**                 if        ParmPassed = 1
     C                   eval      RmvErrMsg  = Upper(RmvErrMsg_p)
     C**                 endif
     C                   endif
      * ---------------------------------------------------------
      * Execute the command.
      *
     C                   eval      CmdLength = %len(%trim(CmdString))
      *
     C                   clear                   dsEC
      *
     C                   callp(e)  QCAPCMD(CmdString  : CmdLength  :
     C                                     OptCtlBlk  : OCBLen     :
     C                                     OCBFmt     : ChgCmdStr  :
     C                                     LenAvailCS : LenOfChgCS :
     C                                     dsEC)
      *
      *    Send error message to caller.
      *
     C                   if        dsEC.msgid <> *blanks and
     C                             RmvErrMsg  <> '*YES'
     C                   exsr      $PMrcv
     C                   eval      torel  = '*PRV'
     C                   exsr      $PMsnd
     C                   eval      msgid  = 'GNL0086'
     C                   eval      msgdta = %subst(CmdString:1:CmdLength)
     C                   eval      torel  = '*PRV'
     C                   exsr      $PMsnd
     C                   endif
      *
     C                   return    dsEC.msgid
      *
      /undefine $PMRCV_copied
      /undefine $PMSND_copied
      /COPY QCPYSRC,$PMrcv
      /COPY QCPYSRC,$PMsnd
      *
     P ExecCmd         E
      ***********************************************************
      * Check command.
      ***********************************************************
     P ChkCmd          B                   export
      *
     D ChkCmd          PI                  like(msgid )
     D  CmdString                          like(CmdStg) const
     D  RmvErrMsg_p                   4    const options(*nopass)
      *
     D CmdLen          s                   like(StdInt) inz(%len(CmdString))
     D RmvErrMsg       s                   like(RmvErrMsg_p) inz
     D ZZpgm           s                   like(StdNam) inz('UT8064R')
      *
     D OCBLen          s                   like(StdInt) inz(20)
     D OCBFmt          s                   like(StdFmt) inz('CPOP0100')
     D ChgCmdStr       s                   like(CmdStg) inz
     D LenAvailCS      s                   like(StdInt) inz
     D LenOfChgCS      s                   like(StdInt) inz
      *
     D OptCtlBlk       ds
     D  TypOfCmdP                          like(StdInt) inz(1)
     D  DBCS                               like(StdChr) inz('0')
     D  Prompt                             like(StdChr) inz('0')
     D  CmdStrSyn                          like(StdChr) inz('0')
     D  MsgKey                        4    inz
     D  Resvd1                        9    inz(*loval)
      * ---------------------------------------------------------
      *
      *    Check for omitted parameters.
      *
     C                   if        %parms    >= 2
     C**                 callp     CEETSTA(ParmPassed:2:*omit)
     C**                 if        ParmPassed = 1
     C                   eval      RmvErrMsg  = Upper(RmvErrMsg_p)
     C**                 endif
     C                   endif
      * ---------------------------------------------------------
      *
      *    Check the command.
      *
     C                   callp     QCAPCMD(CmdString :CmdLen    :
     C                                     OptCtlBlk :OCBLen    :
     C                                     OCBFmt    :ChgCmdStr :
     C                                     LenAvailCS:LenOfChgCS:
     C                                     dsEC)
      * ---------------------------------------------------------
      *
      *    Return error message to caller.
      *
     C                   if        dsEC.msgid <> *blanks and
     C                             RmvErrMsg  <> '*YES'
     C                   exsr      $PMrcv
     C                   eval      torel  = '*PRV'
     C                   exsr      $PMsnd
     C                   eval      msgid  = 'GNL0086'
     C                   eval      msgdta = %subst(CmdString:1:CmdLen)
     C                   eval      torel  = '*PRV'
     C                   exsr      $PMsnd
     C                   endif
      *
     C                   return    dsEC.msgid
      *
      /undefine $PMRCV_copied
      /undefine $PMSND_copied
      /COPY QCPYSRC,$PMrcv
      /COPY QCPYSRC,$PMsnd
      *
     P ChkCmd          E
      ***********************************************************
      * Replace command keyword.
      ***********************************************************
     P RplCmdKwd       B                   Export
      *
     D RplCmdKwd       PI                  like(CmdStg)
     D  WPkwdval                           like(CmdStg) const
     D  WPcmdstg                           like(CmdStg) const
      *
     D  WKkwdval       s                   like(CmdStg) inz
     D  WKcmdstg       s                   like(CmdStg) inz
     D  WKcmdkwd       s                   like(CmdStg) inz
     D  WKkwdloc       s                   like(StdInt) inz
     D  WKlftpar       s                   like(StdInt) inz
     D  WKrgtpar       s                   like(StdInt) inz
      * ---------------------------------------------------------
      * Bring in parameters to workfields.
      *
     C                   eval      WKkwdval = WPkwdval
     C                   eval      WKcmdstg = WPcmdstg
      * ---------------------------------------------------------
      * Assure that keyword and command string are present.
      *
     C                   if        WKkwdval = *blanks or
     C                             WKcmdstg = *blanks
     C                   return    *blanks
     C                   endif
      *
      * Assure that parens are on keyword.
      *
     C                   if        %scan('(':WKkwdval) = *zero or
     C                             %scan(')':WKkwdval) = *zero
     C                   return    WKcmdstg
     C                   endif
      *
      * Assure that left parens is not in postion 1.
      *
     C                   if        %scan('(':WKkwdval) = 1
     C                   return    WKcmdstg
     C                   endif
      * ---------------------------------------------------------
      * Convert keyword to lower case.
      *
     C                   eval      WKkwdval = CvtCmdLwrCas(WKkwdval)
      *
      * Convert command to lower case.
      *
     C                   eval      WKcmdstg = CvtCmdLwrCas(WKcmdstg)
      * ---------------------------------------------------------
      * Extract keyword with paren.
      *
     C                   eval      WKcmdkwd = %trim(%subst(WKkwdval:1:
     C                                        %scan('(':WKkwdval)))
      *
      * Assure that keyword is present.
      *
     C                   if        WKcmdkwd = *blanks
     C                   return    WKcmdstg
     C                   endif
      * ---------------------------------------------------------
      * Add keyword if not found in command string.
      *
     C                   if        %scan(%trim(WKcmdkwd):WKcmdstg)
     C                             = *zero
     C                   eval      WKcmdstg = %trim(WKcmdstg) + ' ' +
     C                                        %trim(WKkwdval)
     C                   return    WKcmdstg
     C                   endif
      * ---------------------------------------------------------
      * Determine keyword location.
      *
     C                   eval      WKkwdloc = %scan(%trim(WKcmdkwd):
     C                                                    WKcmdstg)
      *
     C                   if        WKkwdloc = *zero
     C                   return    WKcmdstg
     C                   endif
      * ---------------------------------------------------------
      * Find left and right parens.
      *
     C                   eval      WKlftpar=%scan('(':WKcmdstg:WKkwdloc)
     C                   eval      WKrgtpar=%scan(')':WKcmdstg:WKkwdloc)
      * ---------------------------------------------------------
      * Extract old keyword.
      *
     C                   eval      WKcmdstg = %subst(WKcmdstg:1:
     C                                        WKkwdloc - 1) +
     C                                        %subst(WKcmdstg:WKrgtpar + 1)
      * ---------------------------------------------------------
      * Add new keyword.
      *
     C                   eval      WKcmdstg = %trim(WKcmdstg) + ' ' +
     C                                        %trim(WKkwdval)
      *
     C                   return    WKcmdstg
      *
     P RplCmdKwd       E
      ***********************************************************
      * Remove command keyword.
      ***********************************************************
     P RmvCmdKwd       B                   Export
      *
     D RmvCmdKwd       PI                  like(CmdStg)
     D  WPkwdval                           like(CmdStg) const
     D  WPcmdstg                           like(CmdStg) const
      *
     D  WKkwdval       s                   like(CmdStg) inz
     D  WKcmdkwd       s                   like(CmdStg) inz
     D  WKcmdstg       s                   like(CmdStg) inz
     D  WKkwdloc       s                   like(StdInt) inz
     D  WKlftpar       s                   like(StdInt) inz
     D  WKrgtpar       s                   like(StdInt) inz
      * ---------------------------------------------------------
      * Bring in parameters to workfields.
      *
     C                   eval      WKkwdval = WPkwdval
     C                   eval      WKcmdstg = WPcmdstg
      * ---------------------------------------------------------
      * Assure that keyword and command string are present.
      *
     C                   if        WKkwdval = *blanks or
     C                             WKcmdstg = *blanks
     C                   return    *blanks
     C                   endif
      *
      * Assure that parens are on keyword.
      *
     C                   if        %scan('(':WKkwdval) = *zero or
     C                             %scan(')':WKkwdval) = *zero
     C                   return    WKcmdstg
     C                   endif
      *
      * Assure that left parens is not in postion 1.
      *
     C                   if        %scan('(':WKkwdval) = 1
     C                   return    WKcmdstg
     C                   endif
      * ---------------------------------------------------------
      * Convert keyword to lower case.
      *
     C                   eval      WKkwdval = CvtCmdLwrCas(WKkwdval)
      *
      * Convert command to lower case.
      *
     C                   eval      WKcmdstg = CvtCmdLwrCas(WKcmdstg)
      * ---------------------------------------------------------
      * Extract keyword with paren.
      *
     C                   eval      WKcmdkwd = %trim(%subst(WKkwdval:1:
     C                                        %scan('(':WKkwdval)))
      *
      * Assure that keyword is present.
      *
     C                   if        WKcmdkwd = *blanks
     C                   return    WKcmdstg
     C                   endif
      * ---------------------------------------------------------
      * Determine keyword location.
      *
     C                   eval      WKkwdloc = %scan(%trim(WKcmdkwd):
     C                                                    WKcmdstg)
      *
     C                   if        WKkwdloc = *zero
     C                   return    WKcmdstg
     C                   endif
      * ---------------------------------------------------------
      * Find left and right parens.
      *
     C                   eval      WKlftpar=%scan('(':WKcmdstg:WKkwdloc)
     C                   eval      WKrgtpar=%scan(')':WKcmdstg:WKkwdloc)
      * ---------------------------------------------------------
      * Extract old keyword.
      *
     C                   eval      WKcmdstg = %subst(WKcmdstg:1:
     C                                        WKkwdloc - 1) +
     C                                        %subst(WKcmdstg:WKrgtpar + 1)
      *
     C                   return    WKcmdstg
      *
     P RmvCmdKwd       E
      ***********************************************************
      * Extract command keyword value.
      ***********************************************************
     P ExtCmdKwdVal    B                   Export
      *
     D ExtCmdKwdVal    PI                  like(CmdStg)
     D  WPkwdval                           like(CmdStg) const
     D  WPcmdstg                           like(CmdStg) const
      *
     D  WKkwdval       s                   like(CmdStg) inz
     D  WKcmdstg       s                   like(CmdStg) inz
     D  WKkwdloc       s                   like(StdInt) inz
     D  WKlftpar       s                   like(StdInt) inz
     D  WKrgtpar       s                   like(StdInt) inz
      * ---------------------------------------------------------
      * Bring in parameters to workfields.
      *
     C                   eval      WKkwdval = WPkwdval
     C                   eval      WKcmdstg = WPcmdstg
      * ---------------------------------------------------------
      * Assure that keyword and command string are present.
      *
     C                   if        WPkwdval = *blanks or
     C                             WPcmdstg = *blanks
     C                   return    WPcmdstg
     C                   endif
      *
      * Format the command so we know where the PGM is.
      * -- wasn't able to get this working.
      *
     C**                 eval      WKcmdstg = RtvFmtCmd(WPcmdstg)
      * ---------------------------------------------------------
      * Convert keyword and command to lower case.
      *
     C                   eval      WKkwdval = CvtCmdLwrCas(WPkwdval)
     C                   eval      WKcmdstg = CvtCmdLwrCas(WPcmdstg)
      * ---------------------------------------------------------
      * Determine keyword location.
      *
     C                   eval      WKkwdloc = %scan(%trim(WKkwdval):
     C                                                    WKcmdstg)
     C                   if        WKkwdloc = *zero
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      * Find left and right parens.
      *
     C                   eval      WKlftpar=%scan('(':WKcmdstg:WKkwdloc)
     C                   eval      WKrgtpar=%scan(')':WKcmdstg:WKkwdloc)
      * ---------------------------------------------------------
      * Extract keyword value.
      *
     C                   if        WKlftpar > *zero   and
     C                             WKrgtpar > 1
     C                   eval      WKcmdstg = %subst(WKcmdstg:WKlftpar+1:
     C                                        WKrgtpar - WKlftpar - 1)
     C                   else
     C                   return    *blanks
     C                   endif
      *
     C                   return    WKcmdstg
      *
     P ExtCmdKwdVal    E
      ***********************************************************
      * Convert command to lower case.
      ***********************************************************
     P CvtCmdLwrCas    B                   Export
      *
     D CvtCmdLwrCas    PI                  like(StdSQL)  opdesc
     D  CharValue                          like(StdSQL)  const
      *
     D RtnString       s                    like(StdSQL)  inz
     D WrkString       s                    like(StdSQL)  inz
     D WrkString2      s                    like(StdSQL)  inz
     D Eidx            s                    like(StdLen)  inz
     D Iidx            s                    like(StdLen)  inz
     D Length          s                    like(StdLen)  inz
     D LeftByte        s                    like(StdLen)  inz
     D NbrofChar       s                    like(StdLen)  inz
     D DescType        s                    like(StdInt)  inz
     D DataType        s                    like(StdInt)  inz
     D DescInfo1       s                    like(StdInt)  inz
     D DescInfo2       s                    like(StdInt)  inz
     D InLen           s                    like(StdInt)  inz
      *
     D x               s                    like(StdInt) inz
     D Quote           s                    like(StdChr) inz('''')
     D InQuote         s                    like(StdInd) inz
      * ---------------------------------------------------------
      *
      *    Determine length of input string.
      *
     C                   CALLP     CEEDOD(1         : DescType : DataType :
     C                                    DescInfo1 : DescInfo2: InLen    :
     C                                    *OMIT)
      *
      *    Test for no input.
      *
     C                   if        %subst(CharValue:1:Inlen) = *blanks
     C                   return    *blanks
     C                   endif
      *
      *    Extract the character value to the end of the string.
      *
     C                   eval      WrkString = %subst(CharValue:1:InLen)
      *
      *    Locate leftmost byte of character data.
      *
     C     ' '           check     CharValue     LeftByte
      *
      *    Determine the length of the string.
      *
     C                   eval      Length = InLen - LeftByte + 1
      *
      *    If there is no data then get out.
      *
     C                   if           Length    <= *zero
     C                             or LeftByte  <= *zero
     C                             or LeftByte  >= InLen
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *    Extract the character value to the end of the string.
      *
     C                   eval      WrkString =
     C                               %subst(CharValue:LeftByte:Length)
      *
      *    Convert to lower case.
      *
     C                   for       x = 1 to Length
     C                   if        %subst(WrkString:x:1) = Quote
     C                   if        InQuote
     C                   eval      InQuote = *off
     C                   else
     C                   eval      InQuote = *on
     C                   endif
     C                   endif
      *
     C                   if        InQuote
     C                   eval      %subst(RtnString:x:1) =
     C                             %subst(WrkString:x:1)
     C                   else
     C                   eval      %subst(RtnString:x:1) =
     C                             %xlate(uppr:lowr:%subst(WrkString:x:1))
     C                   endif
     C                   endfor
      *
     C                   return    RtnString
      *
     P CvtCmdLwrCas    E
      ***********************************************************
      * System command.
      ***********************************************************
     P System          B                   export
      *
     D System          PI                  like(msgid)
     D  CmdString                          like(CmdStg) const
     D  RmvErrMsg_p                   4    const options(*nopass)
      *
     D SystemProc      pr                  extproc('system')
     D                                     like(StdInt)
     D  SysCmd                             like(StdPtr) value
     D                                     options(*string)
      *
     D ZZpgm           s                   like(StdNam)       inz
     D RmvErrMsg       s                   like(RmvErrMsg_p)  inz
     D RC              s                   like(StdInt)       inz
     D NullString      c                   -1
     D Success         c                   0
      /free
       // -------------------------------------------------------
       //    Check for omitted parameters.

       if %parms >= 2;
         RmvErrMsg = Upper(RmvErrMsg_p);
       endif;
       // -------------------------------------------------------
       //    Execute the command.

       RC = SystemProc(CmdString);

       // -------------------------------------------------------
       //  Remove error message.

       if RmvErrMsg = '*YES';
         exsr $PMrcv;
         return *blanks;
       endif;

       // -------------------------------------------------------
       //  Return if ok, or nothing passed.

       if RC = Success  or
          RC = Nullstring;
         return *blanks;
       endif;

       // -------------------------------------------------------
       //  Pass back error message.

       if ErrMsgid <> *blanks;
         exsr $PMrcv;
         if   msgid <> *blanks;
           torel = '*PRV';
           exsr $PMsnd;
         endif;

         msgid  = 'GNL0086';
         msgdta = CmdString;
         torel  = '*PRV';
         exsr $PMsnd;
       endif;

       return ErrMsgid;

      /end-free
      /undefine $PMRCV_copied
      /undefine $PMSND_copied
      /COPY QCPYSRC,$PMrcv
      /COPY QCPYSRC,$PMsnd
      *
     P System          E
      ***********************************************************
      * Retrieve formatted command.
      ***********************************************************
     P RtvFmtCmd       B                   export
      *
     D RtvFmtCmd       PI                  like(CmdStg)
     D  CmdStr                             like(CmdStg) const
      *
     D CmdLen          s                   like(StdInt) inz(%len(CmdStr))
     D OCBLen          s                   like(StdInt) inz(%len(OptCtlBlk))
     D OCBFmt          s                   like(StdFmt) inz('CPOP0100')
     D ChgCmdStr       s                   like(CmdStg) inz
     D ChgCmdAvl       s                   like(StdInt) inz
     D ChgCmdLen       s                   like(StdInt) inz
      *
     D OptCtlBlk       ds
     D  TypOfCmdP                          like(StdInt) inz(1)
     D  DBCS                               like(StdChr) inz('0')
     D  Prompt                             like(StdChr) inz('0')
     D  CmdStrSyn                          like(StdChr) inz('0')
     D  MsgKey                        4    inz
     D  Resvd1                        9    inz(*loval)
      * ---------------------------------------------------------
      *
      *    Retrieve the formatted command.
      *
     C                   callp     QCAPCMD(CmdStr    :CmdLen    :
     C                                     OptCtlBlk :OCBLen    :
     C                                     OCBFmt    :ChgCmdStr :
     C                                     ChgCmdAvl :ChgCmdLen :
     C                                     dsEC)
      *
     C                   return    ChgCmdStr
      *
     P RtvFmtCmd       E
