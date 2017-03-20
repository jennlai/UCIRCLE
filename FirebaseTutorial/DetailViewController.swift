//
//  DetailViewController.swift
//  UCIRCLE
//
//  Created by Jennifer Lai on 3/13/17.
//

import UIKit

class DetailViewController: UIViewController {

//    var event: EventData!
    var event: Event!
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UITextView!
    @IBOutlet weak var eventLoc: UITextView!
    @IBOutlet weak var eventStart: UITextView!
    @IBOutlet weak var eventEnd: UITextView!
    @IBOutlet weak var eventDesc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        eventTitle.text = event.title
        eventDesc.text = event.desc
        eventStart.text = event.start
        eventEnd.text = event.end
        eventLoc.text = event.loc
        eventImage.image = event.image
        
//        if let eImage = UIImage(data: event.image as! Data) {
//            eventImage.image = eImage
//        }
        
    }
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
