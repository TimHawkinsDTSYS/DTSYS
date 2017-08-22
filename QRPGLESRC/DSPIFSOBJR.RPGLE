      *  ===================================================================
      *  =  Copyright (c) 2002 by Multifoods Distribution Group, Inc.      =
      *  =  All rights reserved.                                           =
      *  =                                                                 =
      *  =  Program....... DspIFSObjR                                      =
      *  =  Description... This program populates an outfile with a list   =
      *  =                 of objects in the specified path, including the =
      *  =                 total size of all objects in any subdirectories =
      *  =                                                                 =
      *  =  Input Parameters:                                              =
      *  =   DirPath - 255 character path name                             =
      *  =  Output Parameters:                                             =
      *  =   None.                                                         =
      *  =                                                                 =
      *  =  To create...                                                   =
      *  =  CrtBndDir BndDir(DspIFSObj/DspIFSObj)                          =
      *  =            Text('Binding Directory for DspIFSObj Utility')      =
      *  =  AddBndDirE BndDir(DspIFSObj)                                   =
      *  =             Obj((Qp0LLib1))                                     =
      *  =  Use option 14 from PDM to compile program                      =
      *  ===================================================================

     H DftActGrp( *No )
     H BndDir( 'DSPIFSOBJ' )

      *  ===================================================================
      *  = File Definitions                                                =
      *  ===================================================================

     FdspifsobjpO    E             DISK

      *  ===================================================================
      *  = Entry Parameters                                                =
      *  =                                                                 =
      *  = Usage      Length   Type         Parameter Description          =
      *  =                                                                 =
      *  = Input         255   Character    Starting path                  =
      *  ===================================================================

     D MainProcedure   PR                  ExtPgm( 'DSPIFSOBJR' )
     D                              255A

     D MainProcedure   PI
     D  DirPath                     255A

      *  ===================================================================
      *  = Procedure Prototypes                                            =
      *  ===================================================================

      *  -------------------------------------------------------------------
      *  -  Process Path Name API (Qp0lProcessSubtree)                     -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Return         10   Integer      Success indication            -
      *  -  Input               Pointer      Path name                     -
      *  -  Input          10   Unsigned     Subtree level                 -
      *  -  Input               Pointer      Object Type List              -
      *  -  Input          10   Unsigned     Local/remote objects          -
      *  -  Input               Pointer      Inclusion/exclusion           -
      *  -  Input          10   Unsigned     Error recover action          -
      *  -  Input               Pointer      User function pointer         -
      *  -  Input               Pointer      Function control block        -
      *  -------------------------------------------------------------------

     D ProcSubtree     PR            10I 0 ExtProc( 'Qp0lProcessSubtree' )
     D                                 *   Value
     D                               10U 0 Value
     D                                 *   Value
     D                               10U 0 Value
     D                                 *   Value
     D                               10U 0 Value
     D                                 *   Value
     D                                     Options( *String )
     D                                 *   Value

      *  -------------------------------------------------------------------
      *  -  Get Attributes API (Qp0lGetAttr)                               -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Return         10   Integer      Success indication            -
      *  -  Input               Pointer      Path name                     -
      *  -  Input               Pointer      Attribute array               -
      *  -  Input               Pointer      Return buffer                 -
      *  -  Input          10   Unsigned     Return buffer size            -
      *  -  Input               Pointer      Buffer size needed            -
      *  -  Input               Pointer      Bytes returned                -
      *  -  Input          10   Unsigned     Follow symlink                -
      *  -------------------------------------------------------------------

     D GetAttr         PR            10I 0 ExtProc( 'Qp0lGetAttr' )
     D                                 *   Value
     D                                 *   Value
     D                                 *   Value
     D                               10U 0 Value
     D                                 *   Value
     D                                 *   Value
     D                               10U 0 Value

      *  -------------------------------------------------------------------
      *  -  Receive Program Message (QMHRCVPM) API                         -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Output              Character    Message information           -
      *  -  Input          10   Integer      Length of message information -
      *  -  Input           8   Character    Format name                   -
      *  -  Input          10   Character    Call stack entry              -
      *  -  Input          10   Integer      Call stack counter            -
      *  -  Input          10   Character    Message type                  -
      *  -  Input           4   Character    Message key                   -
      *  -  Input          10   Integer      Wait time                     -
      *  -  Input          10   Character    Message action                -
      *  -  Input               Pointer      Error code                    -
      *  -------------------------------------------------------------------

     D RcvPgmMsg       PR                  ExtPgm( 'QMHRCVPM' )
     D                             9999    Options( *VarSize )
     D                               10I 0 Const
     D                                8A   Const
     D                               10A   Const
     D                                     Options( *VarSize )
     D                               10I 0 Const
     D                               10A   Const
     D                                4A   Const
     D                               10I 0 Const
     D                               10A   Const
     D                                 *   Const

      *  -------------------------------------------------------------------
      *  - Send Program Message (QMHSNDPM) API                             -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Input       7       Character    Message identifier            -
      *  -  Input      20       Character    Qualified message file name   -
      *  -  Input                            Message data or text          -
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
     D                                     Options( *VarSize )
     D                               10I 0 Const
     D                               10A   Const
     D                               10A   Const
     D                               10I 0 Const
     D                                4A
     D                                 *   Const

      *  -------------------------------------------------------------------
      *  -  Current level procedure                                        -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Input               Pointer      Selection status              -
      *  -  Input               Pointer      Error value                   -
      *  -  Input               Pointer      Return value                  -
      *  -  Input               Pointer      Object name                   -
      *  -  Input               Pointer      Function control block        -
      *  -------------------------------------------------------------------

     D CurLvl          PR                  ExtProc( 'CurLvl' )
     D                                 *   Value
     D                                 *   Value
     D                                 *   Value
     D                                 *   Value
     D                                 *   Value

      *  -------------------------------------------------------------------
      *  -  Sub level procedure                                            -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  Input               Pointer      Selection status              -
      *  -  Input               Pointer      Error value                   -
      *  -  Input               Pointer      Return value                  -
      *  -  Input               Pointer      Object name                   -
      *  -  Input               Pointer      Function control block        -
      *  -------------------------------------------------------------------

     D SubLvl          PR                  ExtProc( 'SubLvl' )
     D                                 *   Value
     D                                 *   Value
     D                                 *   Value
     D                                 *   Value
     D                                 *   Value

      *  -------------------------------------------------------------------
      *  -  Error Handler                                                  -
      *  -                                                                 -
      *  -  Usage      Length   Type         Parameter Description         -
      *  -                                                                 -
      *  -  No Parameters.                                                 -
      *  -------------------------------------------------------------------

     D ErrHandler      PR                  ExtProc( 'ErrHandler')

      *  ===================================================================
      *  = Data Definitions                                                =
      *  ===================================================================

      *  -------------------------------------------------------------------
      *  - Parameters for ProcSubtree                                      -
      *  -------------------------------------------------------------------

     D PSObjType       S               *   Inz( *Null )
     D PSIncExc        S               *   Inz( *Null )
     D PSFCB@          S               *   Inz( *Null )

      *  -------------------------------------------------------------------
      *  - Large path name date structure                                  -
      *  -------------------------------------------------------------------

     D QLGPN           DS
     D  QLGCCSID                     10U 0 Inz( x'00'     )
     D  QLGCntryID                    2A   Inz( *ALLx'00' )
     D  QLGLangID                     3A   Inz( *ALLx'00' )
     D  QLGReserved1                  3    Inz( *ALLx'00' )
     D  QLGPathType                  10U 0 Inz( 0         )
     D  QLGPathLen                   10U 0
     D  QLGPathDelim                  2A   Inz( '/'       )
     D  QLGReserved2                 10    Inz( *ALLx'00' )
     D  QLGPath                     255A

      *  -------------------------------------------------------------------
      *  - Function pointer for current level procedure                    -
      *  -------------------------------------------------------------------

     D CL@             DS
     D  CLType                       10U 0 Inz( 0                  )
     D  CLPgmLib                     10A   Inz( *Blank             )
     D  CLPgmName                    10A   Inz( *Blank             )
     D  CLThreadAct                   1A   Inz( x'00'              )
     D  CLReserved                    7    Inz( *ALLx'00'          )
     D  CLProc@                        *   Inz( %PAddr( 'CurLvl' ) )
     D                                     ProcPtr

      *  -------------------------------------------------------------------
      *  - Function pointer for sub level procedure                        -
      *  -------------------------------------------------------------------

     D SL@             DS
     D  SLType                       10U 0 Inz( 0                  )
     D  SLPgmLib                     10A   Inz( *Blank             )
     D  SLPgmName                    10A   Inz( *Blank             )
     D  SLThreadAct                   1A   Inz( x'00'              )
     D  SLReserved                    7    Inz( *ALLx'00'          )
     D  SLProc@                        *   Inz( %PAddr( 'SubLvl' ) )
     D                                     ProcPtr

      *  ===================================================================
      *  = Main procedure                                                  =
      *  ===================================================================

      *  -------------------------------------------------------------------
      *  - Initialize the large path data structure with specified path    -
      *  -------------------------------------------------------------------

     C                   Eval      QLGPath    = %Trim( DirPath )
     C                   Eval      QLGPathLen = %Len( %Trim( QLGPath ) )

      *  -------------------------------------------------------------------
      *  - Use Process Subtree to call CurLvl for each object in the path  -
      *  -------------------------------------------------------------------

     C                   If        ProcSubtree( %Addr( QLGPN ) :
     C                                          1              :
     C                                          PSObjType      :
     C                                          0              :
     C                                          PSIncExc       :
     C                                          2              :
     C                                          CL@            :
     C                                          PSFCB@         ) = -1
     C                   CallP     ErrHandler
     C                   EndIf

      *  -------------------------------------------------------------------
      *  - Exit program                                                    -
      *  -------------------------------------------------------------------

     C                   Eval      *InLr = *On
     C                   Return

      *  ===================================================================
      *  = Sub procedure - Current Level                                   =
      *  ===================================================================

     P CurLvl          B
     D CurLvl          PI
     D  SltStatus@                     *   Value
     D  ErrValue@                      *   Value
     D  ReturnValue@                   *   Value
     D  ObjectName@                    *   Value
     D  FCB@                           *   Value

      *  -------------------------------------------------------------------
      *  - Variables used to access procedure parameters                   -
      *  -------------------------------------------------------------------

     D SltStatus       S              9B 0 Based( SltStatus@ )
     D ReturnValue     S              9B 0 Inz( 0 )

      *  -------------------------------------------------------------------
      *  - Data structure for GetAttr return data                          -
      *  -------------------------------------------------------------------

     D Receiver        DS
     D  RContents                   100

      *  -------------------------------------------------------------------
      *  - Object attribute type constants                                 -
      *  -------------------------------------------------------------------

     D BA_ObjType      C                   Const( 0  )
     D BA_AllocSize64  C                   Const( 15 )

      *  -------------------------------------------------------------------
      *  - Data structure for GetAttr attribute array                      -
      *  -------------------------------------------------------------------

     D AttrArr         DS
     D  AANumAttr                    10I 0 Inz( 2              )
     D  AAObjType                    10I 0 Inz( BA_ObjType     )
     D  AAAlcSize64                  10I 0 Inz( BA_AllocSize64 )

      *  -------------------------------------------------------------------
      *  - Data structure for GetAttr buffer variable                      -
      *  -------------------------------------------------------------------

     D Buffer          DS                  Based( Buffer@ )
     D  BNextOffset                  10I 0
     D  BAttr                        10I 0
     D  BAttrSize                    10I 0
     D  BReserved                     4
     D  BAttrData                     1
      * ^^^^^^^^^ 'Dummy' field.  Use the address to resolve to attribute

      *  -------------------------------------------------------------------
      *  - Data structure for the object name                              -
      *  -------------------------------------------------------------------

     D ThisPath        DS                  Based( ObjectName@ )
     D  TPCCSID                      10I 0
     D  TPCntryID                     2A
     D  TPLangID                      3A
     D  TPReserved1                   3
     D  TPPathType                   10I 0
     D  TPPathLen                    10I 0
     D  TPPathDelim                   2A
     D  TPReserved2                  10
     D  TPPath@                        *

      *  -------------------------------------------------------------------
      *  - Variables used to translate object name                         -
      *  -------------------------------------------------------------------

     D PathNameUNI     S          16000C   Based( TPPath@ )
     D PathName255     S            510C   Inz( *Blanks )
     D PathName        S            255A   Inz( *Blanks )

      *  -------------------------------------------------------------------
      *  - Work variables                                                  -
      *  -------------------------------------------------------------------

     D SumSize         S             15P 0 Inz( 0                )
     D SumSize@        S               *   Inz( %Addr( SumSize ) )
     D NeedSize        S             10U 0
     D BytesRet        S             10U 0
     D AllocSize64     S             20U 0 Based( AllocSize64@ )
     D ObjType         S             10A   Based( ObjType@     )

      *  -------------------------------------------------------------------
      *  - Initialize the return value pointer                             -
      *  -------------------------------------------------------------------

     C                   Eval      ReturnValue@ = %Addr( ReturnValue )

      *  -------------------------------------------------------------------
      *  - Skip this object if the selection status is not normal, or if   -
      *  - the path name is null.                                          -
      *  -------------------------------------------------------------------

     C                   If        SltStatus <> 0     or
     C                             TPPath@   =  *Null
     C                   Return
     C                   EndIf

      *  -------------------------------------------------------------------
      *  - Parse out the object name from Unicode to the job's CCSID       -
      *  -------------------------------------------------------------------

     C                   Eval      PathName255 = %Subst( PathNameUNI         :
     C                                                   1                   :
     C                                                   %Int( TPPathLen/2 ) )
     C                   MoveL     PathName255   PathName

      *  -------------------------------------------------------------------
      *  - This procedure will be called for the original path, which we   -
      *  - do not want to return a value for.  QSYS.LIB and QOPT are       -
      *  - excluded here as well.                                          -
      *  -------------------------------------------------------------------

     C                   If        %Subst( PathName : 2 : 8 ) = 'QSYS.LIB' or
     C                             %Subst( PathName : 2 : 4 ) = 'QOPT'     or
     C                             PathName                   = DirPath
     C                   Return
     C                   EndIf

      *  -------------------------------------------------------------------
      *  - Populate receiver with object attributes                        -
      *  -------------------------------------------------------------------

     C                   If        GetAttr( ObjectName@        :
     C                                      %Addr( AttrArr   ) :
     C                                      %Addr( RContents ) :
     C                                      %Size( RContents ) :
     C                                      %Addr( NeedSize  ) :
     C                                      %Addr( BytesRet  ) :
     C                                      0                  ) = -1
     C                   CallP     ErrHandler
     C                   EndIf

      *  -------------------------------------------------------------------
      *  - Overlay receiver with the buffer data structure                 -
      *  -------------------------------------------------------------------

     C                   Eval      Buffer@ = %Addr( Receiver )

      *  -------------------------------------------------------------------
      *  - Move the buffer data strucure through the receiver variable,    -
      *  - extracting the attributes.                                      -
      *  -------------------------------------------------------------------

     C                   DoW       BNextOffset <> -1
     C                   Select
     C                   When      BAttr        = BA_ObjType
     C                   Eval      ObjType@     = %Addr( BAttrData )
     C                   When      BAttr        = BA_AllocSize64
     C                   Eval      AllocSize64@ = %Addr( BAttrData )
     C                   EndSl

     C                   If        BNextOffset =  0
     C                   Eval      BNextOffset = -1
     C                   Else
     C                   Eval      Buffer@ = %Addr ( Receiver ) + BNextOffset
     C                   Endif
     C                   EndDo

      *  -------------------------------------------------------------------
      *  - If the object is a directory or folder, use Process Subtree to  -
      *  - call SubLvl for each object in the tree.  Pass the pointer to   -
      *  - SumSize as the FCB so SubLvl can keep a running sum of the      -
      *  - object sizes.                                                   -
      *  -------------------------------------------------------------------

     C                   If        %Trim( ObjType ) = '*DIR' or
     C                             %Trim( ObjType ) = '*FLR'
     C                   Eval      SumSize = 0
     C                   If        ProcSubtree( ObjectName@ :
     C                                          0           :
     C                                          *Null       :
     C                                          0           :
     C                                          *Null       :
     C                                          2           :
     C                                          SL@         :
     C                                          SumSize@    ) = -1
     C                   CallP     ErrHandler
     C                   Return
     C                   EndIf
     C                   Else

      *  -------------------------------------------------------------------
      *  - Otherwise, just use the size we received from GetAttr           -
      *  -------------------------------------------------------------------

     C                   Eval      SumSize = AllocSize64
     C                   EndIf

      *  -------------------------------------------------------------------
      *  - Write the record to the output file                             -
      *  -------------------------------------------------------------------

     C                   Eval      PATH = PathName
     C                   Eval      SIZE = SumSize
     C                   Eval      TYPE = ObjType
     C                   Write     IFSOBJOUTR

      *  -------------------------------------------------------------------
      *  - End of subprocedure                                             -
      *  -------------------------------------------------------------------

     C                   Return
     P                 E

      *  ===================================================================
      *  = Sub procedure - Sub level                                       =
      *  ===================================================================

     P SubLvl          B
     D SubLvl          PI
     D  SltStatus@                     *   Value
     D  ErrValue@                      *   Value
     D  ReturnValue@                   *   Value
     D  ObjectName@                    *   Value
     D  FCB@                           *   Value

      *  -------------------------------------------------------------------
      *  - Variables used to access procedure parameters                   -
      *  -------------------------------------------------------------------

     D SltStatus       S             10I 0 Based( SltStatus@ )
     D ReturnValue     S             10I 0 Inz( 0 )
     D SumSize         S             15P 0 Based( FCB@       )

      *  -------------------------------------------------------------------
      *  - Data structure for GetAttr return data                          -
      *  -------------------------------------------------------------------

     D Receiver        DS
     D  RContents                   100

      *  -------------------------------------------------------------------
      *  - Object attribute type constants                                 -
      *  -------------------------------------------------------------------

     D BA_AllocSize64  C                   Const( 15 )

      *  -------------------------------------------------------------------
      *  - Data structure for GetAttr attribute array                      -
      *  -------------------------------------------------------------------

     D AttrArr         DS
     D  AANumAttr                    10I 0 Inz( 1              )
     D  AAAlcSize64                  10I 0 Inz( BA_AllocSize64 )

      *  -------------------------------------------------------------------
      *  - Data structure for GetAttr buffer variable                      -
      *  -------------------------------------------------------------------

     D Buffer          DS                  Based( Buffer@ )
     D  BNextOffset                  10I 0
     D  BAttr                        10I 0
     D  BAttrSize                    10I 0
     D  BReserved                     4
     D  BAttrData                     1
      * ^^^^^^^^^ 'Dummy' field.  Use the address to resolve to attribute

      *  -------------------------------------------------------------------
      *  - Data structure for the object name                              -
      *  -------------------------------------------------------------------

     D ThisPath        DS                  Based( ObjectName@ )
     D  TPCCSID                      10I 0
     D  TPCntryID                     2A
     D  TPLangID                      3A
     D  TPReserved1                   3
     D  TPPathType                   10I 0
     D  TPPathLen                    10I 0
     D  TPPathDelim                   2A
     D  TPReserved2                  10
     D  TPPath@                        *

      *  -------------------------------------------------------------------
      *  - Work variables                                                  -
      *  -------------------------------------------------------------------

     D NeedSize        S             10U 0
     D BytesRet        S             10U 0
     D AllocSize64     S             20U 0 Based( AllocSize64@ )

      *  -------------------------------------------------------------------
      *  - Initialize the return value pointer                             -
      *  -------------------------------------------------------------------

     C                   Eval      ReturnValue@ = %Addr( ReturnValue )

      *  -------------------------------------------------------------------
      *  - Skip this object if the selection status is not normal, or if   -
      *  - the path name is null.                                          -
      *  -------------------------------------------------------------------

     C                   If        SltStatus <> 0  or
     C                             TPPath@ = *Null
     C                   Return
     C                   EndIf

      *  -------------------------------------------------------------------
      *  - Populate receiver with object attributes                        -
      *  -------------------------------------------------------------------

     C                   If        GetAttr( ObjectName@         :
     C                                      %Addr( AttrArr   )  :
     C                                      %Addr( RContents )  :
     C                                      %Size( RContents )  :
     C                                      %Addr( NeedSize  )  :
     C                                      %Addr( BytesRet  )  :
     C                                      0                   ) = -1
     C                   CallP     ErrHandler
     C                   EndIf

      *  -------------------------------------------------------------------
      *  - Overlay receiver with the buffer data structure and extract the -
      *  - size of the object                                              -
      *  -------------------------------------------------------------------

     C                   Eval      Buffer@ = %Addr( Receiver )
     C                   Eval      AllocSize64@ = %Addr( BAttrData )

      *  -------------------------------------------------------------------
      *  - Update SumSize by adding this object's size to the total        -
      *  -------------------------------------------------------------------

     C                   Eval      SumSize = SumSize + AllocSize64

      *  -------------------------------------------------------------------
      *  - End of subprocedure                                             -
      *  -------------------------------------------------------------------

     C                   Eval      ReturnValue@ = %Addr( ReturnValue )
     C                   Return
     P                 E

      *  ===================================================================
      *  = Sub procedure - Error Handler                                   =
      *  ===================================================================

     P ErrHandler      B

      *  -------------------------------------------------------------------
      *  - Data structure for Receive Message                              -
      *  -------------------------------------------------------------------

     D RCVM0200        DS
     D  RM2Ununed1                   12
     D  RM2MsgID                      7A
     D  RM2Unused2                    2
     D  RM2MsgKey                     4A
     D  RM2QMsgF                     20A
     D  RM2Unused3                  107
     D  RM2MDLen                     10I 0
     D  RM2Unused4                   20
     D  RM2MsgDta                  3000A

      *  -------------------------------------------------------------------
      *  - Work variables                                                  -
      *  -------------------------------------------------------------------

     D MsgKey          S              4

      *  -------------------------------------------------------------------
      *  - Receive and promote the error message                           -
      *  -------------------------------------------------------------------

     C                   CallP     RcvPgmMsg( RCVM0200        :
     C                                        %Size(RCVM0200) :
     C                                        'RCVM0200'      :
     C                                        '*'             :
     C                                        1               :
     C                                        '*DIAG'         :
     C                                        *Blanks         :
     C                                        0               :
     C                                        '*REMOVE'       :
     C                                        *Null           )

     C                   CallP     SndPgmMsg( RM2MsgID         :
     C                                        RM2QMsgF         :
     C                                        RM2MsgDta        :
     C                                        %Len(RM2MsgDta)  :
     C                                        '*ESCAPE'        :
     C                                        '*'              :
     C                                        3                :
     C                                        MsgKey           :
     C                                        *Null            )

     C                   Return
     P                 E
