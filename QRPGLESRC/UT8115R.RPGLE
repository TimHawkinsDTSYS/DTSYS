      /TITLE Utility, Source text (SrvPgm)
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
      * **********************************************************
      * ExtSrcTxt() - Extract source text
      * **********************************************************
     P ExtSrcTxt       B                   Export
      *
     Fqtxtsrc   if   e             disk    static
     F                                     extdesc('TSPRDOBJ/QTXTSRC')
     F                                     rename(qtxtsrc: rtxtsrc)
     F                                     extfile(srcfile)
     F                                     extmbr(srcmbr)
     F                                     usropn
      *
     D ExtSrcTxt       pi                  likeDS(t_ExtSrcTxt)
     D  in_tag                             like(StdStg) const
     D                                     options(*omit: *nopass)
     D  in_options                         like(StdStg) const
     D                                     options(*omit: *nopass)
      *
     D d_ExtSrcTxt     ds                  likeDS(t_ExtSrcTxt) inz

      * ---------------------------------------------------------
      * Standalone fields
      *
     D AYtxtsrcidx     s                   like(StdInt) inz           static
     D AYtxtsrc        s            256    varying      inz dim(1000) static

     D srcfile         s                   like(StdQnm) inz
     D srcmbr          s                   like(StdNam) inz

     D wk_tag          s                   like(StdStg) inz
     D wk_options      s                   like(StdStg) inz

     D x               s                   like(StdInt) inz
     D FndTag          s                   like(StdInd) inz
     D LoadArray       s                   like(StdInd) inz

     D DStxtsrc        ds                  likerec(rtxtsrc)
      /free
       // -------------------------------------------------------
       // Check for omitted parameters.

       if  %parms           >= 1;
           CEETSTA(ParmPassed: 1: *omit);
           if  ParmPassed = 1;
               wk_tag  = in_tag;
           endif;
       endif;

       if  %parms           >= 2;
           CEETSTA(ParmPassed: 2: *omit);
           if  ParmPassed = 1;
               wk_options = upper(in_options);
           endif;
       endif;

       // -------------------------------------------------------
       // Open the specified member.

       if  %scan('MBR(': wk_options) <> *zero;
           exsr  $OpnMbr;
       endif;

       // -------------------------------------------------------
       // Extract tagged source data.

       exsr  $ExtTagSrcDta;

       return  d_ExtSrcTxt;

       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       // Open the specified member.
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       begsr $OpnMbr;

       // -------------------------------------------------------
       // Extract file and member from options.

       if  %open(qtxtsrc);
           close qtxtsrc;
       endif;

       srcfile = upper(ExtCmdKwdVal('FILE': wk_options));
       srcmbr  = upper(ExtCmdKwdVal('MBR':  wk_options));

       if  srcfile = *blanks;
           srcfile = 'QTXTSRC';
       endif;

       if  srcmbr = *blanks;
           srcmbr = '*FIRST';
       endif;

       open qtxtsrc;

       // -------------------------------------------------------
       // Load text source array.

       AYtxtsrcidx = *zero;
       AYtxtsrc(*) = *blanks;

       read rtxtsrc DStxtsrc;

       dow  not %eof;
            AYtxtsrcidx += 1;
            AYtxtsrc(AYtxtsrcidx) = DStxtsrc.srcdta;

            read rtxtsrc DStxtsrc;
       enddo;

       close qtxtsrc;

       endsr;
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       // Extract tagged source data.
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       begsr $ExtTagSrcDta;

       FndTag      = *off;
       LoadArray   = *off;
       reset d_ExtSrcTxt;

       // -------------------------------------------------------
       // Extract tagged source data.

       for  x = 1 to AYtxtsrcidx;

            FndTag = (%scan('%' + %trim(wk_tag) + '%': AYtxtsrc(x)) <> *zero);

            select;
            when  not FndTag  and    // nothing found yet.
                  not LoadArray;

            when  FndTag    and      // found start tag.
                  not LoadArray;
                  LoadArray = *on;

                  if  %scan('INCTAG(*YES)': wk_options) <> *zero;
                      exsr  $ExtSrcDta;
                  endif;

            when  FndTag    and      // found end tag.
                  LoadArray;

                  if  %scan('INCTAG(*YES)': wk_options) <> *zero;
                      exsr  $ExtSrcDta;
                  endif;
                  leave;

            when  LoadArray;         // load return array element
                  exsr  $ExtSrcDta;
            endsl;
       endfor;

       endsr;
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       // Extract source data.
       // * * * * * * * * * * * * * * * * * * * * * * * * * * * *
       begsr $ExtSrcDta;

       // -------------------------------------------------------
       // Extract source data.

       d_ExtSrcTxt.maxidx += 1;
       d_ExtSrcTxt.AYtxt(d_ExtSrcTxt.maxidx) = AYtxtsrc(x);

       endsr;
      /end-free
     P ExtSrcTxt       E
