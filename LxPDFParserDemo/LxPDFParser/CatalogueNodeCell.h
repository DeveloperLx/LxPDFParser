//
//  CatalogueNodeCell.h
//  LxPDFParser
//

#import <UIKit/UIKit.h>

@interface CatalogueNodeCell : UITableViewCell

@property (nonatomic,assign) NSUInteger depth;
@property (nonatomic,strong) UILabel *nameLabel;

@end
