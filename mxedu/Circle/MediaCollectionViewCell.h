//
//  CaseInfoCollectionViewCell.h
//  NTreat
//
//  Created by 刘德胜 on 15/12/16.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mediaModel.h"
@class MediaCollectionViewCell;
@protocol MediaCollectionViewCellDelegate <NSObject>

//选中某个标签
-(void)didChoiceCellWithModel:(mediaModel *)choiceModel local:(NSIndexPath *)localpath;
//删除某个标签
-(void)didRemoveCellWithModel:(mediaModel *)choiceModel;

@end
@interface MediaCollectionViewCell : UICollectionViewCell
typedef enum {
    CellForImageType=0,//开始
    CellForMedicalType,//停止
    CellForAudioType//暂停
} CaseCellType;

@property (nonatomic,assign)  NSInteger CaseCellType;

@property (nonatomic,retain) NSIndexPath *localIndexpath;

@property (nonatomic,retain) id<MediaCollectionViewCellDelegate> delegate;

@property (nonatomic,retain) mediaModel *modelData;

-(void)setMediaModel:(mediaModel *)mediaModel;

-(void)choiceCell;

@end
