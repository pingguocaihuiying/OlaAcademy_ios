//
//  ExamViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/3/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ExamViewController.h"

#import "SysCommon.h"
#import "UIImageView+WebCache.h"

#import "ExamCollectionView.h"
#import "QuestionWebController.h"
#import "VIPSubController.h"

#import "AuthManager.h"
#import "ExamManager.h"
#import "PayManager.h"

#import "Masonry.h"
#import "ExamFilterView.h"
#import "LoginViewController.h"
#import "IAPVIPController.h"

@interface ExamViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,FilterChooseDelegate>

@property (nonatomic) UIButton *titleBtn;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UILabel *targetScore;
@property (nonatomic) UILabel *rank;
@property (nonatomic) UILabel *coverPoint;

@property (nonatomic) ExamFilterView *filterView;// 遮罩筛选视图
@property (nonatomic) NSString *subjectId;//当前科目ID
@property (nonatomic) NSString *type;//当前类型

@property (nonatomic) NSArray *examArray;

@property (nonatomic) ThirdPay *thirdPay; //用于判断现实IAP还是微信支付宝

@end

@implementation ExamViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _subjectId = @"1";
    _type = @"1";
    [self setupNavBar];
    
    [self setupHeadView];
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    int statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    int navHeight = self.navigationController.navigationBar.frame.size.height;
    int tabHeight = self.tabBarController.tabBar.frame.size.height;
     _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, GENERAL_SIZE(400), SCREEN_WIDTH, SCREEN_HEIGHT-GENERAL_SIZE(400)-statusHeight-navHeight-tabHeight) collectionViewLayout:flowLayout];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = NO;
    _collectionView.allowsSelection = YES;
    _collectionView.backgroundColor = RGBCOLOR(222, 222, 222);
    
    [_collectionView registerClass:[ExamCollectionView class] forCellWithReuseIdentifier:@"colletionCell"];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_collectionView];
    
    [self fetchExamList];
    [self fetchPayModuleStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchExamList) name:@"NEEDREFRESH" object:nil];
    
}

// 后台控制是否显示支付相关功能
-(void)fetchPayModuleStatus{
    PayManager *pm = [[PayManager alloc]init];
    [pm fetchPayModuleStatusSuccess:^(ThirdPayResult *result) {
        _thirdPay = result.thirdPay;
    } Failure:^(NSError *error) {
        
    }];
}


-(void)setupNavBar{
    _titleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_titleBtn setFrame:CGRectMake(0, 0, 50, 20)];
    [_titleBtn setTitle:@"数学" forState:UIControlStateNormal];
    _titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [_titleBtn setImage:[UIImage imageNamed:@"ic_pulldown"] forState:UIControlStateNormal];
    [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -30)];
    [_titleBtn addTarget:self action:@selector(showFilterView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _titleBtn;
}

-(void)setupHeadView{
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_exam"]];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(400));
    [self.view addSubview:bgView];
    
    UIImageView *scoreIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_circle"]];
    [bgView addSubview:scoreIV];
    [scoreIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.equalTo(bgView.mas_left).offset(GENERAL_SIZE(66));
    }];
    
    _targetScore = [[UILabel alloc]init];
    _targetScore.text = @"100";
    _targetScore.textColor = COMMONBLUECOLOR;
    [scoreIV addSubview:_targetScore];
    [_targetScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(scoreIV);
    }];
    
    UILabel *scoreLabel = [[UILabel alloc]init];
    scoreLabel.text = @"目标分数";
    scoreLabel.textColor = RGBCOLOR(100, 100, 100);
    scoreLabel.font = LabelFont(32);
    [bgView addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scoreIV);
        make.top.equalTo(scoreIV.mas_bottom).offset(10);
    }];
    
    UIImageView *rangeIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_range"]];
    [bgView addSubview:rangeIV];
    [rangeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bgView);
    }];
    
    _rank = [[UILabel alloc]init];
    _rank.textColor = COMMONBLUECOLOR;
    _rank.font = LabelFont(60);
    [bgView addSubview:_rank];
    [_rank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.centerY.equalTo(bgView).offset(-10);
    }];
    
    UIImageView *pointIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_circle"]];
    [bgView addSubview:pointIV];
    [pointIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(bgView.mas_right).offset(-GENERAL_SIZE(66));
    }];
    
    _coverPoint = [[UILabel alloc]init];
    _coverPoint.textColor = COMMONBLUECOLOR;
    [pointIV addSubview:_coverPoint];
    [_coverPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(pointIV);
    }];
    
    UILabel *pointLabel = [[UILabel alloc]init];
    pointLabel.text = @"覆盖考点";
    pointLabel.textColor = RGBCOLOR(100, 100, 100);
    pointLabel.font = LabelFont(32);
    [bgView addSubview:pointLabel];
    [pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pointIV);
        make.top.equalTo(pointIV.mas_bottom).offset(10);
    }];
}

-(void)fetchExamList{
    NSString *userId = @"";
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    ExamManager *em = [[ExamManager alloc]init];
    [em fetchExamListWithCourseID:_subjectId Type:_type UserId:userId
                          Success:^(ExamListRsult *result) {
        _examArray = result.examArray;
        [_collectionView reloadData];
        if ([_examArray count]>0) {
            [self updateHeadView:[_examArray objectAtIndex:0]];
        }
    } Failure:^(NSError *error) {
        
    }];
}

-(void)updateHeadView:(Examination*)exam{
    NSString *target = [NSString stringWithFormat:@"%@分",exam.target];
    NSMutableAttributedString *targeStr = [[NSMutableAttributedString alloc] initWithString:target];
    [targeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(target.length-1,1)];
    _targetScore.attributedText = targeStr;
    
    NSString *coverpoint = [NSString stringWithFormat:@"%@个",exam.coverpoint];
    NSMutableAttributedString *coverpointStr = [[NSMutableAttributedString alloc] initWithString:coverpoint];
    [coverpointStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(coverpoint.length-1,1)];
    _coverPoint.attributedText = coverpointStr;
    
    NSString *rank = [NSString stringWithFormat:@"%@名",exam.rank];
    NSMutableAttributedString *rankStr = [[NSMutableAttributedString alloc] initWithString:rank];
    [rankStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(rank.length-1,1)];
    _rank.attributedText = rankStr;
}

#pragma 下拉筛选

// 筛选视图
-(void)showFilterView:(UIButton*)btn{
    if(_filterView){
        _filterView.hidden = !_filterView.hidden;
        if (_filterView.hidden) {
            [_titleBtn setImage:[UIImage imageNamed:@"ic_pulldown"] forState:UIControlStateNormal];
        }else{
            [_titleBtn setImage:[UIImage imageNamed:@"ic_pullup"] forState:UIControlStateNormal];
        }
    }else{
        _filterView = [[ExamFilterView alloc]initWithFrame:self.view.bounds];
        _filterView.delegate = self;
        [self.view addSubview:_filterView];
        [_titleBtn setImage:[UIImage imageNamed:@"ic_pullup"] forState:UIControlStateNormal];
    }
}

// 筛选视图 delegate
-(void)didChooseSubject:(NSString*)subject Button: (UIButton *)button{
    _filterView.hidden = YES;
    [_titleBtn setTitle:subject forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"ic_pulldown"] forState:UIControlStateNormal];
    _subjectId = [NSString stringWithFormat:@"%ld",button.tag+1];
    [self fetchExamList];
}

-(void)didChooseTypeWithButton: (UIButton *)button{
    _filterView.hidden = YES;
    [_titleBtn setImage:[UIImage imageNamed:@"ic_pulldown"] forState:UIControlStateNormal];
    _type = [NSString stringWithFormat:@"%ld",button.tag+1];
    [self fetchExamList];
}

#pragma tableview delegate

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_examArray count];
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"colletionCell";
    ExamCollectionView * cell = (ExamCollectionView*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Examination *examination = [_examArray objectAtIndex:indexPath.row];
    [cell setupViewWithModel:examination];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(GENERAL_SIZE(500), GENERAL_SIZE(630));
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(GENERAL_SIZE(0), GENERAL_SIZE(120), 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Examination *examination = [_examArray objectAtIndex:indexPath.row];
    if([examination.isfree intValue]==1){
        QuestionWebController *questionVC = [[QuestionWebController alloc]init];
        if ([_type isEqualToString:@"1"]) {
            questionVC.titleName = @"模拟考试";
        }else{
            questionVC.titleName = @"真题练习";
        }
        questionVC.objectId = examination.examId;
        questionVC.type = 2;
        if ([_subjectId isEqualToString:@"2"]) { //英语类
            questionVC.hasArticle = 1;
        }
        questionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:questionVC animated:YES];
    }else{
        OLA_LOGIN;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"购买会员后即可拥有" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"去购买",nil];
        [alert show];
    }
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = GENERAL_SIZE(500);
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //滑动后定位在某个cell
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
    // 更新头视图
    int index = targetOffset.x/GENERAL_SIZE(500);
    Examination *examination = [_examArray objectAtIndex:index];
    [self updateHeadView:examination];
}

#pragma alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    if (buttonIndex==1) {
        if ([_thirdPay.version isEqualToString:[infoDictionary objectForKey:@"CFBundleShortVersionString"]]&&[_thirdPay.thirdPay isEqualToString:@"0"]) {
            IAPVIPController *iapVC =[[IAPVIPController alloc]init];
            iapVC.callbackBlock = ^{
                [self fetchExamList];
            };
            iapVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:iapVC animated:YES];
        }else{
            VIPSubController *vipVC =[[VIPSubController alloc]init];
            vipVC.callbackBlock = ^{
                [self fetchExamList];
            };
            vipVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vipVC animated:YES];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
