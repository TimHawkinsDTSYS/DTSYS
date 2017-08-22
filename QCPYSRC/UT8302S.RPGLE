      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Pax Array prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *  Set passenger arrary.
      *
     D SetPaxAry       PR                  like(DFNblpary)
     D   WKpary                            like(DFNblpary) value
     D   WKpcnt                            like(DFNblpcnt) value
      * ---------------------------------------------------------
      *
      *  Edit passenger arrary.
      *
     D EdtPaxAry       PR                  like(msgid)
     D   WKpary                            like(DFNblpary) value
     D   WKpcnt                            like(DFNblpcnt) value
      * ---------------------------------------------------------
      *
      *  Count passenger arrary.
      *
     D CntPaxAry       PR                  like(DFNblpcnt)
     D   WKpary                            like(DFNblpary) value
     D   WKpcnt                            like(DFNblpcnt) value
      * ---------------------------------------------------------
      *
      *  Cleanup passenger arrary.
      *
     D ClnPaxAry       PR                  like(DFNblpary)
     D   WKpary                            like(DFNblpary) value
     D   WKpcnt                            like(DFNblpcnt) value
      * ---------------------------------------------------------
      *
      *  Check passenger array for entry.
      *
     D ChkPary         PR                  like(StdInd)
     D  RtvPseq                            like(DFNPNpseq) value
     D  RtvPary                            like(DFNBLpary) value
