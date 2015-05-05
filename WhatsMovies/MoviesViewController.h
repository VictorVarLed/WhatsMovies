//
//  MoviesViewController.h
//  WhatsMovies
//
//  Created by Víctor Varillas Ledesma on 23/04/15.
//  Copyright (c) 2015 Víctor Varillas Ledesma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoviesCell.h"

@interface MoviesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *moviesCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *seriesCollection;

- (IBAction)segmentChanged:(id)sender;

@end
