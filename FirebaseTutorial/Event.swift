//
//  Event.swift
//  UCIRCLE
//
//  Created by Jennifer Lai on 3/12/17.
//

import Foundation
import MapKit
import CoreLocation


class Event {
    
    private var _title: String!
    private var _desc: String!
    private var _titleAndDesc: String!
    private var _loc: String!
    private var _start: String!
    private var _end: String!
    private var _count: Int!
    private var _coord: CLLocationCoordinate2D!
    private var _distance: Double!
    private var _image: UIImage!
    
    
    var title: String{
        return _title
    }
    
    var desc: String{
        return _desc
    }
    
    var titleAndDesc: String{
        return _titleAndDesc
    }
    
    var loc: String{
        return _loc
    }
    
    var start: String{
        return _start
    }
    
    var end: String{
        return _end
    }
    
    var count: Int{
        set { _count = newValue}
        get { return _count }
    }
    
    
    var coord: CLLocationCoordinate2D{
        set { _coord = newValue}
        get { return _coord }
    }
    
    var distance: Double!{
        set { _distance = newValue}
        get { return _distance }
    }
    
    var image: UIImage!{
        set { _image = newValue}
        get { return _image }
    }
    
    
    init(title: String, desc: String, loc: String, start: String, end: String, titleAndDesc: String, count: Int) {
        self._title = title
        self._desc = desc
        self._loc = loc
        self._start = start
        self._end = end
        self._titleAndDesc = title + " " + desc
        self._count = 0
        self._coord = CLLocationCoordinate2DMake(33.641361, -117.854175)
        self._distance = 0
        self._image = UIImage(named: "4")
//        self._image = image
    }
}
