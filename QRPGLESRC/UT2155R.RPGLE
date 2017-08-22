      /TITLE Utility, Print a character set
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Produces a list of each of the characters in a
      *              character set so that they can be measured.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  12/15/05  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /COPY QCPYSRC,Hspec
      *
     FESchrwid1 if   e           k disk    rename(chrwidr:chrwidr1)
     Fut2155p   o    e             printer infds(DSprt) usropn
      *
     D chrsw         e ds                  extname(ESchrwid) inz
      *
     D PLchrset        s                   like(SWchrset)
     D PLfntlib        s                   like(StdNam)
     D PVchrwid        s                   like(SWchrwid) inz
     D WKchrwid        s                   like(SWchrwid) inz
     D chrwidlmt       s                   like(SWchrwid) inz(1.10)
     D nbrchr          s                   like(Stdint)   inz
     D seclvl          s                   like(StdStg)   inz
      *
      /copy qcpysrc,Dspec
      * ---------------------------------------------------------
      *
      *   Process brochure requests.
      *
     C                   exsr      $Main
      *
     C                   eval      *inLR = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Process brochure requests.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $Main         begsr
      * ---------------------------------------------------------
      *
      *   Process all records for this character set.
      *
     C     PLchrset      setll     chrwidr1
     C     PLchrset      reade     chrwidr1
      *
š1b€ C                   dow       not %eof
     C                   exsr      $Print
     C     PLchrset      reade     chrwidr1
š1e€ C                   enddo
      *
      *
     CSR   #Main         endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Print character set.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $print        BEGSR
      *
     C                   eval      WKprtchr = *blanks
      * ---------------------------------------------------------
      *
      *   Set number of characters to print.
      *
     C                   if        SWchrwid > chrwidlmt
     C                   eval      nbrchr   = 50
     C                   else
     C                   eval      nbrchr   = 100
     C                   endif
      * ---------------------------------------------------------
      *
      *   Format characters to print.
      *
     C                   if        SWprtchr = *blanks
     C                   eval      %subst(WKprtchr:nbrchr+1) = '('
     C                   else
      *
     C                   do        nbrchr
     C                   eval      WKprtchr = %trim(WKprtchr) + SWprtchr
     C                   enddo
      *
     C                   eval      WKprtchr = %trim(WKprtchr) + '('
     C                   endif
      * ---------------------------------------------------------
      *
      *   Insert current width and characters printed.
      *
     C                   eval      WKprtchr = %trim(WKprtchr) +
     C                                 %trim(%editc(SWchrwid:'J')) + ') at '
     C                                 + %char(nbrchr)
      *
     C                   if        SWchrwid > chrwidlmt
     C                   eval      WKchrwid = SWchrwid / 2
     C                   eval      WKprtchr = %trim(WKprtchr) + ' /2=' +
     C                                 %trim(%editc(WKchrwid:'J'))
     C                   endif
      * ---------------------------------------------------------
      *
      *   Print detail.
      *
     C                   exsr      $ChkHdg
     C                   write     #Detail                              OF
      *
     Csr   #print        ENDSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Check headings.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   $ChkHdg       BEGSR
      * ---------------------------------------------------------
      *
      *   Check line count or changed width.
      *
š1b€ C                   if         not *inOF      and
š1b€ C                             (Z3cln     > 45 or
š1b€ C                              Z3cln     > 35 and
     C                              SWchrwid <> PVchrwid)
     C                   eval      *inOF     = *on
š1e€ C                   endif
      *
      *   Print page headings.
      *
š1b€ C                   if        *inOF
     C                   write     #PagHdg
š1e€ C                   endif
      *
      *   Print detail headings.
      *
š1b€ C                   if        *inOF                 or
     C                             SWchrwid <> PVchrwid  and
     C                             PVchrwid <> *zero
     C                   write     #DtlHdg
     C                   endif
      *
      *   Reset overflow indicator.
      *
š1b€ C                   if        *inOF
     C                   eval      *inOF = *off
     C                   endif
      *
     C                   eval      PVchrwid  = SWchrwid
      *
     Csr   #ChkHdg       ENDSR
      /SPACE 3
      /COPY QCPYSRC,$PSSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * INITIALIZE PROGRAM
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     Csr   *inzsr        BEGSR
      *
     C                   eval      today  = CurrentDate()
     C                   eval      COname = 'Company Name'
      * ---------------------------------------------------------
      *
      *    Override print file.
      *
     C                   eval      seclvl = 'ovrprtf ut2155p +
     C                             usrdta(' + PLchrset + ')'
     C                   callp     ExecCmd(seclvl)
     C                   open      ut2155p
      * ---------------------------------------------------------
      *
      *   Set headings to print.
      *
     C                   eval      *inOF      = *on
     C                   eval      *in40      = *on
     C                   exsr      $ChkHdg
     C                   eval      *in40      = *off
      *
     C                   eval      chrset     = PLchrset
     C                   eval      fntlib     = PLfntlib
      *
     C     *entry        plist
     C                   parm                    PLchrset
     C                   parm                    PLfntlib
      *
     Csr   #inzsr        ENDSR
