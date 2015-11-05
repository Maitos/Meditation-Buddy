//
//  MBDropDownMenu.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 22/10/2015.
//  Copyright © 2015 MMarshall. All rights reserved.
//

#import "MBDropDownMenu.h"
#import "MBView.h"
#import "MBDropDownMenuItem.h"

int TITLE_OFFSET = 45;
double SHOW_MENU_ANIMATION_LENGTH = 0.25;

@interface MBDropDownMenu()

@property (nonatomic, strong) MBView* dropDownMenu;

@end

@implementation MBDropDownMenu

#pragma mark INITIALIZATION
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialize];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    self.items = [NSMutableArray new];
    self.MenuItemHeight = 50;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
    [tap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tap];
}

#pragma mark FUNCTIONALITY
-(void)addMenuItem:(NSString*)item imageNamed: (NSString*)imgName {
    MBDropDownMenuItem* menuItem = [MBDropDownMenuItem new];
    menuItem.title = item;
    menuItem.imageName = imgName;
    [self.items addObject:menuItem];
}
-(void)removeMenuItem:(NSString*)itemTitle {
    MBDropDownMenuItem* itemToRemove;
    
    for(MBDropDownMenuItem* item in self.items) {
        if([item.title isEqualToString:itemTitle]) {
            itemToRemove = item;
            break;
        }
    }
    
    if(itemToRemove) {
        [self.items removeObject:itemToRemove];
    }
}
-(void)toggleMenu {
    [self setupLayout];
}
-(void)menuItemWasTapped: (UITapGestureRecognizer*) gesture {
    CGPoint tapLocation = [gesture locationInView:gesture.view];
    double rippleSize = 5; //diameter
    double rippleMaxSize = 300;
    
    gesture.view.layer.masksToBounds = YES;
    
    CAShapeLayer* ripple = [[CAShapeLayer alloc] initWithLayer:gesture.view.layer];
    ripple.fillColor = [self.tintColor colorWithAlphaComponent:0].CGColor;
    ripple.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(tapLocation.x - rippleMaxSize / 2, tapLocation.y - rippleMaxSize / 2, rippleMaxSize, rippleMaxSize)].CGPath;
    [gesture.view.layer addSublayer:ripple];
    
    [CATransaction begin];
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.duration = 0.3;
    anim.removedOnCompletion = NO;
    anim.fromValue = (id)[UIBezierPath bezierPathWithOvalInRect:CGRectMake(tapLocation.x - rippleSize / 2, tapLocation.y - rippleSize / 2, rippleSize, rippleSize)].CGPath;
    anim.toValue = (id)[UIBezierPath bezierPathWithOvalInRect:CGRectMake(tapLocation.x - rippleMaxSize / 2, tapLocation.y - rippleMaxSize / 2, rippleMaxSize, rippleMaxSize)].CGPath;
    
    CABasicAnimation* anim2 = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    anim2.duration = 0.5;
    anim2.fromValue =(id)[self.tintColor colorWithAlphaComponent:0.3].CGColor;
    anim2.toValue = (id)[self.tintColor colorWithAlphaComponent:0].CGColor;
    
    [CATransaction setCompletionBlock:^{
        [ripple removeFromSuperlayer];
        [self hideMenu];
        
        UILabel* senderLabel = [[gesture.view subviews] objectAtIndex:0];
        [self menuItemWasSelected:senderLabel.text];
    }];
    
    [ripple addAnimation:anim forKey:@"path"];
    [ripple addAnimation:anim2 forKey:@"fillColor"];
    [CATransaction commit];
}


#pragma mark DELEGATES
-(void)menuItemWasSelected: (NSString*) item {
    //TODO: ANIMATION
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(menuItemWasSelected:)]) {
        [self.delegate menuItemWasSelected:item];
    }
}

#pragma mark LAYOUT
-(void)setupLayout {
    if(self.dropDownMenu) {
        [self hideMenu];
        return;
    }
    
    [self showMenu];
    
}

#pragma mark SHOW MENU
-(void)showMenu {
    self.dropDownMenu = [[MBView alloc] initWithFrame:CGRectMake(self.frame.origin.x - 3, self.frame.origin.y + self.frame.size.height, 130, self.MenuItemHeight * self.items.count)];
    self.dropDownMenu.backgroundColor =  [UIColor whiteColor];
    self.dropDownMenu.BorderRadius = 3;
    self.dropDownMenu.TailHeight = 10;
    self.dropDownMenu.TailOffset = -30;
    self.dropDownMenu.TailWidth = 30;
    self.dropDownMenu.TailPosition = 2;
    
    [self generateMenuItems];
    [self performShowMenuAnimation];
    
}
-(void)generateMenuItems {
    int i = 0;
    for(MBDropDownMenuItem* item in self.items) {
        UIView* itemVw = [[UIView alloc] initWithFrame:CGRectMake(0, self.MenuItemHeight * i, self.dropDownMenu.bounds.size.width, self.MenuItemHeight)];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemWasTapped:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [itemVw addGestureRecognizer:tap];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFSET, 0, self.dropDownMenu.bounds.size.width - TITLE_OFFSET, self.MenuItemHeight)];
        lbl.text = item.title;
        lbl.textColor = self.tintColor;
        lbl.font  = [UIFont fontWithName:@"Verdana" size:12];
        [itemVw addSubview:lbl];
        
        //line separator
        if(i < self.items.count-1) {
            UIView* seperator = [[UIView alloc] initWithFrame:CGRectMake(5, self.MenuItemHeight * (i+1), self.dropDownMenu.bounds.size.width - 10, 1)];
            seperator.backgroundColor = [self.tintColor colorWithAlphaComponent:0.5];
            [self.dropDownMenu.contentView addSubview:seperator];
        }
        
        //image
        if(item.imageName) {
            UIImageView * img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:item.imageName]];
            [img setFrame:CGRectMake(10, self.MenuItemHeight * (i + 1) - self.MenuItemHeight / 2 - 10, 20, 20)];
            [self.dropDownMenu.contentView addSubview:img];
        }
        
        [self.dropDownMenu.contentView addSubview:itemVw];
        i++;
    }
}
-(void)performShowMenuAnimation {
    double oldHeight = self.dropDownMenu.frame.size.height;
    CGRect dropDownMenuFrame = self.dropDownMenu.frame;
    dropDownMenuFrame.size.height = 0;
    
    self.dropDownMenu.frame = dropDownMenuFrame;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.dropDownMenu];

    [UIView animateWithDuration:SHOW_MENU_ANIMATION_LENGTH
                          delay:0
         usingSpringWithDamping:50
          initialSpringVelocity:10
                        options:0 animations:^{
                            CGRect newFrame = dropDownMenuFrame;
                            newFrame.size.height = oldHeight;
                            self.dropDownMenu.frame = newFrame;
                        }
                     completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark HIDE MENU
-(void)hideMenu {
    if(!self.dropDownMenu) return;
    
    [UIView animateWithDuration:SHOW_MENU_ANIMATION_LENGTH
                          delay:0
         usingSpringWithDamping:50
          initialSpringVelocity:10
                        options:0 animations:^{
                            CGRect dropDownMenuFrame = self.dropDownMenu.frame;
                            dropDownMenuFrame.size.height = 0;
                            self.dropDownMenu.frame = dropDownMenuFrame;
                            [self.dropDownMenu.specialView setAlpha:0];
                        }
                     completion:^(BOOL finished) {
                         [self.dropDownMenu removeFromSuperview];
                         self.dropDownMenu = nil;
                     }];
}

@end
