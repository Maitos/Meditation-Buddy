//
//  MBData.h
//  Meditation Buddy
//
//  Created by Maitland Marshall on 15/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Meditation.h"

@interface MBData : NSObject

@property (nonatomic, strong) NSManagedObjectModel* objectModel;
@property (nonatomic, strong) NSManagedObjectContext* objectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

+(MBData*)defaultData;

@end
