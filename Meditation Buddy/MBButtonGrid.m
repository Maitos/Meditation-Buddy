//
//  MBButtonGrid.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 4/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import "MBButtonGrid.h"

int MAX_COLUMNS = 4;

@interface MBButtonGrid()

@property (nonatomic, strong) CAShapeLayer* GRID_DIVIDER;


@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, strong) UIView* selectedItem;



@end

@implementation MBButtonGrid

#pragma mark INITIALIZATION
-(void)_initButtonGrid {
    self.items = [NSMutableArray new];
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self _initButtonGrid];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self _initButtonGrid];
    }
    return self;
}

#pragma mark LAYOUT
-(int)rows {
    return floor(self.items.count / MAX_COLUMNS);
}
-(int)columns {
    return (int)MIN(MAX_COLUMNS, self.items.count);
}
-(double)itemHeight {
    return (double)self.bounds.size.height / self.rows;
}
-(double)itemWidth {
    return (double)self.bounds.size.width / MIN(self.items.count, MAX_COLUMNS);
}
-(void)layoutSubviews {
    [super layoutSubviews];
    if(CGRectIsEmpty(self.bounds)) return;
    if(self.items.count == 0) return;
    
    [self layoutItems];
    [self layoutGridDivider];
    
}
-(void)layoutItems {
    for(int i = 0; i<self.items.count; i++) {
        UIView* item = [self.items objectAtIndex:i];
        
        item.backgroundColor = [UIColor clearColor];
        
        if(item == self.selectedItem) {
            item.backgroundColor = self.GridCellColor;
        }
        
        CGRect itemFrame = item.frame;
        
        int currentRow = floor((double)i / self.columns);
        int currentCol = i % self.columns;
        
        itemFrame.size.width = self.itemWidth;
        itemFrame.size.height = self.itemHeight;
        
        itemFrame.origin.x = currentCol * self.itemWidth;
        itemFrame.origin.y = currentRow * self.itemHeight;
        
        item.frame = CGRectIntegral(itemFrame);
        
        UILabel* label = [[item subviews] objectAtIndex:0];
        CGRect labelFrame = CGRectMake(0, self.itemHeight / 2 - 15, self.itemWidth, 30);
        label.frame = labelFrame;
    }
}
-(void)layoutGridDivider {
    if(self.GRID_DIVIDER) {
        [self.GRID_DIVIDER removeFromSuperlayer];
        self.GRID_DIVIDER = nil;
    }
    
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.strokeColor = self.GridCellColor.CGColor;
    layer.zPosition = 5;
    layer.lineWidth = 0.5;
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    //HORIZONTAL
    int rows = self.rows;
    for (int i=1; i<rows; i++) {
        CGPoint startPoint = CGPointMake(self.bounds.origin.x, self.itemHeight * i - 0.25);
     
        [path moveToPoint:startPoint];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, startPoint.y)];
    }

    //VERTICAL
    int columns = self.columns;
    for (int i = 1; i<columns; i++) {
        CGPoint nextPoint = CGPointMake(self.itemWidth * i, self.bounds.origin.y);
        double height = self.bounds.size.height;
        
//        if(self.TailPosition && nextPoint.x == self.bounds.size.width / 2) {
//            height = self.frame.size.height + 10;
//        }
        
        [path moveToPoint:nextPoint];
        [path addLineToPoint:CGPointMake(nextPoint.x, height)];
    }
    
    
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
    self.GRID_DIVIDER = layer;
}

#pragma mark FUNCTIONALITY
-(void)addGridItem: (NSString*)title {
    UIView* gridItem = [[UIView alloc] initWithFrame:CGRectZero];
    gridItem.userInteractionEnabled = YES;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont fontWithName:@"Verdana" size:18]];
    
    [gridItem addSubview:titleLabel];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapped:)];
    [tap setNumberOfTapsRequired:1];
    [gridItem addGestureRecognizer:tap];
    
    [self.items addObject:gridItem];
    [self.contentView addSubview:gridItem];

    
    [self setNeedsLayout];
}
-(void)selectItem: (NSString*) item {
    for(UIView* view in self.items) {
        UILabel* lbl = [[view subviews] objectAtIndex:0];
        if([lbl.text isEqualToString:item]) {
            self.selectedItem = view;
            break;
        }
    }
    
    if(self.selectedItem) {
        [self setNeedsLayout];
        [self itemWasSelected];
    }
}
-(void)itemTapped: (UITapGestureRecognizer*) tap {
    UIView* itemTapped = [tap view];
    UILabel* lbl = [[itemTapped subviews] objectAtIndex:0];
    [self selectItem:lbl.text];
}
-(NSString*)getSelection {
    UILabel* lbl = [self.selectedItem.subviews objectAtIndex:0];
    return lbl.text;
}

#pragma mark DELEGATES
-(void)itemWasSelected {
    if(!self.delegate) return;
    if(![self.delegate respondsToSelector:@selector(itemWasSelected:)]) return;
    
    UILabel* lbl = [self.selectedItem.subviews objectAtIndex:0];
    [self.delegate itemWasSelected:lbl.text];
}

@end
