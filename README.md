# LxPDFParser
A delightful iOS library. Simply parse the PDF file's structure. The foundation to come true more complicated functions.
Installation
------------
You only need drag LxPDFParser.h and LxPDFParser.m to your project.
Support
------------
Minimum support iOS version: iOS 2.0. Demo runs on iOS 7.0 and later.
How to use
-----------
    #import "LxPDFParser.h"
###
    #define PDFKitGuide_File_Path @"..."

    LxPDFParser * pdfParser = [[LxPDFParser alloc]initWithPDFDocumentPath:PDFKitGuide_File_Path];
    NSLog(@"pdfParser.filePath = %@", pdfParser.filePath);     //
    NSLog(@"pdfParser.pageCount = %ld", pdfParser.pageCount);    //
    NSLog(@"pdfParser.catalogDictionary = %@", pdfParser.catalogDictionary);    //
    
    id content = [pdfParser valueForPDFKeyPath:@[@"Pages", @"Kids", @2, @"Kids", @2, @"Contents", @0]];
    NSLog(@"content = %@", content);    //
Be careful            
-----------
    Use NSString object represents NSDictionary object's key and NSNumber object represents NSArray object's index.
License
-----------
    LxPDFParser is available under the Apache License 2.0. See the LICENSE file for more info.
