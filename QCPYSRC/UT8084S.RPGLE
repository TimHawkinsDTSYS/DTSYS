      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Currency prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *  RtvCurRte() -- Retrieve currency rate
      *
     D RtvCurRte       pr                  like(StdCurRte)
     D  i_FromCurCde                       like(StdCurCde) const
     D  i_ToCurCde                         like(StdCurCde) const
     D  i_Timestamp                        like(StdTms)    const
     D                                     options(*nopass)
