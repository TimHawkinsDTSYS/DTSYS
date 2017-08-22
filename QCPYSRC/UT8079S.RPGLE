      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Journaling prototypes
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Send journal entry
      *
     D SndJrnEnt       pr
     D  JrnNam                             like(StdNam) const
     D  JrnNamLib                          like(StdNam) const
     D  JrnEntInf                  4096a   options(*varsize) const
     D  JrnEntDta                 32766a   options(*varsize) const
      *
      *  Send journal entry API
      *
     D SndJrnE         pr                  ExtPgm('QJOSJRNE')
     D  SjJrnNamQ                          like(StdNamLib) const
     D  SjJrnEntInf                4096a   const  options(*varsize)
     D  SjEntDta                  32766a   const  options(*varsize)
     D  SjEntDtaLen                        like(StdInt) const
     D  SjError                   32767a   options(*varsize)
      *
     D SjJrnEntInf     ds                  qualified
     D  SjInfEntRcds                       like(StdInt) inz(1)
     D  SjInfKey                           like(StdInt) inz(1)
     D  SjInfLen                           inz(%size(SjJrnEntInf.SjInfDta))
     D                                     like(StdInt)
     D  SjInfDta                      2a
