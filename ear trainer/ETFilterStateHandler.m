//
//  ETFilterStateHandler.m
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 22/10/2013.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import "ETFilterStateHandler.h"

@interface ETFilterStateHandler()
{
    NSMutableArray *activeFilters;
}

@end
@implementation ETFilterStateHandler


-(id)init
{
    self = [super init];
    
    if (self) {
        activeFilters = [[NSMutableArray alloc] init];
    }
   
    return self;
}

-(void)updateFilter:(int)filterNumber withState:(BOOL)state
{
    NSNumber *filterNo = [NSNumber numberWithInt:filterNumber];

    NSLog(@" state changed of filter %@", filterNo);
    
    if (state) {
        [activeFilters addObject:filterNo];
    }
    
    else if (!state)
    {
        NSLog(@"hellohello");
        [activeFilters removeObject:filterNo];
        
        
    }
    
    [activeFilters enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"this is inside the array%@", obj);
    }];
}

-(int)selectRandomFilter
{
    if (!([activeFilters count] == 0)) {
        
        int selectedIndex = arc4random_uniform([activeFilters count]);
        
        NSLog(@"%i", selectedIndex);
        
        
        NSNumber *obtainedValue = [activeFilters objectAtIndex:selectedIndex];
        
        int returnIndex = [obtainedValue integerValue];
        
        NSLog(@"%i", returnIndex);
        
        return returnIndex;
    }
    else
        return NULL;
    
}


@end
