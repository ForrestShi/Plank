//
//  ViewController.h
//  Plank
//
//  Created by Shi Lin on 1/9/14.
//  Copyright (c) 2014 Forrest Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIScrollView *scrollBGView;
@property (nonatomic,strong) IBOutlet UIScrollView *scrollHorStatusView;

@property (nonatomic,strong) IBOutlet MDRadialProgressView *todayProgressView;
@property (nonatomic,strong) IBOutlet UIButton *startBtn;

- (IBAction)onStart:(id)sender;

@end
