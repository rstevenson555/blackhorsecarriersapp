//
//  TerminalDetailViewController.h
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 10/7/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FindTerminalViewController.h"

@interface TerminalDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UITextView * locationDetailViewer;
@property (weak, nonatomic) IBOutlet UIButton *drivingDirections;
@property (weak, nonatomic) FindTerminalViewController* findTerminalViewController;

- (IBAction)getDrivingDirections:(id)sender;

@end
