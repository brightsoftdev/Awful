//
//  AwfulInstapaperEngine.m
//  Awful
//
//  Created by Matt Couch on 5/4/12.
//  Copyright (c) 2012 Regular Berry Software LLC. All rights reserved.
//

#import "AwfulInstapaperEngine.h"

@implementation AwfulInstapaperEngine

- (MKNetworkOperation *) testUsername:(NSString *)username
                         withPassword:(NSString *)password
                         onCompletion:(TestLoginBlock) testLoginBlock

{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:username forKey:@"username"];
    [params setObject:password forKey:@"password"];
    
    MKNetworkOperation *op = [self operationWithPath:@"api/authenticate" 
                                              params:params
                                          httpMethod:@"POST"];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        testLoginBlock([completedOperation HTTPStatusCode]);
    }
     onError:^(NSError* error) {
         testLoginBlock([error code]);
     }];
    
    [self enqueueOperation:op];
    return op;
}
@end
