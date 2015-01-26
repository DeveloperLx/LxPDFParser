//
//  ViewController.m
//  LxPDFParser
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "LxPDFParser.h"
#import "PDFTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString * path = [[NSBundle mainBundle]pathForResource:@"PDFKitGuide" ofType:@"pdf"];
    
    LxPDFParser * pdfParser = [[LxPDFParser alloc]initWithPDFDocumentPath:path];
    NSLog(@"pdfParser.filePath = %@", pdfParser.filePath);     //
    NSLog(@"pdfParser.pageCount = %ld", pdfParser.pageCount);    //
    NSLog(@"pdfParser.catalogDictionary = %@", pdfParser.catalogDictionary);    //
    
    id content = [pdfParser valueForPDFKeyPath:@[@"Pages", @"Kids", @2, @"Kids", @2, @"Contents", @0]];
    NSLog(@"content = %@", content);    //
    
    PDFTableViewController * ptvc = [[PDFTableViewController alloc]init];
    ptvc.pdfParser = pdfParser;
    ptvc.title = @"Catalog";
    
    UINavigationController * ptnv = [[UINavigationController alloc]initWithRootViewController:ptvc];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = ptnv;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
