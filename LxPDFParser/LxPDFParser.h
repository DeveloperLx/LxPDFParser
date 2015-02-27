//
//  LxPDFParser.h
//  PDFCategory
//
//  PDF's physical structure and logical structure:
//      http://blog.csdn.net/bobob/article/details/4328426
//      http://blog.csdn.net/bobob/article/details/4328450
//      http://blog.csdn.net/xzz/article/details/4447123

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef void (*CGPDFArrayApplierFunction)(size_t index, CGPDFObjectRef value, void *info);

void CGPDFArrayApplyFunction(CGPDFArrayRef array, CGPDFArrayApplierFunction function, void * info);

@interface CatalogueNodeModel : NSObject

@property (nonatomic,copy) NSString * name;
@property (nonatomic,assign) NSUInteger depth;
@property (nonatomic,strong) NSMutableArray * childNodeArray;
@property (nonatomic,weak) CatalogueNodeModel * parentNode;
@property (nonatomic,assign) NSUInteger pageIndex;  //  Not implementate temporarily.

- (instancetype)initWithName:(NSString *)name;

@end

@interface LxPDFParser : NSObject

- (instancetype)initWithPDFDocumentPath:(NSString *)path;

@property (nonatomic, readonly) NSString * filePath;
@property (nonatomic, readonly) NSInteger pageCount;
@property (nonatomic, readonly) NSDictionary * catalogDictionary;
@property (nonatomic, readonly) CatalogueNodeModel * rootCatalogueNode;

- (NSArray *)keyArrayOfPDFDictionary:(CGPDFDictionaryRef)pdfDictionary;

/**
 *  Return contents for keyPath in PDF file's structure.
 *
 *  @param keyPath Use NSString object represents NSDictionary object's key, NSNumber object represents NSArray object's index.
 *
 *  @return contents for keyPath.
 */
- (id)valueForPDFKeyPath:(NSArray *)keyPath;

@end
