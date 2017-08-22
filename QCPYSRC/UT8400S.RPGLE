      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Date/time definitions.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Standalone fields
      *
     D DteMDY          s               D   datfmt(*mdy) based(StdNulPtr)
     D DteDMY          s               D   datfmt(*dmy) based(StdNulPtr)
     D DteYMD          s               D   datfmt(*ymd) based(StdNulPtr)
     D DteJUL          s               D   datfmt(*jul) based(StdNulPtr)
     D DteISO          s               D   datfmt(*iso) based(StdNulPtr)
     D DteUSA          s               D   datfmt(*usa) based(StdNulPtr)
     D DteEUR          s               D   datfmt(*eur) based(StdNulPtr)
     D DteJIS          s               D   datfmt(*jis) based(StdNulPtr)
     D TimStp          s               Z                based(StdNulPtr)
     D TimHMS          s               T                based(StdNulPtr)
      *
      *  Define constants.
      *
     D NullTSP         s               z   inz
      *
      *  Define likes.
      *
     D Days            S              5  0 inz
     D Week            S              2  0 inz
     D Weeks           S              5  0 inz
     D Months          S              5  0 inz
     D Years           S              5  0 inz
     D Quarter         S              1  0 inz
     D Secs            S              9  0 inz
     D Mins            S              7  2 inz
     D Hours           S              7  2 inz
      *
     D Alpmed          S              1    inz
     D AlpDD           S              2    inz
     D AlpMM           S              2    inz
     D AlpMMM          S              3    inz
     D AlpMY           S              4    inz
     D AlpCC           S              2    inz
     D AlpYY           S              2    inz
     D AlpYYM          S              6    inz
     D AlpYYYY         S              4    inz
     D AlpDDMMMYY      S              7    inz
     D AlpDDMMMYYYY    S              9    inz
     D AlpAMPM         S              1    inz
     D AlpISO          S              8    inz
     D AlpMDY          S              6    inz
     D AlpUSA          S              8    inz
     D AlpYMD          S              6    inz
     D AlpDM           S              5    inz
     D AlpDMY          S              7    inz
     D AlpDMYY         S              9    inz
     D AlpHM           S              4    inz
     D AlpHH           S              2    inz
     D AlpMN           S              2    inz
     D AlpSS           S              2    inz
     D AlpHMS          S              6    inz
     D AlpTimStp       S             26    inz
     D TimDur          S             12    inz
      *
     D NumHM           S              4  0 inz
     D NumHMS          S              6  0 inz
     D NumHHMM         S              4  0 inz
     D NumHH           S              2  0 inz
     D NumMN           S              2  0 inz
     D NumSS           S              2  0 inz
     D NumDD           S              2  0 inz
     D NumMM           S              2  0 inz
     D NumCC           S              2  0 inz
     D NumYY           S              2  0 inz
     D NumYYYY         S              4  0 inz
     D NumMD           S              4  0 inz
     D NumMY           S              4  0 inz
     D NumYYM          S              6  0 inz
     D NumMDY          S              6  0 inz
     D NumUSA          S              8  0 inz
     D NumISO          S              8  0 inz
     D NumYMD          S              6  0 inz
     D NumWEEK         S              2  0 inz
     D NumQTR          S              2  0 inz
      *
     D EdtDM           S              5    inz
     D EdtDMY          S              7    inz
     D EdtDMYY         S              9    inz
     D EdtMD           S              5    inz
     D EdtMDY          S              8    inz
     D EdtUSA          S             10    inz
     D EdtHM           S              5    inz
     D EdtHMS          S              8    inz
     D EdtHMm          S              6    inz
      *
     D WrkHMS          S                   like(NumHMS ) inz
     D WrkHH           S                   like(NumHH  ) inz
     D WrkMN           S                   like(NumMN  ) inz
     D WrkSS           S                   like(NumSS  ) inz
     D WrkDD           S                   like(NumDD  ) inz
     D WrkMM           S                   like(NumMM  ) inz
     D WrkYY           S                   like(NumYY  ) inz
     D WrkYYYY         S                   like(NumYYYY) inz
     D WrkMY           S                   like(NumMY  ) inz
     D WrkYYM          S                   like(NumYYM ) inz
     D WrkMDY          S                   like(NumMDY ) inz
     D WrkUSA          S                   like(NumUSA ) inz
     D WrkISO          S                   like(NumISO ) inz
     D WrkYMD          S                   like(NumYMD ) inz
      *
     D WrktimHMS       S                   like(TimHMS ) inz
     D WrkdteMDY       S                   like(DteMDY ) inz
     D WrkdteUSA       S                   like(DteUSA ) inz
     D*WrkdteISO       S                   like(DteISO ) inz
     D WrkdteYMD       S                   like(DteYMD ) inz
      *
      *  Define standard date/time fields.
      *
     D Today           S                   like(NumISO ) inz
     D CurTime         S                   like(NumHMS ) inz
      *
      *  Define data structure for ISO date creation.
      *
     D d_CatISO        DS             8
     D  CatISOyyyy                    4    inz
     D  CatISOmm                      2    inz
     D  CatISOdd                      2    inz
      *
     D d_CatdteISO     DS
     D  CatdteISOyyyy                 4    inz
     D  CatdteISOsl1                  1    inz('/')
     D  CatdteISOmm                   2    inz
     D  CatdteISOsl2                  1    inz('/')
     D  CatdteISOdd                   2    inz
