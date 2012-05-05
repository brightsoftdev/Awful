//
//  AwfulTagLoginViewController.h
//  Awful
//
//  Created by Matt Couch on 5/3/12.
//  Copyright (c) 2012 Regular Berry Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNetworkKit.h"
@class AwfulSettingsViewController;

@interface AwfulSendToLoginViewController : UIViewController
{
    NSString *_password;
}
@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *prefKey;
@property (nonatomic, strong) MKNetworkOperation *networkOperation;
@property (weak) AwfulSettingsViewController *settingsViewController;

@property (strong, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

- (IBAction)verifyLogin:(id)sender;
- (IBAction)clearLogin:(id)sender;


@end