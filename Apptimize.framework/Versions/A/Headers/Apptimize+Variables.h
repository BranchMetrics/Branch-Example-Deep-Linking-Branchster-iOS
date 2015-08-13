//
//  Apptimize+Variables.h
//  Apptimize (v2.12.1)
//
//  Copyright (c) 2014 Apptimize, Inc. All rights reserved.
//

#ifndef Apptimize_Apptimize_Variables_h
#define Apptimize_Apptimize_Variables_h

#import "Apptimize+VariablesInternal.h"

// Please see the documentation at http://apptimize.com/docs/advanced-functionality/dynamic-variables

#define ApptimizeString(_name, _value)  _ApptimizeEnsuredObjectTypeVariable(_name, NSString*, s, ,_value)
#define ApptimizeInt(_name, _value)     _ApptimizeVariableDefinition(_name, i) _ApptimizeVariableInitializer(_name, i, ,default_ = _Generic(_value, \
    int:           @(_value), \
    unsigned int:  @(_value), \
    long:          @(_value), \
    unsigned long: @(_value)))
#define ApptimizeDouble(_name, _value)  _ApptimizeVariableDefinition(_name, d) _ApptimizeVariableInitializer(_name, d, ,default_ = _Generic(_value, \
    float:  @(_value), \
    double: @(_value)))
#define ApptimizeBoolean(_name, _value) _ApptimizeVariableDefinition(_name, b) _ApptimizeVariableInitializer(_name, b, , default_ = _Generic(_value, BOOL: @(_value)))

#define ApptimizeArrayOfStrings(_name, ...)       _ApptimizeEnsuredObjectTypeVariable(_name, NSArray*,      A, s, __VA_ARGS__)
#define ApptimizeDictionaryOfStrings(_name, ...)  _ApptimizeEnsuredObjectTypeVariable(_name, NSDictionary*, D, s, __VA_ARGS__)
#define ApptimizeArrayOfInts(_name, ...)          _ApptimizeEnsuredObjectTypeVariable(_name, NSArray*,      A, i, __VA_ARGS__)
#define ApptimizeDictionaryOfInts(_name, ...)     _ApptimizeEnsuredObjectTypeVariable(_name, NSDictionary*, D, i, __VA_ARGS__)
#define ApptimizeArrayOfDoubles(_name, ...)       _ApptimizeEnsuredObjectTypeVariable(_name, NSArray*,      A, d, __VA_ARGS__)
#define ApptimizeDictionaryOfDoubles(_name, ...)  _ApptimizeEnsuredObjectTypeVariable(_name, NSDictionary*, D, d, __VA_ARGS__)
#define ApptimizeArrayOfBooleans(_name, ...)      _ApptimizeEnsuredObjectTypeVariable(_name, NSArray*,      A, b, __VA_ARGS__)
#define ApptimizeDictionaryOfBooleans(_name, ...) _ApptimizeEnsuredObjectTypeVariable(_name, NSDictionary*, D, b, __VA_ARGS__)

#endif
