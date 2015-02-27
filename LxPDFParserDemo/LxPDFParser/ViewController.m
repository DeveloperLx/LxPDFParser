//
//  ViewController.m
//  LxPDFParser
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "PDFCollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PDFCollectionViewController * pcvc = [[PDFCollectionViewController alloc]initWithNibName:@"PDFCollectionViewController" bundle:nil];
    UINavigationController * pcnc = [[UINavigationController alloc]initWithRootViewController:pcvc];
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = pcnc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
