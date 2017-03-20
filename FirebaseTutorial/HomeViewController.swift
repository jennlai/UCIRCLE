//
//  HomeViewController.swift
//  FirebaseTutorial
//
//  Created by James Dacombe on 16/11/2016.
//

import Firebase
import FirebaseAuth
import UIKit
import Foundation
import CoreData


var eventData = [EventData]()
var managedObjectContext: NSManagedObjectContext!


var events = [Event]()
var once = false
var filteredEventsByDistance = [Event]()



class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var filteredEventsByCount = [Event]()
    var inSearchMode = false
    //    var inNearestMode = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //         Do any additional setup after loading the view.
        
        //        if (!once) {
        //            parseCSV()
        //
        //
        //
        //            once = !once
        //        }
        
        
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        
//        if (!once) {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventData")
//            
//            // Configure Fetch Request
//            fetchRequest.includesPropertyValues = false
//            
//            do {
//                let items = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
//                
//                for item in items {
//                    managedObjectContext.delete(item)
//                }
//                
//                // Save Changes
//                try managedObjectContext.save()
//                
//            } catch {
//                // Error Handling
//                // ...
//            }
//            
//            
//            once = !once
//        }
//        
        loadData()
        
        if (!once) {
            parseCSV()
            
            
            
            once = !once
        }
        
        
        storeDataIntoEventObject()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logOutAction(sender: AnyObject) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func parseCSV() {
        let path = Bundle.main.path(forResource: "eventData", ofType: "csv")
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            //print(rows)
            
            for row in rows {
                let eventTitle = row["Title "]!
                let eventDesc = row[" Description "]!
                let eventLoc = row[" Location "]!
                let eventStart = row[" Start_Time "]!
                let eventEnd = row [" End_Time"]!
                
                let event = Event(title: eventTitle, desc: eventDesc, loc: eventLoc, start: eventStart, end: eventEnd, titleAndDesc: eventTitle + " " + eventDesc, count: 0)
                events.append(event)
            }
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // updates the cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventCell{
            // without search bar
            //            let event = events[indexPath.row]
            //            cell.updateUI(event: event)
            //
            let event: Event!
            if inSearchMode {
                let event = filteredEventsByCount[indexPath.row]
                cell.updateUI(event: event)
            }
                //            else if (inNearestMode){
                //                event = filteredEventsByDistance[indexPath.row]
                //                cell.updateUI(event: event)
                //            }
            else {
                event = events[indexPath.row]
                //                let eventItem = eventData[indexPath.row]
                
                //                if let eventImage = UIImage(data: eventItem.image as! Data) {
                //                    cell.eventImage.image = eventImage
                //                }
                
                //                cell.title.text = eventItem.title
                
                
                cell.updateUI(event: event)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // without search bar
        //        return events.count
        
        if inSearchMode {
            return filteredEventsByCount.count
        }
            //        else if (inNearestMode) {
            //            return filteredEventsByDistance.count
            //        }
        else {
            return events.count
            //            return eventData.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // without search bar
        //        let event = events[indexPath.row]
        
        let event: Event!
        //        let event: EventData!
        if inSearchMode {
            event = filteredEventsByCount[indexPath.row]
            //            event = eventData[indexPath.row]
        } else {
            event = events[indexPath.row]
            //            event = eventData[indexPath.row]
        }
        
        performSegue(withIdentifier: "detailSegue", sender: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let detailVC = segue.destination as? DetailViewController {
                if let event = sender as? Event {
                    detailVC.event = event
                }
            }
        }
        //   code that works the same
        //            if let detailVC = segue.destination as? DetailViewController {
        //                let row = tableView.indexPathForSelectedRow!.row
        //                detailVC.event = events[row]
        //            }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { //search bar filters results
        
        if searchBar.text == nil || searchBar.text == "" { // searchBar.text = user's seach query string
            
            inSearchMode = false
            tableView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            var searchBarText = searchBar.text!
            
            searchBarText = searchBarText.lowercased()
            
            var query = searchBarText.components(separatedBy: " ")
            
            //            var queryCount = [Int]()
            
            //            var totalWordCount = 0
            
            
            for event in events {
                
                //                totalWordCount = 0
                
                event.count = 0
                
                for index in 0...query.count-1 {
                    
                    let wordCount = event.titleAndDesc.lowercased().components(separatedBy: query[index])
                    
                    event.count += (wordCount.count - 1)
                    
                    //                    totalWordCount += (wordCount.count - 1)
                    
                }
                
                //                queryCount.append(totalWordCount)
                
            }
            
            
            for i in 0...events.count-1 {
                
                print(events[i].count)
            }
            
            var sortedEventsByCount = events
            var sortedAboveIndex = events.count
            //            var sortedAboveIndex = queryCount.count
            
            repeat {
                var lastSwapIndex = 0
                
                for i in 1..<sortedAboveIndex {
                    if (sortedEventsByCount[i - 1].count < sortedEventsByCount[i].count) {
                        
                        var tempEvent: Event
                        
                        tempEvent = sortedEventsByCount[i]
                        sortedEventsByCount[i] = sortedEventsByCount[i-1]
                        sortedEventsByCount[i-1] = tempEvent
                        
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
            
            for i in 0...sortedEventsByCount.count-1 {
                
                print(sortedEventsByCount[i].count)
            }
            
            filteredEventsByCount = sortedEventsByCount.filter({$0.count != 0})
            
            
            //            for i in 0...filteredEventsByCount.count-1 {
            //
            //                print(filteredEventsByCount[i].count)
            //            }
            
            tableView.reloadData()
        }
    }
    
    
    
    
    
    
    func loadData() {
        let eventRequest:NSFetchRequest <EventData> = EventData.fetchRequest()
        
        do {
            eventData = try managedObjectContext.fetch(eventRequest)
            self.tableView.reloadData()
        } catch {
            print("Could not load data from database")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    func storeDataIntoEventObject() {
        
        //        events.removeAll()
        
        var eventExists = false
        
        
        for data in eventData {
            //            let event: Event!
            
            //            event.title = data.title
            
            var tempImage: UIImage!
            
            if let eventImage = UIImage(data: data.image as! Data) {
                tempImage = eventImage
            }
            
            for eventOb in events {
                
                if (eventOb.title == data.title! && eventOb.desc == data.desc! && eventOb.loc == data.loc! && eventOb.start == data.start! && eventOb.end == data.end! && eventOb.count == Int(data.count)){
                    
                    eventExists = true
                }
                
            }
            
            if (eventExists == false) {
                let event = Event(title: data.title!, desc: data.desc!, loc: data.loc!, start: data.start!, end: data.end!, titleAndDesc: data.title! + " " + data.desc!, count: Int(data.count))
                event.image = tempImage
                //                events.append(event)
                events.insert(event, at: 0)
            }
            
            eventExists = false
        }
        
        
        print(events.count)
        
        
        
        //        parseCSV()
        
        print(events.count)
        
    }
    
    
    
    
    //    @IBAction func nearFilter(_ sender: UIButton) {
    //
    //        //        let myCustomViewController: MapViewController = MapViewController()
    //        inNearestMode = true
    //
    //        var sortedEventsByDistance = events
    //        var sortedAboveIndex = events.count
    //
    //        print(sortedAboveIndex)
    //        //            var sortedAboveIndex = queryCount.count
    //
    //
    //
    //
    //        repeat {
    //            var lastSwapIndex = 0
    //
    //            for i in 1..<sortedAboveIndex {
    //                if (sortedEventsByDistance[i - 1].distance > sortedEventsByDistance[i].distance) {
    //
    //                    var tempEvent: Event
    //
    //                    tempEvent = sortedEventsByDistance[i]
    //                    sortedEventsByDistance[i] = sortedEventsByDistance[i-1]
    //                    sortedEventsByDistance[i-1] = tempEvent
    //
    //                    //                        var tempCount = 0
    //                    //
    //                    //                        tempCount = queryCount[i]
    //                    //                        queryCount[i] = queryCount[i-1]
    //                    //                        queryCount[i-1] = tempCount
    //                    //
    //                    lastSwapIndex = i
    //                }
    //            }
    //
    //            sortedAboveIndex = lastSwapIndex
    //
    //        } while (sortedAboveIndex != 0)
    //
    //
    //        print("asdf")
    //
    //        for i in 0...sortedEventsByDistance.count-1 {
    //
    //            print(sortedEventsByDistance[i].distance)
    //        }
    //
    //
    //        filteredEventsByDistance = sortedEventsByDistance.filter({$0.distance != 0})
    //
    //
    //
    //        tableView.reloadData()
    //
    //
    //    }
}




