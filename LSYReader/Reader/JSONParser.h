//
//  JSONParser.h
//  LSYReader
//
//  Created by hongli on 16/7/29.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookModel.h"
@interface JSONParser : NSObject
//@property(nonatomic,copy)NSMutableArray* bookModelArr;
+ (void)fetchBookModelCompleteBlock:(void(^)(NSArray *dataarray,NSError *error))block;
@end

