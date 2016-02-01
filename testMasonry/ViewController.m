//
//  ViewController.m
//  testMasonry
//
//  Created by 王迎博 on 15/12/24.
//  Copyright © 2015年 王迎博. All rights reserved.
//

#import "ViewController.h"
#import "UIView+test.h"


//快速的定义一个weakSelf 用于block里面
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface ViewController ()

@end

@implementation ViewController

//生成随机色
-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //底部view
    WS(ws);
    UIView *sv = [UIView new];
    sv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sv];
    
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    
    //第二个view
    UIView *sv1 = [[UIView alloc]init];
    sv1.backgroundColor = [UIColor redColor];
    [sv addSubview:sv1];
    [sv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sv).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    /* 等价于
     make.top.equalTo(sv).with.offset(10);
     make.left.equalTo(sv).with.offset(10);
     make.bottom.equalTo(sv).with.offset(-10);
     make.right.equalTo(sv).with.offset(-10);
     */
    
    /* 也等价于
     make.top.left.bottom.and.right.equalTo(sv).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
     */
        
    /* 
     这里有意思的地方是and和with 其实这两个函数什么事情都没做
     - (MASConstraint *)with {
     return self;
     }
     - (MASConstraint *)and {
     return self;
     }
     
     .and和.with基本可以省略。
     */
    }];
    
    
    
    /**
     让两个高度为150的view垂直居中且等宽且等间隔排列 间隔为10(自动计算其宽度)
     其次 equalTo 和 mas_equalTo的区别在哪里呢? 其实 mas_equalTo是一个MACRO
     #define mas_equalTo(...)                 equalTo(MASBoxValue((__VA_ARGS__)))
     #define mas_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(MASBoxValue((__VA_ARGS__)))
     #define mas_lessThanOrEqualTo(...)       lessThanOrEqualTo(MASBoxValue((__VA_ARGS__)))
     #define mas_offset(...)                  valueOffset(MASBoxValue((__VA_ARGS__)))
     */
    NSInteger padding1 = 10;
    UIView *sv2 = [[UIView alloc]init];
    UIView *sv3 = [[UIView alloc]init];
    sv3.backgroundColor = [UIColor blueColor];
    sv2.backgroundColor = [UIColor blueColor];
    [sv1 addSubview:sv2];
    [sv1 addSubview:sv3];
    
    [sv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sv.mas_centerY);
        make.left.equalTo(sv.mas_left).with.offset(padding1);
        make.right.equalTo(sv3.mas_left).with.offset(-padding1);
        make.height.mas_equalTo(@150);
        make.width.equalTo(sv3);
    }];
    
    [sv3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sv.mas_centerY);
        make.left.equalTo(sv2.mas_right).with.offset(padding1);
        make.right.equalTo(sv.mas_right).with.offset(-padding1);
        make.height.mas_equalTo(@150);
        make.width.equalTo(sv2);
    }];
    
    
    

    //在UIScrollView顺序排列一些view并自动计算contentSize
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor whiteColor];
    [sv addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sv).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];

    UIView *container = [[UIView alloc]init];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    NSInteger count = 10;
    UIView *lastView = nil;
    
    for (int i = 1; i <= count; ++i)
    {
        UIView *subv = [[UIView alloc]init];
        [container addSubview:subv];
        [subv setBackgroundColor:[self randomColor]];
        [subv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(container);
            make.height.mas_equalTo(@(20*i));
            if (lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom);
            }
            else
            {
                make.top.mas_equalTo(container.mas_top);
            }
        }];
        lastView = subv;
    }
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom);
    }];
    
    

    
    
  
    
    
    
    
    
    
    /**
     *  在做第五个功能时，把前面的隐藏掉。
     */
    sv1.hidden = YES;
    sv2.hidden = YES;
    sv3.hidden = YES;
    scrollView.hidden = YES;
    
    

    
    
    /**
     *  横向或者纵向等间隙的排列一组view
     */
    UIView *sv11 = [UIView new];
    UIView *sv12 = [UIView new];
    UIView *sv13 = [UIView new];
    UIView *sv21 = [UIView new];
    UIView *sv31 = [UIView new];
    sv11.backgroundColor = [UIColor redColor];
    sv12.backgroundColor = [UIColor redColor];
    sv13.backgroundColor = [UIColor redColor];
    sv21.backgroundColor = [UIColor redColor];
    sv31.backgroundColor = [UIColor redColor];
    [sv addSubview:sv11];
    [sv addSubview:sv12];
    [sv addSubview:sv13];
    [sv addSubview:sv21];
    [sv addSubview:sv31];
    //给予不同的大小 测试效果
    [sv11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@[sv12,sv13]);
        make.centerX.equalTo(@[sv21,sv31]);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [sv12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    [sv13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [sv21 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    [sv31 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 60));
    }];
    [sv distributeSpacingHorizontallyWith:@[sv11,sv12,sv13]];
    [sv distributeSpacingVerticallyWith:@[sv11,sv21,sv31]];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}




/*
 new在内部调用的alloc和init.
 源代码：
 
 + new
 {
 id newObject = (*_alloc)((Class)self, 0);
 Class metaClass = self->isa;
 if (class_getVersion(metaClass) > 1)
 return [newObject init];
 else
 return newObject;
 }
 + alloc
 {
 return (*_zoneAlloc)((Class)self, 0, malloc_default_zone());
 }
 - init
 {
 return self;
 }
 [className new]基本等同于[[className alloc] init]. 区别只在于alloc分配内存的时候使用了zone，这个zone是个什么东东呢？它是给对象分配内存的时候，把关联的对象分配到一个相邻的内存区域内，以便于调用时消耗很少的代价，提升了程序处理速度.
 
 */






@end
