      /TITLE Utility, Display file (SrvPgm)
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
      * Retrieve panel dimensions.
      ***********************************************************
     P RtvPnlDim       B                   Export
      *
     D RtvPnlDim       PI             4
      *
     D QsnRtvScrDim    PR                  extproc('QsnRtvScrDim')
     D                                     like(StdInt)
     D   NbrRows                           like(StdInt) options(*omit)
     D   NbrCols                           like(StdInt) options(*omit)
     D   Handle                            like(StdInt) options(*omit)
     D   ErrorCode                         like(StdBuf)
     D                                     options(*varsize: *omit)
      *
     D cols            s                   like(StdInt)
      * ---------------------------------------------------------
      *
     c                   callp     QsnRtvScrDim(*omit:cols:*omit:*omit)
      *
     c                   if        cols = 132
     c                   return    '*DS4'
     c                   else
     c                   return    '*DS3'
     c                   endif
      *
     P RtvPnlDim       E
      ***********************************************************
      * SetDspModDS4() -- Set display mode if *DS4
      ***********************************************************
      *
     P SetDspModDS4    B                   Export

     D SetDspModDS4    PI                  like(StdInd)
      * ---------------------------------------------------------
      *
      *   QsnRtvMod() -- Query retrieve mode (24x80 or 27x132)
      *
     D QsnRtvMod       PR                  ExtProc('QsnRtvMod')
     D  DspMod                             like(StdChr)
     D  Handle                             like(StdInt)
     D                                     options(*omit)
     D  ErrorDS                            like(APIerrorDS)
     D                                     options(*omit)

     D wk001a          s                   like(StdChr) inz
     D RtnInd          s                   like(StdInd) inz

      /Free

        eval      wk001a = '4';

        callp     QsnRtvMod(wk001a:*omit:*omit);

        if        wk001a = '4';
          eval    RtnInd = *on;
        else;
          eval    RtnInd = *off;
        endif;

         return RtnInd;

      /End-Free

     P SetDspModDS4    E
