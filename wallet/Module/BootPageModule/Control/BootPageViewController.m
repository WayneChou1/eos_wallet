//
//  BootPageViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/16.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BootPageViewController.h"
#import "BootPageControl.h"

@interface BootPageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet BootPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *skipLab;
@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;

@end

@implementation BootPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpScrollView];
    [self setUpPageControl];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpScrollView {
    
    // 页数
    NSInteger pageCount = 4;
    // 高度
    CGFloat height = 300.0;
    
    self.topScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * pageCount, height);
    self.topScrollView.delegate = self;
    self.topScrollView.pagingEnabled = YES;
    
    // 设置背景图
    for (int i = 0; i < pageCount; i++) {
        NSString *imgName = [NSString stringWithFormat:@"bootpage/bootpage_bitmap%d.png",i+1];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:kImageWithPath(imgName)];
        imgV.contentMode = UIViewContentModeTop;
        imgV.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, height);
        [self.topScrollView addSubview:imgV];
    }
}

- (void)setUpPageControl {
//    [self.pageControl setImagePageStateNormal:kImageWithPath(@"bootpage_control_normal.png") ImagePageStateHighlighted:kImageWithPath(@"bootpage_control_high_light.png")];
    
//    NSString * bundlePath = [[ NSBundle mainBundle] pathForResource:@"Wallet" ofType:@"bundle"];
//    NSString *imgPath= [bundlePath stringByAppendingPathComponent:@"bootpage/bootpage_bitmap1.png"];
//    UIImage *image_1=[UIImage imageWithContentsOfFile:imgPath];
//
//    UIImageView *imgV = [[UIImageView alloc]initWithImage:image_1];
//    imgV.frame = CGRectMake(100, 100, 100, 100);
//    imgV.backgroundColor = [UIColor redColor];
//    [self.view addSubview:imgV];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
}

#pragma mark - btnOnClick
- (IBAction)nextBtnOnClick:(UIButton *)sender {
    if (self.pageControl.currentPage == 3) {
        
    }else{
        [self.topScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (self.pageControl.currentPage + 1), 0) animated:YES];
        self.pageControl.currentPage++;
    }
}
@end
