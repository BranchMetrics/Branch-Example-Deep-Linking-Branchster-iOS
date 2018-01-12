//
//  BNCApplication.m
//  BranchMonsterFactory
//
//  Created by Edward Smith on 1/8/18.
//  Copyright © 2018 Branch. All rights reserved.
//

#import "BNCApplication.h"
#import "BNCLog.h"
#import "BNCKeyChain.h"

@implementation BNCApplication

+ (BNCApplication*) currentApplication {
    static BNCApplication *bnc_currentApplication = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        bnc_currentApplication = [BNCApplication createCurrentApplication];
    });
    return bnc_currentApplication;
}

+ (BNCApplication*) createCurrentApplication {
    BNCApplication *application = [[BNCApplication alloc] init];
    NSDictionary *infoPlist = [NSBundle mainBundle].infoDictionary;

    application->_bundleID = [NSBundle mainBundle].bundleIdentifier;
    application->_displayName = infoPlist[@"CFBundleDisplayName"];

    // TODO: Look at different version keys.
    // kCFBundleVersionKey  CFBundleShortVersionString  CFBundleVersion
    application->_displayVersionString = infoPlist[@"CFBundleShortVersionString"];
    if (!application->_displayVersionString || application->_displayVersionString.length == 0)
        application->_displayVersionString = infoPlist[@"CFBundleVersionKey"];
    application->_versionString = infoPlist[@"CFBundleVersion"];

    application->_firstInstallBuildDate = [BNCApplication firstInstallBuildDate];
    application->_currentBuildDate = [BNCApplication currentBuildDate];

    application->_firstInstallDate = [BNCApplication firstInstallDate];
    application->_currentInstallDate = [BNCApplication currentInstallDate];

    NSDictionary *entitlements = [self entitlementsDictionary];
    application->_applicationID = entitlements[@"application-identifier"];
    application->_pushNotificationEnvironment = entitlements[@"aps-environment"];
    application->_keychainAccessGroups = entitlements[@"keychain-access-groups"];
    application->_teamID = entitlements[@"com.apple.developer.team-identifier"];
    
    return application;
}

typedef CFTypeRef SecTaskRef;
extern CFDictionaryRef SecTaskCopyValuesForEntitlements(SecTaskRef task, CFArrayRef entitlements, CFErrorRef  _Nullable *error)
    __attribute__((weak_import));

extern SecTaskRef SecTaskCreateFromSelf(CFAllocatorRef allocator)
    __attribute__((weak_import));

+ (NSDictionary*) entitlementsDictionary {
    // Get some entitlement values:

    if (SecTaskCreateFromSelf == NULL || SecTaskCopyValuesForEntitlements == NULL)
        return nil;

    NSArray *entitlementKeys = @[
        @"application-identifier",
        @"com.apple.developer.team-identifier",
        @"keychain-access-groups",
        @"aps-environment"
    ];
    CFErrorRef errorRef = NULL;
    SecTaskRef myself = SecTaskCreateFromSelf(NULL);
    NSDictionary *entitlements = (__bridge_transfer NSDictionary *)
        (SecTaskCopyValuesForEntitlements(myself, (__bridge CFArrayRef)(entitlementKeys), &errorRef));
    if (errorRef) {
        BNCLogError(@"Can't retrieve entitlements: %@.", errorRef);
        CFRelease(errorRef);
    }
    return entitlements;
}

+ (NSDate*) currentBuildDate {
    NSURL *appURL = nil;
    NSURL *bundleURL = [NSBundle mainBundle].bundleURL;
    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
    NSString *appName = info[(__bridge NSString*)kCFBundleExecutableKey];
    if ((NO)) { //appName.length > 0 && bundleURL) {
        [bundleURL URLByAppendingPathComponent:appName];
    } else {
        NSString *path = [[NSProcessInfo processInfo].arguments firstObject];
        appURL = [NSURL fileURLWithPath:path];
    }
    if (appURL == nil)
        return nil;

    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:appURL.path error:&error];
    if (error) {
        BNCLogError(@"Can't get library date: %@.", error);
        return nil;
    }
    NSDate * buildDate = [attributes fileCreationDate];
    if (buildDate == nil || [buildDate timeIntervalSince1970] <= 0.0) {
        BNCLogError(@"Invalid app build date: %@.", buildDate);
    }

    return buildDate;
}

static NSString * const kBranchKeychainService = @"Branch";

+ (NSDate*) firstInstallBuildDate {
    NSDate* firstBuildDate = nil;

    NSError *error = nil;
    NSString * const kBranchKeychainAccountFirstBuild = @"BranchFirstBuild";
    firstBuildDate =
        [BNCKeyChain retrieveValueForService:kBranchKeychainService
            key:kBranchKeychainAccountFirstBuild
            error:&error];
    if (firstBuildDate)
        return firstBuildDate;

    firstBuildDate = [self currentBuildDate];
    error = [BNCKeyChain storeValue:firstBuildDate
        forService:kBranchKeychainService
        key:kBranchKeychainAccountFirstBuild
        cloudAccessGroup:nil];

    return firstBuildDate;
}

+ (NSDate*) currentInstallDate {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
// Was:   [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *libraryURL =
        [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] firstObject];
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:libraryURL.path error:&error];
    if (error) {
        BNCLogError(@"Can't get library date: %@.", error);
        return nil;
    }
    NSDate *installDate = [attributes fileCreationDate];
    if (installDate == nil || [installDate timeIntervalSince1970] <= 0.0) {
        BNCLogError(@"Invalid install date.");
        return nil;
    }
    return installDate;
}

+ (NSDate*) firstInstallDate {
    NSDate* firstInstallDate = nil;

    NSError *error = nil;
    NSString * const kBranchKeychainAccountFirstInstall = @"BranchFirstInstall";
    firstInstallDate =
        [BNCKeyChain retrieveValueForService:kBranchKeychainService
            key:kBranchKeychainAccountFirstInstall
            error:&error];
    if (firstInstallDate)
        return firstInstallDate;

    firstInstallDate = [self currentInstallDate];
    error = [BNCKeyChain storeValue:firstInstallDate
        forService:kBranchKeychainService
        key:kBranchKeychainAccountFirstInstall
        cloudAccessGroup:nil];

    return firstInstallDate;
}

static NSString*const kBranchKeychainAccountDevices = @"kBranchKeychainAccountDevices";

- (NSDictionary*) deviceKeyIdentityValueDictionary {
    @synchronized (self.class) {
        NSError *error = nil;
        NSDictionary *deviceDictionary =
            [BNCKeyChain retrieveValueForService:kBranchKeychainService
                key:kBranchKeychainAccountDevices
                error:&error];
        if (error) BNCLogWarning(@"While retrieving deviceKeyIdentityValueDictionary: %@.", error);
        if (!deviceDictionary) deviceDictionary = @{};
        return deviceDictionary;
    }
}

- (void) addDeviceID:(NSString*)deviceID identityID:(NSString*)identityID {
    @synchronized (self.class) {
        NSMutableDictionary *dictionary =
            [NSMutableDictionary dictionaryWithDictionary:[self deviceKeyIdentityValueDictionary]];
        if (!identityID) identityID = @"";
        dictionary[deviceID] = identityID;

        NSString*const kCloudAccessGroup = [self.class currentApplication].applicationID;

        NSError *error =
            [BNCKeyChain storeValue:dictionary
                forService:kBranchKeychainService
                key:kBranchKeychainAccountDevices
                cloudAccessGroup:kCloudAccessGroup];
        if (error) {
            BNCLogError(@"Can't add device/identity pair: %@.", error);
        }
    }
}

@end
