//
//  MBButtonGrid.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 4/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import "MBView.h"

@protocol MBButtonGridDelegate <NSObject>

@optional
-(void)itemWasSelected:(NSString*)item;

@end

@interface MBButtonGrid : MBView

@property (nonatomic) IBInspectable UIColor* GridCellColor;
@property (nonatomic, weak) id<MBButtonGridDelegate> delegate;

-(void)addGridItem: (NSString*)title;
-(void)selectItem: (NSString*) item;
-(NSString*)getSelection;

@end
