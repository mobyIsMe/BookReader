//
//  GMGridViewLayoutStrategy.m
//  GMGridView
//
//  Created by Gulam Moledina on 11-10-28.
//  Copyright (c) 2011 GMoledina.ca. All rights reserved.
//
//  Latest code can be found on GitHub: https://github.com/gmoledina/GMGridView
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "GMGridViewLayoutStrategies.h"

//////////////////////////////////////////////////////////////
#pragma mark - 
#pragma mark - Factory implementation
//////////////////////////////////////////////////////////////

@implementation GMGridViewLayoutStrategyFactory

+ (id<GMGridViewLayoutStrategy>)strategyFromType:(GMGridViewLayoutStrategyType)type
{
    id<GMGridViewLayoutStrategy> strategy = nil;
    
    switch (type) {
        case GMGridViewLayoutVertical:
            strategy = [[GMGridViewLayoutVerticalStrategy alloc] init];
            break;
        }
    
    return strategy;
}

@end



//////////////////////////////////////////////////////////////
#pragma mark - 
#pragma mark - Strategy base class implementation
//////////////////////////////////////////////////////////////

@implementation GMGridViewLayoutStrategyBase

@synthesize type          = _type;

@synthesize itemSize      = _itemSize;
@synthesize itemSpacing   = _itemSpacing;
@synthesize itemHSpacing  = _itemHSpacing;
@synthesize minEdgeInsets = _minEdgeInsets;
@synthesize centeredGrid  = _centeredGrid;

@synthesize itemCount     = _itemCount;
@synthesize edgeInsets    = _edgeInsets;
@synthesize gridBounds    = _gridBounds;
@synthesize contentSize   = _contentSize;


- (void)setupItemSize:(CGSize)itemSize andItemSpacing:(NSInteger)spacing andItemHSpacing:(NSInteger)hSpacing withMinEdgeInsets:(UIEdgeInsets)edgeInsets andCenteredGrid:(BOOL)centered
{
    _itemSize      = itemSize;
    _itemSpacing   = spacing;
    _itemHSpacing  = hSpacing;
    _minEdgeInsets = edgeInsets;
    _centeredGrid  = centered;
}

- (void)setEdgeAndContentSizeFromAbsoluteContentSize:(CGSize)actualContentSize
{
    if (self.centeredGrid)
    {
        NSInteger widthSpace, heightSpace;        
        NSInteger top, left, bottom, right;
        
        widthSpace  = floor((self.gridBounds.size.width  - actualContentSize.width)  / 2.0);
        heightSpace = floor((self.gridBounds.size.height - actualContentSize.height) / 2.0);
        
        NSLog(@"widthSpace : %d,heightSpace : %d",widthSpace,heightSpace);
        
        left   = MAX(widthSpace,  self.minEdgeInsets.left);
        right  = MAX(widthSpace,  self.minEdgeInsets.right);
        top    = MAX(heightSpace, self.minEdgeInsets.top);
        bottom = MAX(heightSpace, self.minEdgeInsets.bottom);
        
        _edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    }
    else
    {
        _edgeInsets = self.minEdgeInsets;
    }
    
    _contentSize = CGSizeMake(actualContentSize.width  + self.edgeInsets.left + self.edgeInsets.right, 
                              actualContentSize.height + self.edgeInsets.top  + self.edgeInsets.bottom);
}

@end



//////////////////////////////////////////////////////////////
#pragma mark - 
#pragma mark - Vertical strategy implementation
//////////////////////////////////////////////////////////////

@implementation GMGridViewLayoutVerticalStrategy

@synthesize numberOfItemsPerRow = _numberOfItemsPerRow;

+ (BOOL)requiresEnablingPaging
{
    return NO;
}

- (id)init
{
    if ((self = [super init])) 
    {
        _type = GMGridViewLayoutVertical;
    }
    
    return self;
}

- (void)rebaseWithItemCount:(NSInteger)count insideOfBounds:(CGRect)bounds
{
    _itemCount  = count;
    _gridBounds = bounds;
    
    CGRect actualBounds = CGRectMake(0, 
                                     0, 
                                     bounds.size.width  - self.minEdgeInsets.right - self.minEdgeInsets.left, 
                                     bounds.size.height - self.minEdgeInsets.top   - self.minEdgeInsets.bottom);
    
    _numberOfItemsPerRow = 1;
    
    while ((self.numberOfItemsPerRow + 1) * (self.itemSize.width + self.itemSpacing) - self.itemSpacing <= actualBounds.size.width)
    {
        _numberOfItemsPerRow++;
    }
    
    NSInteger numberOfRows = ceil(self.itemCount / (1.0 * self.numberOfItemsPerRow));
    
    
    //update by adam//////////////////////////////
    numberOfRows = numberOfRows < 3 ? 3 : numberOfRows;
    
    NSInteger icount =  self.itemCount;
    icount = icount < 3 ? 3 : icount;
    ////////////////////////////////////////////////
    
    CGSize actualContentSize = CGSizeMake(ceil(MIN(icount, self.numberOfItemsPerRow) * (self.itemSize.width + self.itemSpacing)) - self.itemSpacing, 
                               ceil(numberOfRows * (self.itemSize.height + self.itemHSpacing)) - self.itemSpacing);
    
    [self setEdgeAndContentSizeFromAbsoluteContentSize:actualContentSize];
}

//计算每一个item的坐标
- (CGPoint)originForItemAtPosition:(NSInteger)position
{
    CGPoint origin = CGPointZero;

    if (self.numberOfItemsPerRow > 0 && position >= 0) 
    {
        
        NSUInteger col = position % self.numberOfItemsPerRow; 
        NSUInteger row = position / self.numberOfItemsPerRow;
        
        origin = CGPointMake(col * (self.itemSize.width + self.itemSpacing) + self.edgeInsets.left,
                             row * (self.itemSize.height + self.itemHSpacing) + self.edgeInsets.top);
    }
    
    return origin;
}

- (NSInteger)itemPositionFromLocation:(CGPoint)location
{
    CGPoint relativeLocation = CGPointMake(location.x - self.edgeInsets.left,
                                           location.y - self.edgeInsets.top);
    
    int col = (int) (relativeLocation.x / (self.itemSize.width + self.itemSpacing)); 
    int row = (int) (relativeLocation.y / (self.itemSize.height + self.itemHSpacing));
    
    int position = col + row * self.numberOfItemsPerRow;
    
    if (position >= [self itemCount] || position < 0) 
    {
        position = GMGV_INVALID_POSITION;
    }
    else
    {
        CGPoint itemOrigin = [self originForItemAtPosition:position];
        CGRect itemFrame = CGRectMake(itemOrigin.x, 
                                      itemOrigin.y, 
                                      self.itemSize.width, 
                                      self.itemSize.height);
        
        if (!CGRectContainsPoint(itemFrame, location)) 
        {
            position = GMGV_INVALID_POSITION;
        }
    }
    
    return position;
}

- (NSRange)rangeOfPositionsInBoundsFromOffset:(CGPoint)offset
{
    CGPoint contentOffset = CGPointMake(MAX(0, offset.x), 
                                        MAX(0, offset.y));
    
    CGFloat itemHeight = self.itemSize.height + self.itemHSpacing;
    
    CGFloat firstRow = MAX(0, (int)(contentOffset.y / itemHeight) - 1);

    CGFloat lastRow = ceil((contentOffset.y + self.gridBounds.size.height) / itemHeight);
    
    NSInteger firstPosition = firstRow * self.numberOfItemsPerRow;
    NSInteger lastPosition  = ((lastRow + 1) * self.numberOfItemsPerRow);
    
    return NSMakeRange(firstPosition, (lastPosition - firstPosition));
}

@end

