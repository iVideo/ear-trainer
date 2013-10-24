//
//  ETFilterStateHandler.h
//  ear trainer
//
//  Created by Berk Mollamustafaoğlu on 22/10/2013.
//  Copyright (c) 2013 Berk Mollamustafaoğlu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETFilterStateHandler : NSObject

-(void)updateFilter:(int)filterNumber withState:(BOOL)state;
-(int)selectRandomFilter;
@end
