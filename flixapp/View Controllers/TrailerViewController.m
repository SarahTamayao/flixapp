//
//  TrailerViewController.m
//  flixapp
//
//  Created by Laura Yao on 6/24/21.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *trailerView;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *baseCode = [NSString stringWithFormat:@"%@", self.movie[@"id"]];
    NSString *apiStart = @"https://api.themoviedb.org/3/movie/";
    NSString *apibaseURL = [apiStart stringByAppendingString:baseCode];
    NSString *apiendURL = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    NSString *fullapiURL = [apibaseURL stringByAppendingString:apiendURL];
    NSLog(@"%@", fullapiURL);
    NSURL *url = [NSURL URLWithString:fullapiURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSArray *videos = dataDictionary[@"results"];
               NSDictionary *video = videos[0];
               NSString *vidKey =  video[@"key"];
               
               NSString *urlString = @"https://www.youtube.com/watch?v=";
               NSString *fullurlString =[urlString stringByAppendingString:vidKey];
               NSLog(@"%@", fullurlString);
               NSURL *vidURL = [NSURL URLWithString:fullurlString];
               NSURLRequest *request = [NSURLRequest requestWithURL:vidURL
                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                    timeoutInterval:10.0];
               [self.trailerView loadRequest:request];

               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
       }];
    [task resume];
    
    
    // Do any additional setup after loading the view
    
}
- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
