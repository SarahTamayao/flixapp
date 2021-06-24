//
//  MoviesViewController.m
//  flixapp
//
//  Created by Laura Yao on 6/23/21.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h";

@interface MoviesViewController () <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filtermovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
      
    [self.activityIndicator startAnimating];
    [self fetchMovies];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview: self.refreshControl atIndex:0];
}
- (void) fetchMovies{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Show Movies"
                                                                                          message:@"The internet connection appears to be off."
                                                                                   preferredStyle:(UIAlertControllerStyleAlert)];
               UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                   [self.activityIndicator startAnimating];
                   [self fetchMovies];
                                                                 }];
               
               [alert addAction:tryAgainAction];
               [self presentViewController:alert animated:YES completion:^{
                   // optional code for what happens after the alert controller has finished presenting
               }];
               
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSLog(@"%@", dataDictionary);
               self.movies = dataDictionary[@"results"];
               self.filtermovies = self.movies;
               for (NSDictionary *movie in self.movies){
                   NSLog(@"%@",movie[@"title"]);
               }
               
               
               [self.tableView reloadData];

               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
       }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filtermovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell =(MovieCell *) [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filtermovies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURL = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURL];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

- (void) searchBar:(UISearchBar *) searchBar textDidChange:(nonnull NSString *)searchText{
    if (searchText.length != 0){
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filtermovies = [self.movies filteredArrayUsingPredicate:predicate];
    }
    else{
        self.filtermovies = self.movies;
    }
    [self.tableView reloadData];
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filtermovies[indexPath.row];
    DetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
    //NSLog(@"Tapping on a movie!");
}


@end
