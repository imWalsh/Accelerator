#import "JProCell.h"
@interface JProCell()
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UILabel *tipLbl;
@property (weak, nonatomic) IBOutlet UIView *border;
@property (weak, nonatomic) IBOutlet UILabel *durationLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *avgLbl;
@end
@implementation JProCell

- (void)setModel:(JProModel *)model {
	_model = model;
	self.tipLbl.text = model.vip_dtitle;
	self.durationLbl.text = model.duration;
	NSMutableAttributedString *nw = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.0f", model.ios_pris.floatValue] attributes:@{NSForegroundColorAttributeName:kTintColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:26]}];
	[nw addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:NSMakeRange(0, 1)];
	self.priceLbl.attributedText = nw;
	NSMutableAttributedString *old = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"￥%.0f", model.ios_pris.floatValue] attributes:@{NSForegroundColorAttributeName:kTintColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:12], NSStrikethroughStyleAttributeName : @1 } ];
	self.oldPriceLbl.attributedText = old;
	self.avgLbl.text = [NSString stringWithFormat:@"￥%.1f/天", model.des];
}

- (void)awakeFromNib {
    [super awakeFromNib];
	self.tipView.layer.contents = (id)[UIImage imageNamed:@"pro.tip"].CGImage;
}

- (void)setSelected:(BOOL)selected {
	super.selected = selected;
	if (selected) {
		self.border.borderColor = kTintColor;
		self.durationLbl.textColor = kTintColor;
		self.priceLbl.textColor = kTintColor;
		self.oldPriceLbl.textColor = kNormalColor;
		CGFloat off = self.model.ios_pris.floatValue / self.model.pris;
		NSString *str = [NSString stringWithFormat:@"%.0f折，%@", off, self.model.vip_dtitle];
		self.tipLbl.text = str;
	}
	else {
		self.border.borderColor = UIColor.clearColor;
		self.durationLbl.textColor = kNormalColor;
		self.priceLbl.textColor = [UIColor colorWithWhite:1 alpha:.8];
		self.oldPriceLbl.textColor = kNormalColor;
		self.tipLbl.text = self.model.vip_dtitle;
	}
	if (self.model.loaded) {
		[UIView animateWithDuration:0.3 animations:^{
			[self.contentView layoutIfNeeded];
		}];
	}
}

@end
