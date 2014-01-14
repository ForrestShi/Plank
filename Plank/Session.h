//
//  Session.h
//  Plank
//
//  Created by Shi Lin on 1/14/14.
//  Copyright (c) 2014 Forrest Shi. All rights reserved.
//

#import "BaseModel.h"

@interface Session : BaseModel

@property (nonatomic,strong) NSNumber *timeSpent;
@property (nonatomic,strong) NSDate *dateEnd;

@end
