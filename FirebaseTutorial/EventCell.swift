//
//  EventCell.swift
//  UCIRCLE
//
//  Created by Jennifer Lai on 3/12/17.
//

import UIKit

class EventCell: UITableViewCell {

    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI(event: Event) {
        title.text = event.title
        eventImage.image = event.image
    }
    
}
