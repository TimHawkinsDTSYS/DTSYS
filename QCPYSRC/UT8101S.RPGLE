      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Application DB prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *
      *  Define file fields (don't reserve storage).
      *
     D DFNagyma      e ds                  extname(agymap01) template
     D                                     prefix(DFN)
      *
     D DFNbkgma      e ds                  extname(bkgmap01) template
     D                                     prefix(DFN)
      *
     D DFNbkgaf      e ds                  extname(bkgafp01) template
     D                                     prefix(DFN)
      *
     D DFNbkgls      e ds                  extname(bkglsp01) template
     D                                     prefix(DFN)
      *
     D DFNbkgpi      e ds                  extname(bkgpip01) template
     D                                     prefix(DFN)
      *
     D DFNbkgpn      e ds                  extname(bkgpnp01) template
     D                                     prefix(DFN)
      *
     D DFNchrsw      e ds                  extname(chrswp01) template
     D                                     prefix(DFN)
      *
     D DFNctlal      e ds                  extname(ctlalp01) template
     D                                     prefix(DFN)
      *
     D DFNctlac      e ds                  extname(ctlacp01) template
     D                                     prefix(DFN)
      *
     D DFNctlas      e ds                  extname(ctlasp01) template
     D                                     prefix(DFN)
      *
     D DFNctlds      e ds                  extname(ctldsp01) template
     D                                     prefix(DFN)
      *
     D DFNctllo      e ds                  extname(ctllop01) template
     D                                     prefix(DFN)
      *
     D DFNctllc      e ds                  extname(ctllcp01) template
     D                                     prefix(DFN)
      *
     D DFNctlrs      e ds                  extname(ctlrsp01) template
     D                                     prefix(DFN)
      *
     D DFNctlra      e ds                  extname(ctlrap01) template
     D                                     prefix(DFN)
      *
     D DFNctlnr      e ds                  extname(ctlnrp01) template
     D                                     prefix(DFN)
      *
     D DFNctlut      e ds                  extname(ctlutp01) template
     D                                     prefix(DFN)
      *
     D DFNhisbm      e ds                  extname(hisbmp01) template
     D                                     prefix(DFN)
      *
     D DFNpaxad      e ds                  extname(paxadp01) template
     D                                     prefix(DFN)
      *
     D DFNquema      e ds                  extname(quemap01) template
     D                                     prefix(DFN)
      *
     D DFNquetx      e ds                  extname(quetxp01) template
     D                                     prefix(DFN)
      *
     D DFNwdw        e ds                  extname(DSwdw   ) template
     D                                     prefix(DFN)
      *
     D DFNrmkwk      e ds                  extname(rmkwkp01) template
     D                                     prefix(DFN)
      * ---------------------------------------------------------
      *
      *  Data structure for retrieve user defined codes.
      *
     D d_UsrDfn        DS                  qualified inz
     D  Desc                               like(StdTxt)
     D  PC                            5
     D  Nfnd                               like(StdChr)
     D  Pbkg                               like(StdChr)
     D  Pflt                               like(StdChr)
     D  Bflt                               like(StdChr)
     D  Cxl                                like(StdChr)
     D  RtvRmk                             like(StdChr)
     D  ChkInv                             like(StdChr)
     D  ZroPrc                             like(StdChr)
     D  NonPrc                             like(StdChr)
     D  Pprc                               like(StdChr)
      * ---------------------------------------------------------
      *  Vendor master subset.
      *
     D SubsetVndma     ds                  qualified      inz
     D  SSenvnam                           like(StdNam)
     D  SSvndn                             like(ZonRcid)
     D  SStype                             like(StdNam)
     D  SSsqst                             like(StdSQL)
