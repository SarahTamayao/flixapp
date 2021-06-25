//
//  BPostViewController.m
//  flixapp
//
//  Created by Laura Yao on 6/24/21.
//

#import "BPostViewController.h"
#import "UIImageView+AFNetworking.h"

@interface BPostViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bigPoster;

@end

@implementation BPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *baseURLSmall = @"https://image.tmdb.org/t/p/w45";
    NSString *baseURLLarge = @"https://image.tmdb.org/t/p/original";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *urlSmallS = [baseURLSmall stringByAppendingString:posterURLString];
    NSString *urlLargeS = [baseURLLarge stringByAppendingString:posterURLString];
    
    NSURL *urlSmall = [NSURL URLWithString:urlSmallS];
    NSURL *urlLarge = [NSURL URLWithString:urlLargeS];

    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    
    __weak BPostViewController *weakSelf = self;

    [self.bigPoster setImageWithURLRequest:requestSmall
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                       
                                       // smallImageResponse will be nil if the smallImage is already available
                                       // in cache (might want to do something smarter in that case).
                                       weakSelf.bigPoster.alpha = 0.0;
                                       weakSelf.bigPoster.image = smallImage;
                                       
                                       [UIView animateWithDuration:0.3
                                                        animations:^{
                                                            
                                                            weakSelf.bigPoster.alpha = 1.0;
                                                            
                                                        } completion:^(BOOL finished) {
                                                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                            // per ImageView. This code must be in the completion block.
                                                            [weakSelf.bigPoster setImageWithURLRequest:requestLarge
                                                                                  placeholderImage:smallImage
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                                weakSelf.bigPoster.image = largeImage;
                                                                                  }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               // do something for the failure condition of the large image request
                                                                                               // possibly setting the ImageView's image to a default image
                                                                                           }];
                                                        }];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       // do something for the failure condition
                                       // possibly try to get the large image
                                   }];
    // Do any additional setup after loading the view.
}
- (IBAction)cancelButton:(UIButton *)sender {
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
