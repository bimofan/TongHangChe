//
//  YMShowImageView.m
//  WFCoretext
//
//  Created by 阿虎 on 14/11/3.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "YMShowImageView.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
@implementation YMShowImageView{

    UIScrollView *_scrollView;
    CGRect self_Frame;
    NSInteger page;
    BOOL doubleClick;
    NSMutableArray * arrUrl;
    int aaa;

}



- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray{

    self = [super initWithFrame:frame];
    if (self) {
        
        self_Frame = frame;
        
        self.backgroundColor = [UIColor redColor];
        self.alpha = 0.0f;
        page = 0;
        doubleClick = YES;
        
        [self configScrollViewWith:clickTag andAppendArray:appendArray];
        
        UITapGestureRecognizer *tapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        tapGser.numberOfTouchesRequired = 1;
        tapGser.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGser];
        
        UITapGestureRecognizer *doubleTapGser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBig:)];
        doubleTapGser.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGser];
        [tapGser requireGestureRecognizerToFail:doubleTapGser];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteFer:)];
        longPress.minimumPressDuration = 0.5;
        longPress.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:longPress];
        
    }
    return self;

    
}









-(void)deleteFer:(UILongPressGestureRecognizer *)sender{
    

    if (sender.state == UIGestureRecognizerStateBegan) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否下载图片?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        [alert show];

        
        
        
        
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        
//        [manager downloadImageWithURL:arrUrl[aaa] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            
//            NSLog(@"显示当前进度");
//            
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//       UIImageWriteToSavedPhotosAlbum(image, self, @selector(image1:didFinishSavingWithError:contextInfo:), nil);
//            NSLog(@"下载完成");
//        }];


    
         NSLog(@"使劲按");
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        if(alertView.tag==1||alertView.tag==2){
            return;
        }else{
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        [manager downloadImageWithURL:arrUrl[aaa] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            NSLog(@"显示当前进度");
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image1:didFinishSavingWithError:contextInfo:), nil);
            NSLog(@"下载完成");
        }];
        
    }
    }
}







- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point=scrollView.contentOffset;
    aaa=(int)point.x/[UIScreen mainScreen].bounds.size.width;
   // NSLog(@"%f",point.x/[UIScreen mainScreen].bounds.size.width);
  
}

- (void)image1:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo{
    
    if (error == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag=1;
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        alert.tag=2;
        [alert show];
    }
    
}










- (void)configScrollViewWith:(NSInteger)clickTag andAppendArray:(NSArray *)appendArray{
    arrUrl=[[NSMutableArray alloc]init];
    [arrUrl addObjectsFromArray:appendArray];
    _scrollView = [[UIScrollView alloc] initWithFrame:self_Frame];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = true;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * appendArray.count, 0);
    [self addSubview:_scrollView];
    
    float W = self.frame.size.width;
  
    for (int i = 0; i < appendArray.count; i ++) {
        
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imageScrollView.backgroundColor = [UIColor blackColor];
        imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        imageScrollView.delegate = self;
        imageScrollView.maximumZoomScale = 4;
        imageScrollView.minimumZoomScale = 1;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[appendArray objectAtIndex:i]]];
//        imageView.image = img;iconfont-autoesc
        NSLog(@"%@",[appendArray objectAtIndex:i]);
        [imageView sd_setImageWithURL:[appendArray objectAtIndex:i] placeholderImage:[UIImage imageNamed:@"iconfont-autoesc"]];
//        [imageView sd_setImageWithURL:[appendArray objectAtIndex:i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        [_scrollView addSubview:imageScrollView];
        
        imageScrollView.tag = 100 + i ;
        imageView.tag = 1000 + i;
        
        
    }
    [_scrollView setContentOffset:CGPointMake(W * (clickTag - 9999), 0) animated:YES];
    page = clickTag - 9999;

}

- (void)disappear{
    
    _removeImg();
   
}


- (void)changeBig:(UITapGestureRecognizer *)tapGes{

    CGFloat newscale = 1.9;
    UIScrollView *currentScrollView = (UIScrollView *)[self viewWithTag:page + 100];
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[tapGes locationInView:tapGes.view] andScrollView:currentScrollView];
    
    if (doubleClick == YES)  {
        
        [currentScrollView zoomToRect:zoomRect animated:YES];
        
    }else {
      
        [currentScrollView zoomToRect:currentScrollView.frame animated:YES];
    }
    
    doubleClick = !doubleClick;

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:scrollView.tag + 900];
    return imageView;

}

- (CGRect)zoomRectForScale:(CGFloat)newscale withCenter:(CGPoint)center andScrollView:(UIScrollView *)scrollV{
   
    CGRect zoomRect = CGRectZero;
    
    zoomRect.size.height = scrollV.frame.size.height / newscale;
    zoomRect.size.width = scrollV.frame.size.width  / newscale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
   // NSLog(@" === %f",zoomRect.origin.x);
    return zoomRect;

}

- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock{
    
     [bgView addSubview:self];
    
     _removeImg = tempBlock;
    
     [UIView animateWithDuration:.4f animations:^(){
         
         self.alpha = 1.0f;
    
      } completion:^(BOOL finished) {
        
     }];

}


#pragma mark - ScorllViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
    CGPoint offset = _scrollView.contentOffset;
    page = offset.x / self.frame.size.width ;
   
    
    UIScrollView *scrollV_next = (UIScrollView *)[self viewWithTag:page+100+1]; //前一页
    
    if (scrollV_next.zoomScale != 1.0){
    
        scrollV_next.zoomScale = 1.0;
    }
    
    UIScrollView *scollV_pre = (UIScrollView *)[self viewWithTag:page+100-1]; //后一页
    if (scollV_pre.zoomScale != 1.0){
        scollV_pre.zoomScale = 1.0;
    }
    
   // NSLog(@"page == %d",page);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
  

}

@end
