#import "JProController.h"
#import "JProCell.h"
#define kCellID					@"JProCell"
@interface JProController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (weak, nonatomic) IBOutlet UICollectionView *cv;
@property (nonatomic, strong) NSMutableArray<JProModel *> *datas;
@property (nonatomic, strong) JProModel *selectedModel;
@end

@implementation JProController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)_loadUI {
	[super _loadUI];
	self.navigationItem.title = @"Pro";
	self.datas = @[].mutableCopy;
	UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
	flow.itemSize = CGSizeMake(SCREEN_WIDTH, 66);
	flow.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
	flow.minimumLineSpacing = 10;
	flow.minimumInteritemSpacing = 10;
	self.cv.delegate = self;
	self.cv.dataSource = self;
	self.cv.collectionViewLayout = flow;
	self.cv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	[self.cv registerNib:[UINib nibWithNibName:kCellID bundle:nil] forCellWithReuseIdentifier:kCellID];
}

- (void)_loadData {
	NSString *url = [APIURL stringByAppendingString:@""];
	
	[[JNetwork shared] get:url header:@{} param:nil success:^(id  _Nonnull response) {
		if ([response[@"code"] intValue] == 0) {
			

			[self.cv reloadData];
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
			[self.cv selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
		}
	} failure:nil];
}

- (IBAction)buy_clicked:(id)sender {
	[self.view makeToastActivity:CSToastPositionCenter];
	[[XYStore defaultStore] addPayment:self.selectedModel.ios_code success:^(SKPaymentTransaction *transaction) {
		[self.view hideToastActivity];
		[self.view makeToast:@"购买成功" duration:3 position:CSToastPositionTop];
	} failure:^(SKPaymentTransaction *transaction, NSError *error) {
		[self.view hideToastActivity];
		[self.view makeToast:@"购买失败" duration:3 position:CSToastPositionTop];
	}];
}

#pragma mark -- delegate & datasource
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	JProCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
	cell.model = self.datas[indexPath.item];
	cell.selected = NO;
	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.datas.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	JProModel *model = self.datas[indexPath.item];
	model.loaded = YES;
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	JProModel *model = self.datas[indexPath.item];
	model.selected = YES;
	self.selectedModel = model;
}
@end
