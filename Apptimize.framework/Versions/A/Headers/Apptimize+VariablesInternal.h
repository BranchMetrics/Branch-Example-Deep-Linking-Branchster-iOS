//
//  Apptimize+VariablesInternal.h
//  Apptimize (v2.12.1)
//
//  Copyright (c) 2014 Apptimize, Inc. All rights reserved.
//
// This is the internal/backend implementation for Apptimize Dynamic Variables
// Move along.

#ifndef Apptimize_Apptimize_VariablesInternal_h
#define Apptimize_Apptimize_VariablesInternal_h

#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

@protocol _ApptimizeVariableProtocol    <NSObject>
@end

@protocol _ApptimizeVariableProtocol_i  <_ApptimizeVariableProtocol>
@property (nonatomic, readonly) NSInteger     integerValue;
@property (nonatomic, readonly) NSUInteger    unsignedIntegerValue;
@end

@protocol _ApptimizeVariableProtocol_s <_ApptimizeVariableProtocol> @property (nonatomic, readonly) NSString     *stringValue;     @end
@protocol _ApptimizeVariableProtocol_d <_ApptimizeVariableProtocol> @property (nonatomic, readonly) double        doubleValue;     @end
@protocol _ApptimizeVariableProtocol_b <_ApptimizeVariableProtocol> @property (nonatomic, readonly) BOOL          boolValue;       @end
@protocol _ApptimizeVariableProtocol_A <_ApptimizeVariableProtocol> @property (nonatomic, readonly) NSArray      *arrayValue;      @end
@protocol _ApptimizeVariableProtocol_D <_ApptimizeVariableProtocol> @property (nonatomic, readonly) NSDictionary *dictionaryValue; @end

struct _apptimize_variable_descriptor {
    // out pointer for variable; name; type code; default value pointer.
    __strong id *p; const char *n; const char *t; __strong id *d;
};

#define _ApptimizeVariableSegment "__DATA"
#define _ApptimizeVariableSection "__atz_vdesc_1"
#define _ApptimizeVariableConstSection "__atz_cstring_1"
#define _ApptimizeVariableDefinition(_name, _type) __attribute__((unused)) NSObject< _ApptimizeVariableProtocol_ ## _type > * _name = nil;
#define _ApptimizeVariableInitializer(_name, _type, _subtype, ...) \
    static void __attribute__((constructor)) _atz_var_init ## _name () { \
        __attribute__((used,unused)) static __strong id default_ = NULL; \
        __attribute__((used,unused,section(_ApptimizeVariableSegment "," _ApptimizeVariableConstSection))) static const char name_[] = #_name; \
        __attribute__((used,unused,section(_ApptimizeVariableSegment "," _ApptimizeVariableConstSection))) static const char type_[] = "" #_type #_subtype ""; \
        static struct _apptimize_variable_descriptor __attribute__((used,unused,section(_ApptimizeVariableSegment "," _ApptimizeVariableSection))) desc_ = { &(_name), (const char*)name_, (const char*)type_, &default_ }; \
        __VA_ARGS__; \
    }
#define _ApptimizeEnsuredObjectTypeVariable(_name, _ensuredType, _type, _subtype, ...) _ApptimizeVariableDefinition(_name, _type) _ApptimizeVariableInitializer(_name, _type, _subtype, default_ = _Generic((__VA_ARGS__), _ensuredType: (__VA_ARGS__), void*: nil))

#endif
