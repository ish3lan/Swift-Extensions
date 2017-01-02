//
//  Extensions.swift
//
//  Created by Mohammed Alshaalan @imsh3lan on 8/11/16.
//  Copyright © 2016 Mohammed Alshaalan. All rights reserved. // JUST Kidding, do whatever you want with this code

import Foundation
import UIKit


// MARK: - UIViewController Extensions
extension UIViewController{
    
    /**
     Will Show a UIAlertController with a message msg and
     
     - parameter msg:     String  message to be shown for the user
     - parameter doneStr: String text representing the done action.
     - parameter ch:      ()->() Completion handler, called after dissmissing the Alert Controller "Done"
     */
    func showAlertView(msg:String, doneStr:String = "تم", ch: @escaping ()->()) {
        let alertView = UIAlertController(title:"", message: msg, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: doneStr, style: .default, handler: { (action:UIAlertAction) in
            ch()
        }))
        
        
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    /**
     Hides the keyboard when reciveing any click on the UIViewController.
     Should be called in viewDidLoad()
     */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


// MARK: - Date Extensions
extension Date {
    /**
     Initializer for NSDate, takes a date string e.g /Date(234534534) and returns an NSDate Object
     
     - parameter jsonDate: String date string e.g. /Date(234234234)
     
     - returns:            NSDate the date object or nil
     */
    init?(jsonDate: String) {
        
        let prefix = "/Date("
        let suffix = ")/"
        // Check for correct format:
        if jsonDate.hasPrefix(prefix) && jsonDate.hasSuffix(suffix) {
            // Extract the number as a string:
            let from = jsonDate.index(jsonDate.startIndex, offsetBy:prefix.characters.count)
            let to = jsonDate.index(jsonDate.endIndex, offsetBy: -suffix.characters.count)
            // Convert milleseconds to double
            guard let milliSeconds = Double(jsonDate[from ..< to]) else {
                return nil
            }
            // Create NSDate with this UNIX timestamp
            self.init(timeIntervalSince1970: milliSeconds/1000.0)
        } else {
            return nil
        }
    }
    
    /**
     Given a date (NSDate) it will return a formatted date as a string
     
     - parameter date: NSDate to be converted to String
     
     - returns:        String the supplied date formatted as DD-MM-YYY HH:mm
     */
    static func getStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    
    /**
     Given a string it will return an NSDate Object
     
     - parameter dateString : String Formatted as "dd-MM-yyyy HH:mm" to be converted to an NSDate
     
     - returns:               NSDate object
     */
    static func getDateFromString(dateString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let data = dateFormatter.date(from: dateString)
        return data!
    }
    
}


// MARK: - UILabel Extensions
extension UILabel {
    /// Change the font without changing the size,
    /// Extremely helpful when dealing with app theming.
    /// Supply the font name (String)
    var setFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
    
}


// MARK: - UIColor Extensions
extension UIColor {
    
    /**
     define a color with its hexString representation
     
     - parameter hexString: String Hex String representation of the color e.g. #FFFFFF
     - parameter alpha:     CGFloat (optional) set the transparancy of the color, 1 is the default
     
     - returns:             UIColor color object
     */
    func colorWithHexString(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}


// MARK: - UICollectionView Extensions
extension UICollectionView {
    /**
     get the cell Index path of given UIView, really helpful for locating the clicked view or button in a
     collection view cell. e.g. get the index path of button then retrieve relative data from dataSource.
     
     - parameter view: UIView the view to search for its indexpath
     
     - returns:        NSIndexPath the index path for the cell containing the UIView, Might be nil,
     */
    func indexPathForView(view: AnyObject) -> IndexPath? {
        let originInCollectioView = self.convert(CGPoint.zero, from: (view as! UIView))
        
        
        
        return self.indexPathForItem(at: originInCollectioView)
    }
    
    
    /**
     Set the number of items per row
     
     - parameter items: Int number of items per row in collection view
     */
    func setItemsInRow(items: Int) {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            let contentInset = self.contentInset
            let itemsInRow: CGFloat = CGFloat(items);
            let innerSpace = layout.minimumInteritemSpacing * (itemsInRow - 1.0)
            let insetSpace = contentInset.left + contentInset.right + layout.sectionInset.left + layout.sectionInset.right
            let width = floor((frame.width - insetSpace - innerSpace) / itemsInRow);
            layout.itemSize = CGSize(width ,width * 1.7)
        }
    }
}

// MARK: - String Extensions
extension String {
    
    /**
     Search a string inside a string "CASE SENSITIVE"
     
     - parameter find: String the string to be search for
     
     - returns:        Bool returns true if the string contains the supplied string or false otherwise
     */
    func contains(find: String) -> Bool{
        return self.range(of:find) != nil
    }
    
    
    /**
     Search a string inside a string "NOT CASE SENSITIVE"
     
     - parameter find: String the string to be search for
     
     - returns:        Bool returns true if the string contains the supplied string or false otherwise
     */
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of:find, options: .caseInsensitive) != nil
    }
}

// MARK: - UIAlertController Extensions
extension UIAlertController {
    func addActions(actions: [UIAlertAction]) {
        
        for action in actions {
            self.addAction(action)
        }
    }
}


// MARK: - UIImage Extensions
extension UIImage {
    /**
     Get an Image from a given color
     
     - parameter color:  UIColor the color to make the image of.
     - parameter width:  Int width of the image
     - parameter height: Int height of the image
     
     - returns:          UIImage an image object
     */
    static func fromColor(color: UIColor, width: Int = 100, height: Int = 100) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}
