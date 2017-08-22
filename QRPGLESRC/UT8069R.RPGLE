      /TITLE Utility, SQL (SrvPgm)
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
      * Run dynamic SQL statement.
      ***********************************************************
     P RunDynSQLstm    B                   export
      *
     D RunDynSQLstm    PI
     D   SQLstmt                           like(StdSQL ) value
      * ---------------------------------------------------------
      *
     C                   call      'UT1830R'
     C                   parm                    SQLstmt
      *
     C                   return
      *
     P RunDynSQLstm    E
      ***********************************************************
      * Submit dynamic SQL statement.
      ***********************************************************
     P SbmDynSQLstm    B                   export
      *
     D SbmDynSQLstm    PI
     D   JobNam                            like(StdNam ) value
     D   SQLstmt                           like(StdSQL ) value
      * ---------------------------------------------------------
      *
     C                   call      'UT1830C'
     C                   parm                    JobNam
     C                   parm                    SQLstmt
      *
     C                   return
      *
     P SbmDynSQLstm    E
      ***********************************************************
      * Set return value as quoted string.
      ***********************************************************
     P quote           b                   export

    DD quote           pi          1026a   varying
    DD string                      1024a   const varying

    DD result          s           1026a   varying
    DD i               s             10i 0
    DD ch              s              2a   varying
      * ---------------------------------------------------------

      /free
       // Prime result
       result = '''';

       // Loop for each character of input parameter
       for i = 1 to %len(string);
          ch = %subst(string:i:1);

          // Convert apostrophe into doubled apostrophe
          if ch = '''';
             ch = '''''';
          endif;

          // Append character to result
          %len(result) = %len(result) + %len(ch);
          %subst(result:%len(result)-%len(ch)+1) = ch;
       endfor;
       %len(result) = %len(result) + 1;
       %subst(result:%len(result)) = '''';

       return result;
      /end-free

     P quote           e
      * **********************************************************
      *  Swap ascending/descending.
      * **********************************************************
     P SwapAscDesc     B                   Export
      *
     D SwapAscDesc     PI                  like(StdSQL)
     D  ChrString                          like(StdSQL)
      *
      *  Standalone fields
      *
     D AscDscWrd       ds                  likeds(t_ExtWords)
     D                                     based(pAscDscWrd)
      *
     D x               s                   like(StdInt)       inz
      * ---------------------------------------------------------
      *
      *    Escape if nothing passed.
      *
     C                   if        ChrString = *blanks
     C                   return    ChrString
     C                   endif
      * ---------------------------------------------------------
      *
      *    Change string to all lower case.
      *
     C                   eval      ChrString = lower(ChrString)
      * ---------------------------------------------------------
      *
      *    Extract words.
      *
     C                   eval      pAscDscWrd = ExtWords(ChrString)
      * ---------------------------------------------------------
      *
      *    Set the sort order.
      *
     C                   for       WordsIdx = 1 to AscDscWrd.WordsMax
     C                   select
     C                   when      AscDscWrd.words(WordsIdx) = 'desc'
     C                   eval      AscDscWrd.words(WordsIdx) = 'asc'
      *
     C                   when      AscDscWrd.words(WordsIdx) = 'desc,'
     C                   eval      AscDscWrd.words(WordsIdx) = 'asc,'
      *
     C                   when      AscDscWrd.words(WordsIdx) = 'asc'
     C                   eval      AscDscWrd.words(WordsIdx) = 'desc'
      *
     C                   when      AscDscWrd.words(WordsIdx) = 'asc,'
     C                   eval      AscDscWrd.words(WordsIdx) = 'desc,'
     C                   endsl
     C                   endfor
      * ---------------------------------------------------------
      *
      *    Concatenate it back.
      *
     C                   eval      ChrString = AscDscWrd.words(1)
      *
     C                   for       WordsIdx = 2 to AscDscWrd.WordsMax
     C                   eval      ChrString = %trim(ChrString) + ' ' +
     C                                         AscDscWrd.words(WordsIdx)
     C                   endfor
      *
     C                   dealloc                 pAscDscWrd
      *
     C                   return    ChrString
      *
     P SwapAscDesc     E
