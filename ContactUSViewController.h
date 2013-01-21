//
//  BHCThirdViewController.h
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 9/4/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUSViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *submit;
@property (weak, nonatomic) IBOutlet UITextField *requester_name;
@property (weak, nonatomic) IBOutlet UITextField *requester_email;
@property (weak, nonatomic) IBOutlet UITextView *requester_comments;


@end
