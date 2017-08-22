      /if not defined(UT8071S)
      /define UT8071S

      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Socket prototypes.
     ‚*
     ‚*  Notes   :  Sockets code copied from Scott Klement (c) 2001
     ‚*              at klement.dstorm.net/rpg/socktut/tutorial.html
     ‚*
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  C O N S T A N T S
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     D IPVERSION       C                   const(4)

      * Address families.
      *  Only Internet will be included for now...
      *  If you intend to use other than IP sockets
      *  you will have to add them in yourself.
      *
     D AF_INET         C                   const(2)

      * Socket Types:
      *                                             stream socket (TCP)
     D SOCK_STREAM     C                   const(1)
      *                                             datagram socket (UDP)
     D SOCK_DGRAM      C                   const(2)
      *                                             raw socket
     D SOCK_RAW        C                   const(3)


      ** Error initializing GSKit environment
     D**HTTP_GSKENVI    C                   const(25)
      ** Error opening GSKit environment
     D**HTTP_GSKENVO    C                   const(26)


      * Protocols...
      *   These are the commonly used protocols in
      *   the Internet Address Family.
      *
      *                                                Internet Protocol
     D IPPROTO_IP      C                   const(0)
      *                                                Transmission Control
      *                                                Protocol
     D IPPROTO_TCP     C                   const(6)
      *                                                Unordered Datagram
      *                                                Protocol
     D IPPROTO_UDP     C                   const(17)
      *                                                Raw Packets
     D IPPROTO_RAW     C                   const(255)
      *                                                Internet Control
      *                                                Msg Protocol
     D IPPROTO_ICMP    C                   const(1)
      *                                                socket layer
     D SOL_SOCKET      C                   const(-1)


      * IP-Level (IPPROTO_IP) options for setsockopt()/getsockopt()
      *   (Note: None of the multicast options are set here, but
      *     they probably should be)
      *                                                  ip options
     D IP_options      C                   const(5)
      *                                                  type of service
     D IP_TOS          C                   const(10)
      *                                                  time to live
     D IP_TTL          C                   const(15)
      *                                                  recv lcl ifc addr
     D IP_RECVLCLIFADDR...
     D                 C                   const(99)


      * TCP level (IPPROTO_TCP) options for setsockopt()/getsockopt()
      *                                          max segment size (MSS)
     D TCP_MAXSEG      C                   5
      *                                          dont delay small packets
     D TCP_NODELAY     C                   10


      * Socket-Level (SOL_SOCKET) options for setsockopt()/getsockopt()
      *                                          allow broadcast msgs
     D SO_BROADCAST    C                   5
      *                                          record debug information
     D SO_DEBUG        C                   10
      *                                          just use interfaces,
      *                                          bypass routing
     D SO_DONTROUTE    C                   15
      *                                          error status
     D SO_ERROR        C                   20
      *                                          keep connections alive
     D SO_KEEPALIVE    C                   25
      *                                          linger upon close
     D SO_LINGER       C                   30
      *                                          out-of-band data inline
     D SO_OOBINLINE    C                   35
      *                                          receive buffer size
     D SO_RCVBUF       C                   40
      *                                          receive low water mark
     D SO_RCVLOWAT     C                   45
      *                                          receive timeout value
     D SO_RCVTIMEO     C                   50
      *                                          re-use local address
     D SO_REUSEADDR    C                   55
      *                                          send buffer size
     D SO_SNDBUF       C                   60
      *                                          send low water mark
     D SO_SNDLOWAT     C                   65
      *                                          send timeout Value
     D SO_SNDTIMEO     C                   70
      *                                          socket type
     D SO_TYPE         C                   75
      *                                          send loopback
     D SO_USELOOPBACK  C                   80


      * Types of Service for IP packets
      *  These are indended to be used in the 'ip' data structure
      *  defined below.
      *                                                  normal
     D IPTOS_NORMAL    C                   const(x'00')
      *                                                  min cost
     D IPTOS_MIN       C                   const(x'02')
      *                                                  reliability
     D IPTOS_RELIABLE  C                   const(x'04')
      *                                                  throughput
     D IPTOS_THRUPUT   C                   const(x'08')
      *                                                  low-delay
     D IPTOS_LOWDELAY  C                   const(x'10')


      * Precedence for Types of Service
      *  These are indended to be used in the 'ip' data structure
      *  defined below.
      *                                                 net control
     D IPTOS_NET       C                   const(x'E0')
      *                                                 internet control
     D IPTOS_INET      C                   const(x'C0')
      *                                                 critic ecp
     D IPTOS_CRIT      C                   const(x'A0')
      *                                                 flash override
     D IPTOS_FOVR      C                   const(x'80')
      *                                                 flash
     D IPTOS_FLAS      C                   const(x'60')
      *                                                 immediate
     D IPTOS_IMME      C                   const(x'40')
      *                                                 priority
     D IPTOS_PTY       C                   const(x'20')
      *                                                 routine
     D IPTOS_ROUT      C                   const(x'10')


      * I/O flags (for send, sendto, recv, recvfrom functions)
      *                                               dont route
     D MSG_DONTROUTE   C                   const(1)
      *                                               out-of-band data
     D MSG_OOB         C                   const(4)
      *                                               keep data in buffer
     D MSG_PEEK        C                   const(8)


      * "Special" IP Address Values
      *                                                any address available
     D INADDR_ANY      C                   const(0)
      *                                                broadcast
     D INADDR_BROADCAST...
     D                 C                   const(4294967295)
      *                                                loopback/localhost
     D INADDR_LOOPBACK...
     D                 C                   const(2130706433)
      *                                                no address exists
     D INADDR_NONE     C                   const(4294967295)

      * ICMP message types
      *                                                  echo reply
     D ICMP_ECHOR      C                   const(x'00')
      *                                                  unreachable
     D ICMP_UNREA      C                   const(x'03')
      *                                                  source quench
     D ICMP_SRCQ       C                   const(x'04')
      *                                                  redirect
     D ICMP_REDIR      C                   const(x'05')
      *                                                  echo
     D ICMP_ECHO       C                   const(x'08')
      *                                                  time exceeded
     D ICMP_TIMX       C                   const(x'0B')
      *                                                  parameter problem
     D ICMP_PARM       C                   const(x'0C')
      *                                                  timestamp request
     D ICMP_TSTP       C                   const(x'0D')
      *                                                  timestamp req reply
     D ICMP_TSTPR      C                   const(x'0E')
      *                                                  info request
     D ICMP_IREQ       C                   const(x'0F')
      *                                                  info request reply
     D ICMP_IREQR      C                   const(x'10')
      *                                                  addr mask request
     D ICMP_MASK       C                   const(x'11')
      *                                                  addr mask req reply
     D ICMP_MASKR      C                   const(x'12')

      * ICMP subtype codes
      *                                                  network unreachable
     D UNR_NET         C                   const(x'00')
      *                                                  host unreachable
     D UNR_HOST        C                   const(x'01')
      *                                                  protocol unreachble
     D UNR_PROTO       C                   const(x'02')
      *                                                  port unreachable
     D UNR_PORT        C                   const(x'03')
      *                                                  fragmentation needed
      *                                                  and dont fragment
      *                                                  flag is set
     D UNR_FRAG        C                   const(x'04')
      *                                                  source route failed
     D UNR_SRCF        C                   const(x'05')
      *                                                  time exceeded in
      *                                                  transit
     D TIMX_INTRA      C                   const(x'00')
      *                                                  time exceeded in
      *                                                  frag reassembly
     D TIMX_REASS      C                   const(x'01')
      *                                                  redir for network
     D REDIR_NET       C                   const(x'00')
      *                                                  redir for host
     D REDIR_HOST      C                   const(x'01')
      *                                                  redir for TOS & Net
     D REDIR_TOSN      C                   const(x'02')
      *                                                  redir for TOS & Host
     D REDIR_TOSH      C                   const(x'03')

      * fcntl() commands
     D F_DUPFD         C                   const(0)
     D F_GETFL         C                   const(6)
     D F_SETFL         C                   const(7)
     D F_GETOWN        C                   const(8)
     D F_SETOWN        C                   const(9)

      * fcntl() flags

      /if not defined(O_NONBLOCK_PROTOTYPE)
     D O_NONBLOCK      C                   const(128)
      /define O_NONBLOCK_PROTOTYPE
      /endif

     D O_NDELAY        C                   const(128)
     D FNDELAY         C                   const(128)
     D FASYNC          C                   const(512)

      * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  D A T A    S T R U C T U R E S
      *
      *  Note that data structures here are all set up to be based on
      *  a pointer.  The reason for this is:
      *      1) Data structs that you don't use in your program won't
      *          have memory allocated to them.
      *      2) You can have different "instances" of each data struct
      *          simply by moving the pointer to a different area of
      *          memory.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
      * Socket Address (Generic, for any network type)
      *
      *   struct sockaddr {
      *       u_short sa_family;
      *       char    sa_data[14];
      *   };
      *
     D p_sockaddr      S                   like(StdPtr)
     D  SockAddr       DS                  based(p_sockaddr)
     D    SA_Family                        like(StdUnsSml)
     D    SA_Data                    14A


      *  Socket Address (Internet)
      *
      *   struct sockaddr_in {
      *      short           sin_family;
      *      u_short         sin_port;
      *      struct in_addr  sin_addr;
      *      char            sin_zero[8];
      *   };
      *
     D sockaddr_in     DS                  based(p_sockaddr)
     D   sin_Family                        like(StdIntSml)
     D   sin_Port                          like(StdUnsSml)
     D   sin_addr                          like(StdUns)
     D   sin_zero                     8A


      *
      * Host Database Entry (for DNS lookups, etc)
      *
      *   (this is a partial implementation... didn't try to
      *    figure out how to deal with all possible addresses
      *    or all possible aliases for a host in RPG)
      *
      *            struct hostent {
      *              char   *h_name;
      *              char    *h_aliases;
      *              int    h_addrtype;
      *              int    h_length;
      *              char    *h_addr_list;
      *            };
      *
      *           #define h_addr   h_addr_list[0]
      *
     D p_hostent       S                   like(StdPtr)
     D hostent         DS                  based(p_hostent)
     D   h_name                            like(StdPtr)
     D   h_aliases                         like(StdPtr)
     D   h_addrtype                        like(StdIntSml)
     D   h_length                          like(StdIntSml)
     D   h_addrlist                        like(StdPtr)
     D p_h_addr        S                   based(h_addrlist)
     D                                     like(StdPtr)
     D h_addr          S                   based(p_h_addr)
     D                                     like(StdUns)


      *
      * Service Database Entry (which service = which port, etc)
      *
      *            struct servent {
      *              char   *s_name;
      *              char    *s_aliases;
      *              int    s_port;
      *              char   *s_proto;
      *            };
      *
     D p_servent       S                   like(StdPtr)
     D servent         DS                  based(p_servent)
     D   s_name                            like(StdPtr)
     D   s_aliases                         like(StdPtr)
     D   s_port                            like(StdInt)
     D   s_proto                           like(StdPtr)


      *
      * IP structure without any opts (for RAW sockets)
      *
      *   struct ip {
      *       unsigned       ip_v:4;       Version (first 4 bits)
      *       unsigned       ip_hl:4;      Header length (next 4)
      *       u_char         ip_tos;       Type of service
      *       short          ip_len;       Total Length
      *       u_short        ip_id;        Identification
      *       short          ip_off;       Fragment offset field
      *       u_char         ip_ttl;       Time to live
      *       u_char         ip_p;         Protocol
      *       u_short        ip_sum;       Checksum
      *       struct in_addr ip_src;       Source Address
      *       struct in_addr ip_dst;       Destination Address
      *   };
      *
      *  Note:  Since you can't define a variable to be 4 bits long
      *     in RPG, ip_v_hl is a combination of ip_v and ip_hl.
      *     with mult/div/mvr and data structures, it should still
      *     be usable...
      *
      *  Since ip_tos & ip_ttl conflict with the definitions for
      *  setsockopt() & getsockopt(), we add an extra $ to the end...
     d p_ip            S                   like(StdPtr)
     D ip              DS                  based(p_ip)
     D   ip_v_hl                           like(StdChr)
     D   ip_tos$                           like(StdChr)
     D   ip_len                            like(StdIntSml)
     D   ip_id                             like(StdUnsSml)
     D   ip_off                            like(StdIntSml)
     D   ip_ttl$                           like(StdChr)
     D   ip_p                              like(StdChr)
     D   ip_sum                            like(StdUnsSml)
     D   ip_src                            like(StdUns)
     D   ip_dst                            like(StdUns)


      *
      * UDP Packet Header (for RAW sockets)
      *
      *   struct udphdr {                       /* UDP header             */
      *       u_short     uh_sport;             /* source port            */
      *       u_short     uh_dport;             /* destination port       */
      *       short       uh_ulen;              /* UDP length             */
      *       u_short     uh_sum;               /* UDP checksum           */
      *   };
      *
     d p_udphdr        S                   like(StdPtr)
     d udphdr          DS                  based(p_udphdr)
     D  uh_sport                           like(StdUnsSml)
     D  uh_dport                           like(StdUnsSml)
     D  uh_ulen                            like(StdIntSml)
     D  uh_sum                             like(StdUnsSml)


      * Internet Control Message Protocol (ICMP) header
      *   (I THINK I did the unions correctly...  but you might want to
      *    check that out if you're having problems...)
      *
      *   struct icmp {                     /* ICMP header                */
      *       u_char      icmp_type;        /* ICMP message type          */
      *       u_char      icmp_code;        /* type sub code              */
      *       u_short     icmp_cksum;       /* ICMP checksum              */
      *       union {                       /* Message type substructures:*/
      *           u_char ih_pptr;           /*   Parameter problem pointer*/
      *           struct in_addr ih_gwaddr; /*   Redirect gateway address */
      *           struct ih_idseq {         /*   Echo/Timestmp Req/Reply  */
      *               u_short     icd_id;   /*      Indentifier           */
      *               u_short     icd_seq;  /*      Sequence number       */
      *           } ih_idseq;
      *           int ih_void;              /* Unused part of some msgs   */
      *       } icmp_hun;
      *       union {
      *           struct id_ts {            /* Timestamp substructure     */
      *               u_long its_otime;     /*    Originate timestamp     */
      *               u_long its_rtime;     /*    Receive timestamp       */
      *               u_long its_ttime;     /*    Transmit timestamp      */
      *           } id_ts;
      *           struct id_ip  {           /* Imbedded 'original' IP hdr */
      *               struct ip idi_ip;     /* in ICMP error-type msgs.   */
      *                                     /* Includes IP header,IP opts,*/
      *                                     /* and 64 bits of data.       */
      *           } id_ip;
      *           u_long  id_mask;          /* Address mask request/reply */
      *           char    id_data[1];       /* Beginning of echo req data */
      *       } icmp_dun;
      *   };
     D p_icmp          S                   like(StdPtr)
     D icmp            DS                  based(p_icmp)
     D  icmp_type                          like(StdChr)
     D  icmp_code                          like(StdChr)
     D  icmp_cksum                         like(StdUnsSml)
     D  icmp_hun                      4A
     D    ih_gwaddr                        overlay(icmp_hun:1)
     D                                     like(StdUns)
     D    ih_pptr                          overlay(icmp_hun:1)
     D                                     like(StdChr)
     D    ih_idseq                    4A   overlay(icmp_hun:1)
     D      icd_id                         overlay(ih_idseq:1)
     D                                     like(StdUnsSml)
     D      icd_seq                        overlay(ih_idseq:3)
     D                                     like(StdUnsSml)
     D    ih_void                          overlay(icmp_hun:1)
     D                                     like(StdIntSml)
     D  icmp_dun                     20A
     D    id_ts                      12A   overlay(icmp_dun:1)
     D      its_otime                      overlay(id_ts:1)
     D                                     like(StdUns)
     D      its_rtime                      overlay(id_ts:5)
     D                                     like(StdUns)
     D      its_ttime                      overlay(id_ts:9)
     D                                     like(StdUns)
     D    id_ip                      20A   overlay(icmp_dun:1)
     D      idi_ip                   20A   overlay(id_ip:1)
     D    id_mask                          overlay(icmp_dun:1)
     D                                     like(StdUns)
     D    id_data                          overlay(icmp_dun:1)
     D                                     like(StdChr)


      *
      * Time Value Structure (for the select() function, etc)
      *
      *      struct timeval {
      *         long  tv_sec;                  /* seconds       */
      *         long  tv_usec;                 /* microseconds  */
      *      };
      *
      *   contrains a structure for specifying a wait time on
      *   a select() function...
      *
      *    tv_sec = seconds.    tv_usec = microseconds
      *
     D p_timeval       S                   like(StdPtr)
     D timeval         DS                  based(p_timeval)
     D   tv_sec                            like(StdInt)
     D   tv_usec                           like(StdInt)


      *  linger structure   (used with setsockopt or getsockopt)
      *
      *     struct linger {
      *          int   l_onoff;       /* Option Setting ON/OFF */
      *          int   l_linger;      /* Time to linger in seconds */
      *     };
      *
     D p_linger        S                   like(StdPtr)
     D linger          DS                  based(p_linger)
     D   l_onoff                           like(StdInt)
     D   l_linger                          like(StdInt)


      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
      *  S U B P R O C E D U R E   P R O T O T Y P E S
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **
      /if not defined(InitSSL)
     D InitSSL         PR                  like(StdInd)
     D   AppID                      100A   const
      /endif
      * --------------------------------------------------------------------
      *
      *    socket--Create Socket
      *
      *    int  socket(int address_family,
      *                int type,
      *                int protocol)
      *
      *
      *     The socket() function is used to create an end point for
      *        communications.  The end point is represented by the
      *        socket descriptor returned by the socket() function.
      *
      * --------------------------------------------------------------------
     D socket          PR                  ExtProc('socket')
     D                                     like(StdInt)
     D   AddrFamily                        like(StdInt) value
     D   SocketType                        like(StdInt) value
     D   Protocol                          like(StdInt) value


      * --------------------------------------------------------------------
      *
      *    setsockopt()--Set Socket options
      *
      *    int  setsockopt(int socket_descriptor,
      *                    int level,
      *                    int option_name,
      *                    char *option_Value
      *                    int option_length)
      *
      *    The setsockopt() function is used to set socket options
      *     (there are many, see the book.)
      * --------------------------------------------------------------------
     D setsockopt      PR                  ExtProc('setsockopt')
     D                                     like(StdInt)
     D   SocketDesc                        like(StdInt) value
     D   Opt_Level                         like(StdInt) value
     D   Opt_Name                          like(StdInt) value
     D   Opt_Value                         like(StdPtr) value
     D   Opt_Len                           like(StdInt) value


      * --------------------------------------------------------------------
      *   getsockopt() -- Retrieve Info about Socket options
      *
      *   int getsockopt(int socket_descriptor,
      *                  int level,
      *                  int option_name,
      *                  char *option_Value,
      *                  int *option_length)
      *
      *   Gets various information about the socket's options.
      *   (there are many, see the book.)
      * --------------------------------------------------------------------
     D getsockopt      PR                  extproc('getsockopt')
     D                                     like(StdInt)
     D   SocketDesc                        like(StdInt) value
     D   Opt_Level                         like(StdInt) value
     D   Opt_Name                          like(StdInt) value
     D   Opt_Value                         like(StdPtr) value
     D   Opt_Length                        like(StdInt)


      * --------------------------------------------------------------------
      *
      *    getsockname()--Get Local Address for Socket
      *
      *    int  getsockname(int socket_descriptor,
      *              struct sockaddr *local_address,
      *              int *address_length)
      *
      *           struct sockaddr {
      *              u_short sa_family;
      *              char    sa_data[14];
      *           };
      *
      *    The getsockname() function is used to retreive the local address
      *      asociated with a socket.
      * --------------------------------------------------------------------
     D getsockname     PR                  ExtProc('getsockname')
     D                                     like(StdInt)
     D   SocketDesc                        like(StdInt) value
     D   p_sockaddr                        like(StdPtr) value
     D   AddrLength                        like(StdPtr) value


      *
      * --------------------------------------------------------------------
      *
      *    getpeername()--Retrieve Destination Address of Socket
      *
      *    int  getpeername(int socket_descriptor,
      *                     struct sockaddr *local_address,
      *                     int *address_length)
      *
      *           struct sockaddr {
      *              u_short sa_family;
      *              char    sa_data[14];
      *           };
      *
      *
      *    The getpeername() function is used to retreive the destination
      *      address to which the socket is connected.
      *
      *    Note:  Socket must be connected first.
      *
      * --------------------------------------------------------------------
     D getpeername     PR                  ExtProc('getpeername')
     D                                     like(StdInt)
     D   SocketDesc                        like(StdInt) value
     D   p_sockaddr                        like(StdPtr) value
     D   AddrLength                        like(StdInt)


      * --------------------------------------------------------------------
      *    bind()--Bind socket to specified adapter and/or port
      *
      *    int  bind(int socket_descriptor,
      *              struct sockaddr *local_address,
      *              int address_length)
      *
      *           struct sockaddr {
      *              u_short sa_family;
      *              char    sa_data[14];
      *           };
      *
      *
      *    The bind() function is used to associate a local address
      *      and port with a socket.   This allows you to get only
      *      socket requests on a specific network adapter, and to
      *      assign a specific port to your socket.
      *    For example, if you're writing a telnet server, you'd
      *      bind to port 23, because thats the standard port for
      *      telnets to listen on.
      *    If we bind to an address of 0, it will allow requests on
      *      any (TCP/IP enabled) network adapter.
      *
      * --------------------------------------------------------------------
     D bind            PR                  ExtProc('bind')
     D                                     like(StdInt)
     D   Sock_Desc                         like(StdInt) value
     D   p_Address                         like(StdPtr) value
     D   AddressLen                        like(StdInt) value


      * --------------------------------------------------------------------
      *    listen()--Invite Incoming Connections Requests
      *
      *    int  listen(int socket_descriptor,
      *                 int back_log)
      *
      *
      *    The listen() function is used to indicate a willingness to accept
      *       incoming connection requests.  if a listen() is not done,
      *       incoming requests are refused.
      *
      * --------------------------------------------------------------------
     D listen          PR                  ExtProc('listen')
     D                                     like(StdInt)
     D   SocketDesc                        like(StdInt) value
     D   Back_Log                          like(StdInt) value


      * --------------------------------------------------------------------
      *    accept()--Wait for Connection Request and Make Connection
      *
      *    int  accept(int socket_descriptor,
      *              struct sockaddr *address,
      *              int *address_length)
      *
      *           struct sockaddr {
      *              u_short sa_family;
      *              char    sa_data[14];
      *           };
      *
      *   The accept() function is used to wait for connection requests.
      *    accept() takes the first connection request on the queue of
      *    pending connection requests and creates a new socket to service
      *    the connection request.
      *
      * --------------------------------------------------------------------
     D accept          PR                  ExtProc('accept')
     D                                     like(StdInt)
     D   Sock_Desc                         like(StdInt) value
     D   p_Address                         like(StdPtr) value
     D   p_AddrLen                         like(StdInt)


      * --------------------------------------------------------------------
      *   connect() -- Connect to a host.
      *
      *      int connect(int socket_descriptor,
      *                  struct sockaddr *destination,
      *                  int address_length)
      *
      *      Used to connect to a host.  (Usually used on the client-side)
      *      In TCP applications, this takes an address & port and connects
      *      to a server program thats listening on that port.   In UDP
      *      this simply specifies the address & port to send to.
      *
      * --------------------------------------------------------------------
     D connect         PR                  ExtProc('connect')
     D                                     like(StdInt)
     D   Sock_Desc                         like(StdInt) value
     D   p_SockAddr                        like(StdPtr) value
     D   AddressLen                        like(StdInt) value


      * --------------------------------------------------------------------
      *    send()--Send Data
      *
      *    int  send(int socket_descriptor,
      *              char *buffer,
      *              int  buffer_length,
      *              int  flags)
      *
      *    Sends data in buffer via socket connection to another program.
      *
      *    In the case of text, it should be converted to ASCII and then
      *    CR/LF terminated.
      *
      * --------------------------------------------------------------------
     D Send            PR                  ExtProc('send')
     D                                     like(StdInt)
     D   Sock_Desc                         like(StdInt) value
     D   p_Buffer                          like(StdPtr) value
     D   BufferLen                         like(StdInt) value
     D   Flags                             like(StdInt) value


      * --------------------------------------------------------------------
      *    sendto()--Send Data
      *
      *   int sendto(int socket_descriptor,
      *              char *buffer,
      *              int buffer_length,
      *              int flags,
      *              struct sockaddr *destination_address,
      *              int address_length)
      *
      *    Sends data in buffer via connected/connectionless sockets
      *
      *    This is more useful for connectionless sockets (such as UDP)
      *    because allows you to specify the destination address.
      *
      *    When used with a connection-oriented sockets (such as TCP)
      *    the destination address should be set to *NULL, and the length
      *    should be zero.
      *
      * --------------------------------------------------------------------
     D SendTo          PR                  ExtProc('sendto')
     D                                     like(StdInt)
     D   Sock_Desc                         like(StdInt) value
     D   p_Buffer                          like(StdPtr) value
     D   BufferLen                         like(StdInt) value
     D   Flags                             like(StdInt) value
     D   DestAddr                          like(StdPtr) value
     D   AddrLen                           like(StdInt) value


      * --------------------------------------------------------------------
      *    recv()--Receive Data
      *
      *    int  recv(int socket_descriptor,                 I
      *              char *buffer,                          I
      *              int  buffer_length,                    I
      *              int  flags)
      *
      *
      *   The recv() funcion is used to receive data through a socket.
      *
      * --------------------------------------------------------------------
     D Recv            PR                  ExtProc('recv')
     D                                     like(StdInt)
     D   Sock_Desc                         like(StdInt) value
     D   p_Buffer                          like(StdPtr) value
     D   BufferLen                         like(StdInt) value
     D   Flags                             like(StdInt) value


      * --------------------------------------------------------------------
      *    recvfrom()--Receive Data w/From Address
      *
      *    int  recvfrom(int socket_descriptor,
      *                 char *buffer,
      *                 int buffer_length,
      *                 int flags,
      *                 struct sockaddr *from_address,
      *                 int *address_length)
      *
      *
      *   The recvfrom() function receives data through a connected, or
      *   an unconnected socket.
      *
      *   This is particularly useful for UDP/Connectionless sockets
      *   because it allows you to ascertain who sent the data to you.
      *
      *   The from_address and address_length parms are ignored on
      *   connection-oriented sockets -- or if they are set to *NULL.
      * --------------------------------------------------------------------
     D RecvFrom        PR                  ExtProc('recvfrom')
     D                                     like(StdInt)
     D   Sock_Desc                         like(StdInt) value
     D   p_Buffer                          like(StdPtr) value
     D   BufferLen                         like(StdInt) value
     D   Flags                             like(StdInt) value
     D   FromAddr                          like(StdPtr) value
     D   AddrLength                        like(StdInt)


      * --------------------------------------------------------------------
      *    close()--End Socket Connection
      *
      *    int  close(int descriptor)
      *
      *    Ends a socket connection, and deletes the socket descriptor.
      *
      *  Note: Due to conflicts with IFSIO_H, we are only defining
      *        close() if it has not already been defined.
      * --------------------------------------------------------------------
      /if not defined(CLOSE_PROTOTYPE)
     D Close           PR                  ExtProc('close')
     D                                     like(StdInt)
     D   Sock_Desc                         like(StdInt) value
      /define CLOSE_PROTOTYPE
      /endif


      * --------------------------------------------------------------------
      *    shutdown()-- disable reading/writing on a socket
      *
      *    int  shutdown(int descriptor,
      *                  int how)
      *
      *    Stops all reading and/or writing on a socket.
      *    Difference between this and close() is that with close, you
      *    actually delete the descriptor, and must accept() a new one,
      *    or allocate (socket()) a new one.
      *
      *    The how parameter can be:
      *            0 = no more data can be received
      *            1 = no more data can be sent
      *            2 = no more data can be sent or received
      *
      * --------------------------------------------------------------------
     D shutdown        PR                  ExtProc('shutdown')
     D                                     like(StdInt)
     D   Sock_Desc                         like(StdInt) value
     D   How                               like(StdInt) value


      * --------------------------------------------------------------------
      *  select() -- wait for events on multiple sockets
      *
      *   int select(int max_descriptor,
      *              fd_set *read_set,
      *              fd_set *write_set,
      *              fd_set *exception_set,
      *              struct timeval *wait_time)
      *
      *   Select is used to wait for i/o on multiple sockets.  This
      *   prevents your job from "blocking" on one socket read, while
      *   there is data to read on another socket.
      *
      *   It also allows you to "poll" for data to be found on a socket
      *   and to set a timeout Value to keep your application from
      *   stopping forever on a "dead-end" socket.
      *
      *    * ** To help with managing the descriptor sets, I have
      *    * ** created FD_SET, FD_ISSET, FD_CLR and FD_ZERO functions
      *    * ** in my SOCKUTIL_H/SOCKUTILR4 socket utilities functions!
      *
      *   max_desriptor = The number of descriptors in your sets.
      *                   (take the highest descriptor Value you want
      *                   to wait on, and add 1, and put it here)
      *
      *   read_set = A 28-byte character field specifying, on input,
      *                 which descriptors to wait for, and, on output,
      *                 which descriptors have data waiting on them.
      *                 This can be set to *NULL if you do not wish to
      *                 wait for any sockets to be read.
      *
      *  write_set = A 28-byte character field specifying, on input,
      *                 which descriptors to wait for, and, on output,
      *                 which descriptors are ready to be written to.
      *                 This can be set to *NULL if you do not wish to
      *                 wait for any sockets to be written to.
      *
      *  exception_set = A 28-byte character field specifying, on input,
      *                 which descriptors to test, and on output,
      *                 which descriptors have exceptions signalled to them.
      *                 This can be set to *NULL if you do not wish to
      *                 check for any sockets to have exceptions.
      *
      *                 NOTE: An exception is not the same as an error.
      *                       Exceptions are usually out-of-band data!
      *
      *  wait_time = a timeval data structure containing the amoutn of
      *                 time to wait for an event to occur.
      *                 If a wait time of zero is given, select() will
      *                 return immediately.
      *              If *NULL is passed instead of the timeval structure,
      *                 select() will wait indefinitely.
      *
      *  Returns the number of descriptors that met selection criteria
      *           or 0 for timeout
      *           or -1 for error.
      * --------------------------------------------------------------------
     D Select          PR                  extproc('select')
     D                                     like(StdInt)
     D   max_desc                          like(StdInt) value
     D   read_set                          like(StdPtr) value
     D   write_set                         like(StdPtr) value
     D   except_set                        like(StdPtr) value
     D   wait_Time                         like(StdPtr) value


      * --------------------------------------------------------------------
      *   givedescriptor() -- Pass Descriptor Access to Another Job
      *
      *   int givedescriptor(int descriptor,
      *                      char *target_job)
      *
      *   Allows you to pass a descriptor from one OS/400 job to another.
      *   (Very useful if you wanted one job to wait for incoming conn.
      *   then, submit a seperate job to deal with each client connection
      *   while the original keeps waiting for more)
      *
      *   It is the programmer's responsibility to alert the target job
      *   that it needs to take the descriptor, using takedescriptor().
      *
      *   the info for the target job can be obtained by calling a Work
      *   Managment API that supplies an "internal job identifier"
      *   (such as QUSRJOBI)
      *
      *   returns 0 = success, -1 = failure
      * --------------------------------------------------------------------
     D givedescriptor  PR                  extproc('givedescriptor')
     D                                     like(StdInt)
     D   SockDesc                          like(StdInt) value
     D   Target_Job                        like(StdPtr) value


      * --------------------------------------------------------------------
      *   takedescriptor() -- Receive Descriptor Access from Another Job
      *
      *   int takedescriptor(char *source_job)
      *
      *   Allows you to pass a descriptor from one OS/400 job to another.
      *   (Very useful if you wanted one job to wait for incoming conn.
      *   then, submit a seperate job to deal with each client connection
      *   while the original keeps waiting for more)
      *
      *   the info for the source job can be obtained by calling a Work
      *   Managment API that supplies an "internal job identifier"
      *   (such as QUSRJOBI).
      *
      *   You can also specify *NULL pointer for the Source_Job parm if
      *   you want to receive a descriptor from ANY job that gives one
      *   one to you.
      *
      *   If no other jobs has referenced yours with givedescriptor()
      *   then this function will block.
      *
      *   return Value is the socket descriptor taken, or -1 for error.
      * --------------------------------------------------------------------
     D takedescriptor  PR                  extproc('takedescriptor')
     D                                     like(StdInt)
     D   Source_Job                        like(StdPtr) value


      * --------------------------------------------------------------------
      *   gethostbyname() -- Resolves a domain name to an IP address
      *
      *      struct hostent *gethostbyname(char *host_name)
      *
      *            struct hostent {
      *              char   *h_name;
      *              char    *h_aliases;
      *              int    h_addrtype;
      *              int    h_length;
      *              char    *h_addr_list;
      *            };
      *
      *   Returns a pointer to a host entry structure.  The aliases and
      *   address list items in the structure are pointers to arrays of
      *   pointers, which are null terminated.
      *
      *   Note:  The strings & arrays used in C are often variable length,
      *       null-terminated entities.  Be careful to only use bytes from
      *       the returned pointers (in the hostent data structure) to
      *       the first null (x'00') character.
      * --------------------------------------------------------------------
     D gethostbyname   PR                  extProc('gethostbyname')
     D                                     like(StdPtr)
     D  HostName                           like(StdPtr) value
     D                                     options(*string)


      * --------------------------------------------------------------------
      *    getservbyname()--Get Port Number for Service Name
      *
      *    struct servent *getservbyname(char *service_name,
      *                                  char *protocol_name)
      *
      *            struct servent {
      *              char   *s_name;
      *              char    *s_aliases;
      *              int    s_port;
      *              char   *s_proto;
      *            };
      *
      *   This is generally used to look up which port is used for a given
      *   internet service.   i.e. if you want to know the port for
      *   TELNET, you'd do   x = getservbyname('telnet': 'tcp')
      * --------------------------------------------------------------------
     D getservbyname   PR                  extproc('getservbyname')
     D                                     like(StdPtr)
     D   service_name                      like(StdPtr) value
     D                                     options(*string)
     D   protocol_nam                      like(StdPtr) value
     D                                     options(*string)


      * --------------------------------------------------------------------
      *    gethostbyaddr()--Get Host Information for IP Address
      *
      *     struct hostent *gethostbyaddr(char *host_address,
      *                                   int address_length,
      *                                   int address_type)
      *         struct hostent {
      *             char   *h_name;
      *             char    *h_aliases;
      *             int    h_addrtype;
      *             int    h_length;
      *             char    *h_addr_list;
      *         };
      *
      *     An IP address (32-bit integer formnat) goes in, and a
      *     hostent structure pops out.   Really, kinda fun, if you
      *     havent already learned to hate the hostent structure, that is.
      *
      *   Note:  The strings & arrays used in C are often variable length,
      *       null-terminated entities.  use caution to only use data from
      *       the returned pointer up until the terminating null (x'00')
      *
      * --------------------------------------------------------------------
     D gethostbyaddr   PR                  ExtProc('gethostbyaddr')
     D                                     like(StdPtr)
     D  IP_Address                         like(StdUns)
     D  Addr_Len                           like(StdInt) value
     D  Addr_Fam                           like(StdInt) value


      * --------------------------------------------------------------------
      *    inet_addr()--Converts an address from dotted-decimal format
      *         to a 32-bit IP address.
      *
      *         unsigned long inet_addr(char *address_string)
      *
      *    Converts an IP address from format 192.168.0.100 to an
      *    unsigned long, such as hex x'C0A80064'.
      *
      *  returns INADDR_NONE on error.
      *
      * KNOWN BUG: Due to the fact that this can't return a negative Value,
      *              it returns x'FFFFFFFF' on error.  However, x'FFFFFFFF'
      *              is also the correct IP for the valid address of
      *              "255.255.255.255".  (which is "worldwide broadcast")
      *              A reasonable workaround is to check for 255.255.255.255
      *              beforehand, and translate it manually rather than
      *              calling inet_addr.
      * --------------------------------------------------------------------
     D inet_addr       PR                  ExtProc('inet_addr')
     D                                     like(StdUns)
     D  char_addr                          like(StdPtr) value
     D                                     options(*string)


      * --------------------------------------------------------------------
      *    inet_ntoa()--Converts an address from 32-bit IP address to
      *         dotted-decimal format.
      *
      *         char *inet_ntoa(struct in_addr internet_address)
      *
      *    Converts from 32-bit to dotted decimal, such as, x'C0A80064'
      *    to '192.168.0.100'.  Will return NULL on error
      *
      *   Note:  The strings & arrays used in C are often variable length,
      *       null-terminated entities.  Make sure you only use bytes from
      *       the returned pointer to the first null (x'00') character.
      *
      * --------------------------------------------------------------------
     D inet_ntoa       PR                  ExtProc('inet_ntoa')
     D                                     like(StdPtr)
     D  ulong_addr                         like(StdUns) value


      * --------------------------------------------------------------------
      *   fcntl()--Change Descriptor Attributes
      *
      *   int fcntl(int descriptor, int command, ...)
      *
      *   The third parameter (when used with sockets) is also an
      *   integer passed by Value.. it specifies an argument for
      *   some of the commands.
      *
      *   commands supported in sockets are:
      *          F_GETFL -- Return the status flags for the descriptor
      *          F_SETFL -- Set status flags for the descriptor
      *                    (Arg =)status flags (ORed) to set.
      * (the commands below arent terribly useful in RPG)
      *          F_DUPFD -- Duplicate the descriptor
      *                    (Arg =)minimum Value that new descriptor can be
      *          F_GETOWN -- Return the process ID or group ID that's
      *                     set to receive SIGIO & SIGURG
      *          F_SETOWN -- Set the process ID or group ID that's
      *                     to receive SIGIO & SIGURG
      *                    (Arg =)process ID (or neg Value for group ID)
      *
      *  returns -1 upon error.
      *          successful Values are command-specific.
      * --------------------------------------------------------------------
      /if not defined(FCNTL_PROTOTYPE)
     D fcntl           PR                  ExtProc('fcntl')
     D                                     like(StdInt)
     D   SocketDesc                        like(StdInt) value
     D   Command                           like(StdInt) value
     D   Arg                               like(StdInt) value
     D                                     options(*nopass)
      /define FCNTL_PROTOTYPE
      /endif


      * --------------------------------------------------------------------
      * RdLine(): This reads one "line" of text data from a socket.
      *
      *   peSock = socket to read from
      *   peLine = a pointer to a variable to put the line of text into
      *   peLength = max possible length of data to stuff into peLine
      *   peXLate = (default: *OFF) Set to *ON to translate ASCII -> EBCDIC
      *   peLF (default: x'0A') = line feed character.
      *   peCR (default: x'0D') = carriage return character.
      *
      *  returns length of data read, or -1 upon error
      * --------------------------------------------------------------------
     D RdLine          PR                  like(StdInt)
     D   peSock                            like(StdInt) value
     D   peLine                            like(StdPtr) value
     D   peLength                          like(StdInt) value
     D   peXLate                           like(StdChr) const
     D                                     options(*nopass)
     D   peLF                              like(StdChr) const
     D                                     options(*nopass)
     D   peCR                              like(StdChr) const
     D                                     options(*nopass)


      * --------------------------------------------------------------------
      *  WrLine() -- Write a line of text to a socket:
      *
      *      peSock = socket descriptor to write to
      *      peLine = line of text to write to
      *    peLength = length of line to write (before adding CRLF)
      *            you can pass -1 to have this routine calculate
      *            the length for you (which is the default!)
      *     peXlate = Pass '*ON' to have the routine translate
      *            this data to ASCII (which is the default) or *OFF
      *            to send it as-is.
      *      peEOL1 = First character to send at end-of-line
      *            (default is x'0D')
      *      peEOL2 = Second character to send at end-of-line
      *            (default is x'0A' if neither EOL1 or EOL2 is
      *            passed, or to not send a second char is EOL1
      *            is passed by itself)
      *
      * Returns length of data sent (including end of line chars)
      *    returns a short count if it couldnt send everything
      *    (if you're using a non-blocking socket) or -1 upon error
      * --------------------------------------------------------------------
     D WrLine          PR                  like(StdInt)
     D  peSock                             like(StdInt) value
     D  peLine                     1024A   const
     D  peLength                           like(StdInt) value
     D                                     options(*nopass)
     D  peXLate                            like(StdChr) const
     D                                     options(*nopass)
     D  peEOL1                             like(StdChr) const
     D                                     options(*nopass)
     D  peEOL2                             like(StdChr) const
     D                                     options(*nopass)


      * --------------------------------------------------------------------
      * Set a File Descriptor in a set ON...  for use w/Select()
      *
      *      peFD = descriptor to set on
      *      peFDSet = descriptor set
      * --------------------------------------------------------------------
     D FD_SET          PR
     D   peFD                              like(StdInt)
     D   peFDSet                     28A


      * --------------------------------------------------------------------
      * Set a File Descriptor in a set OFF...  for use w/Select()
      *
      *      peFD = descriptor to set off
      *      peFDSet = descriptor set
      * --------------------------------------------------------------------
     D FD_CLR          PR
     D   peFD                              like(StdInt)
     D   peFDSet                     28A


      * --------------------------------------------------------------------
      * Determine if a file desriptor is on or off...
      *
      *      peFD = descriptor to test
      *      peFDSet = descriptor set
      *
      *   Returns *ON if its on, or *OFF if its off.
      * --------------------------------------------------------------------
     D FD_ISSET        PR                  like(StdInd)
     D   peFD                              like(StdInt)
     D   peFDSet                     28A


      * --------------------------------------------------------------------
      * Clear All descriptors in a set.  (also initializes at start)
      *
      *      peFDSet = descriptor set
      * --------------------------------------------------------------------
     D FD_ZERO         PR
     D   peFDSet                     28A

      * --------------------------------------------------------------------
      *  data type of a file descriptor set:
      * --------------------------------------------------------------------
     D fdset           S             28A

      /endif
