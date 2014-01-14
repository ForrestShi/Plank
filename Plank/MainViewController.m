//
//  ViewController.m
//  Plank
//
//  Created by Shi Lin on 1/9/14.
//  Copyright (c) 2014 Forrest Shi. All rights reserved.
//

#import "MainViewController.h"
#import "LocalNotificationManager.h"

static const int TOTAL = 10;

@interface MainViewController (){

    NSTimer *sessionTimer;
    long sessionCount;
    BOOL timerStatus;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"%s",__PRETTY_FUNCTION__);
	// Do any additional setup after loading the view, typically from a nib.

    
    sessionCount = 0;

    timerStatus = NO;
    
    [[LocalNotificationManager sharedInstance] registerLocalNotification:[NSDate dateWithTimeIntervalSinceNow:5] message:@"Time for Self Study"];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    self.todayProgressView.progressTotal = TOTAL;
    self.todayProgressView.progressCounter = 0;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.scrollBGView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height *2);
    self.scrollBGView.frame = self.view.bounds;
    self.scrollBGView.scrollEnabled = YES;
    
    self.scrollHorStatusView.contentSize = CGSizeMake(self.view.bounds.size.width*2, self.view.bounds.size.height*.25);
    self.scrollHorStatusView.scrollEnabled = YES;

    NSLog(@"%s",__PRETTY_FUNCTION__);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onStart:(id)sender{
    
    if (timerStatus) {
        if (sessionTimer) {
            [sessionTimer invalidate];
            sessionTimer = nil;
        }
        sessionCount = 0;
        [self.todayProgressView setProgressCounter:0];
        
    }else{
        if (!sessionTimer) {
            sessionTimer = [NSTimer bk_timerWithTimeInterval:1 block:^(NSTimer *timer) {
                sessionCount++;
                self.todayProgressView.progressCounter = sessionCount;
                
            } repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:sessionTimer forMode:NSDefaultRunLoopMode];
        }
        [sessionTimer fire];
    }
    
    timerStatus = !timerStatus;

}

@end
