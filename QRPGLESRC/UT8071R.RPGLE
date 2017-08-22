      /TITLE Utility, Sockets (SrvPgm)
      *CMDBFR addlible libhttp *last
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides sockets routines via function calls.
      *
      *  Notes   :  Sockets code copied from Scott Klement (c) 2001
      *              at klement.dstorm.net/rpg/socktut/tutorial.html
      *
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  07/22/98  TimH        New program.
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
     H BNDDIR('HTTPAPI')
      *
      *define PROTOSKT
      /define DSpgm
      /copy qcpysrc,Dspec
      /copy qcpysrc,UT8071S
      *
      /copy libhttp/qrpglesrc,gskssl_h
      /copy libhttp/qrpglesrc,httpapi_h
      *
     D CalcBitPos      PR
     D    peDescr                          like(StdInt)
     D    peByteNo                         like(StdIntSml)
     D    peBitMask                        like(StdChr)

      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *RdLine(): This reads one "line" of text data from a socket.
      *
      *  peSock = socket to read from
      *  peLine = a pointer to a variable to put the line of text into
      *  peLength = max possible length of data to stuff into peLine
      *  peXLate = (default: *OFF) Set to *ON to translate ASCII -> EBCDIC
      *  peLF (default: x'0A') = line feed character.
      *  peCR (default: x'0D') = carriage return character.
      *
      * returns length of data read, or -1 upon error
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P RdLine          B                   Export

     D RdLine          PI                  like(StdInt)
     D   peSock                            like(StdInt) value
     D   peLine                            like(StdPtr) value
     D   peLength                          like(StdInt) value
     D   peXLate                           like(StdChr) const options(*nopass)
     D   peLF                              like(StdChr) const options(*nopass)
     D   peCR                              like(StdChr) const options(*nopass)

     D wwBuf           S           -  1    like(StdBuf) based(peLine)
     D wwLen           S                   like(StdInt)
     D RC              S                   like(StdInt)
     D CH              S                   like(StdChr)
     D wwXLate         S                   like(StdChr)
     D wwLF            S                   like(StdChr)
     D wwCR            S                   like(StdChr)

š1b€ c                   if        %parms > 3
     c                   eval      wwXLate = peXLate
š1x€ c                   else
     c                   eval      wwXLate = *OFF
š1e€ c                   endif

š1b€ c                   if        %parms > 4
     c                   eval      wwLF = peLF
š1x€ c                   else
     c                   eval      wwLF = x'0A'
š1e€ c                   endif

š1b€ c                   if        %parms > 5
     c                   eval      wwCR = peCR
š1x€ c                   else
     c                   eval      wwCR = x'0D'
š1e€ c                   endif

     c                   eval      %subst(wwBuf:1:peLength) = *blanks

š1b€ c                   dow       1 = 1

     c                   eval      rc = recv(peSock: %addr(ch): 1: *zero)
š2b€ c                   if        rc<1
š3b€ c                   if        wwLen > *zero
š1v€ c                   leave
š3x€ c                   else
     c                   return    -1
š3e€ c                   endif
š2e€ c                   endif

š2b€ c                   if        ch = wwLF
š1v€ c                   leave
š2e€ c                   endif

š2b€ c                   if        ch <> wwCR
     c                   eval      wwLen = wwLen + 1
     c                   eval      %subst(wwBuf:wwLen:1) = ch
š2e€ c                   endif

š2b€ c                   if        wwLen = peLength
š1v€ c                   leave
š2e€ c                   endif

š1e€ c                   enddo

š1b€ c                   if        wwXLate=*ON  and wwLen>0
     c                   callp     Translate(wwLen: wwBuf: 'QTCPEBC')
š1e€ c                   endif

     c                   return    wwLen

     P RdLine          E
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * WrLine() -- Write a line of text to a socket:
      *
      *     peSock = socket descriptor to write to
      *     peLine = line of text to write to
      *   peLength = length of line to write (before adding CRLF)
      *           you can pass -1 to have this routine calculate
      *           the length for you (which is the default!)
      *    peXlate = Pass '*ON' to have the routine translate
      *           this data to ASCII (which is the default) or *OFF
      *           to send it as-is.
      *     peEOL1 = First character to send at end-of-line
      *           (default is x'0D')
      *     peEOL2 = Second character to send at end-of-line
      *           (default is x'0A' if neither EOL1 or EOL2 is
      *           passed, or to not send a second char is EOL1
      *           is passed by itself)
      *
      *Returns length of data sent (including end of line chars)
      *   returns a short count if it couldnt send everything
      *   (if you're using a non-blocking socket) or -1 upon error
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P WrLine          B                   Export

     D WrLine          PI                  like(StdInt)
     D  peSock                             like(StdInt) value
     D  peLine                             like(StdSQL) const
     D  peLength                           like(StdInt) value options(*nopass)
     D  peXLate                            like(StdChr) const options(*nopass)
     D  peEOL1                             like(StdChr) const options(*nopass)
     D  peEOL2                             like(StdChr) const options(*nopass)

     D wwLine          S                   like(StdSQL)
     D wwLen           S                   like(StdInt)
     D wwXlate         S                   like(StdChr)
     D wwEOL           S              2A
     D wwEOLlen        S                   like(StdInt)
     D rc              S                   like(StdInt)

      ******************************************
      *Allow this procedure to figure out the
      * length automatically if not passed,
      * or if -1 is passed.
      ******************************************
š1b€ c                   if        %parms > 2 and peLength <> -1
     c                   eval      wwLen = peLength
š1x€ c                   else
     c                   eval      wwLen = %len(%trim(peLine))
š1e€ c                   endif

      ******************************************
      *Default 'translate' to *ON.  Usually
      * you want to type the data to send
      * in EBCDIC, so this makes more sense:
      ******************************************
š1b€ c                   if        %parms > 3
     c                   eval      wwXLate = peXLate
š1x€ c                   else
     c                   eval      wwXLate = *On
š1e€ c                   endif

      ******************************************
      *End-Of-Line chars:
      *  1) If caller passed only one, set
      *        that one with length = 1
      *  2) If caller passed two, then use
      *        them both with length = 2
      *  3) If caller didn't pass either,
      *        use both CR & LF with length = 2
      ******************************************
     c                   eval      wwEOL = *blanks
     c                   eval      wwEOLlen = *zero

š1b€ c                   if        %parms > 4
     c                   eval      %subst(wwEOL:1:1) = peEOL1
     c                   eval      wwEOLLen = 1
š1e€ c                   endif

š1b€ c                   if        %parms > 5
     c                   eval      %subst(wwEOL:2:1) = peEOL2
     c                   eval      wwEOLLen = 2
š1e€ c                   endif

š1b€ c                   if        wwEOLLen = *zero
     c                   eval      wwEOL = x'0D0A'
     c                   eval      wwEOLLen = 2
š1e€ c                   endif

      ******************************************
      *Do translation if required:
      ******************************************
     c                   eval      wwLine = peLine
š1b€ c                   if        wwXLate = *On and wwLen > *zero
     c                   callp     Translate(wwLen: wwLine: 'QTCPASC')
š1e€ c                   endif

      ******************************************
      *Send the data, followed by the end-of-line:
      *and return the length of data sent:
      ******************************************
š1b€ c                   if        wwLen > *zero
     c                   eval      rc = send(peSock: %addr(wwLine): wwLen:0)
š2b€ c                   if        rc < wwLen
     c                   return    rc
š2e€ c                   endif
š1e€ c                   endif

     c                   eval      rc = send(peSock:%addr(wwEOL):wwEOLLen:0)
š1b€ c                   if        rc < *zero
     c                   return    rc
š1e€ c                   endif

     c                   return    (rc + wwLen)

     P WrLine          E


      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *Set a File Descriptor in a set ON...  for use w/Select()
      *
      *     peFD = descriptor to set on
      *     peFDSet = descriptor set
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P FD_SET          B                   EXPORT

     D FD_SET          PI
     D   peFD                              like(StdInt)
     D   peFDSet                     28A

     D wkByteNo        S                   like(StdIntSml)
     D wkMask          S                   like(StdChr)
     D wkByte          S                   like(StdChr)

     C                   callp     CalcBitPos(peFD:wkByteNo:wkMask)
     c                   eval      wkByte = %subst(peFDSet:wkByteNo:1)
     c                   biton     wkMask        wkByte
     c                   eval      %subst(peFDSet:wkByteNo:1) = wkByte

     P FD_SET          E


      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *Set a File Descriptor in a set OFF...  for use w/Select()
      *
      *     peFD = descriptor to set off
      *     peFDSet = descriptor set
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P FD_CLR          B                   EXPORT

     D FD_CLR          PI
     D   peFD                              like(StdInt)
     D   peFDSet                     28A

     D wkByteNo        S                   like(StdIntSml)
     D wkMask          S                   like(StdChr)
     D wkByte          S                   like(StdChr)

     C                   callp     CalcBitPos(peFD:wkByteNo:wkMask)
     c                   eval      wkByte = %subst(peFDSet:wkByteNo:1)
     c                   bitoff    wkMask        wkByte
     c                   eval      %subst(peFDSet:wkByteNo:1) = wkByte

     P FD_CLR          E


      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *Determine if a file desriptor is on or off...
      *
      *     peFD = descriptor to set off
      *     peFDSet = descriptor set
      *
      *  Returns *ON if its on, or *OFF if its off.
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P FD_ISSET        B                   EXPORT

     D FD_ISSET        PI                  like(StdInd)
     D   peFD                              like(StdInt)
     D   peFDSet                     28A

     D wkByteNo        S                   like(StdIntSml)
     D wkMask          S                   like(StdChr)
     D wkByte          S                   like(StdChr)

     C                   callp     CalcBitPos(peFD:wkByteNo:wkMask)
     c                   eval      wkByte = %subst(peFDSet:wkByteNo:1)
     c                   testb     wkMask        wkByte                   88
     c                   return    *IN88

     P FD_ISSET        E


      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      *Clear All descriptors in a set.  (also initializes at start)
      *
      *     peFDSet = descriptor set
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P FD_ZERO         B                   EXPORT

     D FD_ZERO         PI
     D   peFDSet                     28A

     C                   eval      peFDSet = *ALLx'00'

     P FD_ZERO         E


      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      * This is used by the FD_SET/FD_CLR/FD_ISSET procedures to
      * determine which byte in the 28-char string to check,
      * and a bitmask to check the individual bit...
      *
      * peDescr = descriptor to check in the set.
      * peByteNo = byte number (returned)
      * peBitMask = bitmask to set on/off or test
      *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     P CalcBitPos      B

     D CalcBitPos      PI
     D    peDescr                          like(StdInt)
     D    peByteNo                         like(StdIntSml)
     D    peBitMask                        like(StdChr)

     D dsMakeMask      DS
     D   dsZeroByte            1      1A
     D   dsMask                2      2A
     D   dsBitMult             1      2U 0 INZ(0)

     C     peDescr       div       32            wkGroup           5 0
     C                   mvr                     wkByteNo          2 0

     C                   div       8             wkByteNo          2 0
     C                   mvr                     wkBitNo           2 0

     C                   eval      wkByteNo = 4 - wkByteNo
     c                   eval      peByteNo = (wkGroup * 4) + wkByteNo
     c                   eval      dsBitMult = 2 ** wkBitNo
     c                   eval      dsZeroByte = x'00'
     c                   eval      peBitMask = dsMask

     P CalcBitPos      E
      ** * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *Initialize application for use with SSL
      ** * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     P InitSSL         B                   export

     D InitSSL         PI                  like(StdInd)
     D   AppID                      100A   const

     D InitComplete    s                   like(StdInd) inz static
     D error           s                   like(StdInt) inz

     D Err             s                   like(StdInd) inz

      /free

        dow not InitComplete;

           if https_init(AppID) = *zero;
               InitComplete = *on;

           else;

           err = http_error(error);

              select;
              when error = HTTP_GSKENVI;
                   return *on;

              when error <> HTTP_NOTREG;
                   return *off;
              endsl;

              if https_dcm_reg(AppID:*off) = -1;
                 return *off;
              endif;

           endif;

        enddo;

        return *on;

      /end-free

     P InitSSL         e
