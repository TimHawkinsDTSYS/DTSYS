      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
      *  Phone number prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *           *
     D phnnbr          s             22
      * ---------------------------------------------------------
      *
      *  ChkPhn() -- Check phone number.
      *
     D ChkPhn          PR                  like(d_ChkPhn)
     D  PhoneNumber                        like(PhnNbr) value
      *
     D d_ChkPhn        ds
     D  ChkPhn_msgid                       like(msgid)
     D  ChkPhn_msgdta                      like(msgdta)
      * ---------------------------------------------------------
      *
      *  ChkFax() -- Check fax number.
      *
     D ChkFax          PR                  like(d_ChkPhn)
     D  PhoneNumber                        like(PhnNbr) value
      * ---------------------------------------------------------
      *
      *  EdtPhn() -- Edit phone number.
      *
     D EdtPhn          PR                  like(PhnNbr)
     D  PhoneNumber                        like(PhnNbr) value
      * ---------------------------------------------------------
      *
      *  MskPhn() -- Mask phone number.
      *
     D MskPhn          PR                  like(PhnNbr)
     D  PhoneNumber                        like(PhnNbr)
      * ---------------------------------------------------------
      *
      *  MskPhnX() -- Mask phone number.
      *
     D MskPhnX         PR                  like(PhnNbr)
     D  PhoneNumber                        like(PhnNbr) const
