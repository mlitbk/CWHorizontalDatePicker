//
//  CWDatePickerCell.m
//  CWDatePicker
//
//  Created by Michael Litvak on 5/18/14.
//  Copyright (c) 2014 codewhisper. All rights reserved.
//

#import "CWDatePickerRow.h"
#import "CWDatePickerCell.h"
#import "Masonry.h"

static CGFloat const kCellWidth = 50;
static CGFloat const kCellHeight = 40;

@interface CWDatePickerRow ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) NSIndexPath* currentIndex;

@end

@implementation CWDatePickerRow

- (id)init {
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(kCellWidth, kCellHeight);
        layout.sectionInset = UIEdgeInsetsMake(0.0f, 150.0f, 0.0f, 150.0f);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.allowsMultipleSelection = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];

        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        [_collectionView addGestureRecognizer:tapGesture];
        
        [_collectionView registerClass:[CWDatePickerCell class] forCellWithReuseIdentifier:@"DatePickerCell"];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - UIScrollView datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.data count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CWDatePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DatePickerCell" forIndexPath:indexPath];

    [cell setupWithData:[self.data objectAtIndex:indexPath.row]];
    
    if (indexPath.row != [self.data count] - 1) {
        [cell setupBorder];
    } else {
        [cell removeBorder];
    }

    return cell;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate) {
        [self scrollViewDidFinishScrolling:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidFinishScrolling:scrollView];
}

- (void)scrollViewDidFinishScrolling:(UIScrollView*)scrollView {
    CGPoint point = CGPointMake(_collectionView.center.x + _collectionView.contentOffset.x,
                                _collectionView.center.y + _collectionView.contentOffset.y);

    NSIndexPath *centerIndexPath = [_collectionView indexPathForItemAtPoint:point];
    
    if (centerIndexPath) {
        self.currentIndex = centerIndexPath;
    }
}

// return true if the table is not dragging and not decelerating
- (BOOL)isStatic {
    return (!_collectionView.decelerating && !_collectionView.dragging);
}

#pragma mark - Selection

- (void)setCurrentIndex:(NSIndexPath *)currentIndex {
    if (currentIndex.row != _currentIndex.row) {
        _currentIndex = currentIndex;

        if (self.datePicker) {
            /* the return value indicates if we should scroll to the selected index
             * for cases when the date is invalid. if the return value if NO than
             * we stop here */
            if (![self.datePicker datePickerRowDidChangeSelection:self]) {
                return;
            }
        }
    }
    
    /* if the cell for the current indexpath is nil, it means that the cell is outside
     the view and we need to scroll to it first, and only then we can select it */
    CWDatePickerCell *cell = (CWDatePickerCell *)[_collectionView cellForItemAtIndexPath:currentIndex];
    if (!cell) {
        [_collectionView scrollToItemAtIndexPath:currentIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
        // wait for the scroll to finish
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [_collectionView selectItemAtIndexPath:currentIndex animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        });
    } else {
        [_collectionView selectItemAtIndexPath:currentIndex animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

#pragma mark - Data Handling

- (void)setData:(NSArray*)data {
    _data = data;
    [_collectionView reloadData];
}

- (void)selectFirstRow {
    self.currentIndex = [NSIndexPath indexPathForItem:0 inSection:0];
}

- (void)selectLastRow {
    self.currentIndex = [NSIndexPath indexPathForItem:([self.data count] - 1) inSection:0];
}

- (void)selectRow:(NSUInteger)row {
    if (row < [self.data count]) {
        self.currentIndex = [NSIndexPath indexPathForItem:row inSection:0];
    }
}

- (void)selectRowWithValue:(NSUInteger)value {
    NSUInteger row = 0;
    for (NSString *stringValue in self.data) {
        if ([stringValue intValue] == value) {
            self.currentIndex = [NSIndexPath indexPathForItem:row inSection:0];
            break;
        }
        row++;
    }
}

- (NSString*)selectedValue {
    return [self.data objectAtIndex:self.currentIndex.row];
}

- (NSUInteger)selectedIndex {
    return self.currentIndex.row;
}

#pragma mark - Gesture

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint location = [tapGesture locationInView:tapGesture.view];
        NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:location];
        
        if (indexPath && indexPath.row != self.currentIndex.row) {
            self.currentIndex = indexPath;
        }
    }
}

@end
