//
//  BHCThirdViewController.m
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 9/4/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//

#import "ContactUSViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"

@implementation ContactUSViewController
@synthesize submit, requester_comments, requester_email, requester_name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //[[self navigationController] setNavigationBarHidden:false];

}

- (void)viewDidUnload
{
    requester_name = nil;
    requester_email = nil;
    requester_comments = nil;
    [self setSubmit:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)submitForm:(id)sender {
    // 3
    NSURL *url = [NSURL URLWithString:CONTACT_US_URL];
    
    // 4
    ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *request = _request;
    
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:requester_name.text forKey:@"name"];
    [request setPostValue:requester_email.text forKey:@"email"];
    [request setPostValue:requester_comments.text forKey:@"comments"];
    
    NSLog(@"comments '%@'",requester_comments.text);
    NSLog(@"name '%@'",requester_name.text);
    NSLog(@"email '%@'",requester_email.text);
    
    if ([requester_name.text length] ==0)
        return;
    
    if ([requester_comments.text length] ==0)
        return;
    
    if ([requester_email.text length] ==0)
        return;

    // 6
    [request startAsynchronous];
    
    [[self navigationController] popViewControllerAnimated:TRUE];
}

@end
