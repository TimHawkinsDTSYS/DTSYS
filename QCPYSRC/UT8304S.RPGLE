      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Queue prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *
     D GVquemaid       s                   like(dfnQTrcid)
     D GVquetxseqn     s                   like(dfnQTseqn)
      * ---------------------------------------------------------
      *
      * WrtQuema() -- Write queue master.
      *
     D WrtQuema        PR
     D  i_quema                            like(dfnquema)  const
      * ---------------------------------------------------------
      *
      * WrtQuetx() -- Write queue text.
      *
     D WrtQuetx        PR
     D  i_text                             like(dfnQTtext) const
      * ---------------------------------------------------------
      *
      * WrtQuetxSeclvl() -- Write queue text from seclvl.
      *
     D WrtQuetxSeclvl  PR
     D  i_text                             like(seclvl) const
