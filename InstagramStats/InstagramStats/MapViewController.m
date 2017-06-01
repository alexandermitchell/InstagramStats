//
//  MapViewController.m
//  InstagramStats
//
//  Created by Marc Maguire on 2017-05-30.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "MapViewController.h"
@import MapKit;
#import "DataManager.h"
#import "Photo+CoreDataProperties.h"
#import "User+CoreDataProperties.h"
#import "MyCustomPointAnnotation.h"
#import "CustomMKAnnotationView.h"

@interface MapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) DataManager *manager;
@property (nonatomic) NSMutableArray <MyCustomPointAnnotation *> *annotations;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [DataManager sharedManager];
    self.mapView.delegate = self;
    self.annotations = [[NSMutableArray alloc]init];
    
    for (Photo *photo in self.manager.currentUser.photos) {
        MyCustomPointAnnotation *point = [[MyCustomPointAnnotation alloc]init];
        point.coordinate = CLLocationCoordinate2DMake(photo.latitude, photo.longitude);
        point.myImage = [UIImage imageWithData:photo.image];
        [self.mapView addAnnotation:point];
        [self.annotations addObject:point];
    }
    
    //zooms in on specific photo that is hardcoded below (since not every annotation has a valid coordinate at this point)
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.466666666667, -0.375);
//    MKCoordinateSpan span = MKCoordinateSpanMake(12.5, 12.5);
//    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    self.mapView.showsUserLocation = NO;
    //[self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation
{
    CustomMKAnnotationView *pin = (CustomMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    
    if (pin == nil) {
        pin = [[CustomMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        
    }
    
    MyCustomPointAnnotation *pointAnnotation = (MyCustomPointAnnotation *)annotation;
    pin.annotation = pointAnnotation;
 
    //reduce image size to prevent MKAnnotationView's view from resizing to accomodate the full sized image
    UIImage *pinImage = pointAnnotation.myImage;
    CGSize size = CGSizeMake(50, 50);
    UIGraphicsBeginImageContext(size);
    [pinImage drawInRect:(CGRectMake(0, 0, size.width, size.height))];
    UIImage *resizedPin = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    pin.image = resizedPin;
    
    [pin setCanShowCallout:YES];
    [self.mapView addSubview:pin];
    
    
    return pin;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
