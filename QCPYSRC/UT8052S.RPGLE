      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Copy: Job prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *  RtvJobTyp() -- Retrieve job type.
      *
     D RtvJobtyp       PR             3
      * ---------------------------------------------------------
      *  RtvJobNam() -- Retrieve job name.
      *
     D RtvJobNam       PR                  like(StdNam)
      * ---------------------------------------------------------
      *  RtvJobUsr() -- Retrieve job user.
      *
     D RtvJobUsr       PR                  like(StdNam)
      * ---------------------------------------------------------
      *  RtvJobNbr() -- Retrieve job number.
      *
     D RtvJobNbr       PR                  like(StdJobNbr)
      * ---------------------------------------------------------
      *  ChkInvStk() -- Check invocation stack.
      *
     D ChkInvStk       PR                  like(StdInd)
     D   PgmNam                            like(StdNam) value
      * ---------------------------------------------------------
      *  ChkInvStk2() -- Check invocation stack.
      *
     D ChkInvStk2      PR                  like(StdInd)
     D   PgmNam                            like(StdNam) value
      *
      *  RtvNbrStkEnt() -- Retrieve number of call stack entries
      *
     D RtvNbrStkEnt    PR                  like(StdInt)
     D  JobNameIn                          like(StdNam)     value
     D  JobUserIn                          like(StdNam)     value
     D  JobNbrIn                           like(StdJobNbr)  value
     D  APIError                    272    Options( *NoPass )
      *
      *  RtvStkEnt() -- Retrieve call stack entry
      *
     D RtvStkEnt       PR                  like(StdInd)
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
      *
      *  RtvCallStkAPI() -- Retrieve call stack API
      *
     D RtvCallStkAPI   PR                  ExtPgm('QWVRCSTK')
     D  InvStkDS                           like(StdBuf)
     D  InvStkLen                          like(StdInt)
     D  InvStkFmt                          like(StdFmt) const
     D  InvStkJobDS                        like(JobIDinf)
     D  InvStkJobFmt                       like(StdFmt) const
     D  APIError                           like(APIerrorDS)
     D                                     Options(*nopass)
      *
     D JobIDinf        DS
     D  JIDQName                     26    Inz('*')
     D  JIDIntID                     16
     D  JIDRes3                       2    Inz(*loval)
     D  JIDThreadInd                       like(StdInt) Inz(1)
     D  JIDThread                     8    Inz(*loval)
      * ---------------------------------------------------------
      *  Sleep() -- Force the job to sleep in seconds.
      *
     D Sleep           PR                  extproc('sleep')
     D                                     like(StdInt)
     D  seconds                      10u 0 value
      *
      *  uSleep() -- Force the job to sleep in microsecs.
      *
     D uSleep          PR                  extproc('usleep')
     D                                     like(StdInt)
     D  microsecs                    10u 0 value
      * ---------------------------------------------------------
      *  RtvUsrLibL() -- Retrieve user library list.
      *
     D RtvUsrLibL      Pr           550
     D  RtvUsrLibl...
     D  JobNam                             like(StdNam)
     D                                     value  options(*nopass)
     D  RtvUsrLibl...
     D  Usr                                like(StdNam)
     D                                     value  options(*nopass)
     D  RtvUsrLibl...
     D  JobNbr                        6  0 value  options(*nopass)
     D  RtvUsrLibl...
     D  APIerror                    272           options(*nopass)
      * ---------------------------------------------------------
      *  RtvJobInf() -- Retrieve job information.
      *
     D RtvJobInf       PR                  ExtPgm('QUSRJOBI')
     D   RcvVar                            like(StdMaxLen) options(*varsize)
     D   RcvVarLen                         like(StdInt)    const
     D   Format                            like(StdFmt)    const
     D   JobName                           like(StdQalJob) const
     D   IntJobID                          like(StdIntID)  const
     D   p_EC                              likeDS(dsEC)
     D                                     options(*nopass)
      *
      *   Structure for JOBI0100.
      *
     D dsJobI0100      DS
     D   JobI_ByteRtn                      like(StdInt)
     D   JobI_ByteAvl                      like(StdInt)
     D   JobI_JobName                      like(StdNam)
     D   JobI_UserID                       like(StdNam)
     D   JobI_JobNbr                       like(StdJobNbr)
     D   JobI_IntJob                 16A
     D   JobI_Status                       like(StdNam)
     D   JobI_Type                         like(StdChr)
     D   JobI_SbType                       like(StdChr)
     D   JobI_Reserv1                 2A
     D   JobI_RunPty                       like(StdInt)
     D   JobI_TimeSlc                      like(StdInt)
     D   JobI_DftWait                      like(StdInt)
     D   JobI_Purge                        like(StdNam)
      * ---------------------------------------------------------
      *  Write job tracking log.
      *
     D WrtJobTrk       PR
     D  PIbgnend                           like(StdNam) const
     D  PIjobnam                           like(StdNam) const
     D  PIstep                             like(StdNam) const
     D  PItext                             like(StdTxt) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *  Write to job log.
      *  -- Joblog('Record %s':%char(RecCnt));
      *  -- "%s" is a positional replacment value for RecCnt
      *
     D Joblog          PR
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
      *
      *  Write to job log API
      *  -- Qp0zLprintf('Record %s' + x'25':%char(RecCnt));
      *  -- "%s" is a positional replacment value for RecCnt
      *  -- x'25' is a line feed.
      *
     D Qp0zLprintf     PR                  ExtProc('Qp0zLprintf')
     D                                     like(StdInt)
     D  szOutputStg                    *   value options(*string)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
     D                                 *   value options(*string:*nopass)
