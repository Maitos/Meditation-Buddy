//
//  MBDataAttendant.m
//  Meditation Buddy
//
//  Created by Maitland Marshall on 15/09/2015.
//  Copyright (c) 2015 MMarshall. All rights reserved.
//

#import "MBDataAttendant.h"

@implementation MBDataAttendant

+(id)performQueryOnDataSet:(NSString*)dataSet withQuery: (NSString*)qry {
    NSManagedObjectContext* context = [MBData defaultData].objectContext;
    NSError* error;
    
    NSFetchRequest* fetch = [NSFetchRequest fetchRequestWithEntityName:dataSet];
    if(qry) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:qry];
        [fetch setPredicate:predicate];
    }
    
    NSArray* results = [context executeFetchRequest:fetch error:&error];
    
    if(error) {
        NSLog(@"%@", error);
        return nil;
    }
    
    return results;
}

+(NSManagedObject*)createEntityWithType: (NSString*)modelType {
    NSEntityDescription* desc = [NSEntityDescription entityForName:modelType inManagedObjectContext:[MBData defaultData].objectContext];
    NSManagedObject* entity = [[NSManagedObject alloc] initWithEntity:desc insertIntoManagedObjectContext:[MBData defaultData].objectContext];
    
    return entity;
}
+(void)deleteEntity: (NSManagedObject*)entity {
    NSManagedObjectContext* context = [MBData defaultData].objectContext;
    [context deleteObject:entity];
}

+(void)saveChanges {
    NSError* error;
    [[MBData defaultData].objectContext save:&error];
    
    if(error) {
        NSLog(@"%@", error);
    }
}


+(NSNumber*)meditationTotalDuration {
    NSArray* results = [self performQueryOnDataSet:@"Meditation" withQuery:nil];
    if(results.count == 0) return @0;
    
    return [results valueForKeyPath:@"@sum.duration"];
}

+(NSNumber*)meditationBestRunStreak {
    NSArray* results = [self performQueryOnDataSet:@"Meditation" withQuery:nil];
    if(results.count == 0) return @0;
    
    results = [results sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    NSDate* currentDate;
    NSDate* today;
    
    NSCalendar* calendar = NSCalendar.currentCalendar;
    NSCalendarUnit preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents* components = [calendar components:preservedComponents fromDate:[NSDate date]];
    today = [calendar dateFromComponents:components];
    
    int runStreak = 0;
    int bestRunStreak = 0;
    for(Meditation* med in results) {
        components = [calendar components:preservedComponents fromDate:med.date];
        NSDate* medDate = [calendar dateFromComponents:components];
        
        if([medDate isEqualToDate:currentDate]) continue;
        //so it counts today as a run streak, but not the same day twice
        
        NSTimeInterval secondsSince = [currentDate ?: today timeIntervalSinceDate:medDate];
        double hoursSince = (double)secondsSince / 60 / 60;
        if(hoursSince < -24) {
            if(runStreak > bestRunStreak) {
                bestRunStreak = runStreak;
                runStreak = 0;
                currentDate = medDate;
                continue;
            }
        };
        runStreak++;
        
        currentDate = medDate;
    }
    
    return @(MAX(bestRunStreak, runStreak));
}

+(NSNumber*)meditationCurrentRunStreak {
    NSArray* results = [self performQueryOnDataSet:@"Meditation" withQuery:nil];
    if(results.count == 0) return @0;
    
    results = [results sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    NSDate* currentDate;
    NSDate* today;
    
    NSCalendar* calendar = NSCalendar.currentCalendar;
    NSCalendarUnit preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents* components = [calendar components:preservedComponents fromDate:[NSDate date]];
    today = [calendar dateFromComponents:components];
    
    int runStreak = 0;
    for(Meditation* med in results) {
        components = [calendar components:preservedComponents fromDate:med.date];
        NSDate* medDate = [calendar dateFromComponents:components];
        
        if([medDate isEqualToDate:currentDate]) continue;
        //so it counts today as a run streak, but not the same day twice
        
        NSTimeInterval secondsSince = [currentDate ?: today timeIntervalSinceDate:medDate];
        double hoursSince = (double)secondsSince / 60 / 60;
        if(hoursSince > 24) break;
        runStreak++;
        
        currentDate = medDate;
    }
    
    return @(runStreak);
}

+(NSNumber*)meditationAverageMinutes {
    NSArray* results = [self performQueryOnDataSet:@"Meditation" withQuery:nil];
    if(results.count == 0) return @0;
    
    int average = 0;
    for(Meditation* med in results) {
        average += [med duration].intValue;
    }
    
    average /= results.count;
    
    return @(average);
}





@end
