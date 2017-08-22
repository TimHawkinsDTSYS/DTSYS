      * T: Display Spoolfile Audit
      *
      * P: PARMS
      *
      * S:
      *
      * C: 02/01/99  MidrangeComputing, page 50 -- Feburary 1999
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * M: MODIFICATIONS --
      *
      * M: YY/MM/DD  PROGRAMMER  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      * M:                        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *
     Fdsa000d   CF   E             WORKSTN Sfile(So001s1:Rrn1)
     Fdsa000p   IF   E           K DISK
     Fdsa000l1  IF   E           K DISK    Rename(Qasysfje:Qasyl1)
     F                                     Prefix(L1_)
      *
     DCounter          S              3  0 inz
     DK_Sfetyp         S                   inz Like(Sfetyp)
     DRrn1             S              5s 0 inz
     D found           S              1n   inz
     D x               S              5  0 inz

     D p_ignusr        DS
     D  ignusrcnt                     4b 0
     D  ignusr                       10    dim(50)
      *
      *
     C                   Exsr      Clrsfl
     C                   Exsr      Bldsfl
     C                   Exsr      Dspsfl

     C                   Eval      *Inlr = *On
      *******************************************************************
      * Clrsfl - Clear Subfile
      *******************************************************************
     C     Clrsfl        Begsr
      *
     C                   Eval      *In90 = *On
     C                   Eval      *In91 = *Off
     C                   Eval      *In92 = *Off
     C                   Z-add     1             RRN1
     C                   Write     So001c1
     C                   Eval      *In90 = *Off
     C                   Eval      *In91 = *On
     C                   Z-add     0             RRN1
      *
     C                   Endsr
      *******************************************************************
      * Bldsfl - Build Subfile
      *******************************************************************
     C     Bldsfl        Begsr

     C                   Read      qasysfje                               99
     C                   Dow       not *In99 and Counter <= 12

     C                   If        Sfetyp <> 'C'
     C                   Eval      K_Sfetyp = 'C'
     C     File_Key2     Chain     Qasyl1                             99
     C                   If        *In99 = *Off
     C                   Eval      Sfuser = L1_Sfuser
     C                   Eval      Sfjob  = L1_Sfjob
     C                   Endif
     C                   Endif

     C                   eval      found     = *off
     C                   do        ignusrcnt     x
     C                   if        ignusr(x) = SFuser
     C                   eval      found     = *on
     C                   leave
     C                   endif
     C                   enddo

     C                   if        not found
     C                   Eval      Select = *Blanks
     C                   Eval      Spool  = Sfsnam
     C                   Eval      Ouser  = Sfuser
     C                   Eval      Ojob   = Sfjob
     C                   Eval      Cuser  = Sfuspf
     C                   Eval      Outq   = Sfonam
     C                   Eval      Xfseq# = Sfseqn
     C                   Eval      Xfdate = Sfdate
     C                   Eval      Xftime = Sftime
     C                   Eval      Xpgm   = Sfpgm
     C                   Eval      Xnumb  = Sfnbr
     C                   Eval      Xspl#  = Sfsnum
     C                   Eval      Xfnam  = Sffnam
     C                   Select
     C                   When      Sfetyp = 'A'
     C                   Eval      Stats = 'Read By Non-Owner'
     C                   When      Sfetyp = 'C'
     C                   Eval      Stats = 'Created          '
     C                   When      Sfetyp = 'H'
     C                   Eval      Stats = 'Held             '
     C                   When      Sfetyp = 'D'
     C                   Eval      Stats = 'Deleted          '
     C                   When      Sfetyp = 'R'
     C                   Eval      Stats = 'Released         '
     C                   When      Sfetyp = 'U'
     C                   Eval      Stats = 'Changed          '
     C                   Endsl
     C                   Eval      Rrn1 = (Rrn1 + 1)
     C                   Eval      Counter = (Counter + 1)
     C                   Write     So001s1
     C                   endif
      *
     C                   Read      qasysfje                               99
     C                   Enddo
      *
      *
      * Set Subfile Record Number
     C                   If        Counter > 0
     C                   If        Recno = 0
     C                   Eval      Recno = 1
     C                   Else
     C                   Eval      Recno = Recno + 13
     C                   Endif
     C                   Endif
      *
     C                   Z-add     0             Counter
      *
     C                   Endsr
      *******************************************************************
      * Dspsfl - Display Subfile
      *******************************************************************
     C     Dspsfl        Begsr
      *
     C                   Dow       *In03 = *Off
      *
     C                   If        Rrn1 > 0
     C                   Eval      *In92 = *On
     C                   Endif
      *
     C                   Write     So001f1
     C                   Exfmt     So001c1
      * Exit Program
     C                   If        *In03 = *On
     C                   Eval      *Inlr = *On
     C                   Return
     C                   Endif
     C                   If        *In40 = *On
     C                   Eval      *In40 = *Off
     C                   Exsr      Bldsfl
     C                   Else
     C                   If        *In92 = *On
     C                   Exsr      Rdsfl
     C                   Endif
     C                   Endif

     C                   Enddo

     C                   Endsr
      *******************************************************************
      * Rdsfl  - Read Subfile
      *******************************************************************
     C     Rdsfl         Begsr
      *
     C                   Readc     So001s1                                50
     C                   Dow       *In50 = *Off
      *
     C                   Select
     C                   When      Select = '5'
     C                   Eval      K_Seq#  = Xfseq#
     C                   Eval      K_Date  = Xfdate
     C                   Eval      K_Time  = Xftime
     C                   Eval      K_Pgm   = Xpgm
     C                   Eval      K_Num   = Xnumb
     C                   Eval      K_Spool = Xfnam
     C                   Eval      K_Spl#  = Xspl#
     C                   Eval      Select = ' '
     C                   Update    So001s1
     C                   Eval      Recno = Rrn1
     C                   Exsr      Detail_Screen
     C                   Endsl

     C                   Readc     So001s1                                50
     C                   Enddo

     C                   Endsr
      *******************************************************************
      * Detail_Screen - Show Detail Screen
      *******************************************************************
     C     Detail_Screen Begsr
      *
     C     File_Key      Chain     qasysfje                           99

     C                   If        Sfetyp <> 'C'
     C                   Eval      K_Sfetyp = 'C'
     C     File_Key2     Chain     Qasyl1                             95
     C                   If        *In95 = *Off
     C                   Eval      Sfuser = L1_Sfuser
     C                   Eval      Sfjob  = L1_Sfjob
     C                   Else
     C                   Eval      Sfuser = '*Unknown'
     C                   Eval      Sfjob  = '*Unknown'
     C                   Endif
     C                   Endif

     C                   Select
     C                   When      Sfetyp = 'A'
     C                   Eval      Status = 'Read By Non-Owner'
     C                   When      Sfetyp = 'C'
     C                   Eval      Stats = 'Created          '
     C                   When      Sfetyp = 'H'
     C                   Eval      Status = 'Held             '
     C                   When      Sfetyp = 'D'
     C                   Eval      Status = 'Deleted          '
     C                   When      Sfetyp = 'R'
     C                   Eval      Status = 'Released         '
     C                   When      Sfetyp = 'U'
     C                   Eval      Status = 'Changed          '
     C                   Endsl
      *
     C                   Exfmt     So00101
     C                   Endsr
      *******************************************************************
      * Initialize
      *******************************************************************
     C     *INZSR        Begsr

     C     *entry        plist
     C                   parm                    p_ignusr

     C     File_Key      Klist
     C                   Kfld                    K_Seq#
     C                   Kfld                    K_Date
     C                   Kfld                    K_Time
     C                   Kfld                    K_Num
     C                   Kfld                    K_Pgm
     C                   Kfld                    K_Spl#
     C                   Kfld                    K_Spool

     C     File_Key2     Klist
     C                   Kfld                    Sffnam
     C                   Kfld                    Sfdnam
     C                   Kfld                    Sfsnam
     C                   Kfld                    Sfsnum
     C                   Kfld                    K_Sfetyp

     C     *Like         Define    Xfseq#        K_Seq#
     C     *Like         Define    Xfdate        K_Date
     C     *Like         Define    Xftime        K_Time
     C     *Like         Define    Ouser         K_User
     C     *Like         Define    Xpgm          K_Pgm
     C     *Like         Define    Xnumb         K_Num
     C     *Like         Define    Xspl#         K_Spl#
     C     *Like         Define    Spool         K_Spool

     C                   Endsr
