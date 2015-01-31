//
//  LxPDFParser.m
//  PDFCategory
//

#import "LxPDFParser.h"

#define PRINTF(fmt, ...)    printf("%s\n",[[NSString stringWithFormat:fmt,##__VA_ARGS__]UTF8String])

typedef void (*CGPDFArrayApplierFunction)(size_t index, CGPDFObjectRef value, void *info);

void CGPDFArrayApplyFunction(CGPDFArrayRef array, CGPDFArrayApplierFunction function, void * info)
{
    size_t pdfArrayCount = CGPDFArrayGetCount(array);
    for (size_t i = 0; i < pdfArrayCount; i++) {
        CGPDFObjectRef pdfObject = 0;
        CGPDFArrayGetObject(array, i, &pdfObject);
        function(i, pdfObject, info);
    }
}

@implementation LxPDFParser
{
    CGPDFDocumentRef _pdfDocument;
}
@synthesize filePath = _filePath;

- (void)dealloc
{
    if (_pdfDocument) {
        CGPDFDocumentRelease(_pdfDocument);
        _pdfDocument = 0;
    }
}

- (instancetype)init
{
    NSAssert(0, @"LxPDFParser must use initWithPDFDocumentPath: method to be instantiated!");
    return nil;
}

- (instancetype)initWithPDFDocumentPath:(NSString *)path
{
    if (self = [super init]) {

        NSAssert(path.length > 0, @"LxPDFParser: Error PDF document path.");
        
        CFStringRef pathString = CFStringCreateWithCString(kCFAllocatorDefault, path.UTF8String, kCFStringEncodingUTF8);

        NSAssert(pathString, @"LxPDFParser: Error PDF document path.");

        CFURLRef pathUrl = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, pathString, kCFURLPOSIXPathStyle, false);

        NSAssert(pathUrl, @"LxPDFParser: Error PDF document path.");
        
        CFRelease(pathString);
        
        _pdfDocument = CGPDFDocumentCreateWithURL(pathUrl);

        NSAssert(_pdfDocument, @"LxPDFParser: Error PDF document path.");
        
        _filePath = path;
    }
    return self;
}

- (NSString *)filePath
{
    return _filePath;
}

- (NSInteger)pageCount
{
    size_t pageCount = CGPDFDocumentGetNumberOfPages(_pdfDocument);
    return (NSInteger)pageCount;
}

- (NSDictionary *)catalogDictionary
{
    CGPDFDictionaryRef pdfCatalogDictionary = CGPDFDocumentGetCatalog(_pdfDocument);
    
    NSMutableDictionary * catalogDictionary = [NSMutableDictionary dictionary];
    
    CGPDFDictionaryApplyFunction(pdfCatalogDictionary, pdfDictionaryHandler, (__bridge void *)(catalogDictionary));
    
    return [NSDictionary dictionaryWithDictionary:catalogDictionary];
}

- (id)valueForPDFKeyPath:(NSArray *)keyPath
{
    id resultValue = nil;
    
    CGPDFArrayRef pdfArray = 0;
    CGPDFDictionaryRef pdfDictionary = CGPDFDocumentGetCatalog(_pdfDocument);
    
    NSMutableArray * resultArray = [NSMutableArray array];
    NSMutableDictionary * resultDictionary = [NSMutableDictionary dictionary];
    
    CGPDFDictionaryApplyFunction(pdfDictionary, pdfDictionaryHandler, (__bridge void *)(resultDictionary));
    resultValue = resultDictionary;

    CGPDFObjectType pdfObjectType = kCGPDFObjectTypeNull;
    bool executeCorrect = true;
    for (id key in keyPath) {
        
        CGPDFObjectRef value;
        if ([key isKindOfClass:[NSString class]]) {
            
            CGPDFDictionaryGetObject(pdfDictionary, [key UTF8String], &value);
        }
        else if ([key isKindOfClass:[NSNumber class]]) {
            
            CGPDFArrayGetObject(pdfArray, (size_t)[key integerValue], &value);
        }
        else {
        
        }
        
        pdfObjectType = CGPDFObjectGetType(value);
        
        switch (pdfObjectType) {
            case kCGPDFObjectTypeNull:
                return @"null";
                break;
            case kCGPDFObjectTypeBoolean:
            {
                CGPDFBoolean pdfBoolean = 0;
                executeCorrect = CGPDFObjectGetValue(value, pdfObjectType, &pdfBoolean);
                return pdfBoolean ? @1:@0;
            }
                break;
            case kCGPDFObjectTypeInteger:
            {
                CGPDFInteger pdfInteger = 0;
                executeCorrect = CGPDFObjectGetValue(value, pdfObjectType, &pdfInteger);
                return @(pdfInteger);
            }
                break;
            case kCGPDFObjectTypeReal:
            {
                CGPDFReal pdfReal = 0;
                executeCorrect = CGPDFObjectGetValue(value, pdfObjectType, &pdfReal);
                return @(pdfReal);
            }
                break;
            case kCGPDFObjectTypeName:
            {
                const char * pdfName = 0;
                executeCorrect = CGPDFObjectGetValue(value, pdfObjectType, &pdfName);
                return @(pdfName);
            }
                break;
            case kCGPDFObjectTypeString:
            {
                CGPDFStringRef pdfString = 0;
                executeCorrect = CGPDFObjectGetValue(value, pdfObjectType, &pdfString);
                CFStringRef string = CGPDFStringCopyTextString(pdfString);
                return (__bridge NSString *)string;
            }
                break;
            case kCGPDFObjectTypeArray:
            {
                [resultArray removeAllObjects];
                
                if ([key isKindOfClass:[NSString class]]) {
                    CGPDFDictionaryGetArray(pdfDictionary, [key UTF8String], &pdfArray);
                }
                else if ([key isKindOfClass:[NSNumber class]]) {
                    CGPDFArrayGetArray(pdfArray, (size_t)[key integerValue], &pdfArray);
                }
                else {
                
                }
                
                CGPDFArrayApplyFunction(pdfArray, pdfArrayHandler, (__bridge void *)(resultArray));
                resultValue = resultArray;
            }
                break;
            case kCGPDFObjectTypeDictionary:
            {
                [resultDictionary removeAllObjects];
                
                if ([key isKindOfClass:[NSString class]]) {
                    CGPDFDictionaryGetDictionary(pdfDictionary, [key UTF8String], &pdfDictionary);
                }
                else if ([key isKindOfClass:[NSNumber class]]) {
                    CGPDFArrayGetDictionary(pdfArray, (size_t)[key integerValue], &pdfDictionary);
                }
                else {
                    
                }
                
                CGPDFDictionaryApplyFunction(pdfDictionary, pdfDictionaryHandler, (__bridge void *)(resultDictionary));
                resultValue = resultDictionary;
            }
                break;
            case kCGPDFObjectTypeStream:
            {
                CGPDFStreamRef pdfStream = 0;
                executeCorrect = CGPDFObjectGetValue(value, pdfObjectType, &pdfStream);
                CGPDFDataFormat pdfDataFormat;
                CFDataRef pdfStreamData = CGPDFStreamCopyData(pdfStream, &pdfDataFormat);
                NSString * streamString = [[NSString alloc]initWithData:(__bridge NSData *)pdfStreamData encoding:NSUTF8StringEncoding];
                streamString = streamString ? streamString : @"";
                return streamString;
//                return @"<Stream>";
            }
                break;
            default:
                break;
        }
    }
    
    return resultValue;
}

void pdfDictionaryHandler(const char * key, CGPDFObjectRef value, void * info)
{
    bool executeCorrect = true;
    
    NSMutableDictionary * newDictionary = (__bridge NSMutableDictionary *)info;
    
    NSString * keyString = [NSString stringWithUTF8String:key];
    
    CGPDFObjectType valueType = CGPDFObjectGetType(value);

    switch (valueType) {
        case kCGPDFObjectTypeNull:
        {
            [newDictionary setValue:@"null" forKey:keyString];
        }
            break;
        case kCGPDFObjectTypeBoolean:
        {
            CGPDFBoolean pdfBoolean = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfBoolean);
            [newDictionary setValue:pdfBoolean ? @1:@0 forKey:keyString];
        }
            break;
        case kCGPDFObjectTypeInteger:
        {
            CGPDFInteger pdfInteger = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfInteger);
            [newDictionary setValue:@(pdfInteger) forKey:keyString];
        }
            break;
        case kCGPDFObjectTypeReal:
        {
            CGPDFReal pdfReal = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfReal);
            [newDictionary setValue:@(pdfReal) forKey:keyString];
        }
            break;
        case kCGPDFObjectTypeName:
        {
            const char * pdfName = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfName);
            NSString * name = [NSString stringWithUTF8String:pdfName];
            name = name ? name : @"";
            [newDictionary setValue:name forKey:keyString];
        }
            break;
        case kCGPDFObjectTypeString:
        {
            CGPDFStringRef pdfString = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfString);
            CFStringRef string = CGPDFStringCopyTextString(pdfString);
            NSString * stringObject = (__bridge NSString *)string;
            stringObject = stringObject ? stringObject : @"";
            [newDictionary setValue:stringObject forKey:keyString];
        }
            break;
        case kCGPDFObjectTypeArray:
        {
            CGPDFArrayRef pdfArray = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfArray);
            
            size_t objectsCount = CGPDFArrayGetCount(pdfArray);
            [newDictionary setValue:[NSString stringWithFormat:@"[ %d objects ]", (int)objectsCount] forKey:keyString];
        }
            break;
        case kCGPDFObjectTypeDictionary:
        {
            CGPDFDictionaryRef pdfDictionary = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfDictionary);
            
            size_t keyValuePairsCount = CGPDFDictionaryGetCount(pdfDictionary);
            [newDictionary setValue:[NSString stringWithFormat:@"{ %d key/value pairs }", (int)keyValuePairsCount] forKey:keyString];
        }
            break;
        case kCGPDFObjectTypeStream:
        {
            CGPDFStreamRef pdfStream = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfStream);
            CGPDFDataFormat pdfDataFormat;
            CFDataRef pdfStreamData = CGPDFStreamCopyData(pdfStream, &pdfDataFormat);
            NSString * streamString = [[NSString alloc]initWithData:(__bridge NSData *)pdfStreamData encoding:NSUTF8StringEncoding];
            streamString = streamString ? streamString : @"";
            [newDictionary setValue:streamString forKey:keyString];
//            [newDictionary setValue:@"<Stream>" forKey:keyString];
        }
            break;
        default:
            break;
    }
    if (!executeCorrect) {
        PRINTF(@"LxPDFParser 解析PDF文件发生错误"); //
    }
}

void pdfArrayHandler(size_t index, CGPDFObjectRef value, void * info)
{
    bool executeCorrect = true;
    
    NSMutableArray * newArray = (__bridge NSMutableArray *)info;
    
    CGPDFObjectType valueType = CGPDFObjectGetType(value);

    switch (valueType) {
        case kCGPDFObjectTypeNull:
        {
        }
            break;
        case kCGPDFObjectTypeBoolean:
        {
            CGPDFBoolean pdfBoolean = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfBoolean);
            [newArray addObject:pdfBoolean ? @1:@0];
        }
            break;
        case kCGPDFObjectTypeInteger:
        {
            CGPDFInteger pdfInteger = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfInteger);
            [newArray addObject:@(pdfInteger)];
        }
            break;
        case kCGPDFObjectTypeReal:
        {
            CGPDFReal pdfReal = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfReal);
            [newArray addObject:@(pdfReal)];
        }
            break;
        case kCGPDFObjectTypeName:
        {
            const char * pdfName = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfName);
            NSString * name = [NSString stringWithUTF8String:pdfName];
            name = name ? name : @"";
            [newArray addObject:name];
        }
            break;
        case kCGPDFObjectTypeString:
        {
            CGPDFStringRef pdfString = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfString);
            CFStringRef string = CGPDFStringCopyTextString(pdfString);
            NSString * stringObject = (__bridge NSString *)string;
            stringObject = stringObject ? stringObject : @"";
            [newArray addObject:stringObject];
        }
            break;
        case kCGPDFObjectTypeArray:
        {
            CGPDFArrayRef pdfArray = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfArray);
            
            size_t objectsCount = CGPDFArrayGetCount(pdfArray);
            [newArray addObject:[NSString stringWithFormat:@"[ %d objects ]", (int)objectsCount]];
        }
            break;
        case kCGPDFObjectTypeDictionary:
        {
            CGPDFDictionaryRef pdfDictionary = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfDictionary);
            
            size_t keyValuePairsCount = CGPDFDictionaryGetCount(pdfDictionary);
            [newArray addObject:[NSString stringWithFormat:@"{ %d key/value pairs }", (int)keyValuePairsCount]];
        }
            break;
        case kCGPDFObjectTypeStream:
        {
            CGPDFStreamRef pdfStream = 0;
            executeCorrect = CGPDFObjectGetValue(value, valueType, &pdfStream);
            CGPDFDataFormat pdfDataFormat;
            CFDataRef pdfStreamData = CGPDFStreamCopyData(pdfStream, &pdfDataFormat);
            NSString * streamString = [[NSString alloc]initWithData:(__bridge NSData *)pdfStreamData encoding:NSUTF8StringEncoding];
            streamString = streamString ? streamString : @"";
            [newArray addObject:streamString];
//            [newArray addObject:@"<Stream>"];
        }
            break;
        default:
            break;
    }
    if (!executeCorrect) {
        PRINTF(@"LxPDFParser 解析PDF文件发生错误"); //
    }
}

@end
