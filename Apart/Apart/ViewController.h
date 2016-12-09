//
//  ViewController.h
//  Apart
//
//  Created by Paripoorna Software on 06/04/15.
//  Copyright (c) 2015 PSSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

{
    
    CLLocationManager *_locationManager;

}

@property (strong, nonatomic) CLLocationManager *_locationManager;
@end

