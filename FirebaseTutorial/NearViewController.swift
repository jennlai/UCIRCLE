//
//  NearViewController.swift
//  UCIRCLE
//
//  Created by Jennifer Lai on 3/18/17.
//

import UIKit
import Foundation

class NearViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //        let myCustomViewController: MapViewController = MapViewController()
        
        var sortedEventsByDistance = events
        var sortedAboveIndex = events.count
        
        print(sortedAboveIndex)
        //            var sortedAboveIndex = queryCount.count
        
        
        
        
        repeat {
            var lastSwapIndex = 0
            
            for i in 1..<sortedAboveIndex {
                if (sortedEventsByDistance[i - 1].distance > sortedEventsByDistance[i].distance) {
                    
                    var tempEvent: Event
                    
                    tempEvent = sortedEventsByDistance[i]
                    sortedEventsByDistance[i] = sortedEventsByDistance[i-1]
                    sortedEventsByDistance[i-1] = tempEvent
                    
                    //                        var tempCount = 0
                    //
                    //                        tempCount = queryCount[i]
                    //                        queryCount[i] = queryCount[i-1]
                    //                        queryCount[i-1] = tempCount
                    //
                    lastSwapIndex = i
                }
            }
            
            sortedAboveIndex = lastSwapIndex
            
        } while (sortedAboveIndex != 0)
        
        
        print("asdf")
        
        //        for i in 0...sortedEventsByDistance.count-1 {
        //
        //            print(sortedEventsByDistance[i].distance)
        //        }
        
        
        filteredEventsByDistance = sortedEventsByDistance.filter({$0.distance != 0})
        
        
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // updates the cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "nearEventCell", for: indexPath) as? NearEventCell{
            
            let event: Event!
            event = filteredEventsByDistance[indexPath.row]
            cell.updateUI(event: event)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEventsByDistance.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // without search bar
        //        var event = events[indexPath.row]
        
        //        let event: EventData!
        let event = filteredEventsByDistance[indexPath.row]
        //        event = eventData[indexPath.row]
        
        performSegue(withIdentifier: "detSegue", sender: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detSegue" {
            
            if let detailVC = segue.destination as? DetailViewController {
                let row = tableView.indexPathForSelectedRow!.row
                detailVC.event = filteredEventsByDistance[row]
                //                detailVC.event = events[row]
            }
        }
    }
}
