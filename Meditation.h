//
//  Meditation.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 15/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meditation : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * location;

@end
