      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Import prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *  ImpMDYtoISO() -- Import m/d/yyyy to yyyymmdd.
      *
     D ImpMDYtoISO     pr                  like(WKiso)
     D  I_mdy                              like(WKmdy)
      *
     D WKmdy           s             10                  inz
     D WKalpMM         s                   like(AlpMM)   inz
     D WKalpDD         s                   like(AlpDD)   inz
     D WKalpYYYY       s                   like(AlpYYYY) inz
     D WKalpISO        s                   like(AlpISO)  inz
     D WKiso           s                   like(NumISO)  inz
      * ---------------------------------------------------------
      *
      *  ImpAlptoNum() -- Import alpha string to numeric.
      *
     D ImpAlptoNum     pr                  like(WKnumamt)
     D  I_alpamt                           like(WKalpamt)
      *
     D WKalpamt        s             15                  inz
     D WKnumamt        s              9  2               inz
