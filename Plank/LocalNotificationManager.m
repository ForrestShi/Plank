//
//  LocalNotificationManager.m
//  Plank
//
//  Created by Shi Lin on 1/14/14.
//  Copyright (c) 2014 Forrest Shi. All rights reserved.
//

#import "LocalNotificationManager.h"

@implementation LocalNotificationManager

+ (instancetype)sharedInstance{
    static LocalNotificationManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LocalNotificationManager alloc] init];
    });
    return _instance;
}

- (void)registerLocalNotification:(NSDate*)fireDate message:(NSString*)showMsg{
    UILocalNotification *lnft = [[UILocalNotification alloc] init];
    lnft.fireDate = fireDate;
    lnft.alertBody = showMsg;
    [[UIApplication sharedApplication] scheduleLocalNotification:lnft];
}

- (void)runLocalNotificationForeground:(NSString*)message{
    SIAlertView *alertView = [[SIAlertView alloc]  initWithTitle:@"" andMessage:message];
    [alertView addButtonWithTitle:@"Gotcha" type:SIAlertViewButtonTypeDestructive handler:^(SIAlertView *alertView) {
        
    }];
    [alertView show];
}
@end
