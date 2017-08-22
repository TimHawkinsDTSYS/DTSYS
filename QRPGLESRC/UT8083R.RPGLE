      /TITLE Utility, Hex (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8083S
      * *********************************************************
      * CvtChrToHex() -- Convert Character to Hex.
      * *********************************************************
     P CvtChrToHex     b                   export

     D CvtChrToHex     pi         32767
     D  input                     16384    options(*varsize) const

     D output          s          32767    inz

      /free
       // -------------------------------------------------------
       // CvtChrToHex() -- Convert Character to Hex.

       cvthc(output:input:%len(input)*2);

       return output;

      /end-free

     P CvtChrToHex     e
      * *********************************************************
      * CvtHexToChr() -- Convert Hex to Character.
      * *********************************************************
     P CvtHexToChr     b                   export

     D CvtHexToChr     pi         16384
     D  input                     32767    options(*varsize) const

     D output          s          16384    inz

      /free
       // -------------------------------------------------------
       // CvtHexToChr() -- Convert Hex to Character.

       cvtch(output:input:%len(input));

       return output;

      /end-free

     P CvtHexToChr     e
