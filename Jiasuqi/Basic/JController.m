#import "JController.h"
@interface JController ()
@end
@implementation JController
- (void)viewDidLoad {
    [super viewDidLoad];
	[self _loadUI];
	[self _loadData];
}

- (void)_loadUI {
	self.view.backgroundColor = [UIColor colorWithHex:0x0B0515];
}

- (void)_loadData { }

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}
@end
