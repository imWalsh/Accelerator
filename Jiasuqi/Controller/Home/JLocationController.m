#import "JLocationController.h"
#import "JLocationCell.h"
#define kCellID					@"JLocationCell"

@interface JLocationController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tv;

@end


@implementation JLocationController

- (UITableView *)tv {
	if (!_tv) {
		_tv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		_tv.delegate = self;
		_tv.dataSource = self;
		_tv.rowHeight = 80;
		_tv.tableFooterView = [UIView new];
		_tv.showsVerticalScrollIndicator = NO;
		_tv.backgroundColor = UIColor.clearColor;
		_tv.separatorStyle = UITableViewCellSeparatorStyleNone;
		[_tv registerNib:[UINib nibWithNibName:kCellID bundle:nil] forCellReuseIdentifier:kCellID];
	}
	return _tv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)_loadUI {
	[super _loadUI];
	self.navigationItem.title = @"选择地区";
	[self.view addSubview:self.tv];
	[self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}

- (void)_loadData {
	if (self.datas.count == 0) return;
	[self.tv reloadData];
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
	[self.tv selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}
#pragma mark -- delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	JLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	cell.model = self.datas[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	for (JLocationModel *m in self.datas) {
		m.selected = NO;
	}
	JLocationModel *model = self.datas[indexPath.row];
	model.selected = YES;
	[tableView reloadData];
	[NOTIFICATION_CENTER postNotificationName:kJLocationChangedNotification object:model];
}

@end
