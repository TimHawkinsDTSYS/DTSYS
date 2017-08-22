      /TITLE Utility, String general (SrvPgm)
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
      * RplStg() - Replace String
      * **********************************************************
     P RplStg          B                   Export
      *
     D RplStg          PI         65535    varying
     D  p_String                  65535    varying const
     D  p_FmReplace                8000    varying const
     D  p_ToReplace                8000    varying const
     D                                     options(*omit:*nopass)
     D  p_Options                          like(StdStg) const
     D                                     options(*omit:*nopass)
      *
     D OutString       s          65535    varying      inz
     D WkString        s          65535    varying      inz
     D WkFmReplace     s           8000    varying      inz
     D WkToReplace     s           8000    varying      inz
     D i_ToReplace     s           8000    varying      inz
     D ToReplaceLen    s                   like(StdInt) inz
     D StrPos          s                   like(StdInt) inz
     D FndPos          s                   like(StdInt) inz
     D options         s                   like(StdStg) inz
      /free
       // -------------------------------------------------------
       // Test for no input.

       if p_String = *blanks;
          return *blanks;
       endif;

       // -------------------------------------------------------
       // Extract parms.

       if %parms >= 3;
         CEETSTA(ParmPassed:3:*omit);
         if ParmPassed = 1;
            i_ToReplace = p_ToReplace;
         endif;
       endif;

       if %parms >= 4;
         CEETSTA(ParmPassed:4:*omit);
         if ParmPassed = 1;
            options = upper(p_Options);
         endif;
       endif;

       // -------------------------------------------------------
       // Case options.

       select;
       when %scan('*IGNCASE':options) <> *zero;
            WkString    = upper(p_String);
            WkFmReplace = upper(p_FmReplace);
            WkToReplace = i_ToReplace;

            %len(WkString)    = %len(p_String);
            %len(WkFmReplace) = %len(p_FmReplace);

       when %scan('*FRCUPPER':options) <> *zero;
            WkString    = upper(p_String);
            WkFmReplace = upper(p_FmReplace);
            WkToReplace = upper(i_ToReplace);

            %len(WkString)    = %len(p_String);
            %len(WkFmReplace) = %len(p_FmReplace);
            %len(WkToReplace) = %len(i_ToReplace);

       when %scan('*FRCLOWER':options) <> *zero;
            WkString    = lower(p_String);
            WkFmReplace = lower(p_FmReplace);
            WkToReplace = lower(i_ToReplace);

            %len(WkString)    = %len(p_String);
            %len(WkFmReplace) = %len(p_FmReplace);
            %len(WkToReplace) = %len(i_ToReplace);

       other;
            WkString    = p_String;
            WkFmReplace = p_FmReplace;
            WkToReplace = i_ToReplace;
       endsl;

       // -------------------------------------------------------
       // Replace string.
       // -- We seek to preserve the case of any text not
       //    included in the scan/replace.

       // -- WkString = set to upper/lower case
       //    WkFmReplace = replace from string in upper/lower case
       //    WkToReplace = replace to string in upper/lower case
       //    OutString = output string

       OutString = p_String;
       strpos = 1;
       ToReplaceLen = %len(i_ToReplace);
       FndPos = %scan(WkFmReplace: WkString: strpos);

       dow FndPos > *zero;

           // Replace out string.

           OutString =
           %replace(WkToReplace: OutString: FndPos: %len(WkFmReplace));

           // Replace scan string used in DOW.

           WkString =
           %replace(WkToReplace: WkString: FndPos: %len(WkFmReplace));

           strpos = FndPos + ToReplaceLen;
           if  strpos + %len(WKfmReplace) > %len(WKstring);
               leave;
           endif;

           FndPos = %scan(WkFmReplace: WKstring: strpos);
       enddo;

       return OutString;

      /end-free
     P RplStg          E
