//
//  MBView.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 3/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import "MBView.h"

int CONTENT_Z = 5;

CGFloat TAIL_WIDTH = 50.0;
CGFloat TAIL_HEIGHT = 10;
int TAIL_Z = 2;

int BORDER_Z = 1;

@interface MBView()

@property (nonatomic, strong) NSMutableArray* MBLayers;

@end

@implementation MBView

#pragma mark INITIALIZATION
-(void)_init {
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.userInteractionEnabled = YES;
    self.contentView.layer.zPosition = CONTENT_Z;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.specialView = [[UIView alloc] initWithFrame:self.bounds];
    self.specialView.userInteractionEnabled = YES;
    self.specialView.layer.zPosition = CONTENT_Z;
    self.specialView.clipsToBounds = NO;
    self.specialView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.TailHeight = TAIL_HEIGHT;
    self.TailWidth = TAIL_WIDTH;
    
    self.MBLayers = [NSMutableArray new];
    
    [self addSubview:self.contentView];
    [self sendSubviewToBack:self.contentView];
    [self addSubview:self.specialView];
    [self sendSubviewToBack:self.specialView];
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self _init];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self _init];
    }
    return self;
}

-(void)prepareForInterfaceBuilder {
    [self setup];
}

#pragma mark UI
-(void)setup {
    [self setupTail];
    [self setupBorder];
}
-(void)setupTail {
    if(!self.TailPosition || !self.TailHeight) return;
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.fillColor = self.backgroundColor.CGColor;
    layer.zPosition = TAIL_Z;
    
    CGRect bounds = self.bounds;
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    if(self.TailPosition == 2) {
        CGPoint startPoint = CGPointMake((bounds.size.width / 2.0) + self.TailOffset - self.TailWidth / 2.0, self.BorderTop);
        
        [path moveToPoint:startPoint];
        [path addLineToPoint:CGPointMake((bounds.size.width / 2.0) + self.TailOffset + self.TailWidth / 2.0, self.BorderTop)];
        [path addLineToPoint:CGPointMake((bounds.size.width / 2.0) + self.TailOffset, -(double)self.TailHeight + self.BorderTop)];
        
    } else if(self.TailPosition == 4) {
        CGPoint startPoint = CGPointMake((bounds.size.width / 2.0) + self.TailOffset - self.TailWidth / 2.0,bounds.size.height - self.BorderBottom);
        
        [path moveToPoint:startPoint];
        [path addLineToPoint:CGPointMake((bounds.size.width / 2.0) + self.TailOffset+ self.TailWidth / 2.0, bounds.size.height - self.BorderBottom)];
        [path addLineToPoint:CGPointMake((bounds.size.width / 2.0) + self.TailOffset, bounds.size.height + (double)self.TailHeight)];
    }
    
    [path closePath];
    layer.path = path.CGPath;
    
    [self.specialView.layer addSublayer:layer];
    [self.MBLayers addObject:layer];
    
    
}
-(void)setupBorder {
    self.layer.cornerRadius = self.BorderRadius;
    self.contentView.layer.cornerRadius = self.BorderRadius;
    
    if(!self.BorderBottom && !self.BorderTop) return;
    
    if(self.BorderTop) {
        
        CAShapeLayer* layer = [CAShapeLayer layer];
        [layer setLineWidth:self.BorderTop];
        [layer setZPosition:BORDER_Z];
        
        if(self.BorderColor) {
            [layer setStrokeColor:self.BorderColor.CGColor];
        }
        
        UIBezierPath* path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(0, self.BorderTop / 2)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, self.BorderTop / 2)];
        
        layer.path = path.CGPath;
        
        [self.layer addSublayer:layer];
        [self.MBLayers addObject:layer];
    }
    
    if(self.BorderBottom) {
        CAShapeLayer* layer = [CAShapeLayer layer];
        [layer setLineWidth:self.BorderBottom];
        [layer setZPosition:BORDER_Z];
        
        if(self.BorderColor) {
            [layer setStrokeColor:self.BorderColor.CGColor];
        }
        
        UIBezierPath* path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(0, self.bounds.size.height - self.BorderBottom / 2)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - self.BorderBottom / 2)];
        
        layer.path = path.CGPath;
        
        [self.layer addSublayer:layer];
        [self.MBLayers addObject:layer];
    }
}

-(void)setTailHeight:(double)TailHeight {
    if(TailHeight < 0) TailHeight = 0;
    _TailHeight = TailHeight;
    [self setNeedsLayout];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    for (CALayer *layer in self.MBLayers) {
        [layer removeFromSuperlayer];
    }
    
    self.contentView.frame = self.bounds;
    [self setup];
}


@end
