//
//  BranchSpotlightUrlRequest.m
//  Branch-TestBed
//
//  Created by Graham Mueller on 7/23/15.
//  Copyright © 2015 Branch Metrics. All rights reserved.
//

#import "BranchSpotlightUrlRequest.h"

@interface BranchSpotlightUrlRequest ()

@property (strong, nonatomic) callbackWithParams spotlightCallback;

@end

@implementation BranchSpotlightUrlRequest

- (id)initWithParams:(NSDictionary *)params callback:(callbackWithParams)callback {
    BNCLinkData *linkData = [[BNCLinkData alloc] init];
    [linkData setupParams:params];
    [linkData setupChannel:@"spotlight"];
    
    if (self = [super initWithTags:nil alias:nil type:BranchLinkTypeUnlimitedUse matchDuration:0 channel:@"spotlight" feature:BRANCH_FEATURE_TAG_SHARE stage:nil params:params linkData:linkData linkCache:nil callback:nil]) {
        _spotlightCallback = callback;
    }

    return self;
}

- (void)processResponse:(BNCServerResponse *)response error:(NSError *)error {
    if (error) {
        if (self.spotlightCallback) {
            self.spotlightCallback(nil, error);
        }
    }
    else if (self.spotlightCallback) {
        self.spotlightCallback(response.data, nil);
    }
}

@end
