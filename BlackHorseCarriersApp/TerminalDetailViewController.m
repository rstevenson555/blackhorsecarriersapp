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

@synthesize locationName, findTerminalViewController, locationDetailViewer, directions;

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
    // adjust the padding insets that was shifting the text to the right and down
    self.locationDetailViewer.contentInset = UIEdgeInsetsMake(-8,-8,-8,-8);
    
    [super viewDidLoad];
}

- (void)viewDidUnload {
    locationName = nil;
    [self setDrivingDirections:nil];
    [self setDirections:nil];
    [super viewDidUnload];
}

- (IBAction)getDrivingDirections:(id)sender {
    NSLog(@"getDrivingDirections action called");
    [self.navigationController popToViewController:self.findTerminalViewController animated:YES];
    [self.findTerminalViewController getDrivingDirections];
}

@end
