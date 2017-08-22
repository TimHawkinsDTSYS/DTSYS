      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Security prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *   Global variables & constants
      *
     D RtnCod          s                   like(StdInt) inz
     D UsrPwd          s                   like(StdNam) inz
     D VldLst          s                   like(StdNam) inz('TSVLDL')
     D VldLib          s                   like(StdNam) inz('*LIBL')
      *
     D NewUsrID        s                   like(StdNam)    inz
     D CurPrfHdl       s                   like(StdPrfHdl) inz
     D NewUsrHdl       s                   like(StdPrfHdl) inz

     D ALGO_DES        c                   const(20)
     D ALGO_TDES       c                   const(21)
     D ALGO_AES        c                   const(22)
     D ALGO_RC4        c                   const(30)
     D ALGO_RSA_PUB    c                   const(50)
     D ALGO_RSA_PRIV   c                   const(51)

     D mode_ECB        c                   const('0')
     D mode_CBC        c                   const('1')
     D mode_OFB        c                   const('2')
     D mode_CFB1Bit    c                   const('3')
     D mode_CFB8Bit    c                   const('4')
     D mode_CFB64Bit   c                   const('5')
     D mode_Cusp       c                   const('6')

     D pad_NoPad       c                   const('0')
     D pad_PadChar     c                   const('1')
     D pad_PadCounter  c                   const('2')

     D key_BIN         c                   const('0')
     D key_BER         c                   const('1')

     D ANY_CRYPTO_SRV  c                   const('0')
     D SWF_CRYPTO_SRV  c                   const('1')
     D HWD_CRYPTO_SRV  c                   const('2')
      * ---------------------------------------------------------
      * Encryption Data Structures
      *
     D ALGD0200_T      DS                  qualified template
     D  Algorithm                          like(StdInt)
     D  BlockLength                        like(StdInt)
     D  Mode                               like(StdChr)
     D  PadOption                          like(StdChr)
     D  PadChar                            like(StdChr)
     D  Reserved1                          like(StdChr)
     D  MACLength                          like(StdInt)
     D  KeySize                            like(StdInt)
     D  InzVector                    32A
      *
     D KEYD0200_T      DS                  qualified template
     D  type                               like(StdInt)
     D  length                             like(StdInt)
     D  format                             like(StdChr)
     D  value                              like(StdStr)
      * ---------------------------------------------------------
      *
      *   VfyUsrPwd() -- Verify user password
      *
     D VfyUsrPwd       Pr                  like(StdInt)
     D  PxVldLst                           like(StdNam) const
     D  PxVldLstLib                        like(StdNam) const
     D  PxUsrId                            like(StdNam) const
     D  PxUsrPwd                           like(StdNam) const
      * ---------------------------------------------------------
      *
      *   AddUsrPwd() -- Add user password
      *
     D AddUsrPwd       Pr                  like(StdInt)
     D  PxVldLst                           like(StdNam) const
     D  PxVldLstLib                        like(StdNam) const
     D  PxUsrId                            like(StdNam) const
     D  PxUsrPwd                           like(StdNam) const
     D  PxUsrDsc                           like(StdTxt) const
      * ---------------------------------------------------------
      *
      *   GetUsrPwd() -- Get user password
      *
     D GetUsrPwd       Pr                  like(StdNam)
     D  PxVldLst                           like(StdNam) const
     D  PxVldLstLib                        like(StdNam) const
     D  PxUsrId                            like(StdNam) const
      * ---------------------------------------------------------
      *
      *   ChgUsrPwd() -- Change user password
      *
     D ChgUsrPwd       Pr                  like(StdInt)
     D  PxVldLst                           like(StdNam) const
     D  PxVldLstLib                        like(StdNam) const
     D  PxUsrId                            like(StdNam) const
     D  PxUsrPwd                           like(StdNam) const
      * ---------------------------------------------------------
      *
      *   ChgPwd() -- Change password
      *
     D ChgPwd          Pr                  like(Msgid)
     D  PxUsrId                            like(StdNam) const
     D  PxCurPwd                           like(StdNam) const
     D  PxNewPwd                           like(StdNam) const
      * ---------------------------------------------------------
      *
      *   RmvUsrPwd() -- Remove user password
      *
     D RmvUsrPwd       Pr                  like(StdInt)
     D  PxVldLst                           like(StdNam) const
     D  PxVldLstLib                        like(StdNam) const
     D  PxUsrId                            like(StdNam) const
      * ---------------------------------------------------------
      *
      *   GetPrfHdl() -- Get profile handle.
      *
     D GetPrfHdl       PR                  ExtPgm('QSYGETPH')
     D  UsrPrf                             like(StdNam)    const
     D  UsrPrfPwd                          like(StdNam)    const
     D  UsrPrfHdl                          like(StdPrfHdl) const
     D  ErrorCode                 32766A   options(*varsize:*nopass)
     D  UsrPrfPwdLen                       like(StdInt)    const
     D                                     options(*nopass)
     D  UsrPrfCCSID                        like(StdInt)    const
     D                                     options(*nopass)
      * ---------------------------------------------------------
      *
      *   RlsPrfHdl() -- Release profile handle.
      *
     D RlsPrfHdl       PR                  ExtPgm('QSYRLSPH')
     D  UsrPrfHdl                          like(StdPrfHdl) const
     D  ErrorCode                 32766A   options(*varsize)
      * ---------------------------------------------------------
      *
      *  ChkUsrPwd() -- Check user password.
      *
     D ChkUsrPwd       pr                  like(StdInd)
     D  UsrPrf                             like(StdNam) const
     D  UsrPrfPwd                          like(StdNam) const
      * ---------------------------------------------------------
      *
      *   SavNewPrf() -- Set new profile.
      *
     D SetNewPrf       PR                  ExtPgm('QWTSETP')
     D  UsrPrfHdl                          like(StdPrfHdl) const
     D  ErrorCode                 32766A   options(*varsize:*nopass)
      * ---------------------------------------------------------
      *
      *   GenRanNbr() -- Generate random number.
      *
     D GenRanNbr       Pr                  like(StdMaxDecWhl)
     D   lowno                             like(StdMaxDecWhl) const
     D   highno                            like(StdMaxDecWhl) const
      * ---------------------------------------------------------
      *
      *   Get_PRN() -- Get pseudo-random number.
      *
     D Get_PRN         pr                  like(StdDblFlt)
      * ---------------------------------------------------------
      * GetJobAut() -- Get job authority                                   -- *
      *   Changes from the current user profile to the
      *    named user profile.                                               error
      * ---------------------------------------------------------
     D GetJobAut       Pr                  like(StdInt)
     D  NewUsrID                           like(StdNam) const
      * ---------------------------------------------------------
      * RstJobAut() -- Restore job authority.                              -- *
      *   Changes from the named user profile back to the
      *    current user profile.                                             error
      * ---------------------------------------------------------
     D RstJobAut       Pr                  like(StdInt)
      * ---------------------------------------------------------
      *
      * EncryptRC4() --  Encrypt using RC4
      *
     D EncryptRC4      PR                  like(StdStr)
     D  SrcData                            like(StdStr)
     D  SecretKey                    16    varying
      * ---------------------------------------------------------
      * DecryptRC4() --  Decrypt using RC4
      *
     D DecryptRC4      PR                  like(StdStr)
     D  SrcData                            like(StdStr)
     D  SecretKey                    16    varying
      * ---------------------------------------------------------
      * LstEncAlg() --  List Encryption Algorithms
      *
     D LstEncAlg       PR
      * ---------------------------------------------------------
      * GetEncAlg() --  Get Encryption Algorithm
      *
     D GetEncAlg       PR            45A   varying
     D   Algorithm                    2A   const
      * ---------------------------------------------------------
      * Qc3EncryptData() --  Encrypt
      *
     D Qc3EncryptData  PR                  ExtProc('Qc3EncryptData')
     D  szClearData               65535A   options(*varsize)
     D  nLenClearData                      like(StdInt)    const
     D  clearDataFmt                       like(StdFmt)    const

     D  AlgoDescr                    64A   const options(*varsize)
     D  szAlgoFormat                       like(StdFmt)    const

     D  KeyDescriptor               512A   const options(*varsize)
     D  szKeyFormat                        like(StdFmt)    const

      ** 0=Use best choice, 1=Software, 2=Hardware
     D  CryptoService                      like(StdChr) const
      **  Hardware Cryptography device name or *BLANKS
     D  CryptoDevName                      like(StdNam) const

     D  szEncryptedData...
     D                            65535A   options(*varsize)
     D  nEncryptedDataLen...
     D                                     like(StdInt) const
     D  nEncryptedDataReturnLen...
     D                                     like(StdInt)
     D  api_ErrorDS                        LikeDS(dsEC)
     D                                     options(*varsize)
      * ---------------------------------------------------------
      * Qc3DecryptData() --  Decrypt
      *
     D Qc3DecryptData  PR                  ExtProc('Qc3DecryptData')
     D  szEncData                 65535A   options(*varsize)
     D  nLenEncData                        like(StdInt) const

     D  AlgoDescriptr                64A   const options(*varsize)
     D  szAlgoFormat                       like(StdFmt)    const

     D  KeyDescriptor               512A   const options(*varsize)
     D  szKeyFormat                        like(StdFmt)    const

      ** 0=Best choice, 1=Software, 2=Hardware
     D  CryptoService                      like(StdChr) const
      **  Hardware Cryptography device name or *BLANKS
     D  CryptoDevName                      like(StdNam) const

     D  szClearData               65535A   options(*varsize)
     D  nClearLen                          like(StdInt) const
     D  nClearRtnLen                       like(StdInt) const
     D  api_ErrorDS                        LikeDS(dsEC)
     D                                     options(*varsize)
      * ---------------------------------------------------------
      * Qc3CalcHash() --  Calculate hash
      *
     D Qc3CalcHash     PR                  ExtProc('Qc3CalculateHash')
     D  szClearData               65535A   options(*varsize)
     D  nLenClearData                      like(StdInt)    const
     D  clearDataFmt                       like(StdFmt)    const
     D  AlgorDesc                    64A   const options(*varsize)
     D  szAlgoFormat                       like(StdFmt)    const

      ** 0=Best choice, 1=Software, 2=Hardware
     D  CryptoService                      like(StdChr) const
      **  Hardware Cryptography device name or *BLANKS
     D  CryptoDevName                      like(StdNam) const

     D  rtnHash                      64A   options(*varsize)
     D  api_ErrorDS                        LikeDS(dsEC)
     D                                     options(*varsize)
      * ---------------------------------------------------------
      * CalcHash() --  Calculate hash
      *
     D CalcHash        PR            64
     D  i_InpDta                           like(StdPtr) value
     D  i_InpDtaLen                        like(StdInt) const
     D  i_Hash                             like(StdNam) const
     D                                     options(*omit:*nopass)
      * ---------------------------------------------------------
      * Encrypt() --  Encrypt
      *
     D Encrypt         PR                  like(StdStr)
     D  EncKeyID                           like(StdTxt)      const
     D                                     options(*varsize)
     D  SrcData                            like(StdStr)      const
     D                                     options(*varsize)
     D  SrcLen                             like(StdInt)      const
     D  dsErrInfo                          likeds(dsEC)
     D                                     options(*nopass)
      * ---------------------------------------------------------
      * Decrypt() --  Decrypt
      *
     D Decrypt         PR                  like(StdStr)
     D  EncKeyID                           like(StdTxt)      const
     D                                     options(*varsize)
     D  SrcData                            like(StdStr)      const
     D                                     options(*varsize)
     D  SrcLen                             like(StdInt)      const
     D  dsErrInfo                          likeds(dsEC)
     D                                     options(*nopass)
