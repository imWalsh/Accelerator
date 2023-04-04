#import "JLocationCell.h"

@interface JLocationCell()
@property (weak, nonatomic) IBOutlet UIButton *radiobox;
@property (weak, nonatomic) IBOutlet UIImageView *flag;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@end

@implementation JLocationCell

- (void)setModel:(JLocationModel *)model {
	[self.flag yy_setImageWithURL:[NSURL URLWithString:model.icon] options:YYWebImageOptionSetImageWithFadeAnimation];
	self.nameLbl.text = model.name;
	self.radiobox.selected = model.selected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	self.backgroundColor = UIColor.clearColor;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
