//
//  ViewController.swift
//  Stormy
//
//  Created by ChangKH on 2014/11/9.
//  Copyright (c) 2014年 kunhsiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let apiKey = "6a619433c5b10bddab277edadb8c01f9"
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshActivityIndicator.hidden = true
        
        getCurrentWeatherData()
    }
    
    func getCurrentWeatherData() -> Void {
    
        let baseURL = NSURL(string:"https://api.forecast.io/forecast/\(apiKey)/")
        
        let forecastURL = NSURL(string:"24.843376,121.001661", relativeToURL:baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL! , completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if (error==nil)
            {
                let dataObject = NSData(contentsOfURL: location)
                
                let weatherDictionary : NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                
                dispatch_async( dispatch_get_main_queue(),{()-> Void in
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    self.iconView.image = currentWeather.icon!
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "\(currentWeather.summary)"
                    
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
            }else
            {
                let networkIssueController = UIAlertController(title:"Error",message:"Unable to load data,connection error!",preferredStyle:.Alert)
                
                let okButton = UIAlertAction(title:"OK",style:.Default,handler:nil)
                networkIssueController.addAction(okButton)

                let cancelButton = UIAlertAction(title:"Cancel",style:.Cancel,handler:nil)
                networkIssueController.addAction(cancelButton)

                self.presentViewController(networkIssueController, animated: true, completion: nil)

                dispatch_async( dispatch_get_main_queue(),{()-> Void in
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
                
                //println(error)
            }
        })
        
        downloadTask.resume()
    }
    
    
    @IBAction func refresh() {
        
        getCurrentWeatherData()
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}