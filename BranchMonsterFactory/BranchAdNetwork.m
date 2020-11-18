//
//  BranchAdNetwork.m
//  BranchMonsterFactory
//
//  Created by Ernest Cho on 10/27/20.
//  Copyright © 2020 Branch. All rights reserved.
//

#import "BranchAdNetwork.h"

@implementation BranchAdNetwork

- (void)requestAttributionWithSource:(NSString *)source target:(NSString *)target completion:(void (^_Nullable)(NSMutableDictionary *params))completion {
    if (@available(iOS 14.0, *)) {
        
        // test server,
        NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.7:8080/attribute?source=%@&target=%@", source, target];
        
        //NSString *urlString = [NSString stringWithFormat:@"https://branch-ad-network.branch.io/attribute?source=%@&target=%@", source, target];
        NSURL *url = [NSURL URLWithString:urlString];
        
        if (url) {
            [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (!error && data) {
                    if (completion) {
                        NSMutableDictionary *params = [self parseAttributionParametersFromData:data];
                        completion(params);
                    }
                } else {
                    if (completion) {
                        completion(nil);
                    }
                }
            }] resume];
        }
    }
}

- (nullable NSMutableDictionary *)parseAttributionParametersFromData:(NSData *)data {
    if (@available(iOS 14.0, *)) {
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!jsonError && json) {
            NSLog(@"Attribution: %@", json);
            
            NSString *adNetworkID = [json objectForKey:@"adNetworkIdentifier"];
            NSNumber *campaignID = [json objectForKey:@"campaignIdentifier"];
            NSNumber *timestamp = [json objectForKey:@"timestamp"];
            NSUUID *nonce = [[NSUUID alloc] initWithUUIDString:[json objectForKey:@"nonce"]];
            NSString *signature = [json objectForKey:@"attributionSignature"];
            NSNumber *source = [json objectForKey:@"sourceAppIdentifier"];
            NSString *version = [json objectForKey:@"version"];
            
            if (!adNetworkID || !campaignID || !timestamp || !nonce || !signature || !source || !version) {
                // give up if any of the expected params are missing
            } else {
                NSMutableDictionary *parameters = [NSMutableDictionary new];
                parameters[SKStoreProductParameterAdNetworkIdentifier] = adNetworkID;
                parameters[SKStoreProductParameterAdNetworkCampaignIdentifier] = campaignID;
                parameters[SKStoreProductParameterAdNetworkTimestamp] = timestamp;
                parameters[SKStoreProductParameterAdNetworkNonce] = nonce;
                parameters[SKStoreProductParameterAdNetworkAttributionSignature] = signature;
                parameters[SKStoreProductParameterAdNetworkSourceAppStoreIdentifier] = source;
                parameters[SKStoreProductParameterAdNetworkVersion] = version;
                return parameters;
            }
        }
    }
    return nil;
}

@end
