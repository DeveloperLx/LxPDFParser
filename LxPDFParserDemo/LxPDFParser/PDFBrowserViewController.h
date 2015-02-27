//
//  PDFBrowserViewController.h
//  LxPDFParser
//

#import <UIKit/UIKit.h>

@interface PDFBrowserViewController : UIViewController

@property (nonatomic,copy) NSString * pdfFilePath;
@property (nonatomic,assign) UIPageViewControllerTransitionStyle transitionStyle;
@property (nonatomic,assign) UIPageViewControllerNavigationOrientation navigationOrientation;
@property (nonatomic,assign) UIPageViewControllerSpineLocation spineLocation;
@property (nonatomic,assign) CGFloat interPageSpacing;
@property (nonatomic,assign) UIPageViewControllerNavigationDirection navigationDirection;

@end
