      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      *  Stack prototypes.
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      * ---------------------------------------------------------
      *
      *   InzStack() -- Initialize stack.
      *
     D InzStack        PR                  like(StdPtr)
     D  PushEsiz                           like(StdInt) value
      *
      *   ClrStack() -- Clear stack.
      *
     D ClrStack        PR
     D  PushData                           like(StdPtr) value
      *
      *   Push() -- Push value into stack.
      *
     D Push            PR                  like(StdPtr)
     D  PushData                           like(StdPtr) value
     D  PushValue                          like(StdStr) value
      *
      *   Pull() -- Pull value from stack.
      *
     D Pull            PR                  like(StdStr)
     D  PullData                           like(StdPtr) value
