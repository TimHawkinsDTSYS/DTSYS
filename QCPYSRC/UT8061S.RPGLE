      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Memory prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      * Get memory (requires QC2LE).
      *
     D GetMemory       PR                  ExtProc('malloc')
     D                                     like(StdPtr)
     D  MemSize                            like(StdInt) value
      * ---------------------------------------------------------
      * Change memory (requires QC2LE).
      *
     D ChgMemory       PR                  ExtProc('realloc')
     D                                     like(StdPtr)
     D  OldPtr                             like(StdPtr)
     D  MemSize                            like(StdInt) value
      * ---------------------------------------------------------
      * Free memory (requires QC2LE).
      *
     D FreeMemory      PR                  ExtProc('free')
     D  OldPtr                             like(StdPtr) value
      * ---------------------------------------------------------
      *  TSmalloc() - Teraspace memory allocation
      *
     D TS_malloc       PR                  ExtProc('_C_TS_malloc')
     D                                     like(StdPtr)
     D  MemSize                            like(StdUns) value
      * ---------------------------------------------------------
      *  TSrealloc() - Teraspace memory reallocation
      *
     D TS_realloc      PR                  ExtProc('_C_TS_realloc')
     D                                     like(StdPtr)
     D   ptr                               like(StdPtr) value
     D   MemSize                           like(StdUns) value
      * ---------------------------------------------------------
      *  TSfree() - Teraspace memory free
      *
     D TS_free         PR                  ExtProc('_C_TS_free')
     D   ptr                               like(StdPtr) value
