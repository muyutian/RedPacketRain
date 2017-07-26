//
//  ViewController.m
//  RedPacketRain
//
//  Created by zhangzy on 2017/7/26.
//  Copyright © 2017年 zhangzy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong,nonatomic)NSTimer*timer;
@property (strong,nonatomic)CALayer*moveLayer;
@property (strong,nonatomic)UIView*bgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-70)];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_bgView addGestureRecognizer:tap];
    [self.view addSubview:_bgView];
}


- (IBAction)startBtnClick:(id)sender {
    [_timer invalidate];
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showRain) userInfo:@"" repeats:YES];
}


- (IBAction)endBtnClick:(id)sender {
    [_timer invalidate];
    //停止所有layer的动画
    for (CALayer*layer in _bgView.layer.sublayers) {
        [layer removeAllAnimations];
    }
    [_bgView.layer removeFromSuperlayer];
}


- (void)tapClick:(UITapGestureRecognizer*)tap{
    CGPoint touchPoint = [tap locationInView:_bgView];
    for (int i=0;i<_bgView.layer.sublayers.count;i++) {
        CALayer*layer = _bgView.layer.sublayers[i];
        if ([layer.presentationLayer hitTest:touchPoint]) {
            NSLog(@"presentationLayer  %d",i);
        }
    }
    

}

-(void)showRain{
    //创建画布
    UIImageView*imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 70)];
    imgView.image=[UIImage imageNamed:@"red"];
    
    _moveLayer=[[CALayer alloc]init];
    _moveLayer.bounds=imgView.frame;
    _moveLayer.anchorPoint = CGPointMake(0, 0);
    _moveLayer.position=CGPointMake(0, -70);
    _moveLayer.contents=(__bridge id _Nullable)(imgView.image.CGImage);
    [_bgView.layer addSublayer:_moveLayer];
    
    //画布动画
    [self addAnimation];
}

-(void)addAnimation{
    CAKeyframeAnimation*moveAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    //设置value
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(arc4random_uniform(self.view.frame.size.width-70), -70)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(value1.CGPointValue.x, self.view.frame.size.height-70)];
    
    moveAnimation.values=@[value1,value2];
    //动画间隔
    moveAnimation.duration = 2;
    //重复次数
    moveAnimation.repeatCount = 1;
    //动画的速度
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.moveLayer addAnimation:moveAnimation forKey:@"move"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
