//
//  AllMoviesViewController.m
//  flixapp
//
//  Created by Laura Yao on 6/25/21.
//

#import "AllMoviesViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NPCell.h"
#import "PCell.h"
#import "TRCell.h"
#import "UCell.h"
#import "DetailsViewController.h"

@interface AllMoviesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *nowPlaying;
@property (weak, nonatomic) IBOutlet UICollectionView *popular;
@property (weak, nonatomic) IBOutlet UICollectionView *topRated;
@property (weak, nonatomic) IBOutlet UICollectionView *upcoming;
@property (nonatomic, strong) NSArray *NPmovies;
@property (nonatomic, strong) NSArray *Pmovies;
@property (nonatomic, strong) NSArray *TRmovies;
@property (nonatomic, strong) NSArray *Umovies;


@end

@implementation AllMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nowPlaying.dataSource = self;
    self.nowPlaying.delegate = self;
    self.popular.dataSource = self;
    self.popular.delegate = self;
    self.topRated.dataSource = self;
    self.topRated.delegate = self;
    self.upcoming.dataSource = self;
    self.upcoming.delegate = self;
    [self fetchMovies];
    [self fetchMovies1];
    [self fetchMovies2];
    [self fetchMovies3];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.popular.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    
    //CGFloat postersPerLine =1;
    CGFloat itemHeight = (self.popular.frame.size.height-2);
    CGFloat itemWidth = itemHeight*(0.70);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.popular.collectionViewLayout = layout;
    
    UICollectionViewFlowLayout *layout1 = (UICollectionViewFlowLayout *) self.nowPlaying.collectionViewLayout;
    
    layout1.minimumInteritemSpacing = 5;
    layout1.minimumLineSpacing = 5;
    layout1.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout1.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    UICollectionViewFlowLayout *layout2 = (UICollectionViewFlowLayout *) self.upcoming.collectionViewLayout;
    
    layout2.minimumInteritemSpacing = 5;
    layout2.minimumLineSpacing = 5;
    layout2.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout2.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    UICollectionViewFlowLayout *layout3 = (UICollectionViewFlowLayout *) self.topRated.collectionViewLayout;
    
    layout3.minimumInteritemSpacing = 5;
    layout3.minimumLineSpacing = 5;
    layout3.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout3.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    
    // Do any additional setup after loading the view.
}

- (void) fetchMovies{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"Error");
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSLog(@"%@", dataDictionary);
               self.NPmovies = dataDictionary[@"results"];
               
               [self.nowPlaying reloadData];

               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
       }];
    [task resume];
}

- (void) fetchMovies1{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/popular?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"Error");
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSLog(@"%@", dataDictionary);
               self.Pmovies = dataDictionary[@"results"];
               
               [self.popular reloadData];

               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
       }];
    [task resume];
}

- (void) fetchMovies2{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"Error");
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSLog(@"%@", dataDictionary);
               self.TRmovies = dataDictionary[@"results"];
               
               [self.topRated reloadData];

               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
       }];
    [task resume];
}

- (void) fetchMovies3{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/upcoming?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"Error");
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSLog(@"%@", dataDictionary);
               self.Umovies = dataDictionary[@"results"];
               
               [self.upcoming reloadData];

               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
       }];
    [task resume];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    if ([sender isKindOfClass:[NPCell class]]){
        NSIndexPath *indexPath = [self.nowPlaying indexPathForCell:tappedCell];
        NSDictionary *movie = self.NPmovies[indexPath.row];
        DetailsViewController *detailViewController = [segue destinationViewController];
        detailViewController.movie = movie;
    }
    else if ([sender isKindOfClass:[PCell class]]){
        NSIndexPath *indexPath = [self.popular indexPathForCell:tappedCell];
        NSDictionary *movie = self.Pmovies[indexPath.row];
        DetailsViewController *detailViewController = [segue destinationViewController];
        detailViewController.movie = movie;
    }
    else if ([sender isKindOfClass:[TRCell class]]){
        NSIndexPath *indexPath = [self.topRated indexPathForCell:tappedCell];
        NSDictionary *movie = self.TRmovies[indexPath.row];
        DetailsViewController *detailViewController = [segue destinationViewController];
        detailViewController.movie = movie;
    }
    else{
        NSIndexPath *indexPath = [self.upcoming indexPathForCell:tappedCell];
        NSDictionary *movie = self.Umovies[indexPath.row];
        DetailsViewController *detailViewController = [segue destinationViewController];
        detailViewController.movie = movie;
    }
    
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (collectionView == self.nowPlaying) {
        NPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NPCell" forIndexPath:indexPath];
        NSDictionary *movie = self.NPmovies[indexPath.item];
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSString *posterURLString = movie[@"poster_path"];
        NSString *fullPosterURL = [baseURLString stringByAppendingString:posterURLString];
        
        NSURL *posterURL = [NSURL URLWithString:fullPosterURL];
        cell.posterView.image = nil;
        [cell.posterView setImageWithURL:posterURL];
        return cell;
        
    }
    else if (collectionView == self.popular){
        PCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PCell" forIndexPath:indexPath];
        NSDictionary *movie = self.Pmovies[indexPath.item];
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSString *posterURLString = movie[@"poster_path"];
        NSString *fullPosterURL = [baseURLString stringByAppendingString:posterURLString];
        
        NSURL *posterURL = [NSURL URLWithString:fullPosterURL];
        cell.posterView.image = nil;
        [cell.posterView setImageWithURL:posterURL];
        return cell;
        
    }
    else if (collectionView == self.topRated){
        TRCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TRCell" forIndexPath:indexPath];
        NSDictionary *movie = self.TRmovies[indexPath.item];
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSString *posterURLString = movie[@"poster_path"];
        NSString *fullPosterURL = [baseURLString stringByAppendingString:posterURLString];
        
        NSURL *posterURL = [NSURL URLWithString:fullPosterURL];
        cell.posterView.image = nil;
        [cell.posterView setImageWithURL:posterURL];
        return cell;
        
    }
    else{
        UCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UCell" forIndexPath:indexPath];
        NSDictionary *movie = self.Umovies[indexPath.item];
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSString *posterURLString = movie[@"poster_path"];
        NSString *fullPosterURL = [baseURLString stringByAppendingString:posterURLString];
        
        NSURL *posterURL = [NSURL URLWithString:fullPosterURL];
        cell.posterView.image = nil;
        [cell.posterView setImageWithURL:posterURL];
        return cell;
        
    }
   
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.nowPlaying) {
        return self.NPmovies.count;
    }
    else if(collectionView == self.popular){
        return self.Pmovies.count;
    }
    else if (collectionView == self.topRated){
        return self.TRmovies.count;
    }
    else{
        return self.Umovies.count;
        
    }
}

@end
