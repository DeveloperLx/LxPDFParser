//
//  LxPDFParser.h
//  PDFCategory
//
//  PDF's physical structure and logical structure:
//      http://blog.csdn.net/bobob/article/details/4328426
//      http://blog.csdn.net/bobob/article/details/4328450

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface LxPDFParser : NSObject

- (instancetype)initWithPDFDocumentPath:(NSString *)path;

@property (nonatomic, readonly) NSString * filePath;
@property (nonatomic, readonly) NSInteger pageCount;
@property (nonatomic, readonly) NSDictionary * catalogDictionary;

/**
 *  Return contents for keyPath in PDF file's structure.
 *
 *  @param keyPath Use NSString object represents NSDictionary object's key, NSNumber object represents NSArray object's index.
 *
 *  @return contents for keyPath.
 */
- (id)valueForPDFKeyPath:(NSArray *)keyPath;

@end
