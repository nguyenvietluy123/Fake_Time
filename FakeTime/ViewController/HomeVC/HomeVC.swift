//
//  HomeVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/23/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit
import GoogleMobileAds

class HomeVC: BaseVC {
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var imgAvatar: KHImageView!
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var tfDelayTime: KHTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ctrHeightTableView: NSLayoutConstraint!
    @IBOutlet weak var viewDelay: UIView!
    @IBOutlet weak var lbTimeCountDown: KHLabel!
    
    var interstitial: GADInterstitial!
    var timer: Timer = Timer()
    var caller: CallerObj = CallerObj()
    var isCallVideo: Bool = false
    var arrItem: [HomeObj] = {
        let items: [HomeObj] = [HomeObj(#imageLiteral(resourceName: "home_call2"), title: "Call", typeCall: .call, isSelected: true),
                                HomeObj(#imageLiteral(resourceName: "home_messager2"), title: "Messenger", typeCall: .messenger),
                                HomeObj(#imageLiteral(resourceName: "home_line2"), title: "Line", typeCall: .line),
                                HomeObj(#imageLiteral(resourceName: "home_wechat2"), title: "Wechat", typeCall: .weChat)]
        return items
    }()
    var timeCountDown: Int = 0 {
        didSet {
            let (h, m,s) = timeCountDown.secondsToHoursMinutesSeconds()
            lbTimeCountDown.text = "Call " + "(\(h):\(m):\(s))"
        }
    }
    var countCall: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caller = CallerObj(name: KeyString.santaClaus, phoneNumber: "123456789", avatar: #imageLiteral(resourceName: "santaClaus"), pathVideo: KeyString.santaClausVideo, fromUser: false)
        initUI()
        initData()
    } 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let count = SaveHelper.get(SaveKey.countCall) as! Int
        if count >= 3 {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
                SaveHelper.save(0, key: SaveKey.countCall)
            }
        }
    }
    
    @IBAction func callPhone(_ sender: Any) {
        count()
        isCallVideo = false
        delayTime()
    }
    
    @IBAction func callVideo(_ sender: Any) {
        count()
        isCallVideo = true
        delayTime()
    }
    
    @IBAction func actionCancelDelay(_ sender: Any) {
        viewDelay.isHidden = true
        timer.invalidate()
    }
    
    @IBAction func actionTimeCountDown(_ sender: Any) {
        viewDelay.isHidden = true
        timer.invalidate()
        if isCallVideo {
            showCallVideoVC()
        } else {
            showCallVC()
        }
    }
    
    func count() {
        let count = SaveHelper.get(SaveKey.countCall) as! Int
        countCall = count + 1
        SaveHelper.save(countCall, key: SaveKey.countCall)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
            vc.handleSelect = { (callerObj) in
                callerObj.typeCall = self.caller.typeCall
                self.caller = callerObj
                self.initData()
            }
        }
        
        collectionView.register(CellCollectionHome.self)
        interstitial = createAndLoadInterstitial()
    }
    
    func initData() {
        imgAvatar.image = caller.avatar
        lbName.text = caller.name
    }
    
    func delayTime() {
        if let timeCountDown = Int(tfDelayTime.text!) {
            if timeCountDown > 0 {
                viewDelay.isHidden = false
                self.timeCountDown = timeCountDown
                timer = Timer.every(1, {
                    if self.timeCountDown == 0 {
                        self.viewDelay.isHidden = true
                        self.timer.invalidate()
                        
                        if self.isCallVideo {
                            self.showCallVideoVC()
                        } else {
                            self.showCallVC()
                        }
                        return
                    }
                    self.timeCountDown -= 1
                    print(self.timeCountDown)
                })
            } else {
                if isCallVideo {
                    showCallVideoVC()
                } else {
                    showCallVC()
                }
            }
        } else {
            Common.showAlert("Please enter the correct timeout")
        }
    }
    
    func showCallVC() {
        switch caller.typeCall {
        case .call:
            let vc = Call_ScreenWaitVC.init(nibName: "Call_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        case .messenger:
            let vc = Messenger_ScreenWaitVC.init(nibName: "Messenger_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        case .line:
            let vc = Line_ScreenWaitVC.init(nibName: "Line_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        case .weChat:
            let vc = Wechat_ScreenWaitVC.init(nibName: "Wechat_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        }
    }
    
    func showCallVideoVC() {
        switch caller.typeCall {
        case .call:
            let vc = CallVideo_ScreenWaitVC.init(nibName: "CallVideo_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        case .messenger:
             let vc = MessengerVideo_ScreenWaitVC.init(nibName: "MessengerVideo_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
             self.present(vc, animated: true, completion: nil)
            break
        case .line:
            let vc = LineVideo_ScreenWaitVC.init(nibName: "LineVideo_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        case .weChat:
            let vc = WechatVideo_ScreenWaitVC.init(nibName: "WechatVideo_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        interstitial = GADInterstitial(adUnitID: kAdmobInterstitial)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CellCollectionHome
        cell.config(arrItem[indexPath.item])
        return cell
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        arrItem[indexPath.item].isSelected = true
        for i in arrItem.indices {
            if i != indexPath.item {
                arrItem[i].isSelected = false
            }
        }
        caller.typeCall = arrItem[indexPath.item].typeCall
        collectionView.reloadData()
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0.38*ScreenSize.SCREEN_WIDTH, height: 0.7*0.38*ScreenSize.SCREEN_WIDTH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.08*ScreenSize.SCREEN_WIDTH
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0.08*ScreenSize.SCREEN_WIDTH, bottom: 0, right: 0.08*ScreenSize.SCREEN_WIDTH)
    }
}

extension HomeVC : GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
}
