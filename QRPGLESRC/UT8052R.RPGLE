      /TITLE Utility, Jobs (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides date routines via function calls
      *              for converting dates from one format to another,
      *              adding dates, determining days between dates, etc.
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
      /copy qcpysrc,Dspec
      * **********************************************************
      * RtvUsrLibl() - Retrieve user library list.
      * **********************************************************
     P RtvUsrLibL      B                   Export

     D RtvUsrLibL      PI           550
     D  JobName                      10    Value options(*nopass)
     D  JobUser                      10    Value options(*nopass)
     D  JobNumber                     6  0 Value options(*nopass)
     D  APIError                    272          options(*nopass)

      *  -------------------------------------------------------------------
      *  - Data definitions                                                -
      *  -------------------------------------------------------------------

     D CharJobNumber   DS
     D  NbrJobNumber                  6  0

     D IntJobID        S             16    Inz( *Blank )
     D QualJobName     S             26    Inz ( '*' )

     D RcvVar          DS         32767
     D                               64                 inz
     D  NbrSysLibs                         like(StdInt) inz
     D  NbrPrdLibs                         like(StdInt) inz
     D  NbrCurLibs                         like(StdInt) inz
     D  NbrUsrLibs                         like(StdInt) inz

     D LibsToSkip      S                   like(StdInt) inz

     D RcvVarLen       S                   like(StdInt) inz(%Len(RcvVar))
     D Format          S              8    Inz( 'JOBI0700' )

     D UsrLibs         S            550    Inz

     D Pos             S                   like(StdInt) inz

     D NoAPIError      C                   Const( *Zero )
     D APIErrorPassed  S                   like(StdInd) inz

      *  -------------------------------------------------------------------
      *  - Determine whether API error parameter was passed                -
      *  -------------------------------------------------------------------

     C                   If        %parms > 3
     C                   Eval      APIErrorPassed = *On
     C                   EndIf

      *  -------------------------------------------------------------------
      *  - Retrieve job information                                        -
      *  -------------------------------------------------------------------

     C                   Reset                   APIErrorDS

     C                   select
     C                   when      %parms       = *zero
     C                   eval      QualJobName  = '*'

     C                   when      JobName     <> '*'
     C                   eval      NbrJobNumber = JobNumber
     C                   eval      QualJobName  = JobName       +
     C                                            JobUser       +
     C                                            CharJobNumber
     C                   endsl

     C                   callP     RtvJobInf(RcvVar     :
     C                                       RcvVarLen  :
     C                                       Format     :
     C                                       QualJobName:
     C                                       IntJobID   :
     C                                       dsEC)

     C                   if        dsEC.Avl <> NoAPIError
     C                   exSr      ReturnError
     C                   endIf

      *  -------------------------------------------------------------------
      *  - Extract user library list and return it to caller               -
      *  -------------------------------------------------------------------

     C                   Eval      LibsToSkip = NbrSysLibs +
     C                                          NbrPrdLibs +
     C                                          NbrCurLibs

     C                   Eval      Pos = ( LibsToSkip * 11 ) + 81

     C                   Eval      UsrLibs = %Subst( RcvVar          :
     C                                               Pos             :
     C                                               NbrUsrLibs * 11)

     C                   Return    UsrLibs

      *  -------------------------------------------------------------------
      *  - Subroutine.... ReturnError                                      -
      *  - Description... Return error condition to caller                 -
      *  -------------------------------------------------------------------

     C     ReturnError   BegSr

     C                   If        APIErrorPassed
     C                   Eval      APIError = APIErrorDS
     C                   EndIf

     C                   Return    *Blank

     C                   EndSr

     P RtvUsrLibL      E
      ***********************************************************
      * WrtJobTrk() - Write job tracking.
      ***********************************************************
     P WrtJobTrk       B                   Export
      *
     D WrtJobTrk       PI
     D  PIbgnend                           like(StdNam) const
     D  PIjobnam                           like(StdNam) const
     D  PIstep                             like(StdNam) const
     D  PItext                             like(StdTxt) const
     D                                     options(*nopass)
      *
     D  WKbgnend       s                   like(PIbgnend)
     D  WKjobnam       s                   like(PIjobnam)
     D  WKstep         s                   like(PIstep  )
     D  WKtext         s                   like(PItext  )
      * ---------------------------------------------------------
      *
      *   Write job tracking.
      *
     C                   call      'UT0800R'
     C                   parm      PIbgnend      WKbgnend
     C                   parm      PIjobnam      WKjobnam
     C                   parm      PIstep        WKstep
     C                   parm      PItext        WKtext
      *
     C                   return
      *
     P WrtJobTrk       E
      ***********************************************************
      * RtvJobTyp() -- Retrieve job type.
      ***********************************************************
     P RtvJobTyp       B                   Export
      *
     D RtvJobTyp       PI             3

     D IntJobID        S             16    inz
     D QualJobName     S             26    inz('*')
      * ---------------------------------------------------------
      *
      *    Retrieve job information
      *
     C                   CallP     RtvJobInf(dsJobI0100 :
     C                                       %len(dsJobI0100):
     C                                       'JOBI0700' :
     C                                       QualJobName:
     C                                       IntJobID   :
     C                                       dsEC)
     C                   if        dsEC.avl <> *zero
     C                   return    *blanks
     C                   endIf
      *
     C                   if        JobI_Type = 'I'
     C                   return    'INT'
     C                   else
     C                   return    'BCH'
     C                   endif
      *
     P RtvJobTyp       E
      ***********************************************************
      * ChkInvStk() - Check invocation stack for a program.
      * -- elapsed time 5 seconds
      ***********************************************************
     P ChkInvStk       B                   Export
      *
     D ChkInvStk       PI                  like(StdInd)
     D  PgmNam                             like(StdNam) value
      *
     D PgmFnd          s                   like(StdInd) inz
      * ---------------------------------------------------------
      *
      *    If program ID is blank, just return.
      *
     C                   if        PgmNam = *blanks
     C                   return    *off
     C                   endif
      *
      *    Call CL program to perform the check.
      *
     C                   CALL      'UT1130C'
     C                   PARM                    PgmNam
     C                   PARM                    PgmFnd
      *
     C                   return    PgmFnd
      *
     P ChkInvStk       E
      ***********************************************************
      * ChkInvStk2() - Check invocation stack for a program.
      * -- CL  version runs in  6 seconds
      * -- API version runs in 46 seconds
      ***********************************************************
     P ChkInvStk2      B                   Export
      *
     D ChkInvStk2      PI                  like(StdInd)
     D  PgmNam                             like(StdNam) value
      *
     D JobName         s                   like(StdNam)    inz('*')
     D JobUser         s                   like(StdNam)    inz
     D JobNbr          s                   like(StdJobNbr) inz
     D NbrStkEnt       s                   like(StdInt)    inz
     D StkEntNbr       s                   like(StdInt)    inz
     D RqsLvl          s                   like(StdInt)    inz
     D PgmName         s                   like(StdNam)    inz
     D PgmLib          s                   like(StdNam)    inz
     D ModName         s                   like(StdNam)    inz
     D ModLib          s                   like(StdNam)    inz
     D ActGrp          s                   like(StdNam)    inz
     D PrcName         s           4096                    inz
      *
     D RtnCode         s                   like(StdInd)    inz
      * ---------------------------------------------------------
      *
      *    Retrieve number of stack entries.
      *
     C                   Eval      NbrStkEnt = RtvNbrStkEnt( JobName    :
     C                                                       JobUser    :
     C                                                       JobNbr     :
     C                                                       APIErrorDS)
      *
     C                   If        AeBytAvl <> *zero
     C                   return    *off
     C                   endif
      * ---------------------------------------------------------
      *
      *    Retrieve details for each entry.
      *
     C                   For       StkEntNbr = 1 To NbrStkEnt
      *
     C                   Eval      RtnCode   = RtvStkEnt( JobName    :
     C                                                    JobUser    :
     C                                                    JobNbr     :
     C                                                    StkEntNbr  :
     C                                                    RqsLvl     :
     C                                                    PgmName    :
     C                                                    PgmLib     :
     C                                                    ModName    :
     C                                                    ModLib     :
     C                                                    ActGrp     :
     C                                                    PrcName    :
     C                                                    APIErrorDS)
      *
     C                   If        AeBytAvl <> *zero
     C                   return    *off
     C                   endif
      *
     C                   If        PgmNam = PgmName
     C                   return    *on
     C                   endif
     C                   EndFor
      *
     C                   return    *off
      *
     P ChkInvStk2      E

      *  ===================================================================
      *  = Procedure..... RtvNbrStkEnt                                     =
      *  = Description... Retrieve number of call stack entries            =
      *  ===================================================================

     P RtvNbrStkEnt    B                   Export

     D RtvNbrStkEnt    PI                  like(StdInt)
     D  JobNameIn                          like(StdNam)    value
     D  JobUserIn                          like(StdNam)    value
     D  JobNbrIn                           like(StdJobNbr) value
     D  APIError                    272    Options(*NoPass)

     D APIErrorPassed  s                   like(StdInd) inz

     D RtvInfoDS       DS         65535
     D  BytAvl                             like(StdInt)
     D  BytRtn                             like(StdInt)
     D  TotStkEnt                          like(StdInt)
     D                                4
     D  NbrStkEnt                          like(StdInt)
     D                                8
     D  Status                        1

     D RtvInfoDSLen    S                   like(StdInt)
     D                                     inz( %len( RtvInfoDS))
     D RtvInfoFmt      S              8    inz( 'CSTK0100' )

     D JobIDInfoDS     DS
     D  JobName                            like(StdNam)    inz
     D  JobUser                            like(StdNam)    inz
     D  JobNbr                             like(StdJobNbr) inz
     D                               16    inz
     D                                2    inz(x'0000')
     D                               10I 0 inz(2)
     D                                8    inz(*allX'00')

     D JobIDFmt        S              8    inz('JIDF0100')

     D BadStatusError  DS
     D                               10I 0 inz(%size(BadStatusError))
     D                               10I 0 inz(16)
     D                                7    inz('CPF9898')
     D                                1    inz(x'00')
     D                              256    inz('Unexpected error')

     D RcvsizeError    DS
     D                               10I 0 inz(%size(RcvsizeError))
     D                               10I 0 inz(16)
     D                                7    inz('CPF9898')
     D                                1    inz(x'00')
     D                              256    inz('Receiver too small')
      *  -------------------------------------------------------------------
      *
      *  - Determine whether API error parameter was passed
      *
     C                   If        %Parms > 3
     C                   eval      APIErrorPassed = *on
     C                   endif
      *
      *  - Load input parameters
      *
     C                   eval      JobName = JobNameIn
     C                   eval      JobUser = JobUserIn
     C                   eval      JobNbr  = JobNbrIn
      *
      *  - Retrieve call stack
      *
     C                   Reset                   APIErrorDS

     C                   CallP     RtvCallStkAPI( RtvInfoDS    :
     C                                            RtvInfoDSLen :
     C                                            RtvInfoFmt   :
     C                                            JobIDInfoDS  :
     C                                            JobIDFmt     :
     C                                            APIErrorDS)

     C                   If        AeBytAvl <> *zero
     C                   exsr      ReturnError
     C                   endif

     C                   select
     C                   when      Status     <> *Blank
     C                   eval      APIerrorDS  = BadStatusError
     C                   exsr      ReturnError

     C                   when      NbrStkEnt  <> TotStkEnt
     C                   eval      APIerrorDS  = RcvsizeError
     C                   exsr      ReturnError
     C                   endsl
      *
     C                   Return    NbrStkEnt
      *  -------------------------------------------------------------------
      *  - Subroutine.... ReturnError                                      -
      *  -------------------------------------------------------------------
     C     ReturnError   BegSr

     C                   If        APIErrorPassed
     C                   eval      APIError = APIErrorDS
     C                   endif
     C                   Return    *zero

     C                   EndSr

     P RtvNbrStkEnt    E

      *  ===================================================================
      *  = Procedure..... RtvStkEnt                                        =
      *  = Description... Retrieve call stack entry                        =
      *  ===================================================================

     P RtvStkEnt       B                   Export

     D RtvStkEnt       PI                  like(StdInd)
     D  JobNameIn                          like(StdNam)    value
     D  JobUserIn                          like(StdNam)    value
     D  JobNbrIn                           like(StdJobNbr) value
     D  EntNbr                             like(StdInt)    value
     D  RtnRqsLvl                          like(StdInt)
     D  RtnPgmName                         like(StdNam)
     D  RtnPgmLib                          like(StdNam)
     D  RtnModName                         like(StdNam)
     D  RtnModLib                          like(StdNam)
     D  RtnActGrpName                      like(StdNam)
     D  RtnPrcName                 4096
     D  APIError                    272    Options( *NoPass )

      *  - Data definitions                                                -

     D APIErrorPassed  S                   like(StdInd)

     D RtvInfoDS       DS         65535
     D  BytAvl                             like(StdInt)
     D  BytRtn                             like(StdInt)
     D  TotStkEnt                          like(StdInt)
     D  FirstEntOff                        like(StdInt)
     D  NbrStkEnt                          like(StdInt)
     D                                8
     D  Status                             like(StdChr)

     D RtvInfoDSLen    S                   like(StdInt)
     D                                     inz(%len(RtvInfoDS))
     D RtvInfoFmt      S              8    inz('CSTK0100')

     D StkEntDS        DS                  Based(StkEntPtr)
     D  EntLen                             like(StdInt)
     D                                8
     D  PrcDisplace                        like(StdInt)
     D  PrcNameLen                         like(StdInt)
     D  RequestLevel                       like(StdInt)
     D  PgmName                            like(StdNam)
     D  PgmLibName                         like(StdNam)
     D                                4
     D  ModName                            like(StdNam)
     D  ModLibName                         like(StdNam)
     D                                8
     D  ActGrpName                         like(StdNam)

     D PrcNameArea     S           4096    Based(PrcNamePtr)
     D PrcName         S           4096

     D JobIDInfoDS     DS
     D  JobName                            like(StdNam)    inz
     D  JobUser                            like(StdNam)    inz
     D  JobNbr                             like(StdJobNbr) inz
     D                               16    inz(*Blank)
     D                                2    inz(*Allx'00')
     D                               10I 0 inz(2)
     D                                8    inz(*Allx'00')

     D JobIDFmt        S              8    inz('JIDF0100')

     D BadStatusError  DS
     D                               10I 0 inz(%size(BadStatusError))
     D                               10I 0 inz(16)
     D                                7    inz('CPF9898')
     D                                1    inz(x'00')
     D                              256    inz('Unexpected error')

     D BadEntNbrError  DS
     D                               10I 0 inz(%size(BadEntNbrError))
     D                               10I 0 inz(20)
     D                                7    inz('CPF9898')
     D                                1    inz(x'00')
     D                              256    inz('Invalid entry number')

     D RcvsizeError    DS
     D                               10I 0 inz(%size(RcvsizeError))
     D                               10I 0 inz(16)
     D                                7    inz('CPF9898')
     D                                1    inz(x'00')
     D                              256    inz('Receiver too small')
      *  -------------------------------------------------------------------
      *  - Determine whether API error parameter was passed                -
      *  -------------------------------------------------------------------
     C                   If        %Parms > 11
     C                   eval      APIErrorPassed = *on
     C                   endif
      *
      *  - Load input parameters
      *
     C                   eval      JobName = JobNameIn
     C                   eval      JobUser = JobUserIn
     C                   eval      JobNbr  = JobNbrIn
      *
      *  - Retrieve call stack
      *
     C                   Reset                   APIErrorDS

     C                   CallP     RtvCallStkAPI( RtvInfoDS    :
     C                                            RtvInfoDSLen :
     C                                            RtvInfoFmt   :
     C                                            JobIDInfoDS  :
     C                                            JobIDFmt     :
     C                                            APIErrorDS)

     C                   If        AeBytAvl <> *zero
     C                   exsr      ReturnError
     C                   endif

     C                   If        EntNbr <= *zero or
     C                             EntNbr >  NbrStkEnt
     C                   eval      APIErrorDS  = BadEntNbrError
     C                   exsr      ReturnError
     C                   endif

     C                   If        Status     <> *Blank
     C                   eval      APIErrorDS  = BadStatusError
     C                   exsr      ReturnError
     C                   endif

     C                   If        NbrStkEnt  <> TotStkEnt
     C                   eval      APIErrorDS  = RcvsizeError
     C                   exsr      ReturnError
     C                   endif

      *  -------------------------------------------------------------------
      *  - Extract call stack entry information                            -
      *  -------------------------------------------------------------------

     C                   eval      StkEntPtr = %Addr( RtvInfoDS ) +
     C                                         FirstEntOff

     C                   Do        EntNbr
     C                   eval      PrcNamePtr = StkEntPtr + PrcDisplace
     C                   eval      PrcName    = %Subst( PrcNameArea :1:
     C                                                  PrcNameLen  )

     C                   eval      RtnRqsLvl     = RequestLevel
     C                   eval      RtnPgmName    = PgmName
     C                   eval      RtnPgmLib     = PgmLibName
     C                   eval      RtnModName    = ModName
     C                   eval      RtnModLib     = ModLibName
     C                   eval      RtnActGrpName = ActGrpName
     C                   eval      RtnPrcName    = PrcName
     C                   eval      StkEntPtr    += EntLen
     C                   EndDo

     C                   Return    *off
      *  -------------------------------------------------------------------
      *  - Subroutine.... ReturnError                                      -
      *  -------------------------------------------------------------------
     C     ReturnError   BegSr

     C                   If        APIErrorPassed
     C                   eval      APIError = APIErrorDS
     C                   endif

     C                   Return    *on
     C                   EndSr

     P RtvStkEnt       E
      ***********************************************************
      * Joblog() - Write to the joblog.
      ***********************************************************
     P Joblog          B                   Export
      *
     D Joblog          PI
     D  szInputStg                     *   value options(*string)
     D  szInputParm01                  *   value options(*string:*nopass)
     D  szInputParm02                  *   value options(*string:*nopass)
     D  szInputParm03                  *   value options(*string:*nopass)
     D  szInputParm04                  *   value options(*string:*nopass)
     D  szInputParm05                  *   value options(*string:*nopass)
     D  szInputParm06                  *   value options(*string:*nopass)
     D  szInputParm07                  *   value options(*string:*nopass)
     D  szInputParm08                  *   value options(*string:*nopass)
     D  szInputParm09                  *   value options(*string:*nopass)
     D  szInputParm10                  *   value options(*string:*nopass)

      /free

       Qp0zLprintf(szInputStg:szInputParm01:
                              szInputParm02:
                              szInputParm03:
                              szInputParm04:
                              szInputParm05:
                              szInputParm06:
                              szInputParm07:
                              szInputParm08:
                              szInputParm09:
                              szInputParm10);

       Qp0zLprintf(x'25');

       return;

      /end-free

     P Joblog          E
      * **********************************************************
      * RtvJobNam() -- Retrieve job name.
      * **********************************************************
     P RtvJobNam       B                   Export
      *
     D RtvJobNam       PI                  like(StdNam)

     D IntJobID        S             16    inz
     D QualJobName     S                   like(StdQalJob) inz('*')
      * ---------------------------------------------------------
      *
      *    Retrieve job information
      *
     C                   CallP     RtvJobInf(dsJobI0100 :
     C                                       %len(dsJobI0100):
     C                                       'JOBI0700' :
     C                                       QualJobName:
     C                                       IntJobID   :
     C                                       dsEC)
     C                   If        dsEC.avl <> *zero
     C                   return    *blanks
     C                   endIf
      *
     C                   return    JobI_JobName
      *
     P RtvJobNam       E
      * **********************************************************
      * RtvJobUsr() -- Retrieve job user.
      * **********************************************************
     P RtvJobUsr       B                   Export
      *
     D RtvJobUsr       PI                  like(StdNam)

     D IntJobID        S             16    inz
     D QualJobName     S                   like(StdQalJob) inz('*')
      * ---------------------------------------------------------
      *
      *    Retrieve job information
      *
     C                   CallP     RtvJobInf(dsJobI0100 :
     C                                       %len(dsJobI0100):
     C                                       'JOBI0700' :
     C                                       QualJobName:
     C                                       IntJobID   :
     C                                       dsEC)
     C                   If        dsEC.avl <> *zero
     C                   return    *blanks
     C                   endIf
      *
     C                   return    JobI_UserID
      *
     P RtvJobUsr       E
      * **********************************************************
      * RtvJobNbr() -- Retrieve job number.
      * **********************************************************
     P RtvJobNbr       B                   Export
      *
     D RtvJobNbr       PI                  like(StdJobNbr)

     D IntJobID        S             16    inz
     D QualJobName     S                   like(StdQalJob) inz('*')
      * ---------------------------------------------------------
      *
      *    Retrieve job information
      *
     C                   CallP     RtvJobInf(dsJobI0100 :
     C                                       %len(dsJobI0100):
     C                                       'JOBI0700' :
     C                                       QualJobName:
     C                                       IntJobID   :
     C                                       dsEC)
     C                   If        dsEC.avl <> *zero
     C                   return    *blanks
     C                   endIf
      *
     C                   return    JobI_JobNbr
      *
     P RtvJobNbr       E
