//
//  LSYMarkModel.m
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYMarkModel.h"

@implementation LSYMarkModel
/***
 
 @property (nonatomic,strong) NSDate *date;
 @property (nonatomic,strong) LSYRecordModel *recordModel;
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.recordModel forKey:@"recordModel"];
    //[aCoder encodeObject:self.markSet forKey:@"markSet"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.recordModel = [aDecoder decodeObjectForKey:@"recordModel"];
        //self.markSet  = [aDecoder decodeObjectForKey:@"markSet"];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    
    return self.recordModel.page == ((LSYMarkModel*)object).recordModel.page&& self.recordModel.chapter == ((LSYMarkModel*)object).recordModel.chapter;
    
}

- (NSUInteger)hash
{

    return self.recordModel.page*31+self.recordModel.chapter;
}

@end
