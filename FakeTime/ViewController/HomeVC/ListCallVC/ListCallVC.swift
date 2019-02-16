//
//  ListCallVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/24/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ListCallVC: BaseVC {
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var strSearch: String = ""
    var arrSearch: [CallerObj] = []
    var arrCaller: [CallerObj] = []
    let fileManager = FileManager.default
    var handleSelect: ((CallerObj) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initAdmob()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initData()
        loadData()
    }
    
    @IBAction func actionAddVideoCall(_ sender: Any) {
        let vc = AddCallVC.init(nibName: "AddCallVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ListCallVC {
    func initUI() {
        navi.handleBack = {
            self.clickBack()
        }
        
        searchView.handleSearchLocal = { str in
            self.strSearch = str
            self.loadData()
        }
        
        tableView.register(CellListCall.self)
    }
    
    func initAdmob() {
        bannerView.adUnitID = kAdmobBanner
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        
    }
    
    func initData() {
        arrCaller.removeAll()
        let defaultCaller1 = CallerObj(name: KeyString.girlFriend, phoneNumber: "123456789", avatar: #imageLiteral(resourceName: "girlfriend"), pathVideo: KeyString.girlFriendVideo)
        arrCaller.append(defaultCaller1)
        let defaultCaller2 = CallerObj(name: KeyString.marianRivera, phoneNumber: "123456789", avatar: #imageLiteral(resourceName: "marian rivera"), pathVideo: KeyString.marianRiveraVideo)
        arrCaller.append(defaultCaller2)
        arrCaller.append(contentsOf: CallerManager().getAllCaller())
    }
    
    func loadData() {
        if strSearch == "" {
            arrSearch = arrCaller
        } else {
            arrSearch = arrCaller.filter
                { $0.name.uppercased().contains(strSearch.uppercased())}
        }
        tableView.reloadData()
    }
}

extension ListCallVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellListCall
        cell.config(caller: arrSearch[indexPath.item])
        
        cell.handleEdit = {
            let vc = AddCallVC.init(nibName: "AddCallVC", bundle: nil)
            vc.isCreate = false
            vc.caller = self.arrSearch[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    
}

extension ListCallVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75*heightRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        handleSelect?(arrSearch[indexPath.item])
        self.navigationController?.popViewController(animated: true)
//        let vc = HomeVC.init(nibName: "HomeVC", bundle: nil)
//        vc.caller = arrCaller[indexPath.item]
//        let navi = UINavigationController(rootViewController: vc)
//        navi.isNavigationBarHidden = true
//        TAppDelegate.menuContainerViewController?.centerViewController = navi
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if arrSearch[indexPath.item].name == KeyString.girlFriend  {
            return false
        } else if arrSearch[indexPath.item].name == KeyString.marianRivera{
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try self.fileManager.removeItem(at: URL(fileURLWithPath: arrSearch[indexPath.row].pathVideo))
                print("removed video on path")
            } catch {
                print("Can't remove")
            }
            arrSearch[indexPath.row].deleteCaller()
            arrSearch.remove(at: indexPath.row)
            initData()
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            GCDCommon.mainQueueWithDelay(0.3) {
                self.tableView.reloadData()
            }
        }
    }
}

extension ListCallVC: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}
