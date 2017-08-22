      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Error prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      /if not defined(ERRNO_LOAD_PROCEDURE)

      *----------------------------------------------------------
      * error constant definitions
      *----------------------------------------------------------

      * these values come originally from file QCLE/H member ERRNO

      * domain error in math function
     D EDOM            C                   3001
      * range error in math function
     D ERANGE          C                   3002
      * truncation on I/O operation
     D ETRUNC          C                   3003
      * file has not been opened
     D ENOTOPEN        C                   3004
      * file not opened for read
     D ENOTREAD        C                   3005
      * file opened for record I/O
     D ERECIO          C                   3008
      * file not opened for write
     D ENOTWRITE       C                   3009
      * stdin cannot be opened
     D ESTDIN          C                   3010
      * stdout cannot be opened
     D ESTDOUT         C                   3011
      * stderr cannot be opened
     D ESTDERR         C                   3012
      * bad offset to seek to
     D EBADSEEK        C                   3013
      * invalid file name specified
     D EBADNAME        C                   3014
      * invalid file mode specified
     D EBADMODE        C                   3015
      * invalid position specifier
     D EBADPOS         C                   3017
      * no record at specified position
     D ENOPOS          C                   3018
      * no ftell if more than 1 member
     D ENUMMBRS        C                   3019
      * no ftell if too many records
     D ENUMRECS        C                   3020
      * invalid function pointer
     D EBADFUNC        C                   3022
      * record not found
     D ENOREC          C                   3026
      * message data invalid
     D EBADDATA        C                   3028
      * bad option on I/O function
     D EBADOPT         C                   3040
      * file not opened for update
     D ENOTUPD         C                   3041
      * file not opened for delete
     D ENOTDLT         C                   3042
      * padding occurred on write operation
     D EPAD            C                   3043
      * bad key length option
     D EBADKEYLN       C                   3044
      * illegal write after read
     D EPUTANDGET      C                   3080
      * illegal read after write
     D EGETANDPUT      C                   3081
      * I/O exception non-recoverable error
     D EIOERROR        C                   3101
      * I/O exception recoverable error
     D EIORECERR       C                   3102

      * The following were taken from QSYSINC/SYS ERRNO:

      *  Permission denied.
     D EACCES          C                   3401
      *  Not a directory.
     D ENOTDIR         C                   3403
      *  No space available.
     D ENOSPC          C                   3404
      *  Improper link.
     D EXDEV           C                   3405
      *  Operation would have caused the process
     D EWOULDBLOCK     C                   3406
      *  Operation would have caused the process
     D EAGAIN          C                   3406
      *  Interrupted function call.
     D EINTR           C                   3407
      *  The address used for an argument was no
     D EFAULT          C                   3408
      *  Operation timed out
     D ETIME           C                   3409
      *  No such device or address
     D ENXIO           C                   3415
      *  Socket closed
     D ECLOSED         C                   3417
      *  Address already in use.
     D EADDRINUSE      C                   3420
      *  Address not available.
     D EADDRNOTAVAIL   C                   3421
      *  The type of socket is not supported in
     D EAFNOSUPPORT    C                   3422
      *  Operation already in progress.
     D EALREADY        C                   3423
      *  Connection ended abnormally.
     D ECONNABORTED    C                   3424
      *  A remote host refused an attempted conn
     D ECONNREFUSED    C                   3425
      *  A connection with a remote socket was r
     D ECONNRESET      C                   3426
      *  Operation requires destination address.
     D EDESTADDRREQ    C                   3427
      *  A remote host is not available.
     D EHOSTDOWN       C                   3428
      *  A route to the remote host is not avail
     D EHOSTUNREACH    C                   3429
      *  Operation in progress.
     D EINPROGRESS     C                   3430
      *  A connection has already been establish
     D EISCONN         C                   3431
      *  Message size out of range.
     D EMSGSIZE        C                   3432
      *  The network is not currently available.
     D ENETDOWN        C                   3433
      *  A socket is connected to a host that is
     D ENETRESET       C                   3434
      *  Cannot reach the destination network.
     D ENETUNREACH     C                   3435
      *  There is not enough buffer space for th
     D ENOBUFS         C                   3436
      *  The protocol does not support the speci
     D ENOPROTOOPT     C                   3437
      *  Requested operation requires a connecti
     D ENOTCONN        C                   3438
      *  The specified descriptor does not refer
     D ENOTSOCK        C                   3439
      *  Operation not supported.
     D ENOTSUP         C                   3440
      *  Operation not supported.
     D EOPNOTSUPP      C                   3440
      *  The socket protocol family is not suppo
     D EPFNOSUPPORT    C                   3441
      *  No protocol of the specified type and d
     D EPROTONO...
     DSUPPORT          C                   3442
      *  The socket type or protocols are not co
     D EPROTOTYPE      C                   3443
      *  An error indication was sent by the pee
     D ERCVDERR        C                   3444
      *  Cannot send data after a shutdown.
     D ESHUTDOWN       C                   3445
      *  The specified socket type is not suppor
     D ESOCKTNO...
     D SUPPORT         C                   3446
      *  A remote host did not respond within th
     D ETIMEDOUT       C                   3447
      *  The protocol required to support the sp
     D EUNATCH         C                   3448
      *  Descriptor not valid.
     D EBADF           C                   3450
      *  Too many open files for this process.
     D EMFILE          C                   3452
      *  Too many open files in the system.
     D ENFILE          C                   3453
      *  Broken pipe.
     D EPIPE           C                   3455
      *  File exists.
     D EEXIST          C                   3457
      *  Resource deadlock avoided.
     D EDEADLK         C                   3459
      *  Storage allocation request failed.
     D ENOMEM          C                   3460
      *  The synchronization object no longer ex
     D EOWNERTERM      C                   3462
      * The synchronization object was destroyed
     D EDESTROYED      C                   3463
      *  Operation terminated.
     D ETERM           C                   3464
      *  Maximum link count for a file was excee
     D EMLINK          C                   3468
      *  Seek request not supported for object.
     D ESPIPE          C                   3469
      *  Function not implemented.
     D ENOSYS          C                   3470
      *  Specified target is a directory.
     D EISDIR          C                   3471
      *  Read-only file system.
     D EROFS           C                   3472
      *  Unknown system state.
     D EUNKNOWN        C                   3474
      *  Iterator is invalid.
     D EITERBAD        C                   3475
      *  A damaged object was encountered.
     D EDAMAGE         C                   3484
      *  A loop exists in the symbolic links.
     D ELOOP           C                   3485
      *  A path name is too long.
     D ENAMETOOLONG    C                   3486
      *  No locks available
     D ENOLCK          C                   3487
      *  Directory not empty.
     D ENOTEMPTY       C                   3488
      *  System resources not available to compl
     D ENOSYSRSC       C                   3489
      *  Conversion error.
     D ECONVERT        C                   3490
      *  Argument list too long.
     D E2BIG           C                   3491
      *  Conversion stopped due to input charact
     D EILSEQ          C                   3492
      * Object has soft damage.
     D ESOFTDAMAGE     C                   3497
      *  User not enrolled in system distributio
     D ENOTENROLL      C                   3498
      *  Object is suspended.
     D EOFFLINE        C                   3499
      * Object is a read only object.
     D EROOBJ          C                   3500
      * Area being read from or written to is lo
     D ELOCKED         C                   3506
      * Object too large.
     D EFBIG           C                   3507
      * The semaphore, shared memory, or message
     D EIDRM           C                   3509
      * The queue does not contain a message of
     D ENOMSG          C                   3510
      * File ID conversion of a directory failed
     D EFILECVT        C                   3511
      * A File ID could not be assigned when lin
     D EBADFID         C                   3512
      * A File ID could not be assigned when lin
     D ESTALE          C                   3513
      * No such process.
     D ESRCH           C                   3515
      * Process not enabled for signals.
     D ENOTSIGINIT     C                   3516
      * No child process.
     D ECHILD          C                   3517
      * The operation would have exceeded the ma
     D ETOOMANYREFS    C                   3523
      * Function not allowed.
     D ENOTSAFE        C                   3524
      * Object is too large to process.
     D EOVERFLOW       C                   3525
      * Journal damaged.
     D EJRNDAMAGE      C                   3526
      * Journal inactive.
     D EJRNINACTIVE    C                   3527
      * Journal space or system storage error.
     D EJRNRCVSPC      C                   3528
      * Journal is remote.
     D EJRNRMT         C                   3529
      * New journal receiver is needed.
     D ENEWJRNRCV      C                   3530
      * New journal is needed.
     D ENEWJRN         C                   3531
      * Object already journaled.
     D EJOURNALED      C                   3532
      * Entry too large to send.
     D EJRNENTTOOLONG  C                   3533
      * Object is a Datalink object.
     D EDATALINK       C                   3534

      * The following values are defined by POSIX ISO/IEC 9945-1:1990
      *  (these were also taken from QCLE/H member ERRNO)

      * invalid argument
     D EINVAL          C                   3021
      * input/output error
     D EIO             C                   3006
      * no such device
     D ENODEV          C                   3007
      * resource busy
     D EBUSY           C                   3029
      * no such file or library
     D ENOENT          C                   3025
      * operation not permitted
     D EPERM           C                   3027

      *----------------------------------------------------------
      * prototype definitions
      *----------------------------------------------------------
     D @__errno        PR                  ExtProc('__errno')
     D                                     like(StdPtr)

     D strerror        PR                  ExtProc('strerror')
     D                                     like(StdPtr)
     D  errnum                             like(StdInt) value

     D perror          PR                  ExtProc('perror')
     D  comment                            like(StdPtr) value
     D                                     options(*string)

     D errno           PR                  like(StdInt)

      *----------------------------------------------------------
      *  Send escape message.
      *----------------------------------------------------------
     D Die             PR
     D   peMsg                      256A   const

      * *********************************************************
      *  EscErrno( -- Escape and return an error.
      * *********************************************************
     D EscErrno        PR                  like(StdInd)
     D   errnum                            like(StdInt) value

      * *********************************************************
      *  DiagErrno( -- Diagnosticand return an error.
      * *********************************************************
     D DiagErrno       PR                  like(StdInd)
     D   errnum                            like(StdInt) value

      * *********************************************************
      *  Error handling DS.
      * *********************************************************
     d APIerrorDS      DS
     d  AeBytPro                           like(StdInt)
     d                                     inz(%size(APIerrorDS))
     d  AeBytAvl                           like(StdInt) inz
     d  AeExcpId                           like(msgid)  inz
     d  Aefiller                           like(Stdchr) inz
     d  AeExcpDta                   256a                inz

      /endif
      *
     D DSerrinfo       DS                  likeds(dsEC)
      * ---------------------------------------------------------
      *
      *  Data structure for Error Code (ERRC0100)
      *
     D dsEC            DS                  qualified
     D  Len                                like(StdInt) inz(%size(dsEC))
     D  Avl                                like(StdInt) inz
     D  Msgid                              like(msgid)  inz
     D  Reserved                           like(StdChr) inz
     D  MsgDta                             like(msgdta) inz
      * ---------------------------------------------------------
      *  Error_throw() -- Throw error messages (RPGmail).
      *
     D Error_throw     pr
     D  pCode                              value like(Error_Info.code)
     D  pSeverity                          value like(Error_Info.severity)
     D  pPgm                               value like(Error_Info.pgm)
     D  pText                              value like(Error_Info.text)
      * ---------------------------------------------------------
      *  Error_catch() -- Catch error messages (RPGmail).
      *
     D Error_catch     pr                  likeds(Error_Info)
      * ---------------------------------------------------------
      *  Error_globalErrNoTxt() -- Catch error messages (RPGmail).
      *
     D Error_globalErrNoTxt...
     D                 pr           128a   varying

     D Error_globalErrNo...
     D                 pr                  like(StdInt)

     D Error_MsgType   s                   like(stdNam)

     D Error_ESCAPE    s                   inz('*ESCAPE') like(Error_MsgType)
     D Error_COMP      s                   inz('*COMP')   like(Error_MsgType)
     D Error_DIAG      s                   inz('*DIAG')   like(Error_MsgType)
     D Error_INFORM    s                   inz('*INFO')   like(Error_MsgType)
     D Error_INQ       s                   inz('*INQ')    like(Error_MsgType)
     D Error_NOTIFY    s                   inz('*NOTIFY') like(Error_MsgType)
     D Error_RQS       s                   inz('*RQS')    like(Error_MsgType)
      * ---------------------------------------------------------

     D Error_Info      DS                  qualified inz
     D  code                               like(StdNam)
     D  severity                           like(StdInt)
     D  pgm                          30a   varying
     D  text                      32000a   varying
