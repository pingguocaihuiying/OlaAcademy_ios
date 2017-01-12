//
//  yindaoyeViewController.m
//  Lvlicheng
//
//  Created by xianjunwang on 14-8-30.
//  Copyright (c) 2014年 lianyou. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()
{
    UIImageView *imageview1;
    UIImageView *imageview2;
    UIImageView *imageview3;
    UIImageView *imageview4;
    UIButton * lijitiyanButton;
}
@end

@implementation IntroViewController
@synthesize myScrollview,myPageController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //立刻翻页到下一页 没中间的拖动过程
    myScrollview.pagingEnabled=YES;
    //去掉翻页中的白屏
    myScrollview.bounces=NO;
    [myScrollview setDelegate:self];
    //不显示水平滚动条
    myScrollview.showsHorizontalScrollIndicator=NO;
    //将图像添加到scrollview中
    imageview1=[[UIImageView alloc]init];
    [imageview1 setImage:[UIImage imageNamed:@"guide1"]];
    imageview2=[[UIImageView alloc]init];
    [imageview2 setImage:[UIImage imageNamed:@"guide2"]];
    imageview3=[[UIImageView alloc]init];
    [imageview3 setImage:[UIImage imageNamed:@"guide3"]];
    imageview4=[[UIImageView alloc]init];
    [imageview4 setImage:[UIImage imageNamed:@"guide4"]];
    imageview4.userInteractionEnabled = YES;
    [myScrollview addSubview:imageview1];
    [myScrollview addSubview:imageview2];
    [myScrollview addSubview: imageview3];
    [myScrollview addSubview: imageview4];
    [self.view addSubview:myScrollview];
    //将pagecontrol添加到scrollview中
    myPageController.numberOfPages=4;
    myPageController.currentPage=0;
    [self.view addSubview:myPageController];
    
    myPageController.pageIndicatorTintColor = [UIColor grayColor];
    myPageController.currentPageIndicatorTintColor = [UIColor colorWithRed:66.0/255.0 green:133.0/255.0 blue:244.0/255.0 alpha:1];
    lijitiyanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lijitiyanButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
     [lijitiyanButton setImage:[UIImage imageNamed:@"start_click"] forState:UIControlStateHighlighted];
    [lijitiyanButton addTarget:self action:@selector(showMainView) forControlEvents:UIControlEventTouchUpInside];
    [imageview4 addSubview:lijitiyanButton];
    
    /***********************存数据*******************/
    //通过它拿到对象的实例，它其实也是一个单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"alreadyUsed"];
    [userDefaults synchronize];//将数据同步到文件里面
}
//pagecontrol的点跟着页数改变
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{
    CGPoint offset=scrollView1.contentOffset;
    CGRect bounds=scrollView1.frame;
    [myPageController setCurrentPage:offset.x/bounds.size.width];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewDidLayoutSubviews{
    CGRect rect = self.view.bounds;
    myScrollview.frame = rect;
    //设置scrollview画布的大小，此设置为四页的宽度，480的高度。用来实现照片的转换。
    [myScrollview setContentSize:CGSizeMake(rect.size.width * 4, rect.size.height)];
    myPageController.frame = CGRectMake(0, rect.size.height - 40, rect.size.width , 30);
    imageview1.frame = rect;
    imageview2.frame = CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height);
    imageview3.frame = CGRectMake(rect.size.width * 2, 0, rect.size.width, rect.size.height);
    imageview4.frame = CGRectMake(rect.size.width * 3, 0, rect.size.width, rect.size.height);
    lijitiyanButton.frame = CGRectMake((rect.size.width - 200) / 2, rect.size.height - 140, 200, 60);
}
- (IBAction)pageValueChanged:(id)sender {

}
//跳转到登陆，注册选择页面
-(void)showMainView{
    [GetAppDelegate() pushToMainView];
}
@end
