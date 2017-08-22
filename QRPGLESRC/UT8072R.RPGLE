      /TITLE Utility, Security (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides security routines via function calls
      *              for handling security related functions.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  06/13/05  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8072S
      *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Structures
      *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *-- Entry Id:  -------------------------------------------------------
     D EntId           Ds
     D  EiDtalen                           like(StdInt)
     D  EiCcsId                            like(StdInt) Inz(65535)
     D  EiDta                              like(StdNam)
      *
      *-- Encryption data:  ------------------------------------------------
     D EncDta          Ds
     D  EcDtalen                           like(StdInt)
     D  EcCcsId                            like(StdInt) Inz(65535)
     D  EcDta                              like(StdNam)
      *
      *-- Entry data:  -----------------------------------------------------
     D EntDta          Ds
     D  EdDtalen                           like(StdInt)
     D  EdCcsID                            like(StdInt) Inz( 65535 )
     D  EdDta                              like(StdTxt)
      *
      *-- Attribute data:  -------------------------------------------------
     D AtrInf          Ds
     D  AiNbrAtr                           like(StdInt) Inz( 1 )
     D   AiAlign                     12a
      * Qsy_Attr_Descr_T
 1  4D   AdAtrLoc                          like(StdInt) Inz( 0 )
 5  8D   AdAtrTyp                          like(StdInt) Inz( 0 )
 9 16D   AdRes_1                      8a   Inz( *Allx'00' )
17 32D   AdAtrId_p                     *
33 64D   AdOthDsc                    32a   Inz( *Allx'00' )
      *  Attr_Data_Info
      *   Qsy_In_VLDL_T
     D    VldLstAtr                  96a
65 68D     AvAtrCcsid                      Overlay( VldLstAtr: 1 )
65 68D                                     like(StdInt) Inz( -1 )
69 72D     AvAtrlen                        Overlay( VldLstAtr: 5 )
69 72D                                     like(StdInt) Inz( 1 )
73 80D     AvRes_1                    8a   Overlay( VldLstAtr: 9 )
73 80D                                     Inz( *Allx'00' )
81 96D     AvAtrVal_p                  *   Overlay( VldLstAtr: 17 )
81 96D                                     Inz( %Addr( AvAtrVal ))
97192D    VaInOther                  96a   Overlay( VldLstAtr: 1 )
     D                               64a   Overlay( VaInOther: 33 )
     D                                     Inz( *Allx'00' )
93224D   AdOtherData                 32a   Inz( *Allx'00' )
      *
     D AvAtrVal        s                   like(StdChr) inz( '1' )
      *
      *-- return data:  ----------------------------------------------------
     D RtnDta          Ds
      * Qsy_Entry_ID_Info_T
     D  RiDtalen                           like(StdInt)
     D  RiCcsId                            like(StdInt)
     D  RiDta                       100a
      * Qsy_Entry_Encr_Data_Info_T
     D  RcDtalen                           like(StdInt)
     D  RcCcsId                            like(StdInt)
     D  RcDta                       600a
      * Qsy_Entry_Data_Info_T
     D  RdDtalen                           like(StdInt)
     D  RdCcsID                            like(StdInt)
     D  RdDta                      1000a
     D                                4a
     D  RaAtrPtr                       *
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Verify user password
      *
      *   Verifies the username and password
      *    against the specified validation list.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
     P VfyUsrPwd       B                   Export
      *
     D VfyUsrPwd       Pi                  like(StdInt)
     D  PxVldL                             like(StdNam) const
     D  PxVldLlib                          like(StdNam) const
     D  PxUsrId                            like(StdNam) const
     D  PxUsrPwd                           like(StdNam) const
      * ---------------------------------------------------------
      *
      *   Verify validation list entry
      *
     D VfyVldLst       pr                  ExtProc('QsyVerifyValidation+
     D                                              LstEntry')
     D                                     like(StdInt)
     D  VvLstNam                           like(StdNamLib) const
     D  VvEntId                        *   value
     D  VvEncDta                       *   value
      * ---------------------------------------------------------
      *
      *   Mainline
      *
     C                   eval      EiDta      =  PxUsrId
     C                   eval      EiDtalen   =  %len( %trimr( EiDta ))
      *
     C                   eval      EcDta      =  PxUsrPwd
     C                   eval      EcDtalen   =  %len( %trimr( EcDta ))
      *
     C                   return    VfyVldLst( PxVldL + PxVldLlib
     C                                      : %Addr( EntId )
     C                                      : %Addr( EncDta ))
      *
     P VfyUsrPwd       E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Add user password
      *
      *  Adds a username, a password and a description to the
      *  specified validation list.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P AddUsrPwd       B                   Export
      *
     D AddUsrPwd       Pi                  like(StdInt)
     D  PxVldL                             like(StdNam) const
     D  PxVldLlib                          like(StdNam) const
     D  PxUsrId                            like(StdNam) const
     D  PxUsrPwd                           like(StdNam) const
     D  PxUsrDsc                           like(StdTxt) const
      * ---------------------------------------------------------
      *
      *   Add validation list entry
      *
     D AddVldLst       Pr                  ExtProc('QsyAddValidation+
     D                                             LstEntry')
     D                                     like(StdInt)
     D  AvLstNam                           like(StdNamLib) const
     D  AvEntId                        *   value
     D  AvEncDta                       *   value
     D  AvEntDta                       *   value
     D  AvAtrDta                       *   value
      * ---------------------------------------------------------
      *
      *   Mainline
      *
     C                   eval      EiDta      =  PxUsrId
     C                   eval      EiDtalen   =  %len( %trimr( EiDta ))
      *
     C                   eval      EcDta      =  PxUsrPwd
     C                   eval      EcDtalen   =  %len( %trimr( EcDta ))
      *
     C                   eval      EdDta      =  PxUsrDsc
     C                   eval      EdDtalen   =  %len( %trimr( EdDta ))
      *
     C                   eval      AdAtrId_p  = %alloc(15)
      *
     C                   eval      %Str(AdAtrId_p:15) = 'QsyEncryptData'
      *
     C                   return    AddVldLst( PxVldL + PxVldLlib
     C                                      : %Addr( EntId  )
     C                                      : %Addr( EncDta )
     C                                      : %Addr( EntDta )
     C                                      : %Addr( AtrInf ))
      *
     P AddUsrPwd       E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Get user password
      *
      *  returns the password of the specified user name if found             e
      *  in the specified validation list.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P GetUsrPwd       B                   Export
      *
     D GetUsrPwd       Pi                  like(StdNam)
     D  PxVldL                             like(StdNam) const
     D  PxVldLlib                          like(StdNam) const
     D  PxUsrId                            like(StdNam) const
      * ---------------------------------------------------------
      *
      *   Find validation list entry
      *
     D FndVldLst       Pr                  ExtProc('QsyFindValidation+
     D                                             LstEntry')
     D                                     like(StdInt)
     D  FvLstNam                           like(StdNamLib) const
     D  FvEntId                        *   value
     D  FvRtnDta                       *   value
      * ---------------------------------------------------------
      *
      *   Mainline
      *
     C                   eval      EiDta      =  PxUsrId
     C                   eval      EiDtalen   =  %len( %trimr( EiDta ))
      *
     C                   If        FndVldLst( PxVldL + PxVldLlib
     C                                      : %Addr( EntId )
     C                                      : %Addr( RtnDta )
     C                                      ) =  -1
     C                   return    *Blanks
      *
     C                   Else
     C                   return    %SubSt( RcDta: 1: RcDtalen )
     C                   EndIf
      *
     P GetUsrPwd       E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   Change user password
      *
      *   Changes the password of the specified username in the
      *   specified validation list.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P ChgUsrPwd       B                   Export
      *
     D ChgUsrPwd       Pi                  like(StdInt)
     D  PxVldL                             like(StdNam) const
     D  PxVldLlib                          like(StdNam) const
     D  PxUsrId                            like(StdNam) const
     D  PxUsrPwd                           like(StdNam) const
      * ---------------------------------------------------------
      *
      *   Change validation list entry
      *
     D ChgVldLst       Pr                  ExtProc('QsyChangeValidation+
     D                                              LstEntry')
     D                                     like(StdInt)
     D  CvLstNam                           like(StdNamLib) const
     D  CvEntId                        *   value
     D  CvEncDta                       *   value
     D  CvEntDta                       *   value
     D  CvAtrDta                       *   value
      * ---------------------------------------------------------
      *
      *   Mainline
      *
     C                   eval      EiDta      =  PxUsrId
     C                   eval      EiDtalen   =  %len( %trimr( EiDta ))
      *
     C                   eval      EcDta      =  PxUsrPwd
     C                   eval      EcDtalen   =  %len( %trimr( EcDta ))
      *
     C                   return    ChgVldLst( PxVldL + PxVldLlib
     C                                      : %Addr( EntId )
     C                                      : %Addr( EncDta )
     C                                      : *Null
     C                                      : *Null)
      *
     P ChgUsrPwd       E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   Remove user password
      *
      *   Removes the validation list entry of the specified
      *   username in the specified validation list.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P RmvUsrPwd       B                   Export
      *
     D RmvUsrPwd       Pi                  like(StdInt)
     D  PxVldL                             like(StdNam) const
     D  PxVldLlib                          like(StdNam) const
     D  PxUsrId                            like(StdNam) const
      * ---------------------------------------------------------
      *
      *   Remove validation list entry
      *
     D RmvVldLst       Pr                  ExtProc('QsyRemoveValidation+
     D                                              LstEntry')
     D                                     like(StdInt)
     D  RvLstNam                           like(StdNamLib) const
     D  RvEntId                        *   value
      * ---------------------------------------------------------
      *
      *   Mainline
      *
     C                   eval      EiDta      =  PxUsrId
     C                   eval      EiDtalen   =  %len( %trimr( EiDta ))
      *
     C                   return    RmvVldLst( PxVldL + PxVldLlib
     C                                      : %Addr( EntId ))
      *
     P RmvUsrPwd       E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *   Generate random number.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P GenRanNbr       b                   export

     D GenRanNbr       PI                  like(StdMaxDecWhl)
     D   lowno                             like(StdMaxDecWhl) const
     D   highno                            like(StdMaxDecWhl) const

     D range           s                   like(StdMaxDecWhl) inz
     D result          s                   like(StdMaxDecWhl) inz

      /free

          if     highno = *hival;
            range  = (highno - lowno);
          else ;
            range  = (highno - lowno) + 1;
          endif;

          result = %int(Get_PRN() * range) + lowno;
          return result;

      /end-free

     P GenRanNbr       E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Get a pseudo-random number between zero and one.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P Get_PRN         B                   export

     D Get_PRN         PI                  like(StdDblFlt)

     D Qc3GenPRNs      PR                  ExtProc('Qc3GenPRNs')
     D   result                            like(StdPtr) value
     D   result_len                        like(StdInt) const
     D   type                              like(StdChr) const
     D   parity                            like(StdChr) const
     D   ErrorCode                         like(StdBuf) options(*varsize)

     D ErrorCode       ds
     D   BytesProv                         like(StdInt) inz
     D   BytesAvail                        like(StdInt)

     D REAL_PRN        C                   *off
     D PARITY_NONE     C                   *off

     D randint         s                   like(StdUns)
     D highval         s                   like(StdUns) inz(*hival)

      /free

            Qc3GenPRNs( %addr(randint)
                      : %size(randint)
                      : REAL_PRN
                      : PARITY_NONE
                      : ErrorCode );

            return randint / highval;
      /end-free

     P Get_PRN         E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  GetJobAut() -- Get job authority
      *
      *   Changes from the current user profile to the
      *    named user profile.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
     P GetJobAut       B                   Export
      *
     D GetJobAut       Pi                  like(StdInt)
     D NewUsrID                            like(StdNam) const
      * ---------------------------------------------------------
      *
      *    Get profile handle for current user.
      *
     C                   callp     GetPrfHdl('*CURRENT':'*NOPWDCHK':
     C                                       CurPrfHdl:dsEC)
      * ---------------------------------------------------------
      *
      *    Get profile handle for new user.
      *
     C                   if        dsEC.msgid = *blanks
     C                   callp     GetPrfHdl(NewUsrID:'*NOPWDCHK':
     C                                       NewUsrHdl:dsEC)
     C                   endif
      * ---------------------------------------------------------
      *
      *    Set profile for new user.
      *
     C                   if        dsEC.msgid = *blanks
     C                   callp     SetNewPrf(NewUsrHdl:dsEC)
     C                   endif
      * ---------------------------------------------------------
      *
      *    Handle errors.
      *
     C                   if        dsEC.msgid <> *blanks
     C                   eval      msgid  = dsEC.msgid
     C                   eval      msgdta = dsEC.msgdta
     C                   eval      torel  = '*PRV'
     C                   eval      msgf   = 'QCPFMSG'
     C                   exsr      $PMsnd
     C                   return    1
     C                   else
     C                   return    *zero
     C                   endif
      *
      /undefine $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P GetJobAut       E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  RstJobAut() -- Restore job authority.
      *
      *   Changes from the named user profile back to the
      *    current user profile.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
     P RstJobAut       B                   Export
      *
     D RstJobAut       Pi                  like(StdInt)
      * ---------------------------------------------------------
      *
      *    Restore profile for current user.
      *
     C                   callp     SetNewPrf(CurPrfHdl:dsEC)
      * ---------------------------------------------------------
      *
      *    Handle errors.
      *
     C                   if        dsEC.msgid <> *blanks
     C                   eval      msgid  = dsEC.msgid
     C                   eval      msgdta = dsEC.msgdta
     C                   eval      torel  = '*PRV'
     C                   eval      msgf   = 'QCPFMSG'
     C                   exsr      $PMsnd
     C                   return    1
     C                   else
     C                   return    *zero
     C                   endif
      *
      /undefine $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P RstJobAut       E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * EncryptRC4():  Encrypt RC4
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P EncryptRC4      B                   Export

     D EncryptRC4      PI                  like(StdStr)
     D  SrcData                            like(StdStr)
     D  SecretKey                    16    varying

     D RtnData         s                   like(StdStr)

     D RC4_Controls    ds                  qualified
     D   funct_id                     2A
     D   datalen                           like(StdIntSml)
     D   operation                         like(StdChr)
     D   reserved                    11A
     D   p_key_ctx                         like(StdPtr)

     D key_ctx         ds                  qualified
     D   stream                            like(StdStr)
     D   len                               like(StdUnsSml)
     D   reserved                     6A

     D cipher          PR                  extproc('_CIPHER')
     D  receiver                           like(StdPtr)
     D  control                      32A
     D  source                             like(StdPtr)

     D p_recv          s                   like(StdPtr)
     D p_src           s                   like(StdPtr)

      /free

          //  The following will encrypt "data" using the RC4
          //  algorithm with the secret key "key", and place
          //  the result into "encrypted"

          key_ctx = *ALLx'00';
          %subst(key_ctx.stream:1:%len(SecretKey)) = SecretKey;
          key_ctx.len = %len(SecretKey);

          RC4_Controls           = *ALLx'00';
          RC4_Controls.funct_id  = x'0013';
          RC4_Controls.datalen   = %size(SrcData);
          RC4_Controls.operation = x'00';     // 0=Encrypt,1=Decrypt
          RC4_Controls.p_key_ctx = %addr(key_ctx);

          p_recv = %addr(RtnData);
          p_src  = %addr(SrcData);

          cipher( p_recv: RC4_Controls: p_src);

          return RtnData;

      /end-free

     P EncryptRC4      E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * DecryptRC4():  Decrypt RC4
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P DecryptRC4      B                   Export

     D DecryptRC4      PI                  like(StdStr)
     D  SrcData                            like(StdStr)
     D  SecretKey                    16    varying

     D RtnData         s                   like(StdStr)

     D RC4_Controls    ds                  qualified
     D   funct_id                     2A
     D   datalen                           like(StdIntSml)
     D   operation                         like(StdChr)
     D   reserved                    11A
     D   p_key_ctx                         like(StdPtr)

     D key_ctx         ds                  qualified
     D   stream                            like(StdStr)
     D   len                               like(StdUnsSml)
     D   reserved                     6A

     D cipher          PR                  extproc('_CIPHER')
     D  receiver                           like(StdPtr)
     D  control                      32A
     D  source                             like(StdPtr)

     D p_recv          s                   like(StdPtr)
     D p_src           s                   like(StdPtr)

      /free

          //  The following will decrypt "encrypted" using the RC4
          //  algorithm with the secret key "key", and place the
          //  result in "data".  We blank out data ahead of time
          //  to ensure that it's contents aren't carried over from
          //  the code above.

          RtnData = *blanks;

          key_ctx = *ALLx'00';
          %subst(key_ctx.stream:1:%len(SecretKey)) = SecretKey;
          key_ctx.len = %len(SecretKey);

          RC4_Controls           = *ALLx'00';
          RC4_Controls.funct_id  = x'0013';
          RC4_Controls.datalen   = %size(SrcData);
          RC4_Controls.operation = x'01';     // 0=Encrypt,1=Decrypt
          RC4_Controls.p_key_ctx = %addr(key_ctx);

          p_recv = %addr(RtnData);
          p_src  = %addr(SrcData);

          cipher( p_recv: RC4_Controls: p_src);

          return RtnData;

      /end-free

     P DecryptRC4      E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * LstEncAlg():  List Encryption Algorithms
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P LstEncAlg       B                   Export

     D LstEncAlg       PI

     D Crypto_Attr_T   ds                  qualified
     D                                     based(Template_Only)
     D   algorithm                    2A
     D   key_length                        like(StdIntSml)
     D   bitflags                     2A

     D MMTR_01C8_T     ds                  qualified
     D                                     based(Template_Only)
     D   numEntries                        like(StdIntSml)
     D   entries                           likeds(Crypto_Attr_T)
     D                                     dim(100)

     D MMTR_Template_T...
     D                 ds                  qualified
     D                                     based(Template_Only)
     D  Template_Size                      like(StdInt)
     D  Bytes_Used                         like(StdInt)
     D  Crypto_Attrs                       likeds(MMTR_01C8_T)

     D MMTR_CRYTPOGRAPHY...
     D                 C                   456

     D matmatr         pr                  extproc('matmatr')
     D   receiver                          likeds(MMTR_Template_T)
     D   attr                              like(StdIntSml) value

     D r               ds                  likeds(MMTR_TEMPLATE_T)
     D x               s                   like(StdInt)
     D msg             s             52A

      /free

        r.Template_Size = %size(r);
        matmatr(r: MMTR_CRYTPOGRAPHY);

        for x = 1 to r.Crypto_Attrs.numEntries;
           msg = %char(r.Crypto_Attrs.entries(x).key_length) + '-bit '
               + GetEncAlg(r.Crypto_Attrs.entries(x).algorithm);
           dsply msg;
        endfor;

      /end-free
     P LstEncAlg       E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * GetEncAlg():  Get Encryption Algorithm
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P GetEncAlg       B                   Export

     D GetEncAlg       PI            45A   varying
     D   Algorithm                    2A   const

      /free

          select;
          when       Algorithm = x'0001';
             return 'MAC - Message Authentication Code';

          when       Algorithm = x'0002';
             return 'MD5';

          when       Algorithm = x'0003';
             return 'SHA-1 - Secure Hash Algorithm';

          when       Algorithm = x'0004';
             return 'DES (one-way) - Data Encryption Standard';

          when       Algorithm = x'0005';
             return 'DES (two-way) - Data Encryption Standard';

          when       Algorithm = x'0006';
             return 'RC4';

          when       Algorithm = x'0007';
             return 'RC5';

          when       Algorithm = x'0008';
             return 'DESX';

          when       Algorithm = x'0009';
             return '3DES - Triple DES';

          when       Algorithm = x'000A';
             return 'DSA - Digital Signature Algorithm';

          when       Algorithm = x'000B';
             return 'RSA - Rivest/Shamir/Adleman';

          when       Algorithm = x'000C';
             return 'Diffie-Hellman';

          when       Algorithm = x'000D';
             return 'CDMF - Commercial Data Masking Facility';

          when       Algorithm = x'000E';
             return 'RC2';

          when       Algorithm = x'000F';
             return 'AES - Advanced Encryption Standard';

          other;
             return 'Unknown';
          endsl;

      /end-free

     P GetEncAlg       E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Change user password
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P ChgPwd          B                   Export
      *
     D ChgPwd          Pi                  like(MsgID)
     D  PxUsrId                            like(StdNam) const
     D  PxCurPwd                           like(StdNam) const
     D  PxNewPwd                           like(StdNam) const
      * ---------------------------------------------------------
      *
     D  UserID         s                   like(stdnam)
     D  CurPwd         s                   like(stdnam)
     D  NewPwd         s                   like(stdnam)
      * ---------------------------------------------------------
      *
      *   Mainline
      *
     C                   eval      UserID = PxUsrID
     C                   eval      CurPwd = PxCurPwd
     C                   eval      NewPwd = PxNewPwd
      *
     C                   call      'QSYCHGPW'
     C                   parm                    UserID
     C                   parm                    CurPwd
     C                   parm                    NewPwd
     C                   parm                    dsEC
      *
     C**                 callp     qsychgpw(UserID:CurPwd:NewPwd:
     C**                                    dsEC)
      * ---------------------------------------------------------
      *
      *    Handle errors.
      *
     C                   if        dsEC.msgid <> *blanks
     C                   eval      msgid  = dsEC.msgid
     C                   eval      msgdta = dsEC.msgdta
     C                   eval      torel  = '*PRV'
     C                   eval      msgf   = 'QCPFMSG'
     C                   exsr      $PMsnd
     C                   endif
      *
     C                   return    dsEC.msgid
      *
      /undefine $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P ChgPwd          E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  CalcHash() -- Calculate hash.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P CalcHash        B                   Export
      *
     D CalcHash        Pi            64
     D  i_InpDta                           like(StdPtr) value
     D  i_InpDtaLen                        like(StdInt) const
     D  i_Hash                             like(StdNam) const
     D                                     options(*omit:*nopass)
      *
     D Qc3CalculateHash...
     D                 PR                  ExtProc('Qc3CalculateHash')
     D   InputData                         like(StdPtr) value
     D   InputDataLen                      like(StdInt) const
     D   InputDataFmt                      like(StdFmt) const
     D   AlgDesc                     16a   const
     D   AlgFmt                            like(StdFmt) const
     D   CryptoSP                          like(StdChr) const
     D   CryptoDev                         like(StdChr) const options(*omit)
     D   Hash                        64a   options(*varsize:*omit)
     D   ErrorCode                32767a   options(*varsize)

     D ALGD0500_t      ds                  qualified
     D                                     based(Template)
     D   HashAlg                           like(StdInt)

     D QDCXLATE        PR                  ExtPgm('QDCXLATE')
     D   len                          5p 0 const
     D   data                     32702a   options(*varsize)
     D   table                             like(StdNam) const

     D cvthc           PR                  ExtProc('cvthc')
     D   target                   65534A   options(*varsize)
     D   src_bits                 32767A   options(*varsize) const
     D   tgt_length                        like(StdInt) value

     D ErrorNull       ds                  qualified
     D    BytesProv                        like(StdInt) inz
     D    BytesAvail                       like(StdInt) inz

     D HASH_MD5        c                   1
     D HASH_SHA1       c                   2
     D HASH_SHA256     c                   3
     D HASH_SHA384     c                   4
     D HASH_SHA512     c                   5
      *
      * Length of standard hashes:
      * MD5 16 bytes
      * SHA-1 20 bytes
      * SHA-256 32 bytes
      * SHA-384 48 bytes
      * SHA-512 64 bytes
      *
     D alg             ds                  likeds(ALGD0500_t)
     D binhash         s             64a
     D hexhash         s             32a
     D w_Hash          s                   like(i_Hash) inz

      /free
         // -----------------------------------------------------
         // Hash the EBCDIC.

         if %parms >= 3;
           w_Hash = i_Hash;
         else;
           w_Hash = 'SHA512';
         endif;

         select;
         when w_Hash   = 'MD5';
           alg.HashAlg = HASH_MD5;

         when w_Hash   = 'SHA1';
           alg.HashAlg = HASH_SHA1;

         when w_Hash   = 'SHA256';
           alg.HashAlg = HASH_SHA256;

         when w_Hash   = 'SHA384';
           alg.HashAlg = HASH_SHA384;

         when w_Hash   = 'SHA512';
           alg.HashAlg = HASH_SHA512;
         endsl;

         Qc3CalculateHash( %addr(i_InpDta)
                         : i_InpDtaLen
                         : 'DATA0100'
                         : alg
                         : 'ALGD0500'
                         : '0'
                         : *OMIT
                         : binhash
                         : ErrorNull );

         // cvthc( hexhash: binhash: %len(binhash)*2);
         return binhash;

         // -----------------------------------------------------
         // Hash the ASCII.

         // QDCXLATE(len: data: 'QTCPASC');
         // Qc3CalculateHash( %addr(i_InpDta)
         //                 : i_InpDtaLen
         //                 : 'DATA0100'
         //                 : alg
         //                 : 'ALGD0500'
         //                 : '0'
         //                 : *OMIT
         //                 : binhash
         //                 : ErrorNull );
         //
         // cvthc( hexhash: binhash: %len(binhash)*2);
         // dsply ('ASCII: ' + hexhash);

      /end-free
      *
     P CalcHash        E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  ChkUsrPwd() -- Check user password.
      *
      *   Checks the password for the specified user ID.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
     P ChkUsrPwd       B                   Export
      *
     D ChkUsrPwd       Pi                  like(StdInd)
     D  UserID                             like(StdNam) const
     D  Password                           like(StdNam) const
      * ---------------------------------------------------------
      *
      *   Get profile handle.
      *
     C                   callp     GetPrfHdl(UserID:Password:
     C                                       CurPrfHdl:dsEC:
     C                                       10:*zero)
      * ---------------------------------------------------------
      *
      *    Release profile handle.
      *
     C                   if        dsEC.msgid = *blanks
     C                   callp     RlsPrfHdl(CurPrfHdl:dsEC)
     C                   endif
      * ---------------------------------------------------------
      *
      *    Handle errors.
      *
     C                   if        dsEC.msgid <> *blanks
     C                   eval      msgid  = dsEC.msgid
     C                   eval      msgdta = dsEC.msgdta
     C                   eval      torel  = '*PRV'
     C                   eval      msgf   = 'QCPFMSG'
     C                   exsr      $PMsnd
     C                   return    *off
     C                   else
     C                   return    *on
     C                   endif
      *
      /undefine $PMSND_copied
      /COPY QCPYSRC,$PMsnd
      *
     P ChkUsrPwd       E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Encrypt() -- Encrypt.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P Encrypt         B                   Export

     D Encrypt         PI                  like(StdStr)
     D  EncKeyID                           like(StdTxt)      const
     D                                     options(*varsize)
     D  p_SrcDta                           like(StdStr)      const
     D                                     options(*varsize)
     D  p_SrcLen                           like(StdInt)      const
     D  p_ErrInfo                          likeds(dsEC)
     D                                     options(*nopass)

     D CRYPTO_SRV      S                   like(StdNam) inz

     D myAlgo          ds                  likeDS(ALGD0200_T) inz(*likeDS)
     D myKey           ds                  likeDS(KEYD0200_T) inz(*likeDS)

     D SrcDta          s                   like(StdStr)   inz
     D SrcLen          s                   like(StdInt)   inz
     D RtnDta          s                   like(StdStr)   inz
     D RtnLen          s                   like(StdInt)   inz
      /Free

       // -------------------------------------------------------
       // Assure that required parameters are passed.

       if EncKeyID = *blanks   or
          p_SrcDta = *blanks   or
          p_SrcLen = *zero;
          return     *blanks;
       endif;

       // -------------------------------------------------------
       //  Set up the Key DS
       //  -- key length must be 16, 24 or 32-bytes

       myKey.type   = ALGO_AES;
       myKey.format = key_BIN;
       myKey.value  = EncKeyID;

       select;
       when  %len(%trimR(EncKeyID)) <= 16;
             myKey.length = 16;

       when  %len(%trimR(EncKeyID)) <= 24;
             myKey.length = 24;

       when  %len(%trimR(EncKeyID)) <= 32;
             myKey.length = 32;
       endsl;

       // -------------------------------------------------------
       //  Set up the AES encryption DS

       myAlgo.Algorithm = ALGO_AES;
       myAlgo.blocklength = 16;
       myAlgo.mode      = mode_Cusp;
       myAlgo.PadOption = pad_nopad;
       myAlgo.reserved1 = X'00';
       myAlgo.macLength = *zero;
       myAlgo.keySize   = *zero;
       myalgo.inzVector = *ALLx'00';

       // -------------------------------------------------------
       // Encrypt using AES.

       SrcDta = p_SrcDta;
       SrcLen = p_SrcLen;

       Qc3EncryptData(SrcDta: SrcLen :'DATA0100':
                         myAlgo  : 'ALGD0200' :
                         myKey   : 'KEYD0200' :
                         ANY_CRYPTO_SRV       : CRYPTO_SRV :
                         RtnDta  : %size(RtnDta) :
                         RtnLen  :
                         dsEC);

       if dsEC.avl <> *zero;
          if %parms   >= 4;
             p_ErrInfo = dsEC;
          endif;

          return *blanks;
       endif;
       // -------------------------------------------------------
       // Clear blanks after the response.

       RtnDta = %subst(RtnDta:1:RtnLen);

       return RtnDta;

      /end-free

     P Encrypt         E
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * Decrypt() -- Decrypt.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P Decrypt         B                   Export

     D Decrypt         PI                  like(StdStr)
     D  EncKeyID                           like(StdTxt)      const
     D                                     options(*varsize)
     D  p_SrcDta                           like(StdStr)      const
     D                                     options(*varsize)
     D  p_SrcLen                           like(StdInt)      const
     D  p_ErrInfo                          likeds(dsEC)
     D                                     options(*nopass)

     D CRYPTO_SRV      S                   like(StdNam) inz

     D myAlgo          ds                  likeDS(ALGD0200_T) inz(*likeDS)
     D myKey           ds                  likeDS(KEYD0200_T) inz(*likeDS)

     D SrcDta          s                   like(StdStr)    inz
     D SrcLen          s                   like(StdInt)    inz
     D RtnDta          s                   like(StdStr)    inz
     D RtnLen          s                   like(StdInt)    inz
      /Free

       // -------------------------------------------------------
       // Assure that required parameters are passed.

       if EncKeyID = *blanks   or
          p_SrcDta = *blanks   or
          p_SrcLen = *zero;
          return     *blanks;
       endif;

       // -------------------------------------------------------
       //  Set up the Key DS
       //  -- key length must be 16, 24 or 32-bytes

       myKey.type   = ALGO_AES;
       myKey.format = key_BIN;
       myKey.value  = EncKeyID;

       select;
       when  %len(%trimR(EncKeyID)) <= 16;
             myKey.length = 16;

       when  %len(%trimR(EncKeyID)) <= 24;
             myKey.length = 24;

       when  %len(%trimR(EncKeyID)) <= 32;
             myKey.length = 32;
       endsl;

       // -------------------------------------------------------
       //  Set up the AES encryption DS

       myAlgo.Algorithm = ALGO_AES;
       myAlgo.blocklength = 16;
       myAlgo.mode      = mode_Cusp;
       myAlgo.PadOption = pad_nopad;
       myAlgo.reserved1 = X'00';
       myAlgo.macLength = *zero;
       myAlgo.keySize   = *zero;
       myalgo.inzVector = *ALLx'00';

       // -------------------------------------------------------
       // Decrypt using AES.

       SrcDta = p_SrcDta;
       SrcLen = p_SrcLen;

       Qc3DecryptData(SrcDta  : SrcLen     :
                      myAlgo  : 'ALGD0200' :
                      myKey   : 'KEYD0200' :
                      ANY_CRYPTO_SRV       :  CRYPTO_SRV :
                      RtnDta  : %size(RtnDta) :
                      RtnLen  :
                      dsEC);

       if dsEC.avl <> *zero;
          if %parms   >= 4;
             p_ErrInfo = dsEC;
          endif;

          return *blanks;
       endif;
       // -------------------------------------------------------
       // Clear blanks after the response.

       RtnDta = %subst(RtnDta:1:RtnLen);

       return RtnDta;

      /end-free

     P Decrypt         E
