//
//  AddCallVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/24/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import Gallery
import AVKit
import AVFoundation
import KRProgressHUD

class AddCallVC: BaseVC {
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var imgAvatar: KHImageView!
    @IBOutlet weak var tfInputName: TextFieldView!
    @IBOutlet weak var tfInputPhoneNumber: TextFieldView!
    @IBOutlet weak var viewShowVideo: UIView!
    @IBOutlet weak var lbAddVideo: KHLabel!
    
    var isCreate: Bool = true
    var caller: CallerObj = CallerObj()
    var gallery = GalleryController()
    let fileManager = FileManager.default
    var filesRemoveToSave: [String] = []
    var filesRemoveToBack: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnAvatar(_ sender: Any) {
        let galleryVideo = GalleryController()
        galleryVideo.delegate = self
        gallery = galleryVideo
        Config.tabsToShow = [.imageTab]
        present(gallery, animated: true, completion: nil)
    }
    
    @IBAction func btnVideo(_ sender: Any) {
        let galleryImage = GalleryController()
        galleryImage.delegate = self
        gallery = galleryImage
        Config.tabsToShow = [.videoTab]
        Config.VideoEditor.maximumDuration = 120
        present(gallery, animated: true, completion: nil)
    }
    
    @IBAction func showVideo(_ sender: Any) {
        let controller = AVPlayerViewController()
        controller.player = AVPlayer(url: URL(fileURLWithPath: caller.pathVideo))
        self.present(controller, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension AddCallVC {
    func initUI() {
        navi.handleBack = {
            for i in self.filesRemoveToBack.indices {
                self.removeFile(path: self.filesRemoveToBack[i])
            }
            self.clickBack()
        }
        
        navi.handleActionRight = {
            self.view.endEditing(true)
            if self.isValid() {
                if self.isCreate {
                    self.caller.saveCallerList(true)
                } else {
                    self.caller.updateCaller()
                }
                for i in self.filesRemoveToSave.indices {
                    self.removeFile(path: self.filesRemoveToSave[i])
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        tfInputName.handleReturnText = { (text) in
            self.caller.name = text
        }
        
        tfInputPhoneNumber.handleReturnText = { (text) in
            if text.isnumberordouble {
                self.caller.phoneNumber = text
            } else {
                Common.showAlert("Phone number is wrong")
                self.tfInputPhoneNumber.textField.becomeFirstResponder()
            }
        }
        
        viewShowVideo.isHidden = caller.pathVideo.count == 0
        lbAddVideo.text = caller.pathVideo.count == 0 ? "Add video" : "Change video"
        gallery.delegate = self
    }
    func initData() {
        tfInputName.textField.text = caller.name
        tfInputPhoneNumber.textField.text = caller.phoneNumber
        imgAvatar.image = caller.avatar
    }
    
    func removeFile(path: String) {
        do {
            try self.fileManager.removeItem(at: URL(fileURLWithPath: path))
            print("removed")
        } catch {
            print("Can't remove")
        }
    }
    
    func copyVideoToPath(urlVideo: URL) {
        let dataPath = FilePaths.videoPaths.path
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dataPath) {
            try? fileManager.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil) //Create folder if not
        }
        let uuid = UUID().uuidString
        let fileName = uuid+".mp4"
        let fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(fileName)//Your video name
        print(fileURL)
        do {
            if self.caller.pathVideo.count > 0 {
                filesRemoveToSave.append(self.caller.pathVideo)
                print("Removed \(filesRemoveToSave.count) file")
            }
            try fileManager.moveItem(at: urlVideo, to: fileURL)
            print("Coppy:\(fileURL)")
            self.caller.pathVideo = fileURL.path
            self.filesRemoveToBack.append(fileURL.path)
            self.initUI()
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                KRProgressHUD.dismiss()
            }
        }
        catch let error as NSError {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                KRProgressHUD.dismiss()
            }
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func isValid() -> Bool {
        if caller.name.count == 0 {
            Common.showAlert("Please input name")
            return false
        }
        if caller.phoneNumber.count == 0 {
            Common.showAlert("Please input phone number")
            return false
        }
        if caller.pathVideo.count == 0 {
            Common.showAlert("Please add video")
            return false
        }
        
        return true
    }
}

extension AddCallVC: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            images[0].resolve { (image) in
                guard let image = image else { return }
                self.imgAvatar.image = image
                self.caller.avatar = image
                self.gallery.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        gallery.dismiss(animated: true, completion: nil)
        KRProgressHUD.show()
        let editor = VideoEditor()
        
        editor.edit(video: video) { (editedVideo: Video?, tempPath: URL?) in
            DispatchQueue.main.async {
                if let tempPath = tempPath {
                    self.copyVideoToPath(urlVideo: tempPath)
                }
            }
        }
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        gallery.dismiss(animated: true, completion: nil)
    }
}

class FilePaths {
    static let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as AnyObject
    struct videoPaths {
        static var path = FilePaths.documentsPath.appending("/data/video/")
        func urlVideoFileName(_ fileName: String) -> URL {
            return URL(fileURLWithPath: FilePaths.videoPaths.path+fileName)
        }
    }
}
