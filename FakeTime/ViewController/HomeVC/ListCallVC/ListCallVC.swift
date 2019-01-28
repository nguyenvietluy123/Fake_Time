//
//  ListCallVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/24/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit

class ListCallVC: BaseVC {
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    var arrCaller: [CallerObj] = []
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrCaller.removeAll()
        arrCaller = CallerManager().getAllCaller()
        tableView.reloadData()
    }
    
    @IBAction func actionAddVideoCall(_ sender: Any) {
        let vc = AddCallVC.init(nibName: "AddCallVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListCallVC {
    func initUI() {
        navi.handleBack = {
            self.clickBack()
        }
        tableView.register(CellListCall.self)
    }
    
    func initData() {
        
    }
}



extension ListCallVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCaller.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellListCall
        cell.config(caller: arrCaller[indexPath.item])
        
        cell.handleEdit = {
            let vc = AddCallVC.init(nibName: "AddCallVC", bundle: nil)
            vc.isCreate = false
            vc.caller = self.arrCaller[indexPath.item]
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
        let vc = HomeVC.init(nibName: "HomeVC", bundle: nil)
        vc.caller = arrCaller[indexPath.item]
        let navi = UINavigationController(rootViewController: vc)
        navi.isNavigationBarHidden = true
        TAppDelegate.menuContainerViewController?.centerViewController = navi
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try self.fileManager.removeItem(at: URL(fileURLWithPath: arrCaller[indexPath.row].pathVideo))
                print("removed video on path")
            } catch {
                print("Can't remove")
            }
            arrCaller[indexPath.row].deleteCaller()
            arrCaller.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            GCDCommon.mainQueueWithDelay(0.3) {
                self.tableView.reloadData()
            }
        }
    }
}
