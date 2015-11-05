//
//  AboutViewController.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 24/10/2015.
//  Copyright © 2015 MMarshall. All rights reserved.
//

#import "AboutViewController.h"
#import "MBDataAttendant.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailMe)];
    [tap setNumberOfTapsRequired:1];
    [self.lblEmail addGestureRecognizer:tap];
    
    if(IS_IPHONE_4_OR_LESS || IS_IPAD) {
        self.vwBackBottomConstraint.constant = 20;
        
        self.lblName.font = [self.lblName.font fontWithSize:16];
        self.lblBlurb.font = [self.lblBlurb.font fontWithSize:10];
        self.lblEmail.font = [self.lblEmail.font fontWithSize:10];
        
        if(IS_RETINA) {
            self.vwBackBottomConstraint.constant = 0;
            self.lblBlurpTop.constant = 5;
            self.lblNameHeight.constant = 15;
        }
        
    } else if(IS_IPHONE_5) {
        self.vwBackBottomConstraint.constant = -20;
        self.lblName.font = [self.lblName.font fontWithSize:20];
        
        self.lblEmail.font = [self.lblEmail.font fontWithSize:12];
    } else if(IS_IPHONE_6) {
        self.vwBackBottomConstraint.constant = 120;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)emailMe {
    NSString *url = [[NSString stringWithFormat:@"mailto:%@?subject=Meditation Buddy",self.lblEmail.text ]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
