//
//  BNCApplication.h
//  Branch-SDK
//
//  Created by Edward Smith on 1/8/18.
//  Copyright © 2018 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNCApplication : NSObject

+ (BNCApplication*) currentApplication;

@property (atomic, readonly) NSString* bundleID;
@property (atomic, readonly) NSString* applicationID;

@property (atomic, readonly) NSString* displayName;
@property (atomic, readonly) NSString* displayVersionString;
@property (atomic, readonly) NSString* versionString;

@property (atomic, readonly) NSDate* firstInstallBuildDate;
@property (atomic, readonly) NSDate* currentBuildDate;

@property (atomic, readonly) NSDate* firstInstallDate;
@property (atomic, readonly) NSDate* currentInstallDate;

@property (atomic, readonly) NSString* pushNotificationEnvironment;
@property (atomic, readonly) NSArray<NSString*>* keychainAccessGroups;
@property (atomic, readonly) NSString* teamID;

@property (atomic, readonly) NSDictionary<NSString*, NSString*>*deviceKeyIdentityValueDictionary;
- (void) addDeviceID:(NSString*)deviceID identityID:(NSString*)identityID;

@end
