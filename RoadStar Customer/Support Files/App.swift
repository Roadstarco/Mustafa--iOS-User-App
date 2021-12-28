//
//  App.swift
//  RoadStar Customer
//
//  Created by Faizan Ali  on 2020/10/4.
//  Copyright © 2020 Faizan.Technology. All rights reserved.
//

import Foundation
import UIKit

class App{
    
    static let shared = App()
    
    private (set) var user: UserProfile
    var uiApplication: UIApplication!
    
    init() {
        user = UserProfile.current ?? UserProfile()
    }
    
    func initialize(_ application: UIApplication){
        self.bootstrap(application)
    }

    open func bootstrap(_ application: UIApplication){
        uiApplication = application
    }
    
    func updateUser() {
        user = UserProfile.current ?? UserProfile()
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Image related ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage
    {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    
    static func screenSizeAdjustImage(maxSize:CGSize, image:UIImage) -> CGSize
    {
        // Calculate the image ratio
        // resize it to
        var imgSize = image.size
        
        if imgSize.width > imgSize.height
        {
            let dividant = imgSize.width / maxSize.width;
            imgSize.height = imgSize.height / dividant;
            imgSize.width = maxSize.height;
        }
        else
        {
            let dividant = imgSize.height / maxSize.height;
            imgSize.width = imgSize.width / dividant;
            imgSize.height = maxSize.height;
        }
        
        return imgSize
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    
    static func correctOrrientationOfImage(_ img:UIImage) -> UIImage
    {
        
        if (img.imageOrientation == UIImage.Orientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ local media storage ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    
    static func getMediaTemproryFolderPath () -> String
    {
        var mediaFolderPath = ""
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        {
            do {

                mediaFolderPath =  tDocumentDirectory.appendingPathComponent("AppMedia").path
                if !fileManager.fileExists(atPath: mediaFolderPath)
                {
                    try fileManager.createDirectory(atPath: mediaFolderPath, withIntermediateDirectories: true, attributes: nil)
                }
            }
            catch
            {
                
            }
        }
        
        return mediaFolderPath
    }

}
