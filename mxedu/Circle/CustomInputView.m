//
//  OWTInputView.m
//  Weitu
//
//  Created by Su on 4/25/14.
//  Copyright (c) 2014 SparkingSoft Co., Ltd. All rights reserved.
//

#import "CustomInputView.h"

#import "SysCommon.h"
#import "Masonry.h"

@interface CustomInputView ()

@property (nonatomic, strong) UIButton* audioBtn;
@property (nonatomic, strong) UIButton* mediaBtn;
@property (nonatomic, strong) UIButton* sendButton;

@end

@implementation CustomInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.audioBtn setImage:[UIImage imageNamed:@"ic_comment_voice"] forState:UIControlStateNormal];
        [self.audioBtn addTarget:self action:@selector(audioButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.audioBtn];
        
        [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.centerY.equalTo(self);

        }];
        
        self.textView = [[EAMTextView alloc]init];
        [self addSubview:self.textView];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendButton.backgroundColor = COMMONBLUECOLOR;
        self.sendButton.layer.borderWidth = 1.0f;
        self.sendButton.layer.borderColor = [COMMONBLUECOLOR CGColor];
        self.sendButton.layer.cornerRadius = 5.0f;
        self.sendButton.titleLabel.font = LabelFont(24);
        [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.sendButton];
        
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-5);
            make.width.equalTo(@50);
        }];
        
        self.mediaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.mediaBtn setImage:[UIImage imageNamed:@"ic_comment_media"] forState:UIControlStateNormal];
        [self.mediaBtn addTarget:self action:@selector(mediaButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.mediaBtn];
        
        [self.mediaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.sendButton.mas_left).offset(-10);
            make.centerY.equalTo(self);
        }];

        
        self.textView.delegate = self;
        self.textView.autoresizesVertically = YES;
        self.textView.minimumHeight = 32.0f;
        self.textView.maximumHeight = 120.0f;
        self.textView.font=[UIFont systemFontOfSize:17];
        self.textView.textColor=[UIColor blackColor];
        self.textView.layer.cornerRadius = 5;
        self.textView.placeholder = @"";
        
        self.textView.layer.borderWidth = 1.0f;
        self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    return self;
}

- (void)audioButtonPressed:(UIButton*)sender
{
    if (_audioAction != nil)
    {
        _audioAction();
    }
}

- (void)mediaButtonPressed:(UIButton*)sender
{
    if (_mediaAction != nil)
    {
        _mediaAction();
    }
}

- (void)sendButtonPressed:(UIButton*)sender
{
    if (_sendAction != nil)
    {
        _sendAction();
    }
}

- (void)textView:(EAMTextView *)textView willChangeFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight
{
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.height.equalTo(@(newHeight));
        make.left.equalTo(self.audioBtn.mas_right).offset(10);
        make.right.equalTo(self.mediaBtn.mas_left).offset(-10);
    }];
}

- (NSString*)text
{
    return _textView.text;
}

- (void)setText:(NSString *)text
{
    [_textView setText:text];
}

@end
