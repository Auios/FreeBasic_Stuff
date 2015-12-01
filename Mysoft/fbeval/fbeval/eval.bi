#ifndef __EVAL_BI__
#define __EVAL_BI__
' A Simple Expression Evaluator
' Copyright (c) 1996 - 1999 Parsifal Software
' evaluateExpression may be freely copied and modified

#ifdef __FB_WIN32__
# inclib "evalwin"
#else
# ifdef __FB_LINUX__
#  inclib "evallin"
# else
#  error "plattform must be WIN32 or Linux!"
# endif
#endif
' Define an error record
type ErrorRecord
  as zstring ptr err_message
  as integer     err_line
  as integer     err_column
end type

type VariableDescriptor
  as zstring ptr var_name
  as double    var_value
end type


extern "C"
declare function eval(byval expression as string) as integer
extern as ErrorRecord ptr        lpErrorRecord 
extern as VariableDescriptor ptr lpVars
extern as integer                nVariables
end extern
#endif ' __EVAL_BI__

