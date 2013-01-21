//
//  TerminalDetailViewController.m
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 10/7/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//

#import "TerminalDetailViewController.h"

@interface TerminalDetailViewController ()

@end


@implementation TerminalDetailViewController

@synthesize locationName, locationCity, locationAddress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[self navigationController] setNavigationBarHidden:false];

}

- (void)viewDidUnload {
    locationName = nil;
    locationCity = nil;
    locationAddress = nil;
    [super viewDidUnload];
}
@end
