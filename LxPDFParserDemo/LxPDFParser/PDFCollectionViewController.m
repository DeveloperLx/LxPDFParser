//
//  PDFCollectionViewController.m
//  LxPDFParser
//

#import "PDFCollectionViewController.h"
#import "PDFFacilityCollectionViewCell.h"
#import "LxPDFParser.h"
#import "CatalogueTableViewController.h"
#import "PDFTableViewController.h"
#import "PDFBrowserViewController.h"

@interface PDFCollectionViewController ()

@end

@implementation PDFCollectionViewController

static NSString * const reuseIdentifier = @"PDFCollectionCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"LxPDFParser";
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[PDFFacilityCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PDFFacilityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = @"Browser";
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"Catalogue";
        }
            break;
        case 2:
        {
            cell.titleLabel.text = @"File structure";
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * path = [[NSBundle mainBundle]pathForResource:@"drawingwithquartz2d" ofType:@"pdf"];
    
    LxPDFParser * pdfParser = [[LxPDFParser alloc]initWithPDFDocumentPath:path];
    NSLog(@"pdfParser.filePath = %@", pdfParser.filePath);      //
    NSLog(@"pdfParser.pageCount = %d", pdfParser.pageCount);    //
    NSLog(@"pdfParser.catalogDictionary = %@", pdfParser.catalogDictionary);    //
    
    id content = [pdfParser valueForPDFKeyPath:@[@"Pages", @"Kids", @2, @"Kids", @2, @"Contents", @0]];
    
    NSLog(@"content = %@", content);    //

    
    switch (indexPath.row) {
        case 0:
        {
            PDFBrowserViewController * pbvc = [[PDFBrowserViewController alloc]init];
            pbvc.pdfFilePath = path;
            [self.navigationController pushViewController:pbvc animated:YES];
        }
            break;
        case 1:
        {
            CatalogueTableViewController * ctvc = [[CatalogueTableViewController alloc]initWithNibName:@"CatalogueTableViewController" bundle:nil];
            ctvc.pdfParser = pdfParser;
            ctvc.title = @"Catalogue";
            
            [self.navigationController pushViewController:ctvc animated:YES];
        }
            break;
        case 2:
        {
            PDFTableViewController * ptvc = [[PDFTableViewController alloc]init];
            ptvc.pdfParser = pdfParser;
            ptvc.title = @"Catalog";
            
            [self.navigationController pushViewController:ptvc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
