#import "CLAdWebView.h"
#import "CLNJKWebViewProgressView.h"
#import "CLNJKWebViewProgress.h"
#import "CLADObject.h"
#import <Masonry.h>
#define iPhoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))
@interface CLAdWebView()<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    CLNJKWebViewProgressView *_progressView;
    CLNJKWebViewProgress *_progressProxy;
}
@property (nonatomic, strong) UIView *statusView;
@end
@implementation CLAdWebView
- (instancetype)init
{
    self = [super init];
    if (self) {
        _progressProxy = [[CLNJKWebViewProgress alloc] init];
        self.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        _progressView = [CLNJKWebViewProgressView new];
        _progressView.progressBarView.backgroundColor = [UIColor colorWithRed:19/255.f green:157/255.f blue:247/255.f alpha:1];
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        [[CLADObject adObject] addObserver:self forKeyPath:@"adObjectShowType" options:
         NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([CLADObject adObject].adObjectShowType==LisztADObjectShowType_CustomContent){
        [self addSubview:_progressView];
        [self bringSubviewToFront:_progressView];
        __weak typeof(self) weakSelf = self;
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf);
            make.top.mas_equalTo([UIApplication sharedApplication].statusBarFrame.size.height);
            make.height.mas_equalTo(3);
        }];
        [self handleInterfaceOritation:[[UIApplication sharedApplication] statusBarOrientation]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
}
- (void)addRequestURL:(NSURL *)url{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLRequest *webRequest = [NSURLRequest requestWithURL:url];
        [self loadRequest:webRequest];
    });
}
- (void)reloadWebView{
    [self refreshWeb];
}
- (void)refreshWeb{
    [self reload];
}
- (void)goBackWeb{
    [self goBack];
}
- (void)handleStatusDidChange:(NSNotification *)notification
{
    UIInterfaceOrientation interfaceOritation = [[UIApplication sharedApplication] statusBarOrientation];
    [self handleInterfaceOritation:interfaceOritation];
}
- (void)handleInterfaceOritation:(UIInterfaceOrientation)interfaceOritation{
    __weak typeof(self) weakSelf = self;
    if(interfaceOritation==UIInterfaceOrientationPortrait||interfaceOritation==UIInterfaceOrientationPortraitUpsideDown){
        [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf).offset([CLADObject adObject].isStatusHidden?0:iPhoneX?44:20);
            make.height.mas_equalTo(3);
        }];
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentAutomatic;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        } else {
            self.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        }
        if(![CLADObject adObject].isStatusHidden){
            self.statusView = [UIView new];
            self.statusView.backgroundColor = [UIColor whiteColor];
            self.statusView.tag = 10090;
            [self addSubview:self.statusView];
            [self bringSubviewToFront:self.statusView];
            [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self);
                make.height.mas_offset(iPhoneX?44:20);
            }];
        }
    }
    else if(interfaceOritation==UIInterfaceOrientationLandscapeLeft||interfaceOritation==UIInterfaceOrientationLandscapeRight){
        [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf);
            make.height.mas_equalTo(3);
        }];
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                self.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
            }
        } else {
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        for(UIView *view in self.subviews){
            if(view.tag==10090){
                [view removeFromSuperview];
            }
        }
    }
    [self layoutIfNeeded];
}
#pragma mark - <UIWebViewDelegate>
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if([CLADObject adObject].adObjectShowType==LisztADObjectShowType_CustomContent){
        if([request.URL isEqual:[CLADObject adObject].gameAddressURL]){
            return NO;
        }
    }
    return YES;
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(CLNJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}
@end
