//
//  ETFilterStateHandler.m
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 22/10/2013.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import "ETFilterStateHandler.h"

@interface ETFilterStateHandler()

@end
@implementation ETFilterStateHandler


-(id)init
{
    self = [super init];
    
    if (self) {
        self.activeFilters = [[NSMutableArray alloc] init];
    }
   
    return self;
}

-(void)updateFilter:(int)filterNumber withState:(BOOL)state
{
    NSNumber *filterNo = [NSNumber numberWithInt:filterNumber];

    NSLog(@" state changed of filter %@", filterNo);
    
    if (state) {
        [self.activeFilters addObject:filterNo];
    }
    
    else if (!state)
    {
        NSLog(@"hellohello");
        [self.activeFilters removeObject:filterNo];
        
        
    }
    
    self.activeFilters = [[self.activeFilters sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    
}

-(int)selectRandomFilter
{
    if (!([self.activeFilters count] == 0)) {
        
        int selectedIndex = arc4random_uniform([self.activeFilters count]);
        
        NSLog(@"%i", selectedIndex);
        
        
        NSNumber *obtainedValue = [self.activeFilters objectAtIndex:selectedIndex];
        
        int returnIndex = [obtainedValue integerValue];
        
        NSLog(@"%i", returnIndex);
        
        return returnIndex;
    }
    else
        return NULL;
    
}


@end
