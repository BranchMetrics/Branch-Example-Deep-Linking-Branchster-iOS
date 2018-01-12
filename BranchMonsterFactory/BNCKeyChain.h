//
//  BNCKeyChain.h
//  Branch-SDK
//
//  Created by Edward on 1/8/18.
//  Copyright © 2018 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNCKeyChain : NSObject

+ (NSError*_Nullable) removeValuesForService:(NSString*_Nullable)service
                                         key:(NSString*_Nullable)key;

+ (id _Nullable) retrieveValueForService:(NSString*_Nonnull)service
                                     key:(NSString*_Nonnull)key
                                   error:(NSError*_Nullable*_Nullable)error;

+ (NSError*_Nullable) storeValue:(id _Nonnull)value
                      forService:(NSString*_Nonnull)service
                             key:(NSString*_Nonnull)key
                cloudAccessGroup:(NSString*_Nullable)accessGroup;
@end
