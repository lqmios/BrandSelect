//
//  BrandCollectionViewCell.h
//  BrandSelect
//
//  Created by lqm on 16/9/8.
//  Copyright © 2016年 LQM. All rights reserved.
//

#import "PLCollectionViewWaterfallLayout.h"
#import "tgmath.h"

NSString *const PLCollectionElementKindSectionHeader = @"PLCollectionElementKindSectionHeader";
NSString *const PLCollectionElementKindSectionFooter = @"PLCollectionElementKindSectionFooter";

@interface PLCollectionViewWaterfallLayout ()
/// The delegate will point to collection view's delegate automatically.
@property (nonatomic, weak) id <PLCollectionViewDelegateWaterfallLayout> delegate;
/// Array to store height for each row
@property (nonatomic, strong) NSMutableArray *rowWidths;
/// Array of arrays. Each array stores item attributes for each section
@property (nonatomic, strong) NSMutableArray *sectionItemAttributes;
/// Array to store attributes for all items includes headers, cells, and footers
@property (nonatomic, strong) NSMutableArray *allItemAttributes;
/// Dictionary to store section headers' attribute
@property (nonatomic, strong) NSMutableDictionary *headersAttribute;
/// Dictionary to store section footers' attribute
@property (nonatomic, strong) NSMutableDictionary *footersAttribute;
/// Array to store union rectangles
@property (nonatomic, strong) NSMutableArray *unionRects;
@end

@implementation PLCollectionViewWaterfallLayout

/// How many items to be union into a single rectangle
static const NSInteger unionSize = 20;

static CGFloat PLFloorCGFloat(CGFloat value) {
    CGFloat scale = [UIScreen mainScreen].scale;
    return floor(value * scale) / scale;
}

#pragma mark - Public Accessors
- (void)setRowCount:(NSInteger)rowCount{
    if (_rowCount != rowCount) {
        _rowCount = rowCount;
        [self invalidateLayout];
    }
}

- (void)setMinimumRowSpacing:(CGFloat)minimumRowSpacing{
    if (_minimumRowSpacing != minimumRowSpacing) {
        _minimumRowSpacing = minimumRowSpacing;
        [self invalidateLayout];
    }
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing {
    if (_minimumInteritemSpacing != minimumInteritemSpacing) {
        _minimumInteritemSpacing = minimumInteritemSpacing;
        [self invalidateLayout];
    }
}

- (void)setHeaderHeight:(CGFloat)headerHeight {
    if (_headerHeight != headerHeight) {
        _headerHeight = headerHeight;
        [self invalidateLayout];
    }
}

- (void)setFooterHeight:(CGFloat)footerHeight {
    if (_footerHeight != footerHeight) {
        _footerHeight = footerHeight;
        [self invalidateLayout];
    }
}

- (void)setHeaderInset:(UIEdgeInsets)headerInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_headerInset, headerInset)) {
        _headerInset = headerInset;
        [self invalidateLayout];
    }
}

- (void)setFooterInset:(UIEdgeInsets)footerInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_footerInset, footerInset)) {
        _footerInset = footerInset;
        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

- (void)setItemRenderDirection:(PLCollectionViewWaterfallLayoutItemRenderDirection)itemRenderDirection {
    if (_itemRenderDirection != itemRenderDirection) {
        _itemRenderDirection = itemRenderDirection;
        [self invalidateLayout];
    }
}

- (NSInteger)rowCountForSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:rowCountForSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self rowCountForSection:section];
    } else {
        return self.rowCount;
    }
}

- (CGFloat)itemWidthInSectionAtIndex:(NSInteger)section {
    UIEdgeInsets sectionInset;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    } else {
        sectionInset = self.sectionInset;
    }
    CGFloat width = self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
    NSInteger rowCount = [self rowCountForSection:section];
    
    CGFloat rowSpacing = self.minimumRowSpacing;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumrowSpacingForSectionAtIndex:)]) {
        rowSpacing = [self.delegate collectionView:self.collectionView layout:self minimumrowSpacingForSectionAtIndex:section];
    }
    
    return PLFloorCGFloat((width - (rowCount - 1) * rowSpacing) / rowCount);
}

#pragma mark - Private Accessors
- (NSMutableDictionary *)headersAttribute {
    if (!_headersAttribute) {
        _headersAttribute = [NSMutableDictionary dictionary];
    }
    return _headersAttribute;
}

- (NSMutableDictionary *)footersAttribute {
    if (!_footersAttribute) {
        _footersAttribute = [NSMutableDictionary dictionary];
    }
    return _footersAttribute;
}

- (NSMutableArray *)unionRects {
    if (!_unionRects) {
        _unionRects = [NSMutableArray array];
    }
    return _unionRects;
}

- (NSMutableArray *)rowWidths {
    if (!_rowWidths) {
        _rowWidths = [NSMutableArray array];
    }
    return _rowWidths;
}

- (NSMutableArray *)allItemAttributes {
    if (!_allItemAttributes) {
        _allItemAttributes = [NSMutableArray array];
    }
    return _allItemAttributes;
}

- (NSMutableArray *)sectionItemAttributes {
    if (!_sectionItemAttributes) {
        _sectionItemAttributes = [NSMutableArray array];
    }
    return _sectionItemAttributes;
}

- (id <PLCollectionViewDelegateWaterfallLayout> )delegate {
    return (id <PLCollectionViewDelegateWaterfallLayout> )self.collectionView.delegate;
}

#pragma mark - Init
- (void)commonInit {
    _rowCount = 2;
    _minimumRowSpacing = 10;
    _minimumInteritemSpacing = 10;
    _headerHeight = 0;
    _footerHeight = 0;
    _sectionInset = UIEdgeInsetsZero;
    _headerInset  = UIEdgeInsetsZero;
    _footerInset  = UIEdgeInsetsZero;
    _itemRenderDirection = PLCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst;
}

- (id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Methods to Override
- (void)prepareLayout {
    [super prepareLayout];
    
    [self.headersAttribute removeAllObjects];
    [self.footersAttribute removeAllObjects];
    [self.unionRects removeAllObjects];
    [self.rowWidths removeAllObjects];
    [self.allItemAttributes removeAllObjects];
    [self.sectionItemAttributes removeAllObjects];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return;
    }
    
    NSAssert([self.delegate conformsToProtocol:@protocol(PLCollectionViewDelegateWaterfallLayout)], @"UICollectionView's delegate should conform to PLCollectionViewDelegateWaterfallLayout protocol");
    NSAssert(self.rowCount > 0 || [self.delegate respondsToSelector:@selector(collectionView:layout:rowCountForSection:)], @"UICollectionViewWaterfallLayout's rowCount should be greater than 0, or delegate must implement rowCountForSection:");
    
    // Initialize variables
    NSInteger idx = 0;
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger rowCount = [self rowCountForSection:section];
        NSMutableArray *sectionrowWidths = [NSMutableArray arrayWithCapacity:rowCount];
        for (idx = 0; idx < rowCount; idx++) {
            [sectionrowWidths addObject:@(0)];
        }
        [self.rowWidths addObject:sectionrowWidths];
    }
    // Create attributes
    CGFloat left = 0;
    UICollectionViewLayoutAttributes *attributes;
    
    for (NSInteger section = 0; section < numberOfSections; ++section) {
        /*
         * 1. 获取设定的值 (minimumInteritemSpacing, sectionInset)
         */
        CGFloat minimumInteritemSpacing;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            minimumInteritemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
        } else {
            minimumInteritemSpacing = self.minimumInteritemSpacing;
        }
        
        CGFloat rowSpacing = self.minimumRowSpacing;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumrowSpacingForSectionAtIndex:)]) {
            rowSpacing = [self.delegate collectionView:self.collectionView layout:self minimumrowSpacingForSectionAtIndex:section];
        }
        
        UIEdgeInsets sectionInset;
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        } else {
            sectionInset = self.sectionInset;
        }
        //==============================================================
        
        CGFloat height = self.collectionView.bounds.size.height - sectionInset.top - sectionInset.bottom;
        NSInteger rowCount = [self rowCountForSection:section];
        CGFloat itemHeight = (height - (rowCount - 1) * rowSpacing) / rowCount;
        
        left += sectionInset.left;
        for (idx = 0; idx < rowCount; idx++) {
            self.rowWidths[section][idx] = @(left);
        }
        
        /*
         * 3. item布局
         */
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
        
        // Item will be put into shortest row.
        for (idx = 0; idx < itemCount; idx++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            NSUInteger rowIndex = [self nextRowIndexForItem:idx inSection:section];
            
            CGFloat xOffset = [self.rowWidths[section][rowIndex] floatValue];
            CGFloat yOffset = sectionInset.top +  (itemHeight + rowSpacing) * rowIndex;
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            
            CGFloat itemWidth = 0;
            if (itemSize.height > 0 && itemSize.width > 0) {
                itemWidth = PLFloorCGFloat(itemSize.width * itemHeight / itemSize.height);
            }
            
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
            [itemAttributes addObject:attributes];
            [self.allItemAttributes addObject:attributes];
            self.rowWidths[section][rowIndex] = @(CGRectGetMaxX(attributes.frame) + minimumInteritemSpacing);
            
            if (section == numberOfSections-1 && idx == itemCount-1) {
                left += CGRectGetMaxX(attributes.frame);
            }
        }
        
        [self.sectionItemAttributes addObject:itemAttributes];
    }
    
    // Build union rects
    idx = 0;
    NSInteger itemCounts = [self.allItemAttributes count];
    while (idx < itemCounts) {
        CGRect unionRect = ((UICollectionViewLayoutAttributes *)self.allItemAttributes[idx]).frame;
        NSInteger rectEndIndex = MIN(idx + unionSize, itemCounts);
        
        for (NSInteger i = idx + 1; i < rectEndIndex; i++) {
            unionRect = CGRectUnion(unionRect, ((UICollectionViewLayoutAttributes *)self.allItemAttributes[i]).frame);
        }
        
        idx = rectEndIndex;
        
        [self.unionRects addObject:[NSValue valueWithCGRect:unionRect]];
    }
}

//显示区域大小
- (CGSize)collectionViewContentSize {
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return CGSizeZero;
    }
    
    CGSize contentSize = self.collectionView.bounds.size;
    NSArray *array = [[self.rowWidths lastObject] sortedArrayUsingSelector:@selector(compare:)];
    contentSize.width = [[array lastObject] floatValue] - self.sectionInset.right;
    if (contentSize.width < self.minimumContentHeight) {
        contentSize.width = self.minimumContentHeight;
    }
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    if (path.section >= [self.sectionItemAttributes count]) {
        return nil;
    }
    if (path.item >= [self.sectionItemAttributes[path.section] count]) {
        return nil;
    }
    return (self.sectionItemAttributes[path.section])[path.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger i;
    NSInteger begin = 0, end = self.unionRects.count;
    NSMutableArray *attrs = [NSMutableArray array];
    
    for (i = 0; i < self.unionRects.count; i++) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            begin = i * unionSize;
            break;
        }
    }
    for (i = self.unionRects.count - 1; i >= 0; i--) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            end = MIN((i + 1) * unionSize, self.allItemAttributes.count);
            break;
        }
    }
    for (i = begin; i < end; i++) {
        UICollectionViewLayoutAttributes *attr = self.allItemAttributes[i];
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    
    return [NSArray arrayWithArray:attrs];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

#pragma mark - Private Methods

/**
 *  Find the shortest row.
 *
 *  @return index for the shortest row
 */
- (NSUInteger)shortestrowIndexInSection:(NSInteger)section {
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;
    
    [self.rowWidths[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat width = [obj floatValue];
        if (width < shortestHeight) {
            shortestHeight = width;
            index = idx;
        }
    }];
    
    return index;
}

/**
 *  Find the longest row.
 *
 *  @return index for the longest row
 */
- (NSUInteger)longestrowIndexInSection:(NSInteger)section {
    __block NSUInteger index = 0;
    __block CGFloat longestHeight = 0;
    
    [self.rowWidths[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}

/**
 *  Find the index for the next row.
 *
 *  @return index for the next row
 */
- (NSUInteger)nextRowIndexForItem:(NSInteger)item inSection:(NSInteger)section {
    NSUInteger index = 0;
    NSInteger rowCount = [self rowCountForSection:section];
    switch (self.itemRenderDirection) {
        case PLCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst:
            index = [self shortestrowIndexInSection:section];
            break;
            
        case PLCollectionViewWaterfallLayoutItemRenderDirectionLeftToRight:
            index = (item % rowCount);
            break;
            
        case PLCollectionViewWaterfallLayoutItemRenderDirectionRightToLeft:
            index = (rowCount - 1) - (item % rowCount);
            break;
            
        default:
            index = [self shortestrowIndexInSection:section];
            break;
    }
    return index;
}

@end
