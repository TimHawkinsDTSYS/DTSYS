      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Remark prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * Remark standard variables.
      *
     D RMprtrmklen     s                   like(StdInt) inz(80)
     D RMchrset        s                   like(StdFmt) inz('*FIXED')
      *
     D AYrmkrtv        s                   like(StdInt)
     D AYrmkwk         s                   like(DFNrmkwk) dim(50)
      *---------------------------------------------------------
      * ChrSetPrtLin() -- Character set print line.
      *
     D ChrSetPrtLin    PR                  like(d_ChrSetPrtLin)
     D  string                    32767    varying           const
     D  chrset                             like(RMchrset)    const
     D                                     options(*nopass)
     D  prtrmklen                          like(StdInt)      const
     D                                     options(*nopass)
     D  options                            like(StdStr)      const
     D                                     options(*nopass)
      *
     D d_ChrSetPrtLin  ds                  inz
     D  AYrmklin                           like(StdInt)
     D  AYrmktxt                           like(StdStr) dim(150)
      *---------------------------------------------------------
      * ChrSetWrdLen() -- Character set word length.
      *
     D ChrSetWrdLen    PR                  like(dfnSWchrwid)
     D  string                      256    varying           const
     D  chrset                             like(RMchrset)    const
     D                                     options(*nopass)
      *---------------------------------------------------------
      * SetParFmt() -- Set paragraph formatting.
      *
     D SetParFmt       PR         32767    varying
     D  InpString                 32767    varying const
      *---------------------------------------------------------
      * RmvColFmt() -- Remove color formatting.
      *
     D RmvColFmt       PR         32767    varying
     D  InpString                 32767    varying         const
     D  options                            like(StdStr)    const
     D                                     options(*nopass)
      *---------------------------------------------------------
      * RmvPrtLoc() -- Remove print locations.
      *
     D RmvPrtLoc       PR         32767    varying
     D  InpString                 32767    varying         const
     D  options                            like(StdStr)    const
     D                                     options(*nopass)
      *---------------------------------------------------------
      *InsSpcPrtCde() -- Insert space between print codes.
      *
     D InsSpcPrtCde    PR         32767    varying
     D  InpString                 32767    varying         const
     D  options                            like(StdStr)    const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * ClnPrtLoc() -- Clean print location.
      *
     D ClnPrtLoc       PR                  like(dfnRWprtloc)
     D  PrtLoc                             like(dfnRWprtloc) value
      * ---------------------------------------------------------
      * ChkPrtLoc() -- Check print location.
      *
     D ChkPrtLoc       PR                  like(StdInd)
     D  FileName                           like(StdNam)      value
     D  PrtLoc                             like(dfnRWprtloc) value
      * ---------------------------------------------------------
      * AddSpcBfrBgnTag() -- Add space before begin tag.
      *
      *
     D AddSpcBfrBgnTag...
     D                 PR         32767    varying
     D  InpString                 32767    varying const
      * ---------------------------------------------------------
      * AddSpcAftEndTag() -- Add space after end tag.
      *
      *
     D AddSpcAftEndTag...
     D                 PR         32767    varying
     D  InpString                 32767    varying const
      * ---------------------------------------------------------
      * AddSpcBfrAftTag() -- Add space before and after tags.
      *
     D AddSpcBfrAftTag...
     D                 PR         32767    varying
     D  InpString                 32767    varying const
