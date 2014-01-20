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
static const int PAGE_MAX = 3;

@interface MainViewController ()<UIScrollViewDelegate>{

    NSTimer *sessionTimer;
    long sessionCount;
    BOOL timerStatus;
    PNBarChart *barChart;
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
    self.todayProgressView.theme.incompletedColor = [UIColor whiteColor];
    self.todayProgressView.theme.completedColor = [UIColor iOS7redGradientStartColor];
    self.todayProgressView.theme.sliceDividerHidden = YES;
    self.todayProgressView.theme.thickness = 7;
    self.todayProgressView.label.hidden = YES;
    
    self.pageCtr.transform = CGAffineTransformRotate(self.pageCtr.transform, M_PI_2);
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.scrollBGView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * PAGE_MAX);
    self.scrollBGView.frame = self.view.bounds;
    self.scrollBGView.scrollEnabled = YES;
    self.scrollBGView.pagingEnabled = YES;
    self.scrollBGView.delegate = self;

    float barCalWidth = 66.* ( [PlankPlan sharedInstance].plankSessions != nil ? [PlankPlan sharedInstance].plankSessions.count:0);
    
    self.scrollHorStatusView.backgroundColor = [UIColor clearColor];
    self.scrollHorStatusView.contentSize = CGSizeMake(self.view.bounds.size.width > barCalWidth ? self.view.bounds.size.width : barCalWidth, self.scrollHorStatusView.frame.size.height);
    self.scrollHorStatusView.scrollEnabled = YES;

    barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, barCalWidth, self.scrollHorStatusView.bounds.size.height)];
    if ([PlankPlan sharedInstance].plankSessions) {
        [self reloadBarView];
    }
    
    [self.scrollHorStatusView addSubview:barChart];
    

    [self.pageCtr setCurrentPage:0];
    [self.pageCtr setNumberOfPages:3];
    
    self.startBtn.backgroundColor = [UIColor whiteColor];
    self.startBtn.layer.cornerRadius = self.startBtn.bounds.size.width/2.;
}

- (void)reloadBarView{
    float barCalWidth = 66.* ( [PlankPlan sharedInstance].plankSessions != nil ? [PlankPlan sharedInstance].plankSessions.count:0);
    self.scrollHorStatusView.contentSize = CGSizeMake(self.view.bounds.size.width > barCalWidth ? self.view.bounds.size.width : barCalWidth, self.scrollHorStatusView.frame.size.height);
    barChart.bounds = CGRectMake(0, 0, barCalWidth, self.scrollHorStatusView.bounds.size.height);
    [barChart setXLabels:[PlankPlan sharedInstance].dateArray];
    //[barChart setYLabels:@[@"60",@"120",@"180",@"240"]];
    [barChart setYValues:[PlankPlan sharedInstance].scoreArray];
    barChart.strokeColor = [UIColor iOS7redGradientStartColor];
    barChart.backgroundColor = [UIColor clearColor];
    
    [self.scrollHorStatusView scrollRectToVisible:CGRectMake(self.scrollHorStatusView.contentSize.width - self.view.bounds.size.width, 0, self.scrollHorStatusView.frame.size.width, self.scrollHorStatusView.frame.size.height) animated:YES];
    [barChart strokeChart];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTimer{
    sessionCount++;
    self.todayProgressView.progressCounter = sessionCount%self.todayProgressView.progressTotal;
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
        [self.startBtn setTitleColor:[UIColor iOS7blackGradientEndColor] forState:UIControlStateNormal];
        self.startBtn.backgroundColor = [UIColor whiteColor];
        
        [self reloadBarView];
        
    }else{
        //START
        
        if (!sessionTimer) {
            sessionTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:sessionTimer forMode:NSDefaultRunLoopMode];
        }
        [sessionTimer fire];

        [self.startBtn setTitle:@"STOP" forState:UIControlStateNormal];
        [self.startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.startBtn.backgroundColor = [UIColor iOS7redColor];
    }
    
    timerStatus = !timerStatus;


    DLog(@"DUMP %@" , [[PlankPlan sharedInstance] plankSessions] );
    
}

#pragma mark - Page Controller & Scroll Gesture
- (IBAction)onChangePage:(id)sender{

    [self.scrollBGView setContentOffset:CGPointMake(0,  self.pageCtr.currentPage*self.view.bounds.size.height) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.pageCtr setCurrentPage:scrollView.contentOffset.y/self.view.bounds.size.height];
}

@end
