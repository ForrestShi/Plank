//
//  ViewController.m
//  Plank
//
//  Created by Shi Lin on 1/9/14.
//  Copyright (c) 2014 Forrest Shi. All rights reserved.
//

#import "MainViewController.h"
#import "LocalNotificationManager.h"
#import "PNChart.h"

static const int TOTAL = 60;

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
    
    //[[LocalNotificationManager sharedInstance] registerLocalNotification:[NSDate dateWithTimeIntervalSinceNow:5] message:@"Time for Self Study"];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    self.todayProgressView.progressTotal = TOTAL;
    //self.todayProgressView.progressCounter = 0;
    //MDRadialProgressTheme *curTheme = [[MDRadialProgressTheme alloc] init];
    self.todayProgressView.theme.incompletedColor = [UIColor clearColor];
    self.todayProgressView.label.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.scrollBGView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height *2);
    self.scrollBGView.frame = self.view.bounds;
    self.scrollBGView.scrollEnabled = YES;


    float barCalWidth = 44.* ( [PlankPlan sharedInstance].plankSessions != nil ? [PlankPlan sharedInstance].plankSessions.count:0);
    
    self.scrollHorStatusView.backgroundColor = [UIColor clearColor];
    self.scrollHorStatusView.contentSize = CGSizeMake(self.view.bounds.size.width > barCalWidth ? self.view.bounds.size.width : barCalWidth, self.scrollHorStatusView.frame.size.height);
    self.scrollHorStatusView.scrollEnabled = YES;
    PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, barCalWidth, self.scrollHorStatusView.bounds.size.height)];
    if ([PlankPlan sharedInstance].plankSessions) {
        [barChart setXLabels:[PlankPlan sharedInstance].dateArray];
        //[barChart setYLabels:@[@"60",@"120",@"180",@"240"]];
        [barChart setYValues:[PlankPlan sharedInstance].scoreArray];
        [barChart strokeChart];
        barChart.backgroundColor = [UIColor clearColor];
        barChart.strokeColor = [UIColor yellowColor];
    }
    [self.scrollHorStatusView addSubview:barChart];
    

    NSLog(@"%s",__PRETTY_FUNCTION__);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTimer{
    sessionCount++;
    self.todayProgressView.progressCounter = sessionCount;
}

- (IBAction)onStart:(id)sender{
    
    if (timerStatus) {
        
        //END
        
        if (sessionTimer) {
            [sessionTimer invalidate];
            sessionTimer = nil;
        }
        
        Session *s = [Session new];
        s.timeSpent = @(sessionCount);
        s.dateEnd = [NSDate date];
        [[PlankPlan sharedInstance].plankSessions addObject:s];
        [[PlankPlan sharedInstance] save];
        
        
        sessionCount = 0;
        [self.todayProgressView setProgressCounter:0];
        
        [self.startBtn setTitle:@"START" forState:UIControlStateNormal];
        
    }else{
        //START
        
        if (!sessionTimer) {
            sessionTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:sessionTimer forMode:NSDefaultRunLoopMode];
        }
        [sessionTimer fire];

        [self.startBtn setTitle:@"STOP" forState:UIControlStateNormal];
        [self.startBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    timerStatus = !timerStatus;


    DLog(@"DUMP %@" , [[PlankPlan sharedInstance] plankSessions] );
    
}

@end
