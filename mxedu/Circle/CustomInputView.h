//
//  OWTInputView.h
//  Weitu
//
//  Created by Su on 4/25/14.
//  Copyright (c) 2014 SparkingSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAMTextView.h"

@interface CustomInputView : UIToolbar<EAMTextViewDelegate>

@property (nonatomic, strong) EAMTextView* textView;
@property (nonatomic, copy) NSString* text;
@property (nonatomic, strong) void (^audioAction)();
@property (nonatomic, strong) void (^mediaAction)();
@property (nonatomic, strong) void (^sendAction)();

@end
