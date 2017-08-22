      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Translation prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      * TranslateCCSID() - Translate CCSID.
      *
     D TranslateCCSID  pr
     D  p_Dta                              like(StdPtr)
     D  p_DtaLen                           like(StdInt) const
     D  p_fromCCSID                        like(StdInt) const
     D  p_toCCSID                          like(StdInt) const
     D  p_Options                          like(StdStr) const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * Translate() - Translate character sets.
      * -- tables: QTCPASC and QTCPEBC
      *
     D Translate       PR                  ExtPgm('QDCXLATE')
     D    peLength                    5P 0 const
     D    peBuffer                32766A   options(*varsize)
     D    peTable                    10A   const
