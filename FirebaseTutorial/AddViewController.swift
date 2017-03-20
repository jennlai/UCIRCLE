//
//  AddViewController.swift
//  UCIRCLE
//
//  Created by Jennifer Lai on 3/18/17.
//

import Foundation
import UIKit
import CoreData






class AddViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventLoc: UITextField!
    @IBOutlet weak var eventStart: UITextField!
    @IBOutlet weak var eventEnd: UITextField!
    @IBOutlet weak var eventDesc: UITextField!
    
    
    
    
    @IBAction func uploadImage(_ sender: UIButton) {
    
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            // After it is complete
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            eventImage.image = image
            self.createEventItem(with: image)
        } else{
            print("Something went wrong.")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    
    func loadData() {
        let eventRequest:NSFetchRequest <EventData> = EventData.fetchRequest()
        
        do {
            eventData = try managedObjectContext.fetch(eventRequest)
//            self.tableView.reloadData()
        } catch {
            print("Could not load data from database")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func addDone(_ sender: UIButton) {
        
        do {
            try managedObjectContext.save()
            loadData()
        } catch {
            print("Could not save data")
        }
        
//        once = true
    }
    
    
    func createEventItem (with image: UIImage) {
        let eventItem = EventData(context: managedObjectContext)
        eventItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
        
//        let event = Event(title: eventTitle.text!, desc: eventDesc.text!, loc: eventLoc.text!, start: eventStart.text!, end: eventEnd.text!, titleAndDesc: eventTitle.text! + " " + eventDesc.text!, count: 0)
        
        eventItem.title = eventTitle.text!
        eventItem.desc = eventDesc.text!
        eventItem.loc = eventLoc.text!
        eventItem.start = eventStart.text!
        eventItem.end = eventEnd.text!
        eventItem.titleAndDesc = eventTitle.text! + " " + eventDesc.text!
        eventItem.count = 0
//        event.image = eventImage.image
//        events.append(event)
        
        
//        do {
//            try managedObjectContext.save()
//            loadData()
//        } catch {
//            print("Could not save data")
//        }
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addHome" {
//            if let addVC = segue.destination as? AddViewController {
//                if let event = sender as? Event {
//                    addVC.event = event
//                }
//            }
//        }
//        //   code that works the same
//        //            if let detailVC = segue.destination as? DetailViewController {
//        //                let row = tableView.indexPathForSelectedRow!.row
//        //                detailVC.event = events[row]
//        //            }
//    }
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
