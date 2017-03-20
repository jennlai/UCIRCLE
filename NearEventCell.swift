//
//  NearEventCell.swift
//  UCIRCLE
//
//  Created by Jennifer Lai on 3/18/17.
//

import UIKit

class NearEventCell: UITableViewCell {
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDist: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateUI(event: Event) {
        eventTitle.text = event.title
        eventImage.image = event.image
    }
    

}
