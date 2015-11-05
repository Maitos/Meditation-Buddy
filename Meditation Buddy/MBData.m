//
//  MBData.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 15/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import "MBData.h"

static MBData* singleton;

@implementation MBData

#pragma mark INITIALIZATION
+(void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
        singleton = [MBData new];
    }
}
-(instancetype)init {
    self = [super init];
    if(self) {
        [self initializeCoreData];
    }
    return self;
}
-(void)initializeCoreData {
     NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"MBDatabase.sqlite"];
    
    NSDictionary *options = @{NSPersistentStoreFileProtectionKey: NSFileProtectionComplete,
                              NSMigratePersistentStoresAutomaticallyOption:@YES};
    
    self.objectModel = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    
    self.objectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.objectModel];
    
    NSError* error;
    [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    
    if(error) {
        NSLog(@"%@", error);
        return;
    }
    
    self.objectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
}

+(MBData*)defaultData {
    return singleton;
}

@end
