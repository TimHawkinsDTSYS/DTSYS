      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Source text prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      * ExtSrcTxt() - Extract source text
      *
     D ExtSrcTxt       pr                  likeDS(t_ExtSrcTxt)
     D  in_tag                             like(StdStg) const
     D                                     options(*omit: *nopass)
     D  in_options                         like(StdStg) const
     D                                     options(*omit: *nopass)
      *
     D t_ExtSrcTxt     ds                  qualified inz
     D  maxidx                             like(StdInt)
     D  AYtxt                       100    varying  dim(1000)
