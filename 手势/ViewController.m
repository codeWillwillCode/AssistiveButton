//
//  ViewController.m
//  手势
//
//  Created by 叶 on 15/7/11.
//  Copyright (c) 2015年 six. All rights reserved.
//

#import "ViewController.h"


#define ScreenBounds [UIScreen mainScreen].bounds



@interface ViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *botton;

@property (strong ,nonatomic) UIPanGestureRecognizer *move;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveBotton:)];
    move.delegate = self;
    [self.botton addGestureRecognizer:move];

//    [self.botton addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:nil];

    _move = move;

}

//移动控件
- (void)moveBotton:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:_botton];
    
    _botton.transform = CGAffineTransformTranslate(_botton.transform, point.x, point.y);
    
    [gesture setTranslation:CGPointZero inView:_botton];

    if (_move.state == UIGestureRecognizerStateEnded)
        [self dealWithEdgeEvent:_botton];
}



- (void)dealWithEdgeEvent:(UIButton *)button
{
    CGFloat buttonMidX   = CGRectGetMidX(button.frame);
    CGFloat buttonMinX   = CGRectGetMinX(button.frame);
    CGFloat buttonMaxX   = CGRectGetMaxX(button.frame);
    CGFloat buttonWidth  = CGRectGetWidth(button.frame);
    CGFloat buttonHeight = CGRectGetHeight(button.frame);
    CGFloat buttonTop    = CGRectGetMinY(button.frame);
    CGFloat buttonBottom = CGRectGetMaxY(button.frame);
    CGSize  buttonSize   = _botton.frame.size;
    
    CGFloat screenMaxX   = CGRectGetMaxX(ScreenBounds);
    CGFloat screenBottom = CGRectGetMaxY(ScreenBounds);
    CGFloat screenMidX   = CGRectGetMidX(ScreenBounds);
    
    CGFloat margin       = 30;
    CGFloat screenMinX   = 0;
    CGFloat screenTop    = 0;
    
    CGFloat finalX;
    CGFloat finalY;
    BOOL    Y_outSide = NO;
    BOOL    X_outSide = NO;
    
    //y轴出界
    if (buttonBottom >= screenBottom || buttonTop <= screenTop) {
        Y_outSide = YES;
    }
    
    //x轴出界
    if (buttonMinX <= screenMinX  || buttonMaxX >= screenMaxX) {
        X_outSide = YES;
    }
    
    //计算最终的X位置
    if (Y_outSide && !X_outSide){
        //Y出界，X不出界，X不变 （粘着上下）
        finalX = buttonMinX;
    }else{//Y出界X出界、Y不出界X不出界的情况，X粘着左右
        if (buttonMidX < screenMidX) {
            finalX = screenMinX;//X粘着左边
        }else{
            finalX = screenMaxX - buttonWidth;//X粘着右边
        }
    }
    
    //计算最终的Y位置
    if (Y_outSide){//Y出界
        if (buttonTop <= screenTop){
            finalY = screenTop;
        }else{
            finalY = screenBottom - buttonHeight;
        }
    }else{//不出界
        finalY = buttonTop;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _botton.frame = (CGRect){CGPointMake(finalX, finalY),buttonSize};
    }];
}
@end
