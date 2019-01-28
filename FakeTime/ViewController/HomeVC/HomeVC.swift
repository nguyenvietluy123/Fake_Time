//
//  HomeVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/23/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class HomeVC: BaseVC {
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var imgAvatar: KHImageView!
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var tfDelayTime: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewShowVideo: UIView!
    
    var caller: CallerObj = CallerObj()
    var arrItem: [HomeObj] = {
        let items: [HomeObj] = [HomeObj(#imageLiteral(resourceName: "home_call"), title: "Call", typeCall: .call),
                                HomeObj(#imageLiteral(resourceName: "home_message"), title: "Messenger", typeCall: .messenger),
                                HomeObj(#imageLiteral(resourceName: "home_line"), title: "Line", typeCall: .line),
                                HomeObj(#imageLiteral(resourceName: "home_wechat"), title: "Wechat", typeCall: .weChat)]
//            ,HomeObj(#imageLiteral(resourceName: "home_setting"), title: "Setting", typeCall: .setting)]
        return items
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }

    @IBAction func callPhone(_ sender: Any) {
    }
    
    @IBAction func callVideo(_ sender: Any) {
//        let player = AVPlayer(url: URL(fileURLWithPath: caller.pathVideo))
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = viewShowVideo.bounds
//        viewShowVideo.layer.addSublayer(playerLayer)
//        player.play()
        let vc = CallVC.init(nibName: "CallVC", bundle: nil)
        present(vc, animated: true, completion: nil)
    }
}

extension HomeVC {
    func initUI() {
        navi.handleMenu = {
            self.clickMenu()
        }
        
        navi.handleActionRight = {
            let vc = ListCallVC.init(nibName: "ListCallVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.register(CellHome.self)
    }
    
    func initData() {
        imgAvatar.image = caller.avatar
        lbName.text = caller.name
    }
}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellHome
        cell.config(arrItem[indexPath.item])
        return cell
    }
    
    
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60*heightRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        arrItem[indexPath.item].isSelected = true
        for i in arrItem.indices {
            if i != indexPath.item {
                arrItem[i].isSelected = false
            }
        }
        caller.typeCall = arrItem[indexPath.item].typeCall
        tableView.reloadData()
    }
}
