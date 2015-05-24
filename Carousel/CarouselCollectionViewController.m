//
//  CarouselCollectionViewController.m
//  Carousel
//
//  Created by Rahul Katariya on 10/04/14.
//  Copyright (c) 2014 Rahul Katariya. All rights reserved.
//

#import "CarouselCollectionViewController.h"

//Layouts
#import "CarouselCollectionViewLayout.h"

//Cells
#import "CarouselImageCollectionViewCell.h"

//Model
#import "CLPhoto+CoreData.h"

//Macros
#define CAROUSEL_IMAGE_COLLECTION_VIEW_CELL @"CarouselImageCollectionViewCell"

@interface CarouselCollectionViewController () <NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

//Outlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSArray *images;

@end


@implementation CarouselCollectionViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeViewAppearance];
    [self registerCollectionViewCells];
}

#pragma mark - CollectionView Delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CarouselImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CAROUSEL_IMAGE_COLLECTION_VIEW_CELL forIndexPath:indexPath];
    cell.photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];;
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
     // In the simplest, most efficient, case, reload the table view.
     [self.collectionView reloadData];
}

#pragma mark - Properties

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSManagedObjectContext *moc = [[CLCoreDataManager defaultManager] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CLPhoto" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return _fetchedResultsController;
}

-(NSArray *)images {
    if (_images) return _images;
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    NSUInteger count = [sectionInfo numberOfObjects];
    return [self nullArrayWithCount:count];
}

#pragma mark - Helper

-(void)customizeViewAppearance {
    self.title = @"Carousel";
    [(CarouselCollectionViewLayout *)self.collectionView.collectionViewLayout setItemSize:CGSizeMake(250.0f, 200.0f)];
}

-(void)registerCollectionViewCells {
    [self.collectionView registerNib:[UINib nibWithNibName:CAROUSEL_IMAGE_COLLECTION_VIEW_CELL bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:CAROUSEL_IMAGE_COLLECTION_VIEW_CELL];
}

-(NSArray *)nullArrayWithCount:(NSUInteger)count {
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<count; i++) {
        [mArr addObject:[NSNull null]];
    }
    return mArr;
}

@end
