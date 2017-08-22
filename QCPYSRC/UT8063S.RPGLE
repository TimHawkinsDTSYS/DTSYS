      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  String case prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *  Convert case API (QlgConvertCase)
      *
     D CvtCaseAPI      Pr                  ExtProc('QlgConvertCase')
     D                               22    Const
     D                            32767    Options(*varsize)
     D                            32767    Options(*varsize)
     D                               10I 0 Const
     D                              272
      * ---------------------------------------------------------
      *  Convert case
      *
     D CvtCase         Pr         32765    varying
     D                            32765    const
     D                                     varying
     D                               10    const
     D                              272    options(*nopass)
     D                               10I 0 const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *  Convert to uppercase
      *
     D CvtToUpper      Pr         32765    varying
     D                            32765    const
     D                                     varying
     D                              272    options(*nopass)
     D                               10I 0 const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *  Convert to lowercase
      *
     D CvtToLower      Pr         32765    varying
     D                            32765    const
     D                                     varying
     D                              272    options(*nopass)
     D                               10I 0 const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *  Convert to upper case.
      *
     D Upper           PR                  like(StdSQL) opdesc
     D  CharValue                          like(StdSQL) const
      * ---------------------------------------------------------
      *  Convert to lower case.
      *
     D Lower           PR                  like(StdSQL) opdesc
     D  CharValue                          like(StdSQL) const
      * ---------------------------------------------------------
      *  Convert to title case.
      *
     D SetTtlCse       PR                  like(StdSQL) opdesc
     D  CharValue                          like(StdSQL) const
     D  options                            like(StdStr) const
     D                                     options(*nopass)
