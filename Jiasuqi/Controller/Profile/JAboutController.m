#import "JAboutController.h"

@interface JAboutController ()

@end

@implementation JAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)_loadUI {
	[super _loadUI];
	self.navigationItem.title = @"关于";
}
@end
