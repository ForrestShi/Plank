//
//  PlankPlan.m
//  Plank
//
//  Created by Shi Lin on 1/14/14.
//  Copyright (c) 2014 Forrest Shi. All rights reserved.
//

#import "PlankPlan.h"

@implementation PlankPlan

- (void)setUp{
    self.plankSessions = [NSMutableArray array];
}

- (NSArray*)dateArray{
    NSMutableArray *arr = [NSMutableArray array];
    if (self.plankSessions) {
        for (Session *s in self.plankSessions) {
            NSString *ss = [NSString stringWithFormat:@"%@", s.dateEnd];
            DLog(@"%@",ss);
            [arr addObject:ss];
        }
    }
    return arr;
}

- (NSArray*)scoreArray{
    NSMutableArray *arr = [NSMutableArray array];
    if (self.plankSessions) {
        for (Session *s in self.plankSessions) {
            NSString *ss = [NSString stringWithFormat:@"%@ sec",s.timeSpent];
            DLog(@"%@",ss);
            [arr addObject:ss];
        }
    }
    return arr;
}

@end
