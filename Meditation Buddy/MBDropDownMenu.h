//
//  MBDropDownMenu.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 22/10/2015.
//  Copyright © 2015 MMarshall. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBDropDownMenuDelegate <NSObject>

-(void)menuItemWasSelected:(NSString*)item;

@end

@interface MBDropDownMenu : UIBarButtonItem <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<MBDropDownMenuDelegate> delegate;
@property (nonatomic) IB_DESIGNABLE NSUInteger MenuItemHeight;
@property (nonatomic, strong) IB_DESIGNABLE UIColor* textColor;

@property (nonatomic, strong) NSMutableArray* items;

-(void)addMenuItem:(NSString*)item imageNamed: (NSString*)imgName;
-(void)removeMenuItem:(NSString*)itemTitle;
-(void)toggleMenu;
-(void)hideMenu;

@end
