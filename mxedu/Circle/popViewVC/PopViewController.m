//
//  PopViewController.m
//  NTreat
//
//  Created by 周冉 on 16/6/7.
//  Copyright © 2016年 Áî∞ÊôìÈπè. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)parentHeight
{
    return _parentView.bounds.size.height - self.keyboardHeight;
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
