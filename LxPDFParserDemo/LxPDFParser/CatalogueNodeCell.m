//
//  CatalogueNodeCell.m
//  LxPDFParser
//

#import "CatalogueNodeCell.h"

const CGFloat DEPTH_INDENTATION = 32;

@implementation CatalogueNodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self configView];
    }
    return self;
}

- (void)configView
{
    self.depth = 0;
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.layer.borderWidth = 1;
    self.nameLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nameLabel.layer.cornerRadius = 2;
    self.nameLabel.clipsToBounds = YES;
    [self.contentView addSubview:self.nameLabel];
}

- (void)setDepth:(NSUInteger)depth
{
    CGRect contentViewBounds = self.contentView.bounds;
    contentViewBounds.origin.x = depth * DEPTH_INDENTATION;
    contentViewBounds.size.width -= contentViewBounds.origin.x;
    
    self.nameLabel.frame = contentViewBounds;
    
    self.nameLabel.backgroundColor = [UIColor colorWithRed:30 * depth/255.0 green:0.5 blue:(255 - 30 * depth)/255.0 alpha:1];
    
    _depth = depth;
}

@end
