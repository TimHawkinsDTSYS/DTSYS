      *  ===================================================================
      *  =  Copyright (c) 2002 by Jeff Yanoviak                            =
      *  =  All rights reserved.                                           =
      *  =                                                                 =
      *  =  Program....... UPDQRYR                                         =
      *  =  Description... This is the main program for the UPDQRY         =
      *  =                 command.  The program opens a virtual terminal, =
      *  =                 signs on using the supplied user name and       =
      *  =                 password, starts the WRKQRY display, and loops  =
      *  =                 through the supplied list of queries updating   =
      *  =                 them.  If the query update encounters an error, =
      *  =                 the error text is forwarded to the job log.     =
      *  ===================================================================
     H DftActGrp(*NO)
     H ActGrp(*Caller)
     H BndDir('QC2LE')

      *  ===================================================================
      *  = File Definitions                                                =
      *  ===================================================================
     Fqadspobj  IF   E             Disk

      *  ===================================================================
      *  =  Entry Parameters                                               =
      *  =                                                                 =
      *  =  Usage      Length   Type         Parameter Description         =
      *  =                                                                 =
      *  =  Input          20   Character    Qualified file name           =
      *  =  Input          10   Character    User name                     =
      *  =  Input          10   Character    Password                      =
      *  ===================================================================
     D MainProcedure   PR                  ExtPgm( 'UQD000R' )
     D                              500A   dim(50)
     D                               10A
     D                               10A

     D MainProcedure   PI
     D  QFile                       500A   dim(50)
     D  UsrPrf                       10A
     D  UsrPwd                       10A

      *  ===================================================================
      *  =  Procedure prototypes                                           =
      *  ===================================================================

      *  -------------------------------------------------------------------
      *  - Open Virtual Terminal Path (QTVOPNVT) API                       -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Output     16       Character    VT handle                     -
      *  -  Input       3       Character    Keyboard lang type            -
      *  -  Input       4       Binary       Character set                 -
      *  -  Input       4       Binary       Code page                     -
      *  -  Input       4       Binary       Work station type             -
      *  -  Input      20       Character    Qualified DQ name             -
      *  -  Input               Pointer      Key Value for DQ              -
      *  -  Input       4       Binary       Length of Key Value           -
      *  -  Input               Pointer      Error Code                    -
      *  -------------------------------------------------------------------
     D OpnVT           PR                  ExtPgm( 'QTVOPNVT' )
     D                               16A
     D                                3A   Const
     D                               10I 0 Const
     D                               10I 0 Const
     D                               10I 0 Const
     D                               20A
     D                              256A   Const
     D                                     Options( *Varsize )
     D                               10I 0 Const
     D                                 *   Const

      *  -------------------------------------------------------------------
      *  - Read from Virtual Terminal (QTVRDVT) API                        -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Input      16       Character    VT handle                     -
      *  -  Output     10       Character    Read information              -
      *  -  Output   9999       Character    Data buffer                   -
      *  -  Input       4       Binary       Number of bytes to read       -
      *  -  Output      4       Binary       Number of bytes read          -
      *  -  Input               Pointer      Error Code                    -
      *  -------------------------------------------------------------------
     D ReadVt          PR                  ExtPgm( 'QTVRDVT' )
     D                               16A
     D                               10A
     D                             9999    Options( *VarSize )
     D                               10I 0 Const
     D                               10I 0
     D                                 *   Const

      *  -------------------------------------------------------------------
      *  - Write to Virtual Terminal (QTVWRTVT) API                        -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Input      16       Character    VT handle                     -
      *  -  Input      10       Character    Write information             -
      *  -  Input    9999       Character    Data buffer                   -
      *  -  Input       4       Binary       Number of bytes to write      -
      *  -  Input               Pointer      Error Code                    -
      *  -------------------------------------------------------------------
     D WriteVT         PR                  ExtPgm( 'QTVWRTVT' )
     D                               16A
     D                               10A   Const
     D                             9999    Const
     D                                     Options( *Varsize )
     D                               10I 0 Const
     D                                 *   Const

      *  -------------------------------------------------------------------
      *  - Close Virtual Terminal Path (QTVCLOVT) API                      -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Input      16       Character    VT handle                     -
      *  -  Input               Pointer      Error Code                    -
      *  -------------------------------------------------------------------
     D CloseVT         PR                  ExtPgm( 'QTVCLOVT' )
     D                               16A
     D                                 *   Const

      *  -------------------------------------------------------------------
      *  - Send Program Message (QMHSNDPM) API                             -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Input       7       Character    Message identifier            -
      *  -  Input      20       Character    Qualified message file name   -
      *  -  Input    3000                    Message data or text          -
      *  -  Input       4       Binary       Length of msg data or text    -
      *  -  Input      10       Character    Message type                  -
      *  -  Input      10       Char         Call stack entry              -
      *  -  Input       4       Binary       Call stack counter            -
      *  -  Output      4       Character    Message key                   -
      *  -  Input               Pointer      Error code                    -
      *  -------------------------------------------------------------------
     D SndPgmMsg       PR                  ExtPgm( 'QMHSNDPM' )
     D                                7A   Const
     D                               20A   Const
     D                             3000    Const
     D                                     Options( *Varsize )
     D                               10I 0 Const
     D                               10A   Const
     D                               10A   Const
     D                               10I 0 Const
     D                                4A
     D                                 *   Const

      *  -------------------------------------------------------------------
      *  - Execute System Command                                          -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Input               Pointer      Command String                -
      *  -------------------------------------------------------------------
     D CL              PR                  ExtProc( 'system' )
     D                                 *   Value
     D                                     Options( *String )

      *  -------------------------------------------------------------------
      *  - Receive Data Queue (QRCVDTAQ) API                               -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Input          10   Character    DQ Name                       -
      *  -  Input          10   Character    DQ Library                    -
      *  -  Output        5 0   Packed       Length of data                -
      *  -  Output       9999   Character    Data                          -
      *  -  Input         5 0   Packed       Wait time                     -
      *  -------------------------------------------------------------------
     D RcvDtaQ         PR                  ExtPgm( 'QRCVDTAQ' )
     D                               10A   Const
     D                               10A   Const
     D                                5P 0
     D                             9999    Options( *VarSize )
     D                                5P 0 Const

      *  ===================================================================
      *  =  Data Definitions                                               =
      *  ===================================================================

      *  -------------------------------------------------------------------
      *  - These constants define the key press actions                    -
      *  -------------------------------------------------------------------
     D KeyEnter        C                   Const( x'F1' )
     D KeyF3           C                   Const( x'33' )
     D KeyF12          C                   Const( x'3C' )

      *  -------------------------------------------------------------------
      *  - These constants define the 5250 Data Stream Commands            -
      *  -------------------------------------------------------------------
     D CmdNewField     C                   Const( x'11' )
     D CmdInputField   C                   Const( x'1D' )
     D CmdRepeat       C                   Const( x'02' )

      *  -------------------------------------------------------------------
      *  - These constants define field attributes                         -
      *  -------------------------------------------------------------------
     D AttSOField      C                   Const( x'4020' )
     D AttSOUser       C                   Const( x'2400' )
     D AttSOPwd        C                   Const( x'2700' )
     D AttInputField   C                   Const( x'5000' )
     D AttRegField     C                   Const( x'2000' )
     D AttError        C                   Const( x'22'   )

      *  -------------------------------------------------------------------
      *  - These constants define screen positions                         -
      *  -------------------------------------------------------------------
     D PosDft          C                   Const( x'0101' )
     D PosSOErrStr     C                   Const( x'1750' )
     D PosSOErrEnd     C                   Const( x'1850' )
     D PosErrStr       C                   Const( x'1801' )
     D PosErrEnd       C                   Const( x'184D' )
     D PosQryAct       C                   Const( x'051A' )
     D PosQryName      C                   Const( x'081A' )
     D PosQryLib       C                   Const( x'091C' )
     D PosQrySave      C                   Const( x'051D' )
     D PosQryRunOpt    C                   Const( x'071D' )

      *  -------------------------------------------------------------------
      *  - These are miscelaneous constants                                -
      *  -------------------------------------------------------------------
     D NullChar        C                   Const( x'00'  )
     D WritePutGet     C                   Const( '03'   )
     D ReadPutGet      C                   Const( '3'    )
     D CmdLine         C                   Const( '===>' )

      *  -------------------------------------------------------------------
      *  - Data queue definitions                                          -
      *  -------------------------------------------------------------------
     D QDQName         DS
     D  DQName                       10A   Inz( 'UPDQRY' )
     D  DQLib                        10A   Inz( 'QTEMP'  )

      *  -------------------------------------------------------------------
      *  - This field is a dummy row,col.  Row & col are 1 byte in the     -
      *  - 5250 data stream, but there is no 1 byte data type in RPG IV,   -
      *  - so this field is used so that substring and arithmetic          -
      *  - functions can be performed.                                     -
      *  -------------------------------------------------------------------
     D DummyRowColDS   DS
     D  DummyRowCol                   5U 0

      *  -------------------------------------------------------------------
      *  - Data structure used to simplify sending sign on field info      -
      *  - to the virtual terminal.  SOUserPos and SOPwdPos are row & col  -
      *  - fields similar to DummyRowCol above.                            -
      *  -------------------------------------------------------------------
     D SignOn          DS
     D  SOCursorPos                   2A   Inz( PosDft      )
     D  SOKeyAct                      1A   Inz( KeyEnter    )
     D  SOUserCmd                     1A   Inz( CmdNewField )
     D  SOUserPos                     5U 0
     D  SOUserTxt                    10A
     D  SOPwdCmd                      1A   Inz( CmdNewField )
     D  SOPwdPos                      5U 0
     D  SOPwdTxt                     10A

      *  -------------------------------------------------------------------
      *  - Work Variables                                                  -
      *  -------------------------------------------------------------------
     D Buf             S           5000
     D DQData          S             80A
     D DQDtaSz         S              5P 0
     D MsgKey          S              4A
     D Msg             S            256A
     D VtHandle        S             16A
     D VtInfo          S             10A
     D VtReceived      S             10I 0
     D ErrPos          S             10I 0
     D ErrEnd          S             10I 0
     D ErrLen          S             10I 0
     D Pos             S             10I 0
     D MaxIdx          S             10I 0
     D Lib             S             10A
     D File            S             10A
     D Status          S             10A   Inz( '*INFO' )

      *  ===================================================================
      *  =  Main Procedure                                                 =
      *  ===================================================================

      *  Change queries.

     C                   Read      QLIDOBJD
      *
     C                   dow       not %eof
     C                   exsr      ChgQry

     C                   Read      QLIDOBJD
     C                   enddo

      *
      *  After processing all queries, exit Work with Queries.
      *
     C                   Eval      Buf = PosDft + KeyF3
     C                   ExSr      WriteWait
     C                   ExSr      FndCmdLin
     C                   ExSr      Signoff
     C                   ExSr      Cleanup
     C                   ExSr      SndCompMsg

     C                   Return
      *  ===================================================================
      *  VT setup
      *  ===================================================================
     C     VTsetup       BegSr

      *  -------------------------------------------------------------------
      *  - Create the data queue and attach it to the VT                   -
      *
     C                   CallP     CL( 'CRTDTAQ '      +
     C                                 %Trim( DQLib )  +
     C                                 '/'             +
     C                                 %Trim( DQName ) +
     C                                 ' MAXLEN(80)'   )

     C                   CallP     OpnVt( VtHandle :
     C                                    '   '    :
     C                                    0        :
     C                                    0        :
     C                                    1        :
     C                                    QDQName  :
     C                                    ' '      :
     C                                    0        :
     C                                    *Null    )

      *  -------------------------------------------------------------------
      *  - Wait for sign on screen to become available, then read it       -
      *  -------------------------------------------------------------------
     C                   CallP     RcvDtaQ( DQName  :
     C                                      DQLib   :
     C                                      DQDtaSz :
     C                                      DQData  :
     C                                          -1  )

     C                   CallP     ReadVt( VtHandle   :
     C                                     VtInfo     :
     C                                     Buf        :
     C                                     %Size(Buf) :
     C                                     VtReceived :
     C                                     *Null      )

      *  -------------------------------------------------------------------
      *  - Find the first two input capable fields which should be user    -
      *  - name and password.  Put their positions in the SignOn data      -
      *  - structure.                                                      -
      *  -------------------------------------------------------------------
     C                   Eval      Pos = %Scan( CmdInputField +
     C                                          AttSOField    +
     C                                          AttSOUser     :
     C                                          Buf           )
     C                   Eval      %Subst( SignOn : 5     : 2 ) =
     C                             %Subst( Buf    : Pos-2 : 2 )
     C                   Eval      SOUserPos = SOUserPos + 1

     C                   Eval      Pos = %Scan( CmdInputField +
     C                                          AttSOField    +
     C                                          AttSOPwd      :
     C                                          Buf           )
     C                   Eval      %Subst( SignOn : 18    : 2 ) =
     C                             %Subst( Buf    : Pos-2 : 2 )
     C                   Eval      SOPwdPos = SOPwdPos + 1

      *  -------------------------------------------------------------------
      *  - Write the signon data structure to the VT.                      -
      *  -------------------------------------------------------------------
     C                   Eval      Buf = SignOn
     C                   Exsr      WriteWait

      *  -------------------------------------------------------------------
      *  - Check for signon error.  Message and exit if VT cannot be       -
      *  - signed on.                                                      -
      *  -------------------------------------------------------------------
     C                   Eval      ErrPos = %Scan( CmdNewField +
     C                                             PosSOErrStr +
     C                                             AttError    :
     C                                             Buf         )
     C                   If        ErrPos <> 0
     C                   Eval      ErrPos = ErrPos + 4
     C                   Eval      ErrEnd = %Scan( CmdRepeat   +
     C                                             PosSOErrEnd +
     C                                             NullChar    :
     C                                             Buf         )
     C                   Eval      ErrLen = ErrEnd - ErrPos
     C                   Eval      Msg = 'Signon received:  '            +
     C                                   %Subst( Buf : ErrPos : ErrLen )
     C                   ExSr      Cleanup
     C                   CallP     SndPgmMsg( 'CPF9897'        :
     C                                        'QCPFMSG   QSYS' :
     C                                        Msg              :
     C                                        %Len(Msg)        :
     C                                        '*ESCAPE'        :
     C                                        '*'              :
     C                                        2                :
     C                                        MsgKey           :
     C                                        *Null            )
     C                   Return
     C                   EndIf

      *  -------------------------------------------------------------------
      *  - Send enter repeatedly to the VT until a command line appears in -
      *  - the data stream.                                                -
      *  -------------------------------------------------------------------
     C                   DoU       %Scan( CmdLine : Buf ) <> 0
     C                   Eval      Buf = PosDft + KeyEnter
     C                   Exsr      WriteWait
     C                   EndDo

      *  -------------------------------------------------------------------
      *  - Find the coordinates of the command line.                       -
      *  -------------------------------------------------------------------
     C                   ExSr      FndCmdLin

      *  -------------------------------------------------------------------
      *  - Write 'WRKQRY' on the command line and issue Enter              -
      *  -------------------------------------------------------------------
     C                   Eval      Buf = PosDft        +
     C                                   KeyEnter      +
     C                                   CmdNewField   +
     C                                   DummyRowColDS +
     C                                   'WRKQRY'
     C                   ExSr      WriteWait

     C                   EndSr

      *  ===================================================================
      *  Write 'SIGNOFF' on the command line and issue Enter
      *  ===================================================================
     C     Signoff       begsr

     C                   Eval      Buf = PosDft        +
     C                                   KeyEnter      +
     C                                   CmdNewField   +
     C                                   DummyRowColDS +
     C                                   'SIGNOFF'
     C                   ExSr      WriteWait

     C                   endsr

      *  ===================================================================
      *  Change query
      *  ===================================================================
     C     ChgQry        BegSr
      *  -------------------------------------------------------------------
      *  - Populate fields so that the query is opened for change          -
      *
     C                   Eval      Buf = PosDft        +
     C                                   KeyEnter      +
     C                                   CmdNewField   +
     C                                   PosQryAct     +
     C                                   '2'           +
     C                                   CmdNewField   +
     C                                   PosQryName    +
     C                                   ODobnm        +
     C                                   CmdNewField   +
     C                                   PosQryLib     +
     C                                   ODlbnm
     C                   Exsr      WriteWait

      *  -------------------------------------------------------------------
      *  - Scan the screen for errors                                      -
      *
     C                   Eval      ErrPos = %Scan( CmdNewField +
     C                                             PosErrStr   +
     C                                             AttError    :
     C                                             Buf         )
     C                   If        ErrPos <> 0

      *  -------------------------------------------------------------------
      *  - On error, send the message to the job log along with the query  -
      *  - name.                                                           -
      *  -------------------------------------------------------------------
     C                   Eval      Status = '*ESCAPE'
     C                   Eval      ErrPos = ErrPos + 4
     C                   Eval      ErrEnd = %Scan( CmdRepeat +
     C                                             PosErrEnd +
     C                                             NullChar  :
     C                                             Buf       )
     C                   Eval      ErrLen = ErrEnd - ErrPos
     C                   Eval      Msg = 'Query '                        +
     C                                   %Trim(ODobnm)                   +
     C                                   ' in library '                  +
     C                                   %Trim(ODlbnm)                   +
     C                                   ' received:  '                  +
     C                                   %Subst( Buf : ErrPos : ErrLen )
     C                   CallP     SndPgmMsg( 'CPF9897'        :
     C                                        'QCPFMSG   QSYS' :
     C                                        Msg              :
     C                                        %Len(Msg)        :
     C                                        '*INFO'          :
     C                                        '*'              :
     C                                        2                :
     C                                        MsgKey           :
     C                                        *Null            )

      *  -------------------------------------------------------------------
      *  - If the error occurred on a screen other than the Work with      -
      *  - query screen, hit F12 to return to Work with Queries.           -
      *  -------------------------------------------------------------------
     C                   If        %Scan('Work with Queries':buf) = *zero
     C                   Eval      Buf = PosDft + KeyF12
     C                   ExSr      WriteWait
     C                   EndIf

     C                   Else

      *  -------------------------------------------------------------------
      *  - The code will only reach here if there has not been an error.   -
      *  - Save the query and return to the Work with Queries screen.      -
      *  -------------------------------------------------------------------
     C                   Eval      Buf = PosDft + KeyF3
     C                   ExSr      WriteWait

     C                   Eval      Buf = PosDft       +
     C                                   KeyEnter     +
     C                                   CmdNewField  +
     C                                   PosQrySave   +
     C                                   'Y'          +
     C                                   CmdNewField  +
     C                                   PosQryRunOpt +
     C                                   '3'
     C                   ExSr      WriteWait
     C                   EndIf

     C                   EndSr

      *  -------------------------------------------------------------------
      *  - Find command line
      *  -------------------------------------------------------------------
     C     FndCmdLin     begsr

     C                   Eval      Pos = %Scan( CmdInputField +
     C                                          AttInputField +
     C                                          AttRegField   :
     C                                          Buf           )
     C                   Eval      DummyRowColDS = %Subst( Buf : Pos-2 : 2 )
     C                   Eval      DummyRowCol = DummyRowCol + 1

     C                   endsr
      *  ===================================================================
      *  =  Subroutine... Cleanup                                          =
      *  ===================================================================
     C     CleanUp       BegSr
      *  -------------------------------------------------------------------
      *  - Close the Virtual Terminal                                      -
      *
     C                   CallP     CloseVt( VtHandle :
     C                                      *Null    )
      *  -------------------------------------------------------------------
      *  - Delete the working data queue                                   -
      *
     C                   CallP     CL( 'DLTDTAQ '    +
     C                                 %Trim(DQLib)  +
     C                                 '/'           +
     C                                 %Trim(DQName) )
     C                   EndSr

      *  ===================================================================
      *  =  Subroutine... WriteWait                                        =
      *  =    Writes information to the Virtual Terminal and then waits    =
      *  =    for the Virtual Terminal to process the get/put.             =
      *  ===================================================================
     C     WriteWait     BegSr

      *  -------------------------------------------------------------------
      *  - Set status fields to indicate that the enter key was pressed    -
      *  - and that the write operation is a put/get.                      -
      *
     C                   Eval      VtInfo = WritePutGet
      *  -------------------------------------------------------------------
      *  - Write the contents of Buf to the Virtual Terminal               -
      *
     C                   CallP     WriteVt( VtHandle             :
     C                                      VtInfo               :
     C                                      Buf                  :
     C                                      %Len( %Trim( Buf ) ) :
     C                                      *Null                )

      *  -------------------------------------------------------------------
      *  - Read the response back from the Virtual terminal until the      -
      *  - status fields indicate that the put/get has been processed.     -
      *
      * Read from the VT until our get/put is processed

     C                   DoU       %Subst( VtInfo : 1 : 1 ) = ReadPutGet
     C                   CallP     RcvDtaQ( DQName  :
     C                                      DQLib   :
     C                                      DQDtaSz :
     C                                      DQData  :
     C                                          -1  )

     C                   CallP     ReadVt( VtHandle   :
     C                                     VtInfo     :
     C                                     Buf        :
     C                                     %Size(Buf) :
     C                                     VtReceived :
     C                                     *Null      )
     C                   EndDo

     C                   EndSr

      *  ===================================================================
      *  Initialize variables.
      *  ===================================================================
     C     *INZSR        BegSr

      *  -------------------------------------------------------------------
      *  - Initialize variables                                            -
      *  -------------------------------------------------------------------
     C                   Eval      *InLr     = *On
     C                   Eval      SOUserTxt = UsrPrf
     C                   Eval      SOPwdTxt  = UsrPwd

     C**                 for       maxidx = 1 to 50
     C**                 if        qfile(maxidx) = *blanks
     C**                 leave
     C**                 endif
     C**                 endfor
     C**                 eval      maxidx -= 1

      *  -------------------------------------------------------------------
      *  - VT setup
      *  -------------------------------------------------------------------
     C                   exsr      VTsetup

     C                   endsr
      *  ===================================================================
      *  Send completion message
      *  ===================================================================
     C     SndCompMsg    BegSr

     C                   If        Status = '*ESCAPE'
     C                   Eval      Msg =
     C                             'Some queries did not update successfully.'
     C                   Else
     C                   Eval      Msg =
     C                             'Query processing completed normally.'
     C                   EndIf

     C                   CallP(e)  SndPgmMsg( 'CPF9897'        :
     C                                        'QCPFMSG   QSYS' :
     C                                        Msg              :
     C                                        %Len(Msg)        :
     C                                        Status           :
     C                                        '*'              :
     C                                        2                :
     C                                        MsgKey           :
     C                                        *Null            )

     C                   EndSr
