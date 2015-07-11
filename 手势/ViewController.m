//
//  ViewController.m
//  手势
//
//  Created by 叶 on 15/7/11.
//  Copyright (c) 2015年 six. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *botton;

@property (strong ,nonatomic) UIPanGestureRecognizer *move;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveBotton:)];
    move.delegate = self;
    
    [self.botton addGestureRecognizer:move];
    [self.botton addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:nil];
    _move = move;

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    if (_move.state != UIGestureRecognizerStateEnded)
        return;
    
    UIButton *button = (UIButton *)object;
    //按钮中点x
    CGFloat buttonMidX   = CGRectGetMidX(button.frame);
    CGFloat screenMidX   = CGRectGetMidX([UIScreen mainScreen].bounds);
    CGFloat screenMaxX   = CGRectGetMaxX([UIScreen mainScreen].bounds);
    CGFloat screenBottom = CGRectGetMaxY([UIScreen mainScreen].bounds);
    CGFloat buttonWidth  = CGRectGetWidth(button.frame);
    CGFloat buttonHeight = CGRectGetHeight(button.frame);
    CGFloat buttonTop    = CGRectGetMinY(button.frame);
    CGFloat buttonBottom = CGRectGetMaxY(button.frame);
    
    CGFloat finalX;
    CGFloat finalY;
    //上下边界处理
    if (buttonTop < 0){
        finalY = 0;
    }else if (buttonBottom > screenBottom){
        finalY = screenBottom - buttonHeight;
    }else{
        finalY = _botton.frame.origin.y;
    }
    
    if (buttonMidX < screenMidX) {
        finalX = 0;
    }else{
        finalX = screenMaxX - buttonWidth;
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _botton.frame = (CGRect){CGPointMake(finalX, finalY),_botton.frame.size};
    }];
}

//移动控件
- (void)moveBotton:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:_botton];
    
    _botton.transform = CGAffineTransformTranslate(_botton.transform, point.x, point.y);
    
    [gesture setTranslation:CGPointZero inView:_botton];
}
@end
