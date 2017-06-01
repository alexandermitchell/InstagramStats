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
#import "CustomCalloutView.h"

@interface MapViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) DataManager *manager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [DataManager sharedManager];
    self.mapView.delegate = self;
    
    //create annotations and add them to the map.
    for (Photo *photo in self.manager.currentUser.photos) {
        MyCustomPointAnnotation *point = [[MyCustomPointAnnotation alloc]init];
        point.coordinate = CLLocationCoordinate2DMake(photo.latitude, photo.longitude);
        point.myImage = [UIImage imageWithData:photo.image];
        point.likesNum = [NSString stringWithFormat:@"%hd",photo.likesNum];
        point.commentsNum = [NSString stringWithFormat:@"%hd",photo.commentsNum];
        [self.mapView addAnnotation:point];

    }
    
  //    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.466666666667, -0.375);
//    MKCoordinateSpan span = MKCoordinateSpanMake(12.5, 12.5);
//    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    //[self.mapView setRegion:region animated:YES];
    
    self.mapView.showsUserLocation = NO;


}

- (MKAnnotationView*)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation
{
    CustomMKAnnotationView *pin = (CustomMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    
    if (pin == nil) {
        pin = [[CustomMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        pin.canShowCallout = NO;
    } else {
        pin.annotation = annotation;
    }
    
    MyCustomPointAnnotation *pointAnnotation = (MyCustomPointAnnotation *)annotation;

    //reduce image size to prevent MKAnnotationView's view from resizing to accomodate the full sized image
    UIImage *pinImage = pointAnnotation.myImage;
    CGSize size = CGSizeMake(50, 50);
    UIGraphicsBeginImageContext(size);
    [pinImage drawInRect:(CGRectMake(0, 0, size.width, size.height))];
    UIImage *resizedPin = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    pin.image = resizedPin;

    [self.mapView addSubview:pin];
    
    
    return pin;

}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    //cast the annotation to your custom class so you can access its properties
    MyCustomPointAnnotation *customAnnotation = (MyCustomPointAnnotation *)view.annotation;
    //load customnib which holds the customCalloutView
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"CustomCalloutView" owner:nil options:nil];
    //there is only 1 view in the nib, grab the view item
    CustomCalloutView *calloutView = (CustomCalloutView *)views[0];
    
    //access the properties on your customAnnotation and use them to set the labels on the calloutView
    calloutView.likeLabel.text = customAnnotation.likesNum;
    calloutView.commentLabel.text = customAnnotation.commentsNum;
    
    //make rounded edges on the callout, because fancy stuff
    calloutView.layer.masksToBounds = YES;
    calloutView.layer.cornerRadius = 2.0;
    
    //center the callout to be over the annotationView
    calloutView.center = CGPointMake(view.bounds.size.width/2, -calloutView.bounds.size.height*0.52);
    [view addSubview:calloutView];
    
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    
    
    
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    if ([view isKindOfClass:[CustomMKAnnotationView class]]){
        
        for (UIView *subview in view.subviews) {
            
            [subview removeFromSuperview];
            
        }
        
        
    }
    
    
    //if view is kind of class - customMKAnnotationView) { for subview in view.subviews {subview removeFromSuperView}}}
}


@end
