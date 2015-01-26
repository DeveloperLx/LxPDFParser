//
//  PDFTableViewController.h
//  PDFCategory
//

#import <UIKit/UIKit.h>
#import "LxPDFParser.h"

@interface PDFTableViewController : UITableViewController

@property (nonatomic,strong) LxPDFParser * pdfParser;
@property (nonatomic,strong) NSMutableArray * keyPathArray;

@end
