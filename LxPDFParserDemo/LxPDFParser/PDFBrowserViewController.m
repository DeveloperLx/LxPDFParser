//
//  PDFBrowserViewController.m
//  LxPDFParser
//

#import "PDFBrowserViewController.h"

@interface PDFSinglePageViewControler : UIViewController <UIWebViewDelegate>

@property (nonatomic,copy) NSString * path;
@property (nonatomic,assign) NSUInteger page;
@property (nonatomic,strong) UIWebView * pdfSinglePageWebView;

@end

@implementation PDFSinglePageViewControler

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pdfSinglePageWebView = [[UIWebView alloc]init];
    self.pdfSinglePageWebView.backgroundColor = [UIColor clearColor];
    self.pdfSinglePageWebView.delegate = self;
    self.pdfSinglePageWebView.scrollView.minimumZoomScale = 1;
    self.pdfSinglePageWebView.scrollView.maximumZoomScale = 3;
    [self.view addSubview:self.pdfSinglePageWebView];
    
    self.pdfSinglePageWebView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray * constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pdfSinglePageWebView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_pdfSinglePageWebView)];
    NSArray * constraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_pdfSinglePageWebView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_pdfSinglePageWebView)];
    
    [self.view addConstraints:constraintH];
    [self.view addConstraints:constraintV];
    
    [self.view addSubview:self.pdfSinglePageWebView];
    
    [self.pdfSinglePageWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.singlePagePDFFilePath]]];
}

- (NSString *)pdfFileName
{
    return self.path.lastPathComponent.stringByDeletingPathExtension;
}

- (NSString *)singlePagePDFDirectoryPath
{
    NSString * singlePagePDFDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:self.pdfFileName];
    
    NSError * error = nil;
    
    BOOL createDirectorySuccess = [[NSFileManager defaultManager] createDirectoryAtPath:singlePagePDFDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSAssert(createDirectorySuccess, @"创建单页PDF目录失败: %@", error.localizedDescription);  //
    
    return singlePagePDFDirectoryPath;
}

- (NSString *)singlePagePDFFilePath
{
    NSString * singlePagePDFFilePath = [self.singlePagePDFDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ p%u.pdf", self.pdfFileName, self.page]];
    
    BOOL isDirectory = NO;
    BOOL fileExists = [[NSFileManager defaultManager]fileExistsAtPath:singlePagePDFFilePath isDirectory:&isDirectory];
    
    if (fileExists && !isDirectory) {
        
    }
    else {
    
        NSURL * pdfFileUrl = [NSURL fileURLWithPath:self.path];
        
        CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfFileUrl);
        
        NSAssert(pdfDocument, @"创建PDF Document失败");   //
        
        CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdfDocument, self.page);
        
        CGRect pdfPageBoxRect = CGPDFPageGetBoxRect(pdfPage, kCGPDFMediaBox);
        
        CFURLRef singlePagePDFFileUrl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)singlePagePDFFilePath, kCFURLPOSIXPathStyle, false);
        
        NSAssert(singlePagePDFFileUrl, @"生成单页PDF文件地址失败");   //
        
        CGDataConsumerRef singlePagePDFFileDataConsumer = CGDataConsumerCreateWithURL(singlePagePDFFileUrl);
        
        NSAssert(singlePagePDFFileDataConsumer, @"生成单页PDF DataConsumer失败");   //
        
        CGContextRef singlePagePDFFileContext = CGPDFContextCreate(singlePagePDFFileDataConsumer, &pdfPageBoxRect, 0);
        
        NSAssert(singlePagePDFFileContext, @"生成单页PDF Context失败");   //
        
        CGContextBeginPage(singlePagePDFFileContext, &pdfPageBoxRect);
        CGContextSetFillColorWithColor(singlePagePDFFileContext, [UIColor whiteColor].CGColor);
        CGContextFillRect(singlePagePDFFileContext, pdfPageBoxRect);
        CGContextDrawPDFPage(singlePagePDFFileContext, pdfPage);
        CGContextEndPage(singlePagePDFFileContext);
        CGPDFContextClose(singlePagePDFFileContext);
        
        CGContextRelease(singlePagePDFFileContext);
        CGDataConsumerRelease(singlePagePDFFileDataConsumer);
        CFRelease(singlePagePDFFileUrl);
    }
    
    return singlePagePDFFilePath;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"absoluteString = %@", request.URL.absoluteString); //
    
    return YES;
}

@end





@interface PDFBrowserViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic,strong) UIPageViewController * pageViewController;

@end

@implementation PDFBrowserViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self configPageViewController];
}

- (void)configPageViewController
{
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.pageViewController = nil;
    
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:self.transitionStyle
                                                             navigationOrientation:self.navigationOrientation
                                                                           options:@{UIPageViewControllerOptionSpineLocationKey:@(self.spineLocation), UIPageViewControllerOptionInterPageSpacingKey:@(self.interPageSpacing)}];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    PDFSinglePageViewControler * pdfSinglePageViewController1 = [self singlePageViewControlerAtPageIndex:1];
    
    [self.pageViewController setViewControllers:@[pdfSinglePageViewController1] direction:self.navigationDirection animated:YES completion:^(BOOL finished) {
        
    }];
    
    self.pageViewController.view.backgroundColor = [UIColor blackColor];
    self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray * constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageViewControllerView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"pageViewControllerView":self.pageViewController.view}];
    NSArray * constraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[pageViewControllerView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"pageViewControllerView":self.pageViewController.view}];
    [self.view addConstraints:constraintH];
    [self.view addConstraints:constraintV];
}

- (void)setPdfFilePath:(NSString *)pdfFilePath
{
    if (_pdfFilePath != pdfFilePath) {
        
        BOOL isDirectory = NO;
        BOOL pdfFileExists = [[NSFileManager defaultManager] fileExistsAtPath:pdfFilePath isDirectory:&isDirectory];
        
        NSAssert(pdfFileExists && !isDirectory, @"输入PDF文件路径错误");  //
        
        _pdfFilePath = [pdfFilePath copy];
    }
}

- (size_t)pdfDocumentPageCount
{
    NSURL * pdfFileUrl = [NSURL fileURLWithPath:self.pdfFilePath];
    
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfFileUrl);
    
    NSAssert(pdfDocument, @"创建PDF Document失败");   //
    
    size_t pdfDocumentPageCount = CGPDFDocumentGetNumberOfPages(pdfDocument);
    
    CGPDFDocumentRelease(pdfDocument);
    
    return pdfDocumentPageCount;
}

- (PDFSinglePageViewControler *)singlePageViewControlerAtPageIndex:(NSUInteger)pageIndex
{
    PDFSinglePageViewControler * pdfSinglePageViewController = [[PDFSinglePageViewControler alloc]init];
    pdfSinglePageViewController.path = self.pdfFilePath;
    pdfSinglePageViewController.page = pageIndex;
    return pdfSinglePageViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    PDFSinglePageViewControler * pdfSinglePageViewController = (PDFSinglePageViewControler *)viewController;
    NSUInteger beforePage = pdfSinglePageViewController.page - 1;
    
    if (beforePage == 0) {
        return nil;
    }
    else {
        return [self singlePageViewControlerAtPageIndex:beforePage];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    PDFSinglePageViewControler * pdfSinglePageViewController = (PDFSinglePageViewControler *)viewController;
    NSUInteger afterPage = pdfSinglePageViewController.page + 1;
    
    if (afterPage > self.pdfDocumentPageCount) {
        return nil;
    }
    else {
        return [self singlePageViewControlerAtPageIndex:afterPage];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{

}

@end




