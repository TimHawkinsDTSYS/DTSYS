      /TITLE Utility, Email (test)
      *PARMS
      *
      /copy qcpysrc,Hspec
      *
     Fqrpglesrc up   e             disk    rename(qrpglesrc: rpglesrc)
     F                                     extfile('TSPRDOBJ/QRPGLESRC')
     F                                     extmbr('UT8087RX')
      *
      /copy qcpysrc,Dspec

     D x               s                   like(StdInt) inz
      /free
       // -------------------------------------------------------
       // Remove any < 'x40' characters.

       for  x = 1 to %len(srcdta);

            if  %subst(srcdta: x: 1) < x'40';
                joblog(%char(srcseq) + '=(' + %char(x) + ')' + srcdta);
                %subst(srcdta: x: 1) = *blanks;
            endif;
       endfor;

       update rpglesrc;

      /end-free
