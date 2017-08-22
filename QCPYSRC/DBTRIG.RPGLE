      * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Database Trigger Buffer.
      * * * * * * * * * * * * * * * * * * * * * * * * * * *
     D DbTrgDs         DS
     D  DbFilNam                           like(stdNam)
     D  DbLibNam                           like(stdNam)
     D  DbMbrNam                           like(stdNam)
     D  DbTrgAct                           like(stdChr)
     D  DbTrgTim                           like(stdChr)
     D  DbCmtLck                           like(stdChr)
     D  DbReserve1                    3
     D  DbCcsId                            like(StdBin4)
     D  DbRelRecNbr                        like(StdBin4)
     D  DbReserve2                    4
     D  DbBfrOfs                           like(StdBin4)
     D  DbBfrLen                           like(StdBin4)
     D  DbBfrNulOf                         like(StdBin4)
     D  DbBfrNulLn                         like(StdBin4)
     D  DbAftOfs                           like(StdBin4)
     D  DbAftLen                           like(StdBin4)
     D  DbAftNulOf                         like(StdBin4)
     D  DbAftNulLn                         like(StdBin4)
     D  DbReserve3                   16
      *
     D  DbTrgBuf               1  32767A
     D  DbTrgAry                           Overlay(DbTrgBuf)
     D                                     Dim(%size(DbTrgBuf))
     D                                     like(stdChr)
      *
     D OrigDbLibNam    s                   like(stdNam)
     D DbTrgLen        S                   like(StdBin4)
      *
     D DbBfrPtr        S                   like(stdPtr)
     D DbAftPtr        S                   like(stdPtr)
      *
     D DbTrgSiz        C                   %Elem(DbTrgAry)
      *
     D DbActIns        C                   '1'
     D DbActDlt        C                   '2'
     D DbActUpd        C                   '3'
     D DbActRed        C                   '4'
      *
     D DbTimBfr        C                   '1'
     D DbTimAft        C                   '2'
