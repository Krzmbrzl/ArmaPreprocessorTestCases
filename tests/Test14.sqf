#define MACRO Some##Test

MACRO

#define OTHER(ARG) Some##Test

OTHER(nothing)