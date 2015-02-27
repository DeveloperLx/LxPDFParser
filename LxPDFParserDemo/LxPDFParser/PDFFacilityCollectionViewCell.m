//
//  PDFFacilityCollectionViewCell.m
//  LxPDFParser
//

#import "PDFFacilityCollectionViewCell.h"

@implementation PDFFacilityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray * nibArray = [[NSBundle mainBundle]loadNibNamed:@"PDFFacilityCollectionViewCell" owner:self options:nil];
        
        if (nibArray.count < 1 || ![nibArray.firstObject isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = nibArray.firstObject;
    }
    return self;
}

@end
