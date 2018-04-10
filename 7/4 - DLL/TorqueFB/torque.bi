#include once "windows.bi"

#inclib "Torque"

type U32 as ulong
type S32 as long
type F32 as single
type F64 as double
type SimObjectId as U32
type teNamespace as Namespace_

type Entry
	enum
		GroupMarker = -3
		OverloadMarker = -2
		InvalidFunctionType = -1
		ScriptFunctionType
		StringCallbackType
		IntCallbackType
		FloatCallbackType
		VoidCallbackType
		BoolCallbackType
	end enum

	mNamespace as teNamespace ptr
	mNext as Entry ptr
	mFunctionName as const zstring ptr
	mType as S32
	mMinArgs as S32
	mMaxArgs as S32
	mUsage as const zstring ptr
	mPackage as const zstring ptr
	mCode as any ptr
	mFunctionOffset as U32
	cb as any ptr
end type

type SimObject
	enum
		Deleted = 1 shl 0
		Removed = 1 shl 1
		Added = 1 shl 3
		Selected = 1 shl 4
		Expanded = 1 shl 5
		ModStaticFields = 1 shl 7
		ModDynamicFields = 1 shl 8
	end enum

	_padding1 as zstring * 4
	objectName as const zstring ptr
	nextNameObject as SimObject ptr
	nextManagerNameObject as SimObject ptr
	nextIdObject as SimObject ptr
	mGroup as any ptr
	mFlags as ulong
	mNotifyList as any ptr
	id as SimObjectId
	mNameSpace as teNamespace ptr
	mTypeMask as ulong
	mFieldDictionary as any ptr
end type

type SimEvent
	nextEvent as SimEvent ptr
	startTime as ulong
	time as ulong
	sequenceCount as ulong
	destObject as SimObject ptr
end type

extern "C"
type PrintfFn as sub(byval format as const zstring ptr, ...)
extern Printf as PrintfFn
declare function StringTableEntry(byval str as const zstring ptr, byval caseSensitive as bool = false) as const zstring ptr
extern StringTable as DWORD
type initGameFn as function(byval argc as long, byval argv as const zstring ptr ptr) as bool
extern initGame as initGameFn
type LookupNamespaceFn as function(byval ns as const zstring ptr) as teNamespace ptr
extern LookupNamespace as LookupNamespaceFn
type StringTableInsertFn as function(byval stringTablePtr as DWORD, byval value as const zstring ptr, byval caseSensitive as const bool) as const zstring ptr
extern StringTableInsert as StringTableInsertFn
type Namespace__lookupFn as function(byval this_ as teNamespace ptr, byval name_ as const zstring ptr) as Entry ptr
extern Namespace__lookup as Namespace__lookupFn
type CodeBlock__execFn as function(byval this_ as any ptr, byval offset as U32, byval ns as teNamespace ptr, byval fnName as const zstring ptr, byval argc as U32, byval argv as const zstring ptr ptr, byval noCalls as bool, byval packageName as const zstring ptr, byval setFrame as integer) as const zstring ptr
extern CodeBlock__exec as CodeBlock__execFn
type Sim__findObject_nameFn as function(byval name as const zstring ptr) as SimObject ptr
extern Sim__findObject_name as Sim__findObject_nameFn
type Sim__findObject_idFn as function(byval id as ulong) as SimObject ptr
extern Sim__findObject_id as Sim__findObject_idFn
type Sim__postEventFn as function(byval destObject as SimObject ptr, byval event as SimEvent ptr, byval time as U32) as ulong
extern Sim__postEvent as Sim__postEventFn
type Sim__cancelEventFn as sub(byval eventSequence as ulong)
extern Sim__cancelEvent as Sim__cancelEventFn


'type SimObject__setDataFieldFnVoid as function(byval 
'extern SimObject__setDataField as SimObject__setDataFieldFn
'extern SimObject__getDataField as SimObject__getDataFieldFn
'extern SimObject__registerObject as SimObject__registerObjectFn
'extern SimObject__registerReference as SimObject__registerReferenceFn
'extern SimObject__unregisterReference as SimObject__unregisterReferenceFn

'declare sub ConsoleVariableInt alias "ConsoleVariableInt"(byval as const zstring ptr, as long ptr)
declare sub ConsoleVariableInt(byval name as const zstring ptr, byval data as long ptr)

declare function torque_init() as bool
'dim shared ImageBase as DWORD
'dim shared ImageSize as DWORD
'extern     StringTable as DWORD
'dim shared StringTable as DWORD
'dim shared GlobalVars as DWORD
'extern     Printf as PrintfFn
'dim shared Printf as PrintfFn
'extern     LookupNamespace as LookupNamespaceFn
'dim shared LookupNamespace as LookupNamespaceFn
'extern     initGame as initGameFn
'dim shared initGame as initGameFn
'extern     StringTableInsert as StringTableInsertFn
'dim shared StringTableInsert as StringTableInsertFn
'extern     Namespace__lookup as Namespace__lookupFn
'dim shared Namespace__lookup as Namespace__lookupFn
'extern     CodeBlock__exec as CodeBlock__execFn
'dim shared CodeBlock__exec as CodeBlock__execFn
'extern     Sim__findObject_name as Sim__findObject_nameFn
'dim shared Sim__findObject_name as Sim__findObject_nameFn
'extern     Sim__findObject_id as Sim__findObject_idFn
'dim shared Sim__findObject_id as Sim__findObject_idFn
'extern     Sim__postEvent as Sim__postEventFn
'dim shared Sim__postEvent as Sim__postEventFn
'extern     Sim__cancelEvent as Sim__cancelEventFn
'dim shared Sim__cancelEvent as Sim__cancelEventFn
'extern     SimObject__setDataField as SimObject__setDataFieldFn
'dim shared SimObject__setDataField as SimObject__setDataFieldFn
'extern     SimObject__getDataField as SimObject__getDataFieldFn
'dim shared SimObject__getDataField as SimObject__getDataFieldFn
'extern     SimObject__registerObject as SimObject__registerObjectFn
'dim shared SimObject__registerObject as SimObject__registerObjectFn
'extern     SimObject__registerReference as SimObject__registerReferenceFn
'dim shared SimObject__registerReference as SimObject__registerReferenceFn
'extern     SimObject__unregisterReference as SimObject__unregisterReferenceFn
'dim shared SimObject__unregisterReference as SimObject__unregisterReferenceFn
'extern     AbstractClassRep_create_className as AbstractClassRep_create_classNameFn
'dim shared AbstractClassRep_create_className as AbstractClassRep_create_classNameFn
end extern