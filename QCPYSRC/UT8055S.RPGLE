      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  User Space prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *   User space definitions.
      *
     D USspcnam20      DS
     D  USspcnam                     10    overlay(USspcnam20:01)
     D  USspclib                     10    overlay(USspcnam20:11)
     D                                     inz('*LIBL')
      *
     D USdta           S          32767    inz
     D UStext          S             50    inz
     D USextatr        S             10    inz
     D USpubaut        S             10    inz('*LIBCRTAUT')
     D USreplace       S             10    inz('*YES')
     D USinlval        S              1    inz(*loval)
     D USerrcde        S              9b 0 inz(*zero)
     D USfrcdsk        S              1    inz(*off)
     D USstrpos        S              9b 0 inz(1)
     D USinlsiz        S              9b 0 inz(32767)
     D USdtalen        S              9b 0 inz(32767)
      * ---------------------------------------------------------
      *
      * Create user space.
      *
     D CrtUsrSpc       PR                  like(StdInd)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib                          like(StdNam) const
     D  UsrSpcSiz                          like(StdInt) const
     D  UsrSpcExtA                         like(StdNam) const
     D  UsrSpcText                         like(StdTxt) const
      * ---------------------------------------------------------
      *
      * Change user space.
      *
     D ChgUsrSpc       PR                  like(StdInd)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib                          like(StdNam) const
     D                                     options(*omit)
     D  UsrSpcStrPos                       like(StdInt) const
     D  UsrSpcDtaLen                       like(StdInt) const
     D  UsrSpcDta                          like(StdBuf) const
      * ---------------------------------------------------------
      *
      * Get user space pointer.
      *
     D GetUsrSpcP      PR                  like(StdPtr)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib                          like(StdNam) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *
      * Get number of user space entries.
      *
     D GetNbrUsrSpcEnt...
     D                 PR                  like(StdInt)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib                          like(StdNam) const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *
      * Get user space entry.
      *
     D GetUsrSpcEnt    PR                  like(StdBuf)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib                          like(StdNam) const
     D                                     options(*omit)
     D  EntNumber                          like(StdInt) const
      * ---------------------------------------------------------
      *
      * Delete user space.
      *
     D DltUsrSpc       PR                  like(StdInd)
     D  UsrSpcNam                          like(StdNam) const
     D  UsrSpcLib                          like(StdNam) const
     D                                     options(*nopass)
