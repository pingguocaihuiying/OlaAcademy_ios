//
//  MaterialBrowseController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/10/31.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "UIBaseViewController.h"

#import "Material.h"
#import "Organization.h"

@interface MaterialBrowseController : UIBaseViewController

@property (nonatomic) Material *material;  //资料
@property (nonatomic) Organization *org; //招生简章

@end
