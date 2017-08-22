      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Standard type definitions.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     D StdNulPtr       s               *
     D StdPtr          s               *   based(StdNulPtr)
     D StdPrcPtr       s               *   based(StdNulPtr) ProcPtr

     D StdInd          s              1n   based(StdNulPtr)
      *
      * Defined    RPGIII  RPG IV  StdTypD
      * ---------  ------  ------  -------
      * Bin(2)       4b 0    5i 0  StdIntSml
      * Bin(4)       9b 0   10i 0  StdInt
      * UBin(2)       N/A    5u 0  StdUnsSml
      * UBin(4)       N/A   10u 0  StdUns
      * INT2         4b 0    5i 0  StdIntSml
      * INT4         9b 0   10i 0  StdInt
      * UINT2         N/A    5u 0  StdUnsSml
      * UINT4         N/A   10u 0  StdUns
      * SMALLINT     4b 0   5i 0   StdIntSml
      * INTEGER      9b 0  10i 0   StdInt
      * BIGINT        N/A  20i 0   StdIntLon
      *

     D StdBin          s              9b 0 based(StdNulPtr)
     D StdBinSml       s              4b 0 based(StdNulPtr)
     D StdBin2         s              4b 0 based(StdNulPtr)
     D StdBin4         s              9b 0 based(StdNulPtr)

     D StdInt          s             10i 0 based(StdNulPtr)
     D StdIntSml       s              5i 0 based(StdNulPtr)
     D StdIntLon       s             20i 0 based(StdNulPtr)

     D StdUns          s             10u 0 based(StdNulPtr)
     D StdUnsSml       s              5u 0 based(StdNulPtr)
     D StdUnsLon       s             20u 0 based(StdNulPtr)

     D StdZon          s             15s 5 based(StdNulPtr)

     D StdLen          s              5p 0 based(StdNulPtr)
     D StdCnt          s              9p 0 based(StdNulPtr)
     D StdCur          s             13p 2 based(StdNulPtr)
     D StdDec          s             15p 5 based(StdNulPtr)
     D StdMaxDecWhl    s             61p 0 based(StdNulPtr)
     D StdMaxDec       s             61p15 based(StdNulPtr)

     D StdFlt          s              4f   based(StdNulPtr)
     D StdDblFlt       s              8f   based(StdNulPtr)

     D StdLgl          s              1    based(StdNulPtr)
     D StdChr          s              1    based(StdNulPtr)
     D StdFmt          s              8    based(StdNulPtr)
     D StdCndTok       s             12    based(StdNulPtr)
     D StdTok          s             32    based(StdNulPtr)
     D StdTxt          s             50    based(StdNulPtr)
     D StdStr          s            256    based(StdNulPtr)
     D StdStg          s            256    based(StdNulPtr)
     D StdSQL          s           1024    based(StdNulPtr)
     D StdBuf          s          32767    based(StdNulPtr)
     D StdBufMax       s          65534    based(StdNulPtr)
     D StdMaxLen       s          65534    based(StdNulPtr)

     D StdTim          s               t   based(StdNulPtr)
     D StdDat          s               d   based(StdNulPtr)
     D StdTms          s               z   based(StdNulPtr)
     D StdTsp          s               z   based(StdNulPtr)

     D StdHdl          s             16    based(StdNulPtr)
     D StdIntID        s             16    based(StdNulPtr)
     D StdQnm          s             20    based(StdNulPtr)
     D StdQalJob       s             26    based(StdNulPtr)
     D StdJobNbr       s              6    based(StdNulPtr)
     D StdSplNbr       s             10i 0 based(StdNulPtr)

     D StdNam          s             10    based(StdNulPtr)
     D StdNamLib       s             20    based(StdNulPtr)

     D StdMsgID        s              7    based(StdNulPtr)
     D StdMsg          s            132    based(StdNulPtr)
     D StdMsgKey       s              4    based(StdNulPtr)
     D StdMsgDta       s          32767    based(StdNulPtr)
     D*StdMsgDta       s           1024    based(StdNulPtr)
     D StdSecLvl       s          32767    based(StdNulPtr)
     D*StdSecLvl       s           1024    based(StdNulPtr)

     D StdPrfHdl       s             12    based(StdNulPtr)
     D StdEml          s             80    based(StdNulPtr)

     D StdCurCde       s              3    based(StdNulPtr)
     D StdCurRte       s             11p 6 based(StdNulPtr)

     D ZonISO          s              8s 0 template
     D ZonVndn         s              5s 0 template
     D ZonRcid         s             11s 0 template
     D Zoncnxcnt       s              1s 0 template
