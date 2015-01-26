//
//  PDFNodeDisplayCell.m
//  PDFCategory
//

#import "PDFNodeDisplayCell.h"

const CGFloat NODE_DISPLAY_CELL_HEIGHT = 44;

static const CGFloat DISPLAYLABEL_MARGIN = 12;

@implementation PDFNodeDisplayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.contentView.frame = CGRectMake(0, 0, width, NODE_DISPLAY_CELL_HEIGHT);
        self.frame = self.contentView.frame;
        
        self.displayLabel = [[UILabel alloc]initWithFrame:CGRectInset(self.contentView.frame, DISPLAYLABEL_MARGIN, DISPLAYLABEL_MARGIN)];
        self.displayLabel.numberOfLines = 0;
        self.displayLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.displayLabel];
    }
    return self;
}

- (void)sizeToFit
{
    [super sizeToFit];
    
    self.displayLabel.frame = CGRectInset(self.contentView.frame, DISPLAYLABEL_MARGIN, DISPLAYLABEL_MARGIN);
    [self.displayLabel sizeToFit];
    CGRect contentViewRect = self.contentView.frame;
    contentViewRect.size.height = CGRectGetMaxY(self.displayLabel.frame) + DISPLAYLABEL_MARGIN;
    self.contentView.frame = contentViewRect;
    self.frame = self.contentView.frame;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
