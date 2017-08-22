      /TITLE Utility, DB files (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      /COPY QCPYSRC,UT8055S
      * **********************************************************
      * RtvRcdFmt() -- Retrieve record format.
      * **********************************************************
     P RtvRcdFmt       B                   Export

     D RtvRcdFmt       PI                  like(RcdFmtID)
     D  FilNam                             like(StdNam) const
     D  FilLib_p                           like(StdNam) const
     D                                     options(*nopass)
      *
     D FilLib          s                   like(StdNam) inz
     D UsrSpcNam       s                   like(StdNam) inz('RTVRCDFMT')
     D UsrSpcLib       s                   like(StdNam) inz('QTEMP')

      /COPY QSYSINC/QRPGLESRC,QUSGEN
      /COPY QSYSINC/QRPGLESRC,QUSLRCD
      * ---------------------------------------------------------
      *
      *    Set parameters.
      *
     C                   if        %parms   >= 2       and
     C                             FilLib_p <> *blanks
     C                   eval      FilLib    = FilLib_p
     C                   else
     C                   eval      FilLib    = '*LIBL'
     C                   endif
      * ---------------------------------------------------------
      *
      *   Create user space.
      *
     C                   if        not CrtUsrSpc(UsrSpcNam:UsrSpclib:
     C                                           32767:*blanks:
     C                                           'Retrieve record format')
     C                   eval      *inLR = *on
     C                   return    *blanks
     C                   endif
      *
      *   Retrieve record format information.
      *
     C                   eval      RFspcnam20 = UsrSpcNam + UsrSpcLib
     C                   eval      RFfilnam20 = FilNam    + FilLib
      *
     C                   call(e)   'QUSLRCD'
     C                   parm                    RFspcnam20       20
     C                   parm      'RCDL0200'    RFfmtnam         10
     C                   parm                    RFfilnam20       20
     C                   parm      *on           RFovrprc          1
      *
      *   Get user space entry.
      *
     C                   if        not %error
     C                   eval      QUSl020000 =
     C                             GetUsrSpcEnt(UsrSpcNam:UsrSpcLib:1)
      *
      *   Set parameters.
      *
     C**                 eval      RFfmtID     = QUSfi
     C**                 eval      RFreclen    = QUSrl00
     C**                 eval      RFnbrfld    = QUSnbrf
     C**                 eval      RFrectxt    = QUSrtd00
     C                   else
     C                   clear                   QUSl020000
     C                   endif
      *
     C                   return    QUSfi
      *
     P RtvRcdFmt       E
      ***********************************************************
      * RtvNbrRec( Retreive number of records.
      ***********************************************************
     P RtvNbrRec       B                   Export
      *
     D RtvNbrRec       PI                  like(StdInt)
     D  DbfNam_p                           like(StdNam) const
     D  LibNam_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  MbrNam_p                           like(StdNam) const
     D                                     options(*nopass)
      *
     D DbfNam          s                   like(DbfNam_p)   inz
     D LibNam          s                   like(LibNam_p)   inz
     D MbrNam          s                   like(MbrNam_p)   inz
     D DbfLibNam       s                   like(StdNamLib)  inz
     D RtnNbrRec       s                   like(StdInt)     inz
      *
     D MbrDesc         ds                  LikeDS(QUSM0200) inz
      *
      /copy QCPYSRC,QUSRMBRD
      * ---------------------------------------------------------
      *
      *    Set parameters.
      *
     C                   eval      DbfNam     = DbfNam_p
      *
     C                   if        %parms    >= 2    and
     C                             LibNam_p  <> *blanks
     C                   eval      LibNam     = LibNam_p
     C                   else
     C                   eval      LibNam     = '*LIBL'
     C                   endif
      *
     C                   if        %parms    >= 3    and
     C                             MbrNam_p  <> *blanks
     C                   eval      MbrNam     = MbrNam_p
     C                   else
     C                   eval      MbrNam     = '*FIRST'
     C                   endif
      * ---------------------------------------------------------
      *
      *    Retrieve member description.
      *
     C                   clear                   MbrDesc
      *
     C                   eval      DbfNam = upper(DbfNam)
     C                   eval      LibNam = upper(LibNam)
     C                   eval      MbrNam = upper(MbrNam)
      *
     C                   eval      DbfLibNam = DbfNam + LibNam
      *
     C                   CallP     QRtvMbrD(MbrDesc:%size(mbrDesc):
     C                                        'MBRD0200':
     C                                        DbfNam + LibNam:
     C                                        MbrNam:'0': dsEC)
      *
     C                   if        dsEC.avl = *zero
     C                   eval      RtnNbrRec = MbrDesc.QUSNBRCR
     C                   endif
      *
š1b€ C                   return    RtnNbrRec
      *
     P RtvNbrRec       E
      ***********************************************************
      * RtvMbrTxt() Retreive member text.
      ***********************************************************
     P RtvMbrTxt       B                   Export
      *
     D RtvMbrTxt       PI                  like(StdTxt)
     D  DbfNam_p                           like(StdNam) const
     D  LibNam_p                           like(StdNam) const
     D                                     options(*nopass:*omit)
     D  MbrNam_p                           like(StdNam) const
     D                                     options(*nopass)
      *
     D DbfNam          s                   like(DbfNam_p)   inz('BKGMAP01')
     D LibNam          s                   like(LibNam_p)   inz('*LIBL')
     D MbrNam          s                   like(MbrNam_p)   inz('*FIRST')
     D DbfLibNam       s                   like(StdNamLib)  inz
     D RtnMbrTxt       s                   like(StdTxt)     inz
      *
     D MbrDesc         ds                  LikeDS(QUSM0200) inz
      *
      /copy QCPYSRC,QUSRMBRD
      * ---------------------------------------------------------
      *
      *    Set parameters.
      *
     C                   eval      DbfNam     = DbfNam_p
      *
     C                   if        %parms    >= 2
     C                   callp     CEETSTA(ParmPassed:2:*omit)
     C                   if        ParmPassed = 1
     C                   eval      LibNam     = LibNam_p
     C                   endif
     C                   endif
      *
     C                   if        %parms    >= 3
     C                   callp     CEETSTA(ParmPassed:3:*omit)
     C                   if        ParmPassed = 1
     C                   eval      MbrNam     = MbrNam_p
     C                   endif
     C                   endif
      * ---------------------------------------------------------
      *
      *    Retrieve member description.
      *
     C                   clear                   MbrDesc
      *
     C                   eval      DbfNam = upper(DbfNam)
     C                   eval      LibNam = upper(LibNam)
     C                   eval      MbrNam = upper(MbrNam)
      *
     C                   eval      DbfLibNam = DbfNam + LibNam
      *
     C                   CallP     QRtvMbrD(MbrDesc:%size(mbrDesc):
     C                                        'MBRD0200':
     C                                        DbfNam + LibNam:
     C                                        MbrNam:'0': dsEC)
      *
     C                   if        dsEC.avl = *zero
     C                   eval      RtnMbrTxt = MbrDesc.QUSTD04
     C                   endif
      *
š1b€ C                   return    RtnMbrTxt
      *
     P RtvMbrTxt       E
