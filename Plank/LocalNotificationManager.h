//
//  LocalNotificationManager.h
//  Plank
//
//  Created by Shi Lin on 1/14/14.
//  Copyright (c) 2014 Forrest Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationManager : NSObject

+ (instancetype)sharedInstance;

- (void)registerLocalNotification:(NSDate*)fireDate message:(NSString*)showMsg;
- (void)runLocalNotificationForeground:(NSString*)message;
@end
