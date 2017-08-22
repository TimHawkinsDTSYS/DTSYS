      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Weather prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
      *
      * RtvCurWth() -- Retrieve current weather.
      *
     D RtvCurWth       PR                  like(t_RtvCurWth)
     D  i_pscd                        5    const
      *
     D t_RtvCurWth     ds                  qualified template
     D  ObsCity                            like(StdTok)
     D  ObsStcd                       2
     D  Temperature                        like(StdInt)
     D  FeelsLike                          like(StdInt)
     D  Conditions                         like(StdTok)
     D  WindSpeed                          like(StdInt)
     D  WindGust                           like(StdInt)
     D  WindDir                            like(StdInt)
     D  WindCompass                   4
     D  Humidity                           like(StdInt)
     D  Visability                    4  2
     D  PressureBar                   4  2
     D  PressureDesc                       like(StdNam)
     D  UVnumber                           like(StdInt)
     D  UVdesc                             like(StdNam)
     D  Dewpoint                           like(StdInt)
     D  MoonDesc                           like(StdTok)
     D  LstUpdDte                          like(StdISO)
     D  LstUpdTim                          like(StdHMS)
     D  LstUpdZon                     3
     D  XMLerr                             like(StdInd)
     D  XMLpth                             like(StdTok)
     D  XMLnam                             like(StdTok)
     D  XMLval                             like(StdTok)
      *
      * Definitions.
      *
     D StdNulPtr       s               *
     D StdPtr          s               *   based( StdNulPtr )
     D StdISO          S              8  0 based( StdNulPtr )
     D StdHMS          S              6  0 based( StdNulPtr )
     D StdTok          S             32    based( StdNulPtr )
     D StdInt          S             10i 0 based( StdNulPtr )
     D StdNam          S             10    based( StdNulPtr )
     D StdInd          S               n   based( StdNulPtr )
