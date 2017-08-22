      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Weather prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      * ---------------------------------------------------------
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
     D  LstUpdDte                          like(NumISO)
     D  LstUpdTim                          like(NumHMS)
     D  LstUpdZon                     3
     D  XMLerr                             like(StdInd)
     D  XMLpth                             like(StdTok)
     D  XMLnam                             like(StdTok)
     D  XMLval                             like(StdTok)
