      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Sort prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *   SortDS() -- Sort data structure.
      *
     D SortDS          PR
     D  SortDSdata                         like(StdPtr) value
     D  SortDSelem                         like(StdInt) value
     D  SortDSsize                         like(StdInt) value
      *
     D SortDScomp      pr                  like(StdInt)
     D  SortDSfm                           like(StdPtr) value
     D  SortDSto                           like(StdPtr) value
      *
     D Qsort           pr                  extproc('qsort')
     D  qsortdata                          like(StdPtr) value
     D  qsortelem                          like(StdInt) value
     D  qsortsize                          like(StdInt) value
     D  qsortfunc                      *   procptr      value
