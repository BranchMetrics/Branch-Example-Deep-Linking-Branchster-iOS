//
//  BranchAdNetwork.h
//  BranchMonsterFactory
//
//  Created by Ernest Cho on 10/27/20.
//  Copyright © 2020 Branch. All rights reserved.
//

#import <Foundation/Foundation.h>
@import StoreKit;

NS_ASSUME_NONNULL_BEGIN

@interface BranchAdNetwork : NSObject

- (void)requestAttributionWithSource:(NSString *)source target:(NSString *)target completion:(void (^_Nullable)(NSMutableDictionary *params))completion;

@end

NS_ASSUME_NONNULL_END
