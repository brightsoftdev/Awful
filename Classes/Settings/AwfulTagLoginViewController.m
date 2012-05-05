    //
    //  AwfulTagLoginViewController.m
    //  Awful
    //
    //  Created by Matt Couch on 5/3/12.
    //  Copyright (c) 2012 Regular Berry Software LLC. All rights reserved.
    //

#import "AwfulTagLoginViewController.h"
#import "MBProgressHUD.h"
#import "AwfulInstapaperEngine.h"
#import "KeychainWrapper.h"
#import "AwfulSettingsViewController.h"

@interface AwfulTagLoginViewController ()
-(void)stop;
-(void)showStopButton;
-(void)hideStopButton;
-(void) instapaperResponse:(int)status;
@end

@implementation AwfulTagLoginViewController
@synthesize service = _service;
@synthesize userName = _userName;
@synthesize prefKey = _prefKey;
@synthesize networkOperation = _networkOperation;
@synthesize userField = _userField;
@synthesize passwordField = _passwordField;
@synthesize errorLabel = _errorLabel;
@synthesize settingsViewController = _settingsViewController;

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.errorLabel.text = @"";
    self.userField.text = self.userName;
    self.navigationItem.title = self.service;
    
    NSError *err;
    _password = [KeychainWrapper getPasswordForUsername:self.userName andServiceName:self.service error:&err];
    if (!err)
    {
        self.passwordField.text = _password;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidUnload {
    [self setUserField:nil];
    [self setPasswordField:nil];
    [self setErrorLabel:nil];
    [super viewDidUnload];
}

- (IBAction)clearLogin:(id)sender
{
    
    NSError *err;
    
    if ([KeychainWrapper deleteItemForUsername:self.userName andServiceName:self.service error:&err])
    {
        self.errorLabel.text = [NSString stringWithFormat:@"Unknown error: %@", err.localizedDescription];
        [self.errorLabel sizeToFit];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.prefKey];
    self.userField.text = @"";
    self.passwordField.text = @"";
    
    [self.settingsViewController.tableView reloadData];
    
}

- (IBAction)verifyLogin:(id)sender 
{
    [self.view setUserInteractionEnabled:NO];
    [self showStopButton];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.userName = self.userField.text;
    _password = self.passwordField.text;
    
    if ([self.service isEqual:@"Instapaper"])
    {
        self.networkOperation = [ApplicationDelegate.awfulInstapaperEngine testUsername:self.userName
                                                                           withPassword:_password
                                                                           onCompletion:^(int status){
                                                                               [self instapaperResponse:status];
                                                                           }];
        
    }
}


-(void)stop
{
    [self.view setUserInteractionEnabled:YES];
    [self hideStopButton];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.networkOperation cancel];
}

-(void)showStopButton
{
    UIBarButtonItem *stop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stop)];
    stop.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = stop;
}


-(void)hideStopButton
{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void) instapaperResponse:(int)status
{
    [self stop];
    /*TODO:Handle various status codes:
     200: OK
     403: Invalid username or password.
     500: The service encountered an error. Please try again later.
     */
    if (status == 403) 
    {
        self.errorLabel.text = @"Invalid username or password";
    }
    else if (status == 500)
    {
        self.errorLabel.text = @"The service encountered an error. Please try again later.";
    }
    else if (status == 200) {
        
        NSError *err;
        
        [KeychainWrapper storeUsername:self.userName 
                           andPassword:_password 
                        forServiceName:self.service
                        updateExisting:YES
                                 error:&err];
        if (err)
        {
            
            self.errorLabel.text = [NSString stringWithFormat:@"Unknown error: %@", err.localizedDescription];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setValue:self.userName forKey:self.prefKey];
            [self.settingsViewController.tableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        self.errorLabel.text = [NSString stringWithFormat:@"Unknown error: %d", status];
    }
    
    [self.errorLabel sizeToFit];
}

@end
