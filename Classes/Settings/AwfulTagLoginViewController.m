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

@interface AwfulTagLoginViewController ()
-(void)stop;
-(void)showStopButton;
-(void)hideStopButton;
-(void) instapaperResponse:(int)status;
@end

@implementation AwfulTagLoginViewController
@synthesize service = _service;
@synthesize userName = _userName;
@synthesize networkOperation = _networkOperation;
@synthesize userField = _userField;
@synthesize passwordField = _passwordField;
@synthesize errorLabel = _errorLabel;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.userField.text = self.userName;
    self.navigationItem.title = self.service;
    [self.errorLabel sizeToFit];
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

- (IBAction)verifyLogin:(id)sender 
{
    [self.view setUserInteractionEnabled:NO];
    [self showStopButton];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self.service isEqual:@"Instapaper"])
    {
        self.networkOperation = [ApplicationDelegate.awfulInstapaperEngine testUsername:self.userField.text
                                                                           withPassword:self.passwordField.text
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
        /*TODO:Handle various status codes:
    200: OK
    403: Invalid username or password.
    500: The service encountered an error. Please try again later.
         */


}
@end
