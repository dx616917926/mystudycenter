//
//  HXCycleScrollView.h
//  HXMinedu
//
//  Created by mac on 2021/3/29.
//


#import "HXCycleScrollView.h"
#import "HXCycleScrollViewFlowLayout.h"

@interface HXCycleScrollView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) HXCycleScrollViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger fromIndex;
@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) BOOL itemSizeFlag;
@property (nonatomic, assign) NSInteger indexOffset;
@property (nonatomic, assign) BOOL configuredFlag;
@property (nonatomic, assign) NSInteger tempIndex;

@end

@implementation HXCycleScrollView

#pragma mark -- Init
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame shouldInfiniteLoop:YES];
}

- (instancetype)initWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop {
    if (self = [super initWithFrame:frame]) {
        
        _infiniteLoop = infiniteLoop;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        _infiniteLoop = YES;
        [self initialization];
    }
    return self;
}

- (void)initialization {
    _autoScroll = YES;
    _itemZoomScale = 1.f;
    _allowsDragging = YES;
    _autoScrollInterval = 3.f;
    _pageIndicatorTintColor = [UIColor grayColor];
    _currentPageIndicatorTintColor = [UIColor whiteColor];
    
    _flowLayout = [[HXCycleScrollViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 0.f;
    _flowLayout.minimumInteritemSpacing = 0.f;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } 
    _collectionView.backgroundColor = nil;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.enabled = NO;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    [self addSubview:_pageControl];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configuration];
        if (self.loadCompletion) self.loadCompletion();
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_itemSizeFlag) {
        _flowLayout.itemSize = _itemSize;
        _flowLayout.headerReferenceSize = CGSizeMake((self.bounds.size.width - _itemSize.width) / 2, (self.bounds.size.height - _itemSize.height) / 2);
        _flowLayout.footerReferenceSize = CGSizeMake((self.bounds.size.width - _itemSize.width) / 2, (self.bounds.size.height - _itemSize.height) / 2);
    } else {
        _flowLayout.itemSize = self.bounds.size;
        _flowLayout.headerReferenceSize = CGSizeZero;
        _flowLayout.footerReferenceSize = CGSizeZero;
    }
    _collectionView.frame = self.bounds;
    _pageControl.frame = CGRectMake(0.f, self.bounds.size.height - 15.f, self.bounds.size.width, 15.f);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) [self removeTimer];
}

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

#pragma mark -- Public Methods
- (void)registerCellClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [_collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerCellNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier {
    [_collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (__kindof HXCycleScrollViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    index = [self changeIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return [_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)reloadData {
    [self removeTimer];
    [UIView performWithoutAnimation:^{
        [_collectionView reloadData];
    }];
    [_collectionView performBatchUpdates:nil completion:^(BOOL finished) {
        [self configuration];
        if (_loadCompletion) _loadCompletion();
    }];
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    NSInteger numberOfAddedCells = [self numberOfAddedCells];
    if (index < 0 || index > _numberOfItems - numberOfAddedCells - 1) {
        NSLog(@"⚠️attempt to scroll to invalid index:%zd", index);
        return;
    }
    [self removeTimer];
    index += numberOfAddedCells / 2;
    UICollectionViewScrollPosition position = [self scrollPosition];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:animated];
    [self addTimer];
}

- (__kindof HXCycleScrollViewCell *)cellForItemAtIndex:(NSInteger)index {
    NSInteger numberOfAddedCells = [self numberOfAddedCells];
    if (index < 0 || index > _numberOfItems - numberOfAddedCells - 1) {
        return nil;
    }
    index += numberOfAddedCells / 2;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    HXCycleScrollViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
    
    return cell;
}

- (void)beginUpdates {
    _tempIndex = [self pageIndex];
    [self removeTimer];
}

- (void)endUpdates {
    [_flowLayout invalidateLayout];
    [self scrollToItemAtIndex:_tempIndex animated:NO];
    [self addTimer];
}

#pragma mark -- Private Methods
- (UICollectionViewScrollPosition)scrollPosition {
    switch (_scrollDirection) {
        case HXScrollDirectionVertical:
            return UICollectionViewScrollPositionCenteredVertically;
        default:
            return UICollectionViewScrollPositionCenteredHorizontally;
    }
}

- (NSInteger)changeIndex:(NSInteger)index {
    if (_infiniteLoop && _numberOfItems > 1) {
        if (index == 0) {
            index = _numberOfItems - 6;
        } else if (index == 1) {
            index = _numberOfItems - 5;
        } else if (index == _numberOfItems - 2) {
            index = 0;
        } else if (index == _numberOfItems - 1) {
            index = 1;
        } else {
            index -= 2;
        }
    }
    return index;
}

- (void)configuration {
    _fromIndex = 0;
    _indexOffset = 0;
    _configuredFlag = NO;
    
    if (_numberOfItems < 2) return;
    
    if (_infiniteLoop) {
        UICollectionViewScrollPosition position = [self scrollPosition];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
    }
    
    [self addTimer];
    [self updatePageControl];
    
    _configuredFlag = YES;
}

- (void)addTimer {
    [self removeTimer];
    
    if (_numberOfItems < 2 || !_autoScroll || _autoScrollInterval <= 0.f) return;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)automaticScroll {
    NSInteger index = [self currentIndex] + 1;
    if (!_infiniteLoop && index >= _numberOfItems) index = 0;
    UICollectionViewScrollPosition position = [self scrollPosition];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:YES];
}

- (void)removeTimer {
    if (!_timer) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)updatePageControl {
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = MAX(0, _numberOfItems - [self numberOfAddedCells]);
    _pageControl.hidden = (_hidesPageControl || _pageControl.numberOfPages < 2);
}

#pragma mark -- UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_dataSource respondsToSelector:@selector(numberOfItemsInCycleScrollView:)]) {
        _numberOfItems = [_dataSource numberOfItemsInCycleScrollView:self];
        if (_infiniteLoop && _numberOfItems > 1) {
            _numberOfItems += [self numberOfAddedCells];
        }
    }
    return _numberOfItems;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [self changeIndex:indexPath.item];
    return [_dataSource cycleScrollView:self cellForItemAtIndex:index];
}

#pragma mark -- UICollectionView Delegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self removeTimer];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self addTimer];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        NSInteger index = [self changeIndex:indexPath.item];
        [_delegate cycleScrollView:self didSelectItemAtIndex:index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = [self pageIndex];
    if (_configuredFlag && [_delegate respondsToSelector:@selector(cycleScrollViewDidScroll:progress:)]) {
        CGFloat total = 0.f, offset = 0.f;
        NSInteger numberOfAddedCells = [self numberOfAddedCells];
        switch (_scrollDirection) {
            case HXScrollDirectionVertical:
                total = (_numberOfItems - 1 - numberOfAddedCells) * (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing);
                offset = fmod([self contentOffset].y, (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing) * (_numberOfItems - numberOfAddedCells));
                break;
            default:
                total = (_numberOfItems - 1 - numberOfAddedCells) * (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing);
                offset = fmod([self contentOffset].x, (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing) * (_numberOfItems - numberOfAddedCells));
                break;
        }
        CGFloat percent = offset / total;
        CGFloat progress = percent * (_numberOfItems - 1 - numberOfAddedCells);
        [_delegate cycleScrollViewDidScroll:self progress:progress];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger index = [self currentIndex];
    if (_infiniteLoop) {
        UICollectionViewScrollPosition position = [self scrollPosition];
        if (index == 1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_numberOfItems - 3 inSection:0];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
        } else if (index == _numberOfItems - 2) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:NO];
        }
    }
    NSInteger toIndex = [self changeIndex:index];
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didScrollFromIndex:toIndex:)]) {
        [_delegate cycleScrollView:self didScrollFromIndex:_fromIndex toIndex:toIndex];
    }
    _fromIndex = toIndex;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self pageIndex] != _fromIndex) return;
    
    CGFloat sum = velocity.x + velocity.y;
    if (sum > 0) {
        _indexOffset = 1;
    } else if (sum < 0) {
        _indexOffset = -1;
    } else {
        _indexOffset = 0;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSInteger index = [self currentIndex] + _indexOffset;
    index = MAX(0, index);
    index = MIN(_numberOfItems - 1, index);
    UICollectionViewScrollPosition position = [self scrollPosition];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:position animated:YES];
    _indexOffset = 0;
}

#pragma mark -- Getter & Setter
- (NSInteger)currentIndex {
    if (_numberOfItems <= 0) {
        return -1;
    }
    
    NSInteger index = 0;
    NSInteger minimumIndex = 0;
    NSInteger maximumIndex = _numberOfItems - 1;
    
    if (_numberOfItems == 1) {
        return index;
    }
    
    if (_infiniteLoop) {
        minimumIndex = 1;
        maximumIndex = _numberOfItems - 2;
    }
    
    switch (_scrollDirection) {
        case HXScrollDirectionVertical:
            index = (_collectionView.contentOffset.y + (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing) / 2) / (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing);
            break;
        default:
            index = (_collectionView.contentOffset.x + (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing) / 2) / (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing);
            break;
    }
    return MIN(maximumIndex, MAX(minimumIndex, index));
}

- (NSInteger)pageIndex {
    return [self changeIndex:[self currentIndex]];
}

- (CGPoint)contentOffset {
    NSInteger numberOfAddedCells = [self numberOfAddedCells];
    switch (_scrollDirection) {
        case HXScrollDirectionVertical:
            return CGPointMake(0.f, MAX(0.f, _collectionView.contentOffset.y - (_flowLayout.itemSize.height + _flowLayout.minimumLineSpacing) * numberOfAddedCells / 2));
        default:
            return CGPointMake(MAX(0.f, (_collectionView.contentOffset.x - (_flowLayout.itemSize.width + _flowLayout.minimumLineSpacing) * numberOfAddedCells / 2)), 0.f);
    }
}

- (NSInteger)numberOfAddedCells {
    return _infiniteLoop ? 4 : 0;
}

- (void)setScrollDirection:(HXScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    
    switch (scrollDirection) {
        case HXScrollDirectionVertical:
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            break;
        default:
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            break;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    [self addTimer];
}

- (void)setAllowsDragging:(BOOL)allowsDragging {
    _allowsDragging = allowsDragging;
    _collectionView.scrollEnabled = allowsDragging;
}

- (void)setAutoScrollInterval:(NSTimeInterval)autoScrollInterval {
    _autoScrollInterval = autoScrollInterval;
    [self addTimer];
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSizeFlag = YES;
    _itemSize = itemSize;
    _flowLayout.itemSize = itemSize;
//    _flowLayout.headerReferenceSize = CGSizeMake((self.bounds.size.width - itemSize.width) / 2, (self.bounds.size.height - itemSize.height) / 2);
//    _flowLayout.footerReferenceSize = CGSizeMake((self.bounds.size.width - itemSize.width) / 2, (self.bounds.size.height - itemSize.height) / 2);
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    _itemSpacing = itemSpacing;
    _flowLayout.minimumLineSpacing = itemSpacing;
   
}

- (void)setItemZoomScale:(CGFloat)itemZoomScale {
    _itemZoomScale = itemZoomScale;
    _flowLayout.zoomScale = itemZoomScale;
}

- (void)setHidesPageControl:(BOOL)hidesPageControl {
    _hidesPageControl = hidesPageControl;
    _pageControl.hidden = hidesPageControl;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

@end
