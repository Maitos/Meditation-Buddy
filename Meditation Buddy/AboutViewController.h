//
//  AboutViewController.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 24/10/2015.
//  Copyright © 2015 MMarshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBView.h"

@interface AboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UITextView *lblBlurb;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgPicture;
@property (weak, nonatomic) IBOutlet MBView *vwBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblNameHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vwBackBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblBlurpTop;

@end
