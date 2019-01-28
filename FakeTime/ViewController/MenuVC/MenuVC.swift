//
//  MenuVC.swift
//  CNPM
//
//  Created by Luy Nguyen on 12/1/18.
//  Copyright © 2018 Luy Nguyen. All rights reserved.
//

import UIKit

class MenuObj: NSObject {
    var img: UIImage
    var title: String
    
    init(_ img: UIImage, title: String) {
        self.img = img
        self.title = title
    }
}

class MenuVC: UIViewController {
    @IBOutlet weak var tbMain: UITableView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var lbEmail: KHLabel!
    
    var arrItem: [MenuObj] = {
        let items: [MenuObj] = [MenuObj(#imageLiteral(resourceName: "home"), title: "Home"),
                                MenuObj(#imageLiteral(resourceName: "menu_setting"), title: "Setting")]
        return items
    }()
    let indicator = UIActivityIndicatorView(style: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension MenuVC {
    func initUI() {
        tbMain.register(MenuCell.self)
        
//        indicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
//        indicator.center = imgAvatar.center
//        imgAvatar.addSubview(indicator)
//        indicator.startAnimating()
    }

    func initData() {

        tbMain.reloadData()
        tbMain.selectRow(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
}

extension MenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MenuCell
        cell.config(arrItem[indexPath.item])
        return cell
        return UITableViewCell()
    }
    
    
}

extension MenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60*heightRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.item {
        case 0:
            let navi = UINavigationController(rootViewController: HomeVC.init(nibName: "HomeVC", bundle: nil))
            navi.isNavigationBarHidden = true
            TAppDelegate.menuContainerViewController?.centerViewController = navi
            break
        case 1:
            let navi = UINavigationController(rootViewController: SettingVC.init(nibName: "SettingVC", bundle: nil))
            navi.isNavigationBarHidden = true
            TAppDelegate.menuContainerViewController?.centerViewController = navi
            break
        default:
            Common.showAlert("Đang phát triển")
            break
        }
    }
}

extension MenuVC {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imgAvatar.image = UIImage(data: data)
                self.indicator.stopAnimating()
            }
        }
    }
}
