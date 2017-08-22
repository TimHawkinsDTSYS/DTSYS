      /TITLE Utility, User Space (SrvPgm)
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
      /copy qcpysrc,UT8055S
      * **********************************************************
      * CrtUsrSpc() -- Create user space.
      * **********************************************************

     P CrtUsrSpc       B                   Export

     D CrtUsrSpc       PI                  like(StdInd)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib                          like(StdNam) const
     D  UsrSpcSiz                          like(StdInt) const
     D  UsrSpcExtA                         like(StdNam) const
     D  UsrSpcText                         like(StdTxt) const

     D SpaceName       S                   like(StdNamLib) inz
     D SpaceSize       S                   like(StdInt)    inz
     D SpaceInit       S                   like(StdChr)    inz(x'00')
     D SpaceExtA       S                   like(StdNam)    inz
     D SpaceAut        S                   like(StdNam)    inz('*ALL')
     D SpaceText       S                   like(StdTxt)    inz
     D SpaceRepl       S                   like(StdNam)    inz('*YES')
     D SpaceDom        S                   like(StdNam)    inz('*USER')

      * User Space Generic Structure
      /COPY QSYSINC/QRPGLESRC,QUSgen
      * ---------------------------------------------------------
      * Create user space

     C                   eval      SpaceName = UsrSpcNam + UsrSpcLib
     C                   eval      SpaceSize = UsrSpcSiz
     C                   eval      SpaceExtA = UsrSpcExtA
     C                   eval      SpaceText = UsrSpcText

     C                   call      'QUSCRTUS'
     C                   parm                    SpaceName
     C                   parm                    SpaceExtA
     C                   parm                    SpaceSize
     C                   parm                    SpaceInit
     C                   parm                    SpaceAut
     C                   parm                    SpaceText
     C                   parm                    SpaceRepl
     C                   parm                    dsEC
     C                   parm                    SpaceDom

     C                   select
     C                   when      dsEC.avl  = *zero
     C                   return    *on
     C                   when      dsEC.avl <> *zero
     C                   return    *off
     C                   endsl

     P CrtUsrSpc       E
      * **********************************************************
      * ChgUsrSpc() -- Change user space.
      * **********************************************************
     P ChgUsrSpc       B                   Export

     D ChgUsrSpc       PI                  like(StdInd)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib_p                        like(StdNam) const
     D                                     options(*omit)
     D  UsrSpcStrPos_p...
     D                                     like(StdInt) const
     D  UsrSpcDtaLen_p...
     D                                     like(StdInt) const
     D  UsrSpcDta_p                        like(StdBuf) const

     D UsrSpcLib       s                   like(StdNam)    inz
     D SpaceName       s                   like(StdNamLib) inz
     D UsrSpcStrPos    s                   like(StdInt)    inz
     D UsrSpcDtaLen    s                   like(StdInt)    inz
     D UsrSpcDta       s                   like(StdBuf)    inz

      * User Space Generic Structure
      /COPY QSYSINC/QRPGLESRC,QUSgen
      * ---------------------------------------------------------
      * Change user space

     C                   if        UsrSpcLib_p <> '*OMIT'
     C                   eval      UsrSpcLib    = UsrSpcLib_p
     C                   else
     C                   eval      UsrSpcLib    = '*LIBL'
     C                   endif

     C                   eval      SpaceName    = UsrSpcNam + UsrSpcLib
     C                   eval      UsrSpcStrPos = UsrSpcStrPos_p
     C                   eval      UsrSpcDtaLen = UsrSpcDtaLen_p
     C                   eval      UsrSpcDta    = UsrSpcDta_p

     C                   call      'QUSCHGUS'
     C                   parm                    SpaceName
     C                   parm                    UsrSpcStrPos
     C                   parm                    UsrSpcDtaLen
     C                   parm                    UsrSpcDta
     C                   parm      *off          UsrSpcFrcDsk      1
     C                   parm                    dsEC

     C                   select
     C                   when      dsEC.avl  = *zero
     C                   return    *on
     C                   when      dsEC.avl <> *zero
     C                   return    *off
     C                   endsl

     P ChgUsrSpc       E
      * **********************************************************
      * GetUsrSpcP() -- Get user space pointer.
      * **********************************************************
     P GetUsrSpcP      B                   Export

     D GetUsrSpcP      PI                  like(StdPtr)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib_P                        like(StdNam) const
     D                                     options(*nopass)

     D UsrSpcLib       s                   like(StdNam)    inz
     D SpaceName       S                   like(StdNamLib) inz
     D SpacePoint      S                   like(StdPtr)    inz

      * User Space Generic Structure
      /COPY QSYSINC/QRPGLESRC,QUSgen
      * ---------------------------------------------------------
      * Get user space pointer.

     C                   if        %parms   >= 2
     C                   eval      UsrSpcLib = UsrSpcLib_P
     C                   else
     C                   eval      UsrSpcLib = '*LIBL'
     C                   endif

     C                   eval      SpaceName = UsrSpcNam + UsrSpcLib

     C                   call      'QUSPTRUS'
     C                   parm                    SpaceName
     C                   parm                    SpacePoint
     C                   parm                    dsEC

     C                   return                  SpacePoint

     P GetUsrSpcP      E
      * **********************************************************
      * GetNbrUsrSpcEnt() -- Get number of user space entries.
      * **********************************************************
     P GetNbrUsrSpcEnt...
     P                 B                   Export

     D GetNbrUsrSpcEnt...
     D                 PI                  like(StdInt)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib_P                        like(StdNam) const
     D                                     options(*nopass)

     D UsrSpcLib       s                   like(StdNam) inz
     D UsrSpcPntr      s                   like(StdPtr) inz
     D BigField        s                   like(StdBuf) based(UsrSpcPntr)

      * User Space Generic Structure
      /COPY QSYSINC/QRPGLESRC,QUSgen
      * ---------------------------------------------------------
      * Get number of user space entries.

     C                   if        %parms   >= 2
     C                   eval      UsrSpcLib = UsrSpcLib_P
     C                   else
     C                   eval      UsrSpcLib = '*LIBL'
     C                   endif

     C                   eval      UsrSpcPntr =
     C                             GetUsrSpcP(UsrSpcNam:UsrSpcLib)

     C                   eval      QUSH0100 = BigField

     C                   return    QUSnbrle

     P GetNbrUsrSpcEnt...
     P                 E
      * **********************************************************
      * GetUsrSpcEnt() -- Get user space entry.
      * **********************************************************
     P GetUsrSpcEnt    B                   Export

     D GetUsrSpcEnt    PI                  like(StdBuf)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib_P                        like(StdNam) const
     D                                     options(*omit)
     D  EntNumber_P                        like(StdInt) const

     D UsrSpcLib       s                   like(StdNam) inz
     D EntNumber       s                   like(StdInt) inz
     D UsrSpcPntr      s                   like(StdPtr) inz
     D ListPointr      s                   like(StdPtr) inz
     D BigField        s                   like(StdBuf) based(ListPointr)
     D BigFldOut       s                   like(StdBuf) inz

      * User Space Generic Structure
      /COPY QSYSINC/QRPGLESRC,QUSgen
      * ---------------------------------------------------------
      *
      *    Setup parameters.
      *
     C                   if        UsrSpcLib_p <> '*OMIT'
     C                   eval      UsrSpcLib    = UsrSpcLib_P
     C                   else
     C                   eval      UsrSpcLib    = '*LIBL'
     C                   endif
      *
     C                   eval      EntNumber = EntNumber_p
      * ---------------------------------------------------------
      *
      *    Set user space pointer.
      *
     C                   eval      UsrSpcPntr =
     C                             GetUsrSpcP(UsrSpcNam:UsrSpcLib)

      *    Get header information.
     C                   eval      ListPointr = UsrSpcPntr
     C                   eval      QUSH0100   = BigField

      *    Check for end.
     C                   if        EntNumber > QUSnbrle
     C                   return    *blanks
     C                   endif

      *    Return specific list entry
     C                   eval      EntNumber -= 1
     C                   eval      ListPointr = ListPointr + QUSold +
     C                                          (QUSsee * EntNumber)
     C                   eval      BigFldOut = %subst(BigField:1:QUSsee)

     C                   return    BigFldOut

     P GetUsrSpcEnt    E
      * **********************************************************
      * DltUsrSpc() -- Delete user space.
      * **********************************************************
     P DltUsrSpc       B                   Export

     D DltUsrSpc       PI                  like(StdInd)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib_P                        like(StdNam) const
     D                                     options(*nopass)

     D UsrSpcLib       s                   like(StdNam)    inz
     D SpaceName       s                   like(StdNamLib) inz

      * User Space Generic Structure
      /COPY QSYSINC/QRPGLESRC,QUSgen
      * ---------------------------------------------------------
     C                   if        %parms   >= 2
     C                   eval      UsrSpcLib = UsrSpcLib_P
     C                   else
     C                   eval      UsrSpcLib = '*LIBL'
     C                   endif

     C                   eval      SpaceName = UsrSpcNam + UsrSpcLib

     C                   call      'QUSDLTUS'
     C                   parm                    SpaceName
     C                   parm                    dsEC

     C                   select
     C                   when      dsEC.avl  = *zero
     C                   return    *on
     C                   when      dsEC.avl <> *zero
     C                   return    *off
     C                   endsl

     P DltUsrSpc       E
