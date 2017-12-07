//
//  ViewController.m
//  CATransform3DDemo
//
//  Created by Gauss on 2017/12/7.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (strong, nonatomic) CATransformLayer * cube;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self diceCube];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    self.backImg.hidden = YES;
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self scale];
//}
//平移
-(void)transition{
    CATransform3D t = CATransform3DIdentity;
    //x方向平移
    [UIView animateWithDuration:2.0 animations:^{
        self.backImg.layer.transform = CATransform3DTranslate(t, 50, 50, 0);
    } completion:^(BOOL finished) {
        self.backImg.layer.transform = CATransform3DIdentity;
    }];
}
//旋转
-(void)rotate{
    CATransform3D t = CATransform3DIdentity;
    //x,y,z 的值决定旋转轴的方向
    [UIView animateWithDuration:2.0 animations:^{
        self.backImg.layer.transform = CATransform3DRotate(t, 60 * (M_PI / 180), 1, 1, 0);
    } completion:^(BOOL finished) {
        self.backImg.layer.transform = CATransform3DIdentity;
    }];
}
//缩放
-(void)scale{
    CATransform3D t = CATransform3DIdentity;
    //x，y缩放
    [UIView animateWithDuration:2.0 animations:^{
        self.backImg.layer.transform = CATransform3DScale(t,1.5, 1.5, 1);
    } completion:^(BOOL finished) {
        self.backImg.layer.transform = CATransform3DIdentity;
    }];
}
-(void)diceCube{
    CATransformLayer * cube = [CATransformLayer layer];
    //第一个面
    //+z方向平移
    CATransform3D t = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self diceFaceWithTransform:t withIndex:1]];
    
    //第二个面
    //+x方向平移
    t = CATransform3DMakeTranslation(50, 0, 0);
    //y轴旋转90度
    t = CATransform3DRotate(t, 90 * (M_PI / 180), 0, 1, 0);
    [cube addSublayer:[self diceFaceWithTransform:t withIndex:2]];
    
    //第三面
    //+y方向平移
    t = CATransform3DMakeTranslation(0, 50, 0);//CATransform3D CATransform3DInvert (CATransform3D t);
    //x轴旋转90度
    t = CATransform3DRotate(t, 90 * (M_PI / 180), -1, 0, 0);
    [cube addSublayer:[self diceFaceWithTransform:t withIndex:3]];
    
    //第四面
    //-x方向平移
    t = CATransform3DMakeTranslation(-50, 0, 0);
    //y轴旋转90度
    t = CATransform3DRotate(t, 90 * (M_PI / 180), 0, -1, 0);
    [cube addSublayer:[self diceFaceWithTransform:t withIndex:4]];
    
    //第五面
    //-y方向平移
    t = CATransform3DMakeTranslation(0, -50, 0);
    //x轴旋转90度
    t = CATransform3DRotate(t, 90 * (M_PI / 180), 1, 0, 0);
    [cube addSublayer:[self diceFaceWithTransform:t withIndex:5]];
    
    //第六面
    //-z方向平移
    t = CATransform3DMakeTranslation(0, 0, -50);
    t = CATransform3DRotate(t, 180 * (M_PI / 180), 1, 0, 0);
    [cube addSublayer:[self diceFaceWithTransform:t withIndex:6]];
    //旋转30度
//    cube.transform = CATransform3DMakeRotation(30 * (M_PI / 180), 1, 1, 1);
    
    //设置中心点的位置
    cube.position = CGPointMake(200, 200);
    [self.view.layer addSublayer:cube];
    self.cube = cube;
//    CATransform3D transA = CATransform3DMakeScale(1.0, 1.0, 1.0);
//    transA = CATransform3DRotate(transA, 180 * (M_PI / 180), 1, 1, 1);
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    animation.duration          = 2;
//    animation.autoreverses      = YES;
//    animation.repeatCount       = 100;
//    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)];
//    animation.toValue           = [NSValue valueWithCATransform3D:transA];
//    [cube addAnimation:animation forKey:nil];
}
-(CALayer *)diceFaceWithTransform:(CATransform3D)transform withIndex:(NSInteger)index{
    CATextLayer *face = [CATextLayer layer];
    face.bounds = CGRectMake(0, 0, 100, 100);
    face.string = [NSString stringWithFormat:@"第%zd面",index];
    face.fontSize = 20;
    face.contentsScale = 2;
    face.alignmentMode = @"center";
    face.truncationMode = @"middle";
    face.transform = transform;
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    return face;
}
- (void)pan:(UIPanGestureRecognizer *)recognizer{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    //获取到的是手指移动后，在相对坐标中的偏移量(以手指接触屏幕的第一个点为坐标原点)
    CGPoint translation = [recognizer translationInView:self.view];
    NSLog(@"x = %f ------ y = %f",translation.x, translation.y);
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, translation.x * (M_PI * 2 / w), 0, 1, 0);
    transform = CATransform3DRotate(transform, translation.y * (-M_PI * 2 / h), 1, 0, 0);
    self.cube.transform = transform;
}
@end
