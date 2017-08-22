      /TITLE Utility, Generate character set
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Copy character set word length database records
      *              from a standard group (*DEFAULT) for customization.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  12/14/05  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /EJECT
      *
      *
      /COPY QCPYSRC,Hspec
      *
     FESchrwid1 if   e           k disk    rename(chrwidr:chrwidr1)
     FESchrwid  if a e           k disk
      *
    DD chrwid        e ds                  extname(ESchrwid) occurs(100) inz
      *
    DD PLchrset        s                   like(SWchrset)
      *
    DD AYchr           s            256    inz('abcdefghijklmnopqrstuvwxyz+
     D                                          ABCDEFGHIJKLMNOPQRSTUVWXYZ+
     D                                          0123456789+
     D                                          ,.;:"/<>?{}|[]\+
     D                                          ~`!@#$%¢&*()_-=')
    DD AYlen           s                   like(StdInt) inz
    DD x               s                   like(StdInt) inz
    DD MaxIdx          s                   like(StdInt) inz
    DD CurIdx          s                   like(StdInt) inz
      *
      /COPY QCPYSRC,Dspec
      * ---------------------------------------------------------
      *
      *   Load chracter set word records from previous results.
      *
     C                   exsr      $PrvLoad
      *
      *   Scratch load chracter set word records.
      *
     C**                 exsr      $ScrLoad
      *
     C                   eval      *inLR = *on
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Load chracter set word records from previous results.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $PrvLoad      begsr
      /free

       // Load multiple occurance DS with default set.

       setll ('*DEFAULT') chrwidr1;
       reade ('*DEFAULT') chrwidr1;

       dow not %eof;
           MaxIdx += 1;
           %occur(chrwid) = MaxIdx;
           reade ('*DEFAULT') chrwidr1;
       enddo;

       // Write new character set.

       for CurIdx = 1 to MaxIdx;
           %occur(chrwid)  = CurIdx;
           SWchrset = PLchrset;
           setll (SWchrset:SWprtchr) chrwidr;

           if not %equal;
              write chrwidr;
           endif;
       endfor;

      /end-free
     CSR   #PrvLoad      endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Scratch load chracter set word records.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $ScrLoad      begsr
      /free

       // Insert a blank and a quote.

       AYchr = %trim(AYchr) + ' ' + x'8D';

       // Determine length.

       AYlen = %len(%trim(AYchr));

       // Write all characters.

       for x = 1 to AYlen;
           SWchrset = PLchrset;
           SWprtchr = %subst(AYchr:x:1);
           setll (SWchrset:SWprtchr) chrwidr;

           if not %equal;
              write chrwidr;
           endif;
       endfor;

      /end-free
     CSR   #ScrLoad      endsr
      /SPACE 3
      /COPY QCPYSRC,$PSSR
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Initialization
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   *inzsr        begsr
      *
     CSR   #inzsr        endsr
      /SPACE 3
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Definitions
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     CSR   $define       begsr
      *
     C     *entry        plist
     C                   parm                    PLchrset
      *
     CSR   #define       endsr
