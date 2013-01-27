//
//  TerminalDetailViewController.h
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 10/7/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface TerminalDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UILabel *locationCity;
@property (weak, nonatomic) IBOutlet UILabel *locationAddress;
@property (weak, nonatomic) IBOutlet UILabel * locationManager;
@property (weak, nonatomic) IBOutlet UILabel * locationTitle;
@property (weak, nonatomic) IBOutlet UILabel * locationPhone;

@end
