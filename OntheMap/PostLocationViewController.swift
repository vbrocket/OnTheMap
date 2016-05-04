//
//  PostLocationViewController.swift
//  OntheMap
//
//  Created by Ibrahim.Moustafa on 4/16/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController,UITextFieldDelegate , MKMapViewDelegate  {
    
    @IBOutlet weak var viewMapPosition: UIView!
    @IBOutlet weak var viewEnterLocation: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtMediaURL: UITextField!
    let parseClient = ParseClient()
    var studentLocation = CLLocation()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtLocation.delegate = self
        txtMediaURL.delegate = self
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        initScreen()
    }
    
    func initScreen(){
        txtMediaURL.text = ""
        txtMediaURL.text = ""
        self.viewEnterLocation.hidden = true
        self.viewMapPosition.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnFindOnTheMapClick(sender: AnyObject) {
        
        let text = txtLocation.text
        if !text!.isEmpty {
            
            LoadingIndicatorView.show();
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(text!, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in  
                dispatch_async(dispatch_get_main_queue(),{
                LoadingIndicatorView.hide();
                })
                
                if error == nil && placemarks!.count > 0 {
                    // show the map
                    dispatch_async(dispatch_get_main_queue(),{
                        self.viewEnterLocation.hidden = false
                        self.viewMapPosition.hidden = true
                        
                        // center the map and set the pin
                        if let placemarks = placemarks {
                            let placemark = placemarks[0]
                            let geocodedLocation = placemark.location!
                            // save locaion to use it when user submit
                            self.studentLocation = placemark.location!
                            self.centerMapOnLocation(geocodedLocation)
                            let annotation = MKPointAnnotation()
                            let coordinate = CLLocationCoordinate2D(latitude: geocodedLocation.coordinate.latitude, longitude: geocodedLocation.coordinate.longitude)
                            annotation.coordinate = coordinate
                            self.mapView.addAnnotation(annotation)
                        }
                    })
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        LoadingIndicatorView.hide()
                        self.showAlert("Error finding your location")
                        
                    })
                }
            })
        }
        
    }
    
    /**
    Centers the map on a location. From raywenderlich tutorial
    - parameter location: Where to center the map
    */
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 20000, 20000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // post location button click
    @IBAction func btnPostLocationClick(sender: AnyObject) {
        if txtMediaURL.text != "" {
        LoadingIndicatorView.show();
        parseClient.PostStudentLocation(studentLocation.coordinate.latitude, longitude: studentLocation.coordinate.longitude, mediaURL: txtMediaURL.text!, mapString: txtLocation.text!) { (success, error) -> Void in
            
            if let _ = error {
                dispatch_async(dispatch_get_main_queue(),{
                    LoadingIndicatorView.hide()
                    self.showAlert("Error submiting your location")
                })
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(),{
                    LoadingIndicatorView.hide()
                })
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            }
        }
        else{
            self.showAlert("Please enter your link")
        }
    }
    
    // dismiss main view if first cancel button clicked
    @IBAction func btnCanelClick(sender: AnyObject) {
                        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // return to init screen if second cancel button clicked
    @IBAction func btnReturnToPreviousView(sender: AnyObject) {
        initScreen()
    }
    
}
