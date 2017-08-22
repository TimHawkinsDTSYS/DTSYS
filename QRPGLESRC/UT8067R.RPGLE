      /TITLE Utility, Stack (SrvPgm)
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
      * *********************************************************
      * InzStack() -- Initialize stack.
      * *********************************************************
     P InzStack        B                   Export
      *
     D InzStack        PI                  like(StdPtr)
     D  PushSize                           like(StdInt) value
      *
     D Data            ds                  based(pPushData)
     D  ElmSiz                             like(StdInt)
     D  MaxIdx                             like(StdInt)
     D  CurIdx                             like(StdInt)
     D  CurVal                             like(StdBuf)
      *
     D  InlElm         s                   like(StdInt) inz(10)
     D  InzLen         s                   like(StdInt) inz
      * ---------------------------------------------------------
      *
      *   Allocate memory for the structure.
      *
     C                   eval      InzLen = InlElm * PushSize
      *
     C                   eval      pPushData  =
     C                             %alloc(%size(ElmSiz) +
     C                                    %size(MaxIdx) +
     C                                    %size(CurIdx) + InzLen)
      * ---------------------------------------------------------
      *
      *   Initialize the structure.
      *
     C                   eval      ElmSiz = PushSize
     C                   eval      MaxIdx = InlElm
     C                   eval      CurIdx = *zero
     C                   eval      InzLen = InlElm * ElmSiz
     C                   eval      %subst(CurVal:1:InzLen) = *blanks
      *
     C                   return    pPushData
      *
     P InzStack        e
      * *********************************************************
      * ClrStack() -- Clear stack.
      * *********************************************************
     P ClrStack        B                   Export
      *
     D ClrStack        PI
     D  pPushData                          like(StdPtr) value
      *
     D Data            ds                  based(pPushData)
     D  ElmSiz                             like(StdInt)
     D  MaxIdx                             like(StdInt)
     D  CurIdx                             like(StdInt)
     D  CurVal                             like(StdBuf)
      *
     D  InzLen         s                   like(StdInt) inz
      * ---------------------------------------------------------
      *
      *   Bail if no structure.
      *
     C                   if        pPushData = *null
     C                   return
     C                   endif
      * ---------------------------------------------------------
      *
      *   Clear stack.
      *
     C                   if        MaxIdx > *zero
     C                   eval      CurIdx = *zero
     C                   eval      InzLen = MaxIdx * ElmSiz
     C                   eval      %subst(CurVal:1:InzLen) = *blanks
     C                   endif
      *
     C                   return
      *
     P ClrStack        e
      * *********************************************************
      * Push() -- Push data into stack.
      * *********************************************************
     P Push            B                   Export
      *
     D Push            PI                  like(StdPtr)
     D  pPushData                          like(StdPtr) value
     D  PushValue                          like(StdStr) value
      *
     D Data            ds                  based(pPushData)
     D  ElmSiz                             like(StdInt)
     D  MaxIdx                             like(StdInt)
     D  CurIdx                             like(StdInt)
     D  CurVal                             like(StdBuf)
      *
     D  AddElm         s                   like(StdInt) inz(10)
     D  PosVal         s                   like(StdInt) inz
     D  InzLen         s                   like(StdInt) inz
      * ---------------------------------------------------------
      *
      *   Bail if no structure.
      *
     C                   if        pPushData = *null
     C                   return    pPushData
     C                   endif
      * ---------------------------------------------------------
      *
      *   Exit if the item is already there.
      *
     C                   eval      PosVal = CurIdx * ElmSiz + 1 - ElmSiz
      *
     C                   if        CurIdx  >  *zero        and
     C                             CurIdx <=  MaxIdx       and
     C                             %subst(CurVal:PosVal:ElmSiz) = PushValue
     C                   return    pPushData
     C                   endif
      * ---------------------------------------------------------
      *
      *   Reallocate additional memory if needed.
      *
     C                   eval      CurIdx += 1
      *
     C                   if        CurIdx  > MaxIdx
     C                   eval      MaxIdx += AddElm
     C                   eval      PosVal  = CurIdx * ElmSiz + 1
     C                   eval      InzLen  = MaxIdx * ElmSiz
      *
     C                   eval      pPushData = %realloc(pPushData:
     C                                         %size(ElmSiz) +
     C                                         %size(MaxIdx) +
     C                                         %size(CurIdx) + InzLen)
      *
     C                   eval      InzLen = AddElm * ElmSiz
     C                   eval      %subst(CurVal:PosVal:InzLen) = *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Store new value.
      *
     C                   eval      PosVal = CurIdx * ElmSiz + 1 - ElmSiz
     C                   eval      %subst(CurVal:PosVal:ElmSiz) = PushValue
      *
     C                   return    pPushData
      *
     P Push            e
      * *********************************************************
      * Pull() -- Pull data from stack.
      * *********************************************************
     P Pull            B                   Export
      *
     D Pull            PI                  like(StdStr)
     D  pPullData                          like(StdPtr) value
      *
     D Data            ds                  based(pPullData)
     D  ElmSiz                             like(StdInt)
     D  MaxIdx                             like(StdInt)
     D  CurIdx                             like(StdInt)
     D  CurVal                             like(StdBuf)
      *
     D RtnVal          s                   like(StdStr) inz
     D PosVal          s                   like(StdInt) inz
      * ---------------------------------------------------------
      *
      *   Bail if no structure.
      *
     C                   if        pPullData = *null
     C                   return    *blanks
     C                   endif
      * ---------------------------------------------------------
      *
      *   Extract the last item.
      *
     C                   if        CurIdx  > *zero    and
     C                             CurIdx <= MaxIdx
      *
     C                   eval      PosVal = CurIdx * ElmSiz + 1 - ElmSiz
      *
     C                   eval      RtnVal =
     C                             %subst(CurVal:PosVal:ElmSiz)
      *
     C                   eval      CurIdx -= 1
     C                   eval      %subst(CurVal:PosVal:ElmSiz) = *blanks
      * ---------------------------------------------------------
      *
      *   Return nothing.
      *
     C                   else
     C                   eval      CurIdx = *zero
     C                   eval      RtnVal = *blanks
     C                   endif
      *
     C                   return    RtnVal
      *
     P Pull            e
