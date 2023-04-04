#import "JHomeController.h"
#import "JLocationController.h"
#import "JLocationCell.h"
#import "JTabBarController.h"
#import "JSigninController.h"
#import "JVPN.h"
#import "JConfModel.h"
#import "JTabBarController.h"
@interface JHomeController ()
@property (nonatomic, strong) UIButton *proBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *locationView;
@property (nonatomic, strong) UILabel *choiceLbl;
@property (nonatomic, strong) UILabel *locationLbl;
@property (nonatomic, strong) UILabel *delayLbl;
@property (nonatomic, strong) UIImageView *locationFlg;
@property (nonatomic, strong) UIImageView *upView;
@property (nonatomic, strong) UIImageView *downView;
@property (nonatomic, strong) UILabel *upLbl;
@property (nonatomic, strong) UILabel *downLbl;
@property (nonatomic, strong) UIImageView *worldView;
@property (nonatomic, strong) UIView *startView;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) NSMutableArray<JLocationModel *> *datas;
@property (nonatomic, strong) JTimer *timer;
@end

@implementation JHomeController

- (UIButton *)proBtn {
	if (!_proBtn) {
		_proBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
		[_proBtn setImage:[UIImage imageNamed:@"gopro"] forState:UIControlStateNormal];
		[_proBtn addTarget:self action:@selector(pro_clicked) forControlEvents:UIControlEventTouchUpInside];
	}
	return _proBtn;
}

- (UIScrollView *)scrollView {
	if (!_scrollView) {
		_scrollView = [[UIScrollView alloc] initWithFrame:UIScreen.mainScreen.bounds];
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
	}
	return _scrollView;
}

- (UIView *)contentView {
	if (!_contentView) {
		_contentView = [[UIView alloc] init];
	}
	return _contentView;
}

- (UILabel *)titleLbl {
	if (!_titleLbl) {
		_titleLbl = [[UILabel alloc] init];
		_titleLbl.text = @"";
		_titleLbl.textColor = UIColor.whiteColor;
		_titleLbl.font = [UIFont boldSystemFontOfSize:18];
		_titleLbl.textAlignment = NSTextAlignmentCenter;
	}
	return _titleLbl;
}

- (UILabel *)choiceLbl {
	if (!_choiceLbl) {
		_choiceLbl = [[UILabel alloc] init];
		_choiceLbl.text = @"选择路线";
		_choiceLbl.textColor = UIColor.whiteColor;
		_choiceLbl.font = [UIFont systemFontOfSize:16];
		_choiceLbl.textAlignment = NSTextAlignmentCenter;
	}
	return _choiceLbl;
}

- (UIView *)locationView {
	if (!_locationView) {
		_locationView = [UIView new];
		_locationView.backgroundColor = kBackgroundColor;
		_locationFlg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guoqi"]];
		_locationFlg.contentMode = UIViewContentModeScaleAspectFit;
		_locationFlg.layer.masksToBounds = YES;
		[_locationFlg.layer setCornerRadius:(5)];
		[_locationFlg.layer setBorderWidth:0];
		[_locationFlg.layer setBorderColor:[UIColor colorWithWhite:1 alpha:0.3].CGColor];
		_locationLbl = [[UILabel alloc] init];
		_locationLbl.text = @"华北地区";
		_locationLbl.textColor = UIColor.whiteColor;
		_locationLbl.font = [UIFont systemFontOfSize:15];
		_delayLbl = [[UILabel alloc] init];
		_delayLbl.text = @"0 ms";
		_delayLbl.textColor = [UIColor colorWithWhite:1 alpha:0.3];;
		_delayLbl.font = [UIFont systemFontOfSize:12];
		UIImageView *en = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enter"]];
		[_locationView addSubview:_locationFlg];
		[_locationView addSubview:_locationLbl];
		[_locationView addSubview:_delayLbl];
		[_locationView addSubview:en];
		[_locationFlg mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(20);
			make.top.mas_equalTo(15);
			make.bottom.mas_equalTo(-15);
			make.height.mas_equalTo(36);
			make.width.mas_equalTo(52);
		}];
		[_locationLbl mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(_locationFlg.mas_right).offset(10);
			make.top.equalTo(_locationFlg);
		}];
		[_delayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(_locationFlg.mas_right).offset(10);
			make.bottom.equalTo(_locationFlg);
		}];
		[en mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.mas_equalTo(-20);
			make.width.mas_equalTo(10);
			make.height.mas_equalTo(14);
			make.centerY.equalTo(_locationFlg);
		}];
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loc_clicked)];
		[_locationView addGestureRecognizer:tap];
	}
	return _locationView;
}

- (UIImageView *)worldView {
	if (!_worldView) {
		_worldView = [[UIImageView alloc] init];
		_worldView.alpha = 0.3;
		_worldView.image = [UIImage imageNamed:@"map"];
		_worldView.contentMode = UIViewContentModeScaleAspectFill;
	}
	return _worldView;
}

- (UIImageView *)upView {
	if (!_upView) {
		_upView = [[UIImageView alloc] init];
		_upView.image = [UIImage imageNamed:@"up"];
		_upView.contentMode = UIViewContentModeScaleAspectFill;
	}
	return _upView;
}

- (UIImageView *)downView {
	if (!_downView) {
		_downView = [[UIImageView alloc] init];
		_downView.image = [UIImage imageNamed:@"down"];
		_downView.contentMode = UIViewContentModeScaleAspectFill;
	}
	return _downView;
}

- (UILabel *)upLbl {
	if (!_upLbl) {
		_upLbl = [[UILabel alloc] init];
		_upLbl.text = @"0 KB/S";
		_upLbl.textColor = UIColor.whiteColor;
		_upLbl.font = [UIFont boldSystemFontOfSize:15];
		_upLbl.textAlignment = NSTextAlignmentCenter;
	}
	return _upLbl;
}

- (UILabel *)downLbl {
	if (!_downLbl) {
		_downLbl = [[UILabel alloc] init];
		_downLbl.text = @"0 KB/S";
		_downLbl.textColor = UIColor.whiteColor;
		_downLbl.font = [UIFont boldSystemFontOfSize:15];
		_downLbl.textAlignment = NSTextAlignmentCenter;
	}
	return _downLbl;
}

- (UIView *)startView {
	if (!_startView) {
		_startView = [[UIView alloc] init];
		_startView.backgroundColor = kBackgroundColor;
		_startView.layer.shadowColor = kTintColor.CGColor;
		_startView.layer.shadowOffset = CGSizeMake(-3, 10);
		_startView.layer.shadowOpacity = 0.3;
		_startView.layer.shadowRadius = 10;
		[_startView.layer setCornerRadius:(75)];
		[_startView.layer setBorderWidth:0];
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switch_clicked)];
		[_startView addGestureRecognizer:tap];
		
		CABasicAnimation *halo = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
		halo.toValue = @(M_PI * 2);
		halo.repeatCount = MAXFLOAT;
		halo.removedOnCompletion = NO;
		halo.fillMode = kCAFillModeForwards;
		halo.duration = 3;
		[_startView.layer addAnimation:halo forKey:@"halo"];
	}
	return _startView;
}

- (UIButton *)startBtn {
	if(!_startBtn) {
		_startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_startBtn setImage:[UIImage imageNamed:@"powOn"] forState:UIControlStateNormal];
		[_startBtn setImage:[UIImage imageNamed:@"powOff"] forState:UIControlStateSelected];
		[_startBtn setImage:[UIImage imageNamed:@"powOff"] forState:UIControlStateSelected | UIControlStateHighlighted];
		[_startBtn addTarget:self action:@selector(switch_clicked) forControlEvents:UIControlEventTouchUpInside];
	}
	return _startBtn;
}

- (UILabel *)timeLbl {
	if (!_timeLbl) {
		_timeLbl = [UILabel new];
		_timeLbl.text = @"点击启动";
		_timeLbl.textColor = UIColor.whiteColor;
		_timeLbl.font = [UIFont boldSystemFontOfSize:16];
		_timeLbl.textAlignment = NSTextAlignmentCenter;
	}
	return _timeLbl;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[NOTIFICATION_CENTER addObserver:self selector:@selector(location_changed:) name:kJLocationChangedNotification object:nil];
	[NOTIFICATION_CENTER addObserver:self selector:@selector(sign_changed:) name:kJSignChangedNotification object:nil];
	[NOTIFICATION_CENTER addObserver:self selector:@selector(netstatus_changed:) name:kJNetStatusChangedNotification object:nil];
}

- (void)_loadUI {
	[super _loadUI];
	self.navigationItem.title = @"加速器";
	[self.view addSubview:self.scrollView];
	[self.scrollView addSubview:self.contentView];
	[self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.scrollView);
		make.width.equalTo(self.scrollView);
	}];
	[self.contentView addSubview:self.locationView];
	[self.contentView addSubview:self.choiceLbl];
	[self.contentView addSubview:self.upView];
	[self.contentView addSubview:self.downView];
	[self.contentView addSubview:self.upLbl];
	[self.contentView addSubview:self.downLbl];
	[self.contentView addSubview:self.proBtn];
	[self.contentView addSubview:self.worldView];
	[self.contentView addSubview:self.startView];
	[self.contentView addSubview:self.startBtn];
	[self.contentView addSubview:self.timeLbl];
	[self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(@0);
		make.top.equalTo(@(50));
	}];
	[self.choiceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(20);
		make.bottom.equalTo(self.locationView.mas_top).offset(-7);
	}];
	[self.worldView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
		make.left.mas_equalTo(0);
		make.right.mas_equalTo(0);
		make.height.mas_equalTo(SCREEN_HEIGHT / 2);
	}];
	[self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.worldView);
		make.width.height.mas_equalTo(150);
	}];
	[self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.startView);
		make.width.height.equalTo(@44);
	}];
	[self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(0);
		make.right.mas_equalTo(0);
		make.top.equalTo(self.startView.mas_bottom).offset(15);
	}];
	[self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(30);
		make.bottom.mas_equalTo(-50);
		make.top.equalTo(self.worldView.mas_bottom).offset(50);
	}];
	[self.upLbl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.upView.mas_right).offset(10);
		make.centerY.equalTo(self.upView);
	}];
	[self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.downLbl.mas_left).offset(-10);
		make.top.equalTo(self.upView);
	}];
	[self.downLbl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(-30);
		make.centerY.equalTo(self.upView);
	}];
	[self.proBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.contentView);
		make.top.equalTo(self.worldView.mas_bottom).offset(20);
	}];
}

- (void)_loadData {
	//
#pragma mark - 获取路线列表
}

- (void)pro_clicked {
	JTabBarController *tab = ((JTabBarController *)[JUtil presentedController]);
	[tab didSelected:1];
}

- (void)switch_clicked {
	if (self.startBtn.isSelected) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认断开?" message:nil preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
			[self closeVPN];
		}];
		UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
		[alert addAction:a1];
		[alert addAction:a2];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}
#pragma mark - 业务逻辑：判断是否会员
	NSString *url = [APIURL stringByAppendingString:@""];
	NSDictionary *params = @{ @"token": @"" };
	[[JNetwork shared] post:url header:nil param:params success:^(id _Nonnull response) {
		if ([response[@"code"] intValue] == 0) {
			if ([response[@"data"][@"is_vip"] intValue] == 1) {
				[self openVPN];
			}
			else {
				[self pro_clicked];
			}
		}
	} failure:nil];
}

- (void)openVPN {
#pragma mark TODO 后台获取配置
	/*
	 {
	 authscheme = ;
	 host = "";
	 obfs = plain;
	 "obfs_param" = "";
	 "ot_domain" = "";
	 "ot_enable" = 0;
	 "ot_path" = "";
	 ota = 0;
	 password = ;
	 port = ;
	 protocol = origin;
	 "protocol_param" = "";
	 }
	 */
	NSString *url = [APIURL stringByAppendingString:@"load_config"];

	[[JNetwork shared] post:url header:@{} param:nil success:^(id _Nonnull response) {
		if ([response[@"code"] intValue] == 0) {
			dispatch_async(dispatch_get_main_queue(), ^{
				JConfModel *model = [JConfModel mj_objectWithKeyValues:response[@"data"]];
				[[JVPN shared] connect:model callback:^(NETunnelProviderManager * _Nonnull manager) {
					[self addObserver];
				}];
			});
		}
	} failure:nil];
}

- (void)closeVPN {
	[[JVPN shared] disconnect];
	[self removeObserver];
}

- (void)vpnstatus_changed {
	[NOTIFICATION_CENTER addObserverForName:NEVPNStatusDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
		NEVPNConnection *con = (NEVPNConnection *)note.object;
		switch (con.status) {
			case NEVPNStatusConnected:
				[self status:YES];
				break;
			case NEVPNStatusConnecting:
				break;
			case NEVPNStatusDisconnecting:
			case NEVPNStatusInvalid:
			case NEVPNStatusDisconnected:
				[self status:NO];
				break;
			default:
				break;
		}
	}];
}

- (void)addObserver {
	[self vpnstatus_changed];
}

- (void)removeObserver {
	[NOTIFICATION_CENTER removeObserver:self name:NEVPNStatusDidChangeNotification object:nil];
}

- (void)status:(BOOL)flag {
	dispatch_async(dispatch_get_main_queue(), ^{
		self.startBtn.selected = flag;
		flag ? [self startTimer] : [self stopTimer];
	});
}

- (void)startTimer {
	NSDate *date = [NSDate date];
	self.timer = [JTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(JTimer * _Nonnull timer) {
		dispatch_async(dispatch_get_main_queue(), ^{
			int timeIntval = -date.timeIntervalSinceNow;
			NSString *time = [self toTime:timeIntval];
			self.timeLbl.text = time;
			[self setSpeed];
		});
	}];
	[self.timer resume];
}

- (void)stopTimer {
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

- (NSString *)toTime:(int)secs {
	int seconds = secs % 60;
	int minutes = (secs / 60) % 60;
	int hours = secs / 3600;
	return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

#pragma mark - notification
- (void)loc_clicked {
	JLocationController *vc = [[JLocationController alloc] init];
	vc.datas = self.datas;
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)setSpeed {
	//
//	self.upLbl.text = [NSString stringWithFormat:@"%dKB/S", ];
//	self.downLbl.text = [NSString stringWithFormat:@"%dKB/S", ];
//	self.delayLbl.text = [NSString stringWithFormat:@"%d ms", ];
}

- (void)location_changed:(NSNotification *)sender {
	JLocationModel *model = ((JLocationModel *)sender.object);
	self.locationLbl.text = model.name;
	[self.locationFlg yy_setImageWithURL:[NSURL URLWithString:model.icon] options:YYWebImageOptionSetImageWithFadeAnimation];
}

- (void)sign_changed:(NSNotification *)sender {
	
}

- (void)netstatus_changed:(NSNotification *)sender {
	[self _loadData];
}

@end
