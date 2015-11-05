//
//  MBView.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 3/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface MBView : UIView

@property (nonatomic) IBInspectable NSUInteger BorderRadius;
@property (nonatomic) IBInspectable NSUInteger TailPosition;
@property (nonatomic) IBInspectable double TailHeight;
@property (nonatomic) IBInspectable double TailOffset;
@property (nonatomic) IBInspectable double TailWidth;

@property (nonatomic) IBInspectable UIColor* BorderColor;
@property (nonatomic) IBInspectable NSUInteger BorderTop;
@property (nonatomic) IBInspectable NSUInteger BorderBottom;

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIView* specialView;

-(void)_init;

@end
