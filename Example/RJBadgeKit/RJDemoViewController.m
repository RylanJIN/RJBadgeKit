//
//  RJDemoViewController.m
//  RJBadgeKit_Example
//
//  Created by Ryan Jin on 22/12/2017.
//  Copyright © 2017 RylanJIN. All rights reserved.
//

#import "RJDemoViewController.h"
#import "RJBadgeKit.h"

NSString * const RJMarkPath = @"root.mark";

@interface RJDemoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *pageButton;

@end

@implementation RJDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *demoPath = @"root.pbdemo.page";
    
    [RJBadgeController setBadgeForKeyPath:demoPath];
    
    [self.badgeController observePath:demoPath badgeView:self.pageButton block:nil];
    

    UIBarButtonItem *mark = [[UIBarButtonItem alloc] initWithTitle:@"mark" style:UIBarButtonItemStylePlain target:self action:@selector(markAction:)];
    self.navigationItem.rightBarButtonItem = mark;
    
//    //    mark.badgeOffset = CGPointMake(0, 0); //It do not work, use:
//    self.navigationItem.rightBarButtonItem.badgeOffset = CGPointMake(0, 0);
    
    [RJBadgeController setBadgeForKeyPath:RJMarkPath];
    
//    [self.badgeController observePath:RJMarkPath badgeView:mark block:nil];//It do not work, use:
    [self.badgeController observePath:RJMarkPath badgeView:self.navigationItem.rightBarButtonItem block:nil];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //  After the navigationBar initialization is completed
    self.navigationItem.rightBarButtonItem.badgeOffset = CGPointMake(0, 0);

    /**
     @note Example for refresh badge display of -'mark' button on navigation bar,
     which may not appear at first due to autolayout procedure of navigation items.
     */
    [self.badgeController refreshBadgeView];
}

- (void)markAction:(UIButton *)sender
{
    BOOL needShow = [RJBadgeController statusForKeyPath:RJMarkPath];
    if (needShow) {
        [RJBadgeController clearBadgeForKeyPath:RJMarkPath];
    } else {
        [RJBadgeController setBadgeForKeyPath:RJMarkPath];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
