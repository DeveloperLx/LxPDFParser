//
//  PDFNodeDisplayCell.m
//  PDFCategory
//

#import "PDFNodeDisplayCell.h"

const CGFloat NODE_DISPLAY_CELL_HEIGHT = 44;

@implementation PDFNodeDisplayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        self.displayLabel = [[UILabel alloc]init];
        self.displayLabel.numberOfLines = 0;
        self.displayLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.displayLabel];
        
        self.displayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray * constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_displayLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_displayLabel)];
        NSArray * constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_displayLabel]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_displayLabel)];
        
        [self.contentView addConstraints:constraintsH];
        [self.contentView addConstraints:constraintsV];
    }
    return self;
}

@end
