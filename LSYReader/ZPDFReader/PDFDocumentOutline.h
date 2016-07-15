//
//  PDFDocumentOutline.h
//  GreatReader
//
//  Created by MIYAMOTO Shohei on 2014/01/14.
//  Copyright (c) 2014 MIYAMOTO Shohei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDFDocumentOutlineItem;

@interface PDFDocumentOutline : NSObject
@property (nonatomic, strong, readonly) NSArray *items;
- (instancetype)initWithCGPDFDocument:(CGPDFDocumentRef)document;
- (NSString *)sectionTitleAtIndex:(NSUInteger)index;
- (NSArray *)outlineItemsForDocument:(CGPDFDocumentRef)document;
- (NSArray *)childrenForItem:(CGPDFDictionaryRef)item
                    document:(CGPDFDocumentRef)document;
- (NSString *)titleOfDictionary:(CGPDFDictionaryRef)dictionary;
- (NSUInteger)pageNumberOfDictionary:(CGPDFDictionaryRef)dictionary
                            document:(CGPDFDocumentRef)document
                         destination:(CGPDFObjectRef *)destination;
- (CGPDFArrayRef)findDestination:(const char *)destinationName
                            node:(CGPDFDictionaryRef)node;
- (NSString *)description;

@end
