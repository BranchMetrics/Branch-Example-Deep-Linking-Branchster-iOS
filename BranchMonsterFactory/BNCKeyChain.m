//
//  BNCKeyChain.m
//  Branch-SDK
//
//  Created by Edward on 1/8/18.
//  Copyright © 2018 Branch. All rights reserved.
//

#import "BNCKeyChain.h"
#import "BNCLog.h"

@implementation BNCKeyChain

//#define BNC_WEAK_EXPORT __attribute__((weak_import))

#define BNC_WEAK_EXPORT

#if defined(BNC_WEAK_EXPORT)

CFStringRef SecCopyErrorMessageStringStub(OSStatus status, void *reserved)
    __attribute__((weak));
CFStringRef SecCopyErrorMessageStringStub(OSStatus status, void *reserved) {
    return CFSTR("Wut");
}

//CFStringRef SecCopyErrorMessageString(OSStatus status, void *reserved) __attribute__((weak));
extern CFStringRef SecCopyErrorMessageString(OSStatus status, void *reserved)
    __attribute__((weak));
//  __attribute__((alias("SecCopyErrorMessageStringStub")));

//CFStringRef SecCopyErrorMessageString(OSStatus status, void *reserved)
//    __attribute__((weak, weakref("_SecCopyErrorMessageStringStub")));
//    //BNC_WEAK_EXPORT;

#endif

// extern CFStringRef __attribute__((weak_import)) SecCopyErrorMessageString(OSStatus status, void *reserved)
    // __attribute__((weak));
    // __attribute__((weak_import));
    // __attribute__((extern_weak));
    // __attribute__((visibility ("default"))) __attribute__((weak_import));

+ (NSError*) errorWithKey:(NSString*)key OSStatus:(OSStatus)status {
    // Security errors are defined in Security/SecBase.h
    if (status == errSecSuccess) return nil;
    NSString *reason = nil;
    NSString *description =
        [NSString stringWithFormat:@"Security error with key '%@': code %ld.", key, (long) status];

#if defined(BNC_WEAK_EXPORT)
    if (SecCopyErrorMessageString == NULL)
        reason = @"Sec security error.";
    else
        reason = (__bridge_transfer NSString*) SecCopyErrorMessageString(status, NULL);
#else
    reason = @"Sec security error.";
#endif

    NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:@{
        NSLocalizedDescriptionKey: description,
        NSLocalizedFailureReasonErrorKey: reason
    }];
    return error;
}

+ (id) retrieveValueForService:(NSString*)service key:(NSString*)key error:(NSError**)error {
    if (error) *error = nil;
    if (service == nil || key == nil) {
        NSError *localError = [self errorWithKey:key OSStatus:errSecParam];
        if (error) *error = localError;
        return nil;
    }

    NSDictionary* dictionary = @{
        (__bridge id)kSecClass:                 (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService:           service,
        (__bridge id)kSecAttrAccount:           key,
        (__bridge id)kSecReturnData:            (__bridge id)kCFBooleanTrue,
        (__bridge id)kSecMatchLimit:            (__bridge id)kSecMatchLimitOne,
        (__bridge id)kSecAttrSynchronizable:    (__bridge id)kSecAttrSynchronizableAny
    };
    CFDataRef valueData = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dictionary, (CFTypeRef *)&valueData);
    if (status) {
        NSError *localError = [self errorWithKey:key OSStatus:status];
        BNCLogDebugSDK(@"Can't retrieve key: %@.", localError);
        if (error) *error = localError;
        if (valueData) CFRelease(valueData);
        return nil;
    }
    id value = nil;
    if (valueData) {
        @try {
            value = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData*)valueData];
        }
        @catch (id) {
            value = nil;
            NSError *localError = [self errorWithKey:key OSStatus:errSecInvalidValue];
            if (error) *error = localError;
        }
        CFRelease(valueData);
    }
    return value;
}

+ (NSError*) storeValue:(id)value
             forService:(NSString*)service
                    key:(NSString*)key
       cloudAccessGroup:(NSString*)accessGroup {

    if (value == nil || service == nil || key == nil)
        return [self errorWithKey:key OSStatus:errSecParam];

    NSData* valueData = nil;
    @try {
        valueData = [NSKeyedArchiver archivedDataWithRootObject:value];
    }
    @catch(id) {
        valueData = nil;
    }
    if (!valueData) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
            code:NSPropertyListWriteStreamError userInfo:nil];
        return error;
    }
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:@{
        (__bridge id)kSecClass:                 (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService:           service,
        (__bridge id)kSecAttrAccount:           key,
        (__bridge id)kSecAttrSynchronizable:    (__bridge id)kSecAttrSynchronizableAny
    }];
    SecItemDelete((__bridge CFDictionaryRef)dictionary);

    dictionary[(__bridge id)kSecValueData] = valueData;
    dictionary[(__bridge id)kSecAttrIsInvisible] = (__bridge id)kCFBooleanTrue;
    dictionary[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAfterFirstUnlock;

    if (accessGroup.length) {
        dictionary[(__bridge id)kSecAttrAccessGroup] = accessGroup;
        dictionary[(__bridge id)kSecAttrSynchronizable] = (__bridge id) kCFBooleanTrue;
    } else {
        dictionary[(__bridge id)kSecAttrSynchronizable] = (__bridge id) kCFBooleanFalse;
    }
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    if (status) {
        NSError *error = [self errorWithKey:key OSStatus:status];
        BNCLogDebugSDK(@"Can't store key: %@.", error);
        return error;
    }
    return nil;
}

+ (NSError*) removeValuesForService:(NSString*)service key:(NSString*)key {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:@{
        (__bridge id)kSecClass:                 (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccessible:        (__bridge id)kSecAttrAccessibleAfterFirstUnlock,
        (__bridge id)kSecAttrSynchronizable:    (__bridge id)kSecAttrSynchronizableAny
    }];
    if (service) dictionary[(__bridge id)kSecAttrService] = service;
    if (key) dictionary[(__bridge id)kSecAttrAccount] = key;

    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    if (status == errSecItemNotFound) status = errSecSuccess;
    if (status) {
        NSError *error = [self errorWithKey:key OSStatus:status];
        BNCLogDebugSDK(@"Can't remove key: %@.", error);
        return error;
    }
    return nil;
}

@end
