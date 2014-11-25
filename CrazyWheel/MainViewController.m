//
//  MainViewController.m
//  CrazyWheel
//
//  Created by Stig on 25.11.14.
//  Copyright (c) 2014 YESS. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "JDStatusBarNotification.h"

static NSString *kWheely = @"http://crazy-dev.wheely.com";

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    BOOL _loadingContent;
    NSTimer *_loadingTimer;
}

@property (strong, nonatomic) NSMutableArray *arrayMain;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMain;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonRefresh;

@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loadingContent = NO;
    _arrayMain = [[NSMutableArray alloc] init];
    
    _buttonRefresh.target = self;
    _buttonRefresh.action = @selector(loadServerInfo);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _loadingTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:self
                                   selector:@selector(loadServerInfo)
                                   userInfo:nil
                                    repeats:YES];
    [self loadServerInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_loadingTimer invalidate];
    _loadingTimer = nil;
}

- (void)loadServerInfo{
    if (_loadingContent) {
        [JDStatusBarNotification showWithStatus:@"Данные загружаются" dismissAfter:1.0];
    } else {
        _loadingContent = YES;
        [self loadProcess];
    }
}

- (void)loadProcess{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kWheely]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (!error){
            _arrayMain = [jsonArray mutableCopy];
            [_collectionViewMain reloadData];
            _loadingContent = NO;
        }
    }];
}

#pragma mark - UICollectionView Datasource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, 90);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_arrayMain count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"MainCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-50, 30)];
    labelText.text = _arrayMain[indexPath.row][@"title"];
    labelText.font = [UIFont systemFontOfSize:20];
    [cell.contentView addSubview:labelText];
    
    UILabel *labelDetailText = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, self.view.frame.size.width-50, 50)];
    labelDetailText.numberOfLines = 2;
    labelDetailText.text = _arrayMain[indexPath.row][@"text"];
    labelDetailText.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:labelDetailText];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forward"]];
    arrow.frame = CGRectMake(self.view.frame.size.width-40, 45-25/2, 25, 25);
    [cell addSubview:arrow];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    controller.dictionaryDetail = _arrayMain[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
