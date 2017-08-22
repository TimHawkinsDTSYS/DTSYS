      /TITLE Utility, Sort (SrvPgm)
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
      /copy qcpysrc,UT8070S
      * *********************************************************
      * SortDS() -- Sort data structure.
      *
      * -- requires that the data be alpha or zoned.
      * *********************************************************
     P SortDS          B                   Export
      *
     D SortDS          PI
     D  SortDSdata                         like(StdPtr) value
     D  SortDSelem                         like(StdInt) value
     D  SortDSsize                         like(StdInt) value
      * ---------------------------------------------------------
      *
      *   Sort the structure.
      *
     C                   callp     qsort(SortDSdata:SortDSelem:
     C                                   SortDSsize:%paddr('SORTDSCOMP'))
      *
     c                   return
      *
     P SortDS          e
      * ---------------------------------------------------------
      *
      * Sort data structure compare.
      *
     P SortDScomp      b                   export
      *
     D SortDScomp      pi                  like(StdInt)
     D  SortDSfm                           like(StdPtr) value
     D  SortDSto                           like(StdPtr) value

     D FmDta           s                   based(SortDSfm)
     D                                     like(StdSQL)
     D ToDta           s                   based(SortDSto)
     D                                     like(StdSQL)

     C                   select
     C                   when      FmDta < ToDta
     C                   return    -1

     C                   when      FmDta > ToDta
     C                   return    1

     C                   when      FmDta = ToDta
     C                   return    *zero
     C                   endsl

     P SortDScomp      e
