//
//  ViewController.m
//  Apart
//
//  Created by Paripoorna Software on 06/04/15.
//  Copyright (c) 2015 PSSS. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"
#import "YALNavigationBar.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

static NSString *const menuCellIdentifier = @"rotationCell";

@interface ViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
YALContextMenuTableViewDelegate
>

@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;


@end

@implementation ViewController
@synthesize _locationManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:mapView];

    mapView.showsUserLocation = YES;
    mapView.delegate=self;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    // {{10, 164}, {300, 240}}
 
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.1) {
        //  above 7.1
        
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }
    else
    {
        //  below 7.1
        [_locationManager startUpdatingLocation];
        
        
    }


    [self initiateMenuOptions];

    
    // set custom navigationBar with a bigger height
    [self.navigationController setValue:[[YALNavigationBar alloc]init] forKeyPath:@"navigationBar"];

    // Do any additional setup after loading the view, typically from a nib.
    
    //SplashScreenVideo.mp4
//    MPMoviePlayerController *moviePlayer;
//    
//    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"SplashScreenVideo.mp4" ofType:@"mp4"];
//
//   // NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"SplashScreenVideo.mp4" ofType:nil];
//   // NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"big-buck-bunny-clip" ofType:@"m4v"];
//
//    NSLog(@"te path is  %@",filepath);
//    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
//    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
//    [self.view addSubview:moviePlayer.view];
//    moviePlayer.fullscreen = YES;
//    [moviePlayer play];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}

#pragma mark - IBAction

- (IBAction)presentMenuButtonTapped:(UIBarButtonItem *)sender {
    // init YALContextMenuTableView tableView
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.15;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    
    // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
}

#pragma mark - Local methods

- (void)initiateMenuOptions {
    self.menuTitles = @[@"",
                        @"Bed Rooms",
                        @"Hall",
                        @"Zim",
                        @"play ground",
                        @"Hall",
                        @"Zim",
                        @"play ground",
                        @"hosptal"];
    
    self.menuIcons = @[[UIImage imageNamed:@"Checkbox"],
                       [UIImage imageNamed:@"Checkbox"],
                       [UIImage imageNamed:@"Checkbox"],
                       [UIImage imageNamed:@"Checkbox"],
                       [UIImage imageNamed:@"Checkbox"],
                       [UIImage imageNamed:@"Checkbox"],
                       [UIImage imageNamed:@"Checkbox"],
                       [UIImage imageNamed:@"Checkbox"],
                       [UIImage imageNamed:@"Checkbox"]];
}


#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Menu dismissed with indexpath = %@", indexPath);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView dismisWithIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
        cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
    }
    
    return cell;
}


@end
