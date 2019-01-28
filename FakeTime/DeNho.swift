//
//  HomeVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/23/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import Gallery
import AVKit

class deeNho: BaseVC {
    @IBOutlet weak var navi: NavigationView!
    
    let gallery = GalleryController()
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        gallery.delegate = self
        Config.tabsToShow = [.videoTab]
        
//        if !fileManager.fileExists(atPath: FilePaths.videoPaths.path) {
//             var error:NSError? = nil
//            do {
        //viet func truyen vao tempPath
//                try fileManager.copyItem(at: URL.init(fileURLWithPath:tempPath), to: destinationSqliteURL)
//                print("Copied")
//                print(FilePaths.videoPaths.path)
//            } catch let error as NSError {
//                print("Unable to create database \(error.debugDescription)")
//            }
//        }
    }
    
    
    @IBAction func btnAction(_ sender: Any) {
        present(gallery, animated: true, completion: nil)
    }
    
    func saveVideo( success:@escaping (Bool,URL?)->()){
        let dataPath = FilePaths.videoPaths.path
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dataPath) {
            try? fileManager.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil) //Create folder if not
        }
        let uuid = UUID().uuidString
        let fileName = uuid+".mp4"
        let fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(fileName)//Your image name
        print(fileURL)
        do {
//            try fileManager.moveItem(atPath: self.path, toPath: fileURL.path)
//            fileManager.moveItem(at: <#T##URL#>, to: <#T##URL#>)
//            fileManager.remove
//              c2:          URL.init(fileURLWithPath: FilePaths.videoPaths.path)
            //            print("Coppy:\(fileURL.path)")
            //            let obj = MyData()
            //            obj.id = uuid
            //            obj.fileName = fileName
            //            obj.isVideo = true
            //            RealmManager.sharedInstance.addData(object: obj)
            success(true,fileURL)
        }
        catch let error as NSError {
            success(false,fileURL)
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
}

extension deeNho {
    func initUI() {
        navi.handleMenu = {
            self.clickMenu()
        }
    }
}

extension deeNho: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        gallery.dismiss(animated: true, completion: nil)
        
        let editor = VideoEditor()
        
        editor.edit(video: video) { (editedVideo: Video?, tempPath: URL?) in
            DispatchQueue.main.async {
                if let tempPath = tempPath {
                    let controller = AVPlayerViewController()
                    controller.player = AVPlayer(url: tempPath)
                    //tempPath.path
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        
    }
    
    
}


