#import "CLAdTabBarView.h"
#import "CLADObjectConfig.h"
#import <Masonry.h>
@implementation CLAdTabBarView
+ (instancetype)tabBarItemConfigs:(NSArray<CLADObjectConfig *> *)configs{
    return [[CLAdTabBarView alloc] initWithTabBarConfigs:configs];
}
- (instancetype)initWithTabBarConfigs:(NSArray<CLADObjectConfig *>*)configs
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        UIButton *lastTabbarItem = nil;
        for(NSInteger i = 0; i < configs.count; i++){
            UIButton *tabBarItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tabBarItemButton.tag = i;
            [tabBarItemButton addTarget:self action:@selector(tabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:tabBarItemButton];
            CLADObjectConfig *config = configs[i];
            [tabBarItemButton setTitle:config.title forState:UIControlStateNormal];
            [tabBarItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            tabBarItemButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [tabBarItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                if(i % configs.count==0){
                    make.left.offset(0);
                }
                else{
                    make.width.equalTo(lastTabbarItem.mas_width);
                    make.left.equalTo(lastTabbarItem.mas_right).offset(0);
                }
                if(i%configs.count == configs.count-1){
                    make.right.equalTo(self).offset(0);
                }
            }];
            lastTabbarItem = tabBarItemButton;
        }
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,-2);
        self.layer.shadowOpacity = 0.05;
        self.layer.shadowRadius = 4;
    }
    return self;
}
- (void)tabBarButtonAction:(UIButton *)sender{
    if(self.tabBarItemButtonDidSelectAction){
        self.tabBarItemButtonDidSelectAction(sender.tag);
    }
}
@end
