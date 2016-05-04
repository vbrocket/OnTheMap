//
//  StudentMapViewController.swift
//  OntheMap
//
//  Created by Ibrahim.Moustafa on 4/4/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import UIKit
import MapKit

class StudentMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    let parseClient = ParseClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        // start loading data
        LoadData()
    }
    
    // loading data from client and show loading view
    func LoadData(){
        LoadingIndicatorView.show()
        parseClient.getStudentLocations(100, completionHandlerForGetStudentLocation: handler)
    }

    @IBAction func btnPostLocationClick(sender: AnyObject) {
        performSegueWithIdentifier("segPostLocation", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func handler(success: Bool, error: NSError?){
        if let _ = error {
            dispatch_async(dispatch_get_main_queue(),{
                LoadingIndicatorView.hide()
                self.showAlert("Error getting student locations, please refresh")
            })
        }
        else {

            dispatch_async(dispatch_get_main_queue(),{
                //self.stopLoader()
                LoadingIndicatorView.hide()
                // We will create an MKPointAnnotation for each dictionary in "locations". The
                // point annotations will be stored in this array, and then provided to the map view.
                var annotations = [MKPointAnnotation]()
            
                for studentLocation in StudentInformation.arrStudentInformation {
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
                annotation.coordinate = coordinate
                annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
                annotation.subtitle = studentLocation.mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
            
            
                self.mapView.addAnnotations(annotations)
            })
            

        }
    }

    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView

    }

    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    @IBAction func btnRefreshClick(sender: AnyObject) {
        LoadData()
    }
    
    @IBAction func btnLogoutClick(sender: AnyObject) {
        LogoutUdacity()
    }

    

}
