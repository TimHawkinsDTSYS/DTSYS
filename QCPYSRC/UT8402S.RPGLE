      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Date/time conversion prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *  CvtISOtoMDY() - Convert from ISO to MDY.
      *
     D CvtISOtoMDY     PR                  like(NumMDY )
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *  CvtISOtoUSA() - Convert from ISO to USA.
      *
     D CvtISOtoUSA     PR                  like(NumUSA )
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *  CvtISOtoYMD() - Convert from ISO to YMD.
      *
     D CvtISOtoYMD     PR                  like(NumYMD )
     D  InpISO                             like(NumISO ) value
      * ---------------------------------------------------------
      *
      *  CvtYMDtoISO() - Convert from YMD to ISO.
      *
     D CvtYMDtoISO     PR                  like(NumISO )
     D  InpYMD                             like(NumYMD ) value
      * ---------------------------------------------------------
      *
      *  CvtUSAtoISO() - Convert from USA to ISO.
      *
     D CvtUSAtoISO     PR                  like(NumISO )
     D  InpUSA                             like(NumUSA ) value
      * ---------------------------------------------------------
      *
      *  CvtMDYtoISO() - Convert from MDY to ISO.
      *
     D CvtMDYtoISO     PR                  like(NumISO )
     D  InpMDY                             like(NumMDY ) value
      * ---------------------------------------------------------
      *
      *  CvtYYtoYYYY() - Convert from YY to YYYY.
      *
     D CvtYYtoYYYY     PR                  like(NumYYYY)
     D  InpYY                              like(NumYY  ) value
      * ---------------------------------------------------------
      *
      *  CvtYYYYtoYY() -- Convert from YYYY to YY.
      *
     D CvtYYYYtoYY     PR                  like(NumYY  )
     D  InpYYYY                            like(NumYYYY) value
      * ---------------------------------------------------------
      *
      *  CvtMYtoYYM() -- Convert from MMYY to YYYYMM.
      *
     D CvtMYtoYYM      PR                  like(NumYYM )
     D  InpMY                              like(NumMY  ) value
      * ---------------------------------------------------------
      *
      *  CvtYYMtoMY() -- Convert from YYYYMM to MMYY.
      *
     D CvtYYMtoMY      PR                  like(NumMY  )
     D  InpYYM                             like(NumYYM ) value
      * ---------------------------------------------------------
      *
      *  Prototype for CvtHMtoHMS
      *
     D CvtHMtoHMS      PR                  like(NumHMS )
     D  InpHHMM                            like(NumHHMM) value
      * ---------------------------------------------------------
      *
      *  Prototype for CvtHMStoHM
      *
     D CvtHMStoHM      PR                  like(NumHHMM)
     D  InpHMS                             like(NumHMS ) value
      * ---------------------------------------------------------
      *
      *  CvtAMPMtoMIL() -- Convert AM/PM to military time (HMS)
      *
     D CvtAMPMtoMIL    PR                  like(NumHMS )
     D  InpHMS                             like(NumHMS ) value
     D  InpAMPM                            like(AlpAMPM) value
      * ---------------------------------------------------------
      *
      *  CvtAMPMtoHM() -- Convert AM/PM to military time (HM)
      *
     D CvtAMPMtoHM     PR                  like(NumHM  )
     D  InpHM                              like(NumHM  ) value
     D  InpAMPM                            like(AlpAMPM) value
      * ---------------------------------------------------------
      *
      *  CvtMILtoAMPM() -- Convert military time to AM/PM time
      *
     D CvtMILtoAMPM    PR                  like(d_CvtMILtoAMPM)
     D  InpHMS                             like(NumHMS ) value
      *
     D d_CvtMILtoAMPM  DS
     D  CvtMILtoAMPM_HMS...
     D                                     like(NumHMS) inz
     D  CvtMILtoAMPM_AMPM...
     D                                     like(AlpAMPM) inz
      * ---------------------------------------------------------
      *
      *  CvtDteTimtoTSP() -- Convert date/time to timestamp.
      *
     D CvtDteTimtoTSP  PR                  like(TimStp )
     D  InpISO                             like(NumISO ) value
     D  InpHMS                             like(NumHMS ) value
      * ---------------------------------------------------------
      *
      *  CvtTSPtoISO() -- Convert timestamp to ISO date.
      *
     D CvtTSPtoISO     PR                  like(NumISO )
     D  InpTSP                             like(TimStp ) value
      * ---------------------------------------------------------
      *
      *  CvtTSPtoMDY() -- Convert timestamp to MDY date.
      *
     D CvtTSPtoMDY     PR                  like(NumMDY )
     D  InpTSP                             like(TimStp ) value
      * ---------------------------------------------------------
      *
      *  CvtTSPtoHMS() -- Convert timestamp to HMS time.
      *
     D CvtTSPtoHMS     PR                  like(NumHMS )
     D  InpTSP                             like(TimStp ) value
      * ---------------------------------------------------------
      *
      * CvtISOtoDte() -- Convert from ISO to Date.
      *
     D CvtISOtoDte     PR                  like(DteUSA)
     D  InpISO                             like(NumISO) value
      * ---------------------------------------------------------
      *
      * CvtHMStoTim() -- Convert from HMS to Time.
      *
     D CvtHMStoTim     PR                  like(TimHMS)
     D  InpHMS                             like(NumHMS) value
      * ---------------------------------------------------------
      *
      *  Prototype for Convert to lillian date.
      *
     D CEEDAYS         PR                  extproc('CEEDAYS') opdesc
     D  CharDate                    255    const
     D  PictString                  255    const
     D  LillianDate                  10i 0
     D  ErrorCode                   116    options(*omit)
      * ---------------------------------------------------------
      *
      *  CvtMintoHM() -- Convert minutes to hours/minutes.
      *
     D CvtMintoHM      PR                  like(NumHM)
     D  InpMin                             like(StdInt) value
      * ---------------------------------------------------------
      *
      * CvtCYYMMDDtoISO() -- Convert CYYMMDD to ISO.
      *
     D CvtCYYMMDDtoISO...
     D                 PR                  like(NumISO)
     D  InpCYYMMDD                    7  0 const
      * ---------------------------------------------------------
      *
      *  OfsUTCtsp() -- Offset UTC timestamp.
      *
     D OfsUTCtsp       PR                  like(TimStp)
     D  InpUTC                             like(TimStp) const
      * ---------------------------------------------------------
      *  CvtISOHMStodateTime() - Convert ISO/HMS to dateTime.
      *
     D CvtISOHMStodateTime...
     D                 PR                  like(StdTxt)
     D  InpISO                             like(NumISO) const
     D  InpHMS                             like(NumHMS) const
