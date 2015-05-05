//
//  MoviesViewController.m
//  WhatsMovies
//
//  Created by Víctor Varillas Ledesma on 23/04/15.
//  Copyright (c) 2015 Víctor Varillas Ledesma. All rights reserved.
//

#import "MoviesViewController.h"

@interface MoviesViewController ()<UISearchBarDelegate>

    @property (nonatomic) BOOL searchBarActive;
    @property (nonatomic) BOOL moviesActive;

    @property (strong, nonatomic) NSMutableArray *posterImages;
    @property (strong, nonatomic) NSMutableArray *seriesImages;

    @property (strong, nonatomic) NSArray *dataSourceForSearchResult;

    @property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.moviesActive = YES;
    self.seriesCollection.hidden = YES;
    
    self.searchBar.delegate = self;
    
    self.dataSourceForSearchResult = [NSArray new];
    
    _posterImages = [@[@"ironman.jpg", @"interestellar.jpg", @"bighero.png", @"hobbit.jpg", @"torrente.jpg", @"isla.jpg"] mutableCopy];
    _seriesImages = [@[@"gameofthrones.jpg", @"breaking.jpg", @"bigbang.jpg", @"howimet.jpg"] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.searchBarActive)
        return self.dataSourceForSearchResult.count;
    
    else
    {
        if (collectionView == self.moviesCollection)
            return _posterImages.count;
        else
            return _seriesImages.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoviesCell *myCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    
    UIImage *image;
    long row = [indexPath row];
    
    if (self.searchBarActive)
        image = [UIImage imageNamed:_dataSourceForSearchResult[row]];
    
    else
    {
        if (collectionView == self.moviesCollection)
            image = [UIImage imageNamed:_posterImages[row]];
        else
            image = [UIImage imageNamed:_seriesImages[row]];
    }
    
    myCell.imageView.image = image;
    return myCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellLeg = (self.moviesCollection.frame.size.width/2) - 5;
    return CGSizeMake(cellLeg,cellLeg+50);
}


#pragma mark - Search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    if (self.moviesActive)
        self.dataSourceForSearchResult = [_posterImages filteredArrayUsingPredicate:resultPredicate];
    else
        self.dataSourceForSearchResult = [_seriesImages filteredArrayUsingPredicate:resultPredicate];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0)
    {
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
        if (self.moviesActive)
            [self.moviesCollection reloadData];
        else
            [self.seriesCollection reloadData];
        
    } else {
        self.searchBarActive = NO;
        if (self.moviesActive)
            [self.moviesCollection reloadData];
        else
            [self.seriesCollection reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearching];
    if (self.moviesActive)
        [self.moviesCollection reloadData];
    else
        [self.seriesCollection reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBarActive = NO;
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

-( void)cancelSearching
{
    self.searchBarActive = NO;
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        self.moviesActive = YES;
        self.moviesCollection.hidden = NO;
        self.seriesCollection.hidden = YES;
        
    } else {
        
        self.moviesActive = NO;
        self.moviesCollection.hidden = YES;
        self.seriesCollection.hidden = NO;
    }
}
@end
