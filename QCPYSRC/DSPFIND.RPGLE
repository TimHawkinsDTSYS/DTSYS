      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Display file indicator usage overlay.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     DIndicators       ds                  Based(IndicatorP)
     D SflMode                11     11n
     D SetCsrPos              41     41n
     D SflDspCtl              50     50n
     D SflDsp                 51     51n
     D SflEnd                 52     52n
     D SflClr                 53     53n
     D SflDlt                 54     54n
     D SflInz                 55     55n
     D FrcDta                 58     58n
     D SflNxtChg              59     59n
     D VldCmdKey              90     90n
     D PutOvr                 91     91n
      *
     D IndicatorP      s               *   inz(%Addr(*in))
      *
     D*SflMode         s                   like(StdInd) inz(*on)
