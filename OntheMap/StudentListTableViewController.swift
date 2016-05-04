//
//  StudentListTableViewController.swift
//  OntheMap
//
//  Created by Ibrahim.Moustafa on 4/10/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import UIKit

class StudentListTableViewController: UITableViewController {

let parseClient = ParseClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func handler(success: Bool, error: NSError?){
        if let _ = error {
            dispatch_async(dispatch_get_main_queue(),{
                LoadingIndicatorView.hide()
                self.showAlert("Error getting student locations, please refresh")
            })
        }
        else {
            dispatch_async(dispatch_get_main_queue(),{
                LoadingIndicatorView.hide()
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return StudentInformation.arrStudentInformation.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.arrStudentInformation.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellStudent", forIndexPath: indexPath)
        cell.textLabel!.text = "\(StudentInformation.arrStudentInformation[indexPath.row].firstName) \(StudentInformation.arrStudentInformation[indexPath.row].lastName)"
        cell.imageView!.image = UIImage(named: "pin")

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        if let toOpen = NSURL(string: StudentInformation.arrStudentInformation[indexPath.row].mediaURL) {
            app.openURL(toOpen)
        }
    }

    @IBAction func btnRefreshClick(sender: AnyObject) {
        LoadData()
    }
    
    @IBAction func btnLogoutClick(sender: AnyObject) {
        LogoutUdacity()
    }
    @IBAction func btnShowPostLocationClick(sender: AnyObject) {
        performSegueWithIdentifier("segPostLocation", sender: self)    }
}
