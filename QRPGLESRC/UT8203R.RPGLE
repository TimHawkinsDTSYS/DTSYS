      /TITLE Utility, Email Address (SrvPgm)
      *PARMS
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      *  Synopsis:  Provides miscellaneous routines via function calls.
      *
      *  Notes   :  none
      *
      *
      *    Date    Programmer  Description
      *  --------  ----------  ---------------------------------------------
      *  mm/dd/yy  xxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *                         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
      /copy qcpysrc,HspecSrv
      *
      /define DSpgm
      /copy qcpysrc,Dspec
      ***********************************************************
      * ChkEml() -- Check email address.
      ***********************************************************
     P ChkEml          B                   Export
      *
     D ChkEml          PI                  like(d_ChkEml)
     D  EmlAdr                             like(StdEml) value
      *
     D x               s                   like(StdInt) inz
     D SignCnt         s                   like(StdInt) inz
     D Mailbox         s                   like(StdEml) inz
     D Domain          s                   like(StdEml) inz
     D Numb            c                   const('0123456789')
      * ---------------------------------------------------------
      *
      *    Clear return parameters.
      *
     C                   eval      d_ChkEml = *blanks
      *---------------------------------------------------------
      *
      *    Test for no input.
      *
     C                   if        EmlAdr   = *blanks
     C                   return    d_ChkEml
     C                   endif
      *---------------------------------------------------------
      *
      *    Check for only @ sign.
      *
     C                   eval      SignCnt = *zero
      *
     C                   for       x = 1 to %len(%trim(EmlAdr))
     C                   if        %subst(EmlAdr:x:1) = '@'
     C                   eval      SignCnt += 1
     C                   endif
     C                   endfor
      *
     C                   if        SignCnt      <> 1
     C                   eval      ChkEml_MSGID  = 'GNL0108'
     C                   eval      ChkEml_MSGDTA = EmlAdr
     C                   return    d_ChkEml
     C                   endif
      *---------------------------------------------------------
      *
      *    Check for valid characters.
      *     for:  _, -, ., &, or a thru z, 0 thru 9.
      *
     C                   for       x = 1 to %len(%trim(EmlAdr))
     C                   if        %subst(EmlAdr:x:1) <> ' ' and
     C                             %subst(EmlAdr:x:1) <> '_' and
     C                             %subst(EmlAdr:x:1) <> '-' and
     C                             %subst(EmlAdr:x:1) <> '@' and
     C                             %subst(EmlAdr:x:1) <> '.' and
     C                             %subst(EmlAdr:x:1) <> '&' and
     C                             %subst(EmlAdr:x:1) <> '/' and
     C                             %subst(EmlAdr:x:1) <> '\' and
     C                             %scan(%subst(EmlAdr:x:1):Numb) = *zero and
     C                             %scan(%subst(EmlAdr:x:1):uppr) = *zero and
     C                             %scan(%subst(EmlAdr:x:1):lowr) = *zero
     C                   eval      ChkEml_MSGID  = 'GNL0109'
     C                   eval      ChkEml_MSGDTA = EmlAdr
     C                   return    d_ChkEml
     C                   endif
     C                   endfor
      *---------------------------------------------------------
      *
      *    Check for imbeded blanks.
      *
     C                   if        %len(%trim(EmlAdr)) <>
     C                             %len(%trim(CompressString(EmlAdr)))
     C                   eval      ChkEml_MSGID  = 'GNL0110'
     C                   eval      ChkEml_MSGDTA = Emladr
     C                   return    d_ChkEml
     C                   endif
      *---------------------------------------------------------
      *
      *    Extract name and domain.
      *
     C                   if        %scan('@':EmlAdr) <= %len(EmlAdr) - 1
     C                   eval      Mailbox =
     C                             %subst(EmlAdr:1:%scan('@':EmlAdr)-1)
      *
     C                   eval      Domain  =
     C                             %subst(EmlAdr:%scan('@':EmlAdr)+1)
     C                   else
     C                   eval      Mailbox = *blanks
     C                   eval      Domain  = *blanks
     C                   endif
      *---------------------------------------------------------
      *
      *    First character and last chacter cannot be a dot.
      *
     C                   if         MailBox            <> *blanks and
     C                              MailBox            <> '.'     and
     C                             (%subst(Mailbox:1:1) = '.'     or
     C                              %subst(Mailbox:
     C                              %len(%trim(Mailbox)):1) = '.')
     C                   eval      ChkEml_MSGID  = 'GNL0111'
     C                   eval      ChkEml_MSGDTA = EmlAdr
     C                   return    d_ChkEml
     C                   endif
      *
     C                   if         Domain             <> *blanks and
     C                              Domain             <> '.'     and
     C                             (%subst(Domain:1:1)  = '.'     or
     C                              %subst(Domain:
     C                              %len(%trim(Domain)):1) = '.')
     C                   eval      ChkEml_MSGID  = 'GNL0111'
     C                   eval      ChkEml_MSGDTA = EmlAdr
     C                   return    d_ChkEml
     C                   endif
      *---------------------------------------------------------
      *
      *    No errors to return.
      *
     C                   return    d_ChkEml
      *
     P ChkEml          E
      ***********************************************************
      * ValEml(): Check if e-mail address is valid
      ***********************************************************
     P ValEml          B                   export

     D ValEml          PI                  like(StdInd)
     D  p_EmlAdr                           like(StdEml) const
     D  p_ErrInfo                          likeDS(dsErrInfo)
     D                                     options(*nopass)

     D i_EmlAdr        s                   like(StdEml) inz
     D domain          s                   like(StdStg) inz
     D ip              s                   like(StdUns)
     D MXSIZE          c                   const(10)
     d mx              s            256A   dim(MXSIZE)
     d pty             s                   like(StdUnsSml) dim(MXSIZE)
      * ---------------------------------------------------------
      * Parse address into the user ("local") and domain components.
      * if parse fails, it's not a valid address.
      *
     C                   eval      i_EmlAdr = p_EmlAdr
      *
     c                   if        not ParseEmailAddr(p_EmlAdr:
     c                                 *omit: *omit: domain)
     c                   if        %parms >= 2
     c                   eval      p_ErrInfo.msgid  = 'VTD0060'
     c                   eval      p_ErrInfo.msgdta = i_EmlAdr
     c                   endif
     c                   return    *off
     c                   endif
      * ---------------------------------------------------------
      * the domain must either exist as a Host or must have
      * mail exchangers defined for it.  If not, it's not
      * a valid e-mail address.
      *
     c                   if        not GetHost(domain: ip)
     c                   eval      domain = %trim(domain) + '.'
     c                   if        GetMX(domain: MXSIZE: mx: pty) < 1
      *
     C                   if        %parms >= 2
     C                   eval      p_ErrInfo.msgid  = 'VTD0061'
     C                   eval      p_ErrInfo.msgdta = i_EmlAdr
     C                   endif
      *
     c                   return    *off
     c                   endif
     c                   endif

     c                   return    *on

     P ValEml          E
      ***********************************************************
      *  ParseEmailAddr() - Parse email address                       n
      *
      *         input = (input) original e-mail address
      *          name = (output) name portion of address
      *         local = (output) local portion of address
      *        domain = (output) domain portion of address
      *
      *  Returns *on if parse was successful, *off otherwise.         t
      *
      ***********************************************************
     P ParseEmailAddr  B                   Export

     D ParseEmailAddr  PI                  like(StdInd)
     D  p_input                            like(StdStg) const
     D  p_name                             like(StdStg)
     D                                     options(*omit:*nopass)
     D  p_local                            like(StdStg)
     D                                     options(*omit:*nopass)
     D  p_domain                           like(StdStg)
     D                                     options(*omit:*nopass)

     D w_name          s            256    varying      inz
     D w_local         s            256    varying      inz
     D w_domain        s            256    varying      inz
     D state           s                   like(StdInt) inz
     D laststate       s                   like(StdInt) inz
     D format          s                   like(StdInt) inz
     D pos             s                   like(StdInt) inz
     D ch              s                   like(StdChr) inz
     D space           s                   like(StdInd) inz

      * ---------------------------------------------------------
      *  Notes:
      *    -- A Valid E-mail address must be in 1 of 2 formats:
      *         1: sklement@example.com
      *         2: Scott Klement <sklement@example.com>
      *-- Quotes can (sometimes) be used to allow special
      *         characters
      *         ex: "scott@home"@example.com
      *    -- Anything in parenthesis is a comment
      *         ex: sklement@example.com (Nice Guy, Very Clever!)
      *    -- The @ character separates the "local part" (usually a
      *         user name) from the "domain"
      *---------------------------------------------------------
     c                   eval      state = 1
     c                   eval      format = 1
     c                   eval      space = *off

      * ---------------------------------------------------------
      *  This state machine parses the e-mail address or returns *off
      *    if an invalid character is found.
      * ---------------------------------------------------------
     c                   for       pos = 1 to %len(p_input)

     c                   eval      ch = %subst(p_input: pos: 1)

      * ---------------------------------------------------------
      * State 1:  Reading beginning of address.
      *
      *special chars:  " ( @ <
      *   invalid chars:  comma,>,)
      *
      *  A space if legal here ONLY if we end
      *  up with format=2
      * ---------------------------------------------------------
     c                   select
     c                   when      state = 1

     c                   select
     c                   when      ch='"'
     c                   eval      w_local += '"'
     c                   eval      laststate=1
     c                   eval      state=2

     c                   when      ch='('
     c                   eval      laststate=1
     c                   eval      state=3

     c                   when      ch='<'
     c                   eval      format = 2
     c                   eval      w_name = w_local
     c                   eval      %len(w_local) = *zero
     c                   eval      state=4

     c                   when      ch='@'
     c                   eval      laststate = 1
     c                   eval      state=5

     c                   when      ch=' '
     c                   eval      space = *on
     c                   eval      w_local += ch

     c                   when      ch=',' or ch=')' or ch='>'
     c                   return    *off

     c                   other
     c                   eval      w_local += ch
     c                   endsl

      * ---------------------------------------------------------
      * State 2:  Reading quoted text
      *
      *   special chars:  "
      *   invalid chars:  (none)
      * ---------------------------------------------------------
     c                   when      state = 2
     c                   eval      w_local += ch
     c                   if        ch = '"'
     c                   eval      state = laststate
     c                   endif

      * ---------------------------------------------------------
      * State 3:  Reading commented text
      *   special chars:  )
      *   invalid chars: (none)
      * ---------------------------------------------------------
     c                   when      state = 3
     c                   if        ch = ')'
     c                   eval      state = laststate
     c                   endif

      * ---------------------------------------------------------
      * State 4: reading local-part of ext format
      *   special chars: " @ (

      *   invalid chars:  space,comma,>,)
      * ---------------------------------------------------------
     c                   when      state = 4

     c                   select
     c                   when      ch = '"'
     c                   eval      w_local += '"'
     c                   eval      laststate = 4
     c                   eval      state = 2

     c                   when      ch = '('
     c                   eval      laststate = 4
     c                   eval      state = 3

     c                   when      ch = '@'
     c                   eval      laststate = 4
     c                   eval      state = 5

     c                   eval      state = 3
     c                   when      ch=' ' or ch=',' or ch=')' or ch='>'
     c                   return    *off

     c                   other
     c                   eval      w_local += ch
     c                   endsl

      * ---------------------------------------------------------
      * State 5: reading domain portion of addr
      *
      * we aren't too concerned about validation
      * here, because DNS can validate the
      * domain portion.
      * ---------------------------------------------------------
     c                   when      state = 5

     c                   select
     c                   when      ch='>' and format=2
     c                   leave

     c                   when      ch='('
     c                   eval      laststate = 5
     c                   eval      state = 3

     c                   other
     c                   eval      w_domain += ch
     c                   endsl

     c                   endsl

     c                   endfor

      * ---------------------------------------------------------
      *  Some extra validity checking:
      *    -- there must be both a local and domain part
      *    -- domain part is illegal if less than 2 chars
      * ---------------------------------------------------------
     c                   if        format = 1    and
     c                             space  = *on
     c                   return    *off
     c                   endif

     c                   if        %len(w_local)  < 1  or
     c                             %len(w_domain) < 2
     c                   return    *off
     c                   endif

      * ---------------------------------------------------------
      *  Return varying to fixed parms.
      * ---------------------------------------------------------
      /free

       if %parms >= 2;
         CEETSTA(ParmPassed:2:*omit);
         if ParmPassed = 1;
            p_name   = %trim(w_name);
         endif;
       endif;

       if %parms >= 3;
         CEETSTA(ParmPassed:3:*omit);
         if ParmPassed = 1;
            p_local  = %trim(w_local);
         endif;
       endif;

       if %parms >= 4;
         CEETSTA(ParmPassed:4:*omit);
         if ParmPassed = 1;
          p_domain = %trim(w_domain);
         endif;
       endif;

       return *on;

      /end-free
     P ParseEmailAddr  E
      ***********************************************************
      *  GetHost(): Look up a domain name via either host table or DNS
      *
      *       domain = (input) host to look up.
      *         addr = (output) binary IP address of host
      *
      *  returns *off if host could not be looked up, *on otherwise
      ***********************************************************
     P GetHost         B

     D GetHost         PI                  like(StdInd)
     D   domain                     512A   const varying
     D   addr                              like(StdUns)

      * inet_addr() API gets binary IP address from char IP addr.
      *         (in other words, 127.0.0.1 -> x'7F000001'
      *
      *  Returns INADDR_NONE if charaddr is not valid.

     D INADDR_NONE     C                   CONST(4294967295)

     D inet_addr       PR                  extproc('inet_addr')
     D                                     like(StdUns)
     D   charaddr                          options(*string)
     D                                     like(StdPtr) value

      *  gethostbyname() API looks up a host in the host table or
      *      from DNS (if it's not in the host table)
      *
      *  returns a pointer to a hostent structure, or *NULL otherwise

     D gethostbyname   PR                  extproc('gethostbyname')
     D                                     like(StdPtr)
     D  hostname                           options(*string)
     D                                     like(StdPtr) value
      *
      *  the hostent structure is returned by the gethostbyname API
      *
     D p_hostent       S                   like(StdPtr)

     D hostent         DS                  Based(p_hostent)
     D   h_name                            like(StdPtr)
     D   h_aliases                         like(StdPtr)
     D   h_addrtype                        like(StdIntSml)
     D   h_length                          like(StdIntSml)
     D   h_addrlist                        like(StdPtr)

     D p_h_addr        S                   Based(h_addrlist)
     D                                     like(StdPtr)
     D h_addr          S                   Based(p_h_addr)
     D                                     like(StdUns)

     D ipaddr          s                   like(StdUns)

     c                   eval      ipaddr = inet_addr(domain)

     c                   if        ipaddr = INADDR_NONE
     c                   eval      p_hostent = gethostbyname(domain)

     c                   if        p_hostent = *NULL
     c                   return    *off
     c                   endif

     c                   eval      ipaddr = h_addr
     c                   endif

     c                   eval      addr = ipaddr
     c                   return    *on

     P GetHost         E
      ***********************************************************
      *  GetMX(): Get mail exchanger DNS records for a domain
      *
      *       domain = (input) host to look up records for.
      *  max_entries = (input) max number of entries you can fit into
      *                   your host_array and pty_array
      *       mxhost = (output) array of hostnames pointed to by
      *                   DNS MX records.
      *        mxpty = (output) array of priority levels for the
      *                   hosts listed above.
      *
      *  returns -1 upon failure, otherwise the number of MX hosts found
      ***********************************************************
     P GetMX           B

     D GetMX           PI                  like(StdInt)
     D   domain                     512A   const varying
     D   max_entries                       like(StdInt) value
     D   mxhost                     256A   dim(50) options(*varsize)
     D   mxpty                             dim(50) options(*varsize)
     D                                     like(StdUnsSml)

     D MAX_ENTRIES_ALLOWED...
     D                 C                   CONST(50)

     D C_ANY           C                   CONST(255)
     D C_IN            C                   CONST(1)

     D T_A             C                   CONST(1)
     D T_NS            C                   CONST(2)
     D T_CNAME         C                   CONST(5)
     D T_SOA           C                   CONST(6)
     D T_WKS           C                   CONST(11)
     D T_PTR           C                   CONST(12)
     D T_HINFO         C                   CONST(13)
     D T_MX            C                   CONST(15)
     D T_TXT           C                   CONST(16)
     D T_ANY           C                   CONST(255)

     D HFIXEDSZ        C                   CONST(12)
     D QFIXEDSZ        C                   CONST(4)

     D p_dns_HEADER    S                   like(StdPtr)

     D dns_HEADER      DS                  based(p_dns_HEADER)
     D  dns_id                             like(StdUnsSml)
     D  dns_bitflds                   2A
     D  dns_qdcount                        like(StdUnsSml)
     D  dns_ancount                        like(StdUnsSml)
     D  dns_nscount                        like(StdUnsSml)
     D  dns_arcount                        like(StdUnsSml)

     D res_search      PR                  extproc('res_search')
     D                                     like(StdInt)
     D   domain_name                       options(*string)
     D                                     like(StdPtr) value
     D   class                             like(StdInt) value
     D   type                              like(StdInt) value
     D   answer_buf                        like(StdPtr) value
     D   ans_buf_len                       like(StdInt) value

     D dn_skipname     PR                  extproc('dn_skipname')
     D                                     like(StdInt)
     D   comp_dn                           like(StdPtr) value
     D   end_of_msg                        like(StdPtr) value

     D dn_expand       PR                  extproc('dn_expand')
     D                                     like(StdInt)
     D  start_dns_pkt                      like(StdPtr) value
     D  end_dns_pkt                        like(StdPtr) value
     D  comp_dn                            like(StdPtr) value
     D  expanded_dn                        like(StdPtr) value
     D  bufsize                            like(StdInt) value

     D rc              S                   like(StdInt) inz
     D answer          S           2048A
     D cp              S                   like(StdPtr)
     D end             S                   like(StdPtr)
     D namebuf         S            256A
     D n               S                   like(StdInt) inz
     D entries         S                   like(StdInt) inz
     D type            S                   like(StdUnsSml)
     D class           S                   like(StdUnsSml)
     D ttl             S                   like(StdUns)
     D size            S                   like(StdUnsSml)
     D pri             S                   like(StdUnsSml)

     c                   if        max_entries > MAX_ENTRIES_ALLOWED
     c                   return    -1
     c                   endif
      *---------------------------------------------------------
     c* Perform a DNS search for domain by MX record
      *---------------------------------------------------------
     c                   eval      rc = res_search(domain: C_IN:T_MX:
     c                                     %addr(answer):
     c                                     %size(answer))
     c                   if        rc < 0
     c                   return    -1
     c                   endif
      *---------------------------------------------------------
     C*  Parse the returned DNS record, and place entries into the
     C*  mxpty and mxhost arrays
      *---------------------------------------------------------
     C* just to make sure we don't overflow our buffer if
     C*  and invalid packet length is given to us:
     c                   if        rc > %size(answer)
     c                   eval      rc = %size(answer)
     c                   endif

     c* intialize pointers & misc
     c                   eval      p_dns_HEADER = %addr(answer)
     c                   eval      cp = %addr(answer) + HFIXEDSZ
     c                   eval      end = %addr(answer) + rc
     c                   eval      entries = 0

     c* skip over the question records:
     c*
     c                   do        dns_qdcount
     c                   if        cp >= end
     c                   leave
     c                   endif

     c                   eval      n = dn_skipname(cp: end)

     c                   if        n < 0
     c                   return    -1
     c                   endif

     c                   eval      cp = cp + n + QFIXEDSZ
     c                   enddo

     C*   each answer record in the buffer consists of (for MX):
     c                   do        dns_ancount
     c                   if        cp >= end
     c                   leave
     c                   endif
     c                   eval      n = dn_expand(p_dns_HEADER: end: cp:
     c                                   %addr(namebuf):
     c                                   %size(namebuf))
     c                   eval      cp   += n
     c                   eval      type  = GetInt16(cp)
     c                   eval      class = GetInt16(cp)
     c                   eval      ttl   = GetInt32(cp)
     c                   eval      size  = GetInt16(cp)

     c                   if        type <> T_MX
     c                   eval      cp += size
     c                   iter
     c                   endif

     c                   eval      pri = GetInt16(cp)
     c                   eval      n = dn_expand(p_dns_HEADER: end: cp:
     c                                   %addr(namebuf):
     c                                   %size(namebuf))
     c                   eval      cp += n

     c                   if        entries < MAX_ENTRIES
     c                   eval      entries += 1
     c                   eval      mxpty(entries) = pri
     c                   eval      mxhost(entries) =
     c                             %str(%addr(namebuf))
     c                   endif
     c                   enddo

     c                   return    entries

     P GetMX           E
      ***********************************************************
      *  GetInt16() -- Get Short Interger
      *  -- gets short int, and advances the pointer.
      ***********************************************************
     P GetInt16        B

     D GetInt16        PI                  like(StdUnsSml)
     D    ptr                              like(StdPtr)

     D p_short         s                   like(StdPtr)
     D value           s                   based(p_short)
     D                                     like(StdUnsSml)

     c                   eval      p_short = ptr
     c                   eval      ptr    +=   %size(value)
     c                   return    value

     P GetInt16        E
      ***********************************************************
      *  GetInt32() -- Get Interger
      *  -- gets int, and advances the pointer.
      ***********************************************************
     P GetInt32        B

     D GetInt32        PI                  like(StdUns)
     D    ptr                              like(StdPtr)

     D p_int           s                   like(StdPtr)
     D value           s                   based(p_int)
     D                                     like(StdUns)

     c                   eval      p_int = ptr
     c                   eval      ptr  += %size(value)
     c                   return    value

     P GetInt32        E
