//
//  AwfulInstapaperEngine.h
//  Awful
//
//  Created by Matt Couch on 5/4/12.
//  Copyright (c) 2012 Regular Berry Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNetworkEngine.h"

@interface AwfulInstapaperEngine : MKNetworkEngine

typedef void (^TestLoginBlock)(int status);

- (MKNetworkOperation *) testUsername:(NSString *)username
                         withPassword:(NSString *)password
                         onCompletion:(TestLoginBlock) testLoginBlock;
@end
