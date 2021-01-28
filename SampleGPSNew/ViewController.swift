//
//  ViewController.swift
//  SampleGPSNew
//
//  Created by 先生 on 2021/01/21.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate, UIScrollViewDelegate {
    //GPS系の処理を任せてもらうため必要なルール
    @IBOutlet weak var labelLat: UILabel!
    @IBOutlet weak var labelLon: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var inputLat: UITextField!
    @IBOutlet weak var inputLon: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var innerView2: UIView!
    @IBOutlet weak var innerView3: UIView!
    
    @IBOutlet weak var pageControll: UIPageControl!
    
    let locationNameList = [
        "日本コンピュータ専門学校",
        "上新庄駅",
        "だいどう豊里駅"
    ]
    let locationSubNameList = [
        "学校",
        "阪急：駅",
        "OsakaMetoro：駅"
    ]

    // 学校・上新庄駅・だいどう豊里駅の緯度経度の配列
    let locationList = [
        CLLocationCoordinate2DMake(34.742684,135.535068),
        CLLocationCoordinate2DMake(34.750327,135.533098),
        CLLocationCoordinate2DMake(34.743739,135.544665)
    ]

    var locationManager: CLLocationManager!
    // デフォルトのマップ拡大率
    var defaultSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //位置情報
        locationManager = CLLocationManager()
        
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        let status = locationManager.authorizationStatus
        if status == CLAuthorizationStatus.authorizedAlways{
            //画面自身に任せる
            locationManager.delegate = self
            
            locationManager.distanceFilter = 500
            //10m 以内動くなら　ko update vi tri
            //locationManager.startUpdatingLocation()
        
        }
        //Mapの表示モードを変更できる
        mapView.mapType = MKMapType.hybrid
        
        //中心の地位を利用者の現在地にする
        //mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.setRegion(MKCoordinateRegion(center: mapView.userLocation.coordinate, span: defaultSpan), animated: true)
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.userTrackingMode = MKUserTrackingMode.follow
        //mapView.userTrackingMode = MKUserTrackingMode.FollowWithHeading
        //ピンを全て削除
        mapView.removeAnnotations(mapView.annotations)

        mapView.delegate = self

        // ピンを追加
        for index in 0..<locationNameList.count {
            // 新しいピンを作成
            let annotation: MKPointAnnotation = MKPointAnnotation()
            annotation.title = locationNameList[index]
            annotation.subtitle = locationSubNameList[index]
            annotation.coordinate = locationList[index]
            //ピンを追加
            mapView.addAnnotation(annotation)
        }
        
        innerView.frame.size.width = scrollView.frame.size.width
        innerView2.frame.size.width = scrollView.frame.size.width
        innerView3.frame.size.width = scrollView.frame.size.width
        innerView.frame.size.height = scrollView.frame.size.height
        innerView2.frame.size.height = scrollView.frame.size.height
        innerView3.frame.size.height = scrollView.frame.size.height
        
        innerView.frame.origin.x = 0
        innerView2.frame.origin.x = scrollView.frame.size.width
        innerView3.frame.origin.x = scrollView.frame.size.width * 2

        // scrollViewのサイズを指定（幅は1メニューに表示するViewの幅×ページ数）
        let contentWidth = innerView.frame.size.width * CGFloat(pageControll.numberOfPages)
        let contentHeight = innerView.frame.size.height
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        // scrollViewのデリゲートになる（スクロールした際のイベントをメソッドで受け取れる）
        scrollView.delegate = self
        // スクロールを可能にする
        scrollView.isScrollEnabled = true
        // ページ単位のスクロールを可能にする（ページの認識は登録されている部品の数、今回は３つのView）
        scrollView.isPagingEnabled = true
        // 垂直方向のスクロールインジケータを非表示にする（水平方向のみのスクロール）
        scrollView.showsVerticalScrollIndicator = false

    }

    @IBAction func clickSet(sender: UIButton) {
        let lat = Float64(inputLat.text!)!
        let lon = Float64(inputLon.text!)!
        // 新しいピンを作成
        let annotation:MKPointAnnotation = MKPointAnnotation();
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
        annotation.title = "テスト　アノテーションA";
        annotation.subtitle = "サプタイトルA";
        //ピンを追加
        mapView.addAnnotation(annotation);
    }
    
/*
        let annotation: MKPointAnnotation = MKPointAnnotation();
        annotation.coordinate = CLLocationDegrees(latitude: inputLat,longitude: inputLon);
        mapView.addAnnotation(mapView)
*/
    @IBAction func clickPoint(sender: UIButton) {
        let user_let = mapView.userLocation.coordinate.latitude
        let user_lon = mapView.userLocation.coordinate.longitude
        //新しいピンを作成
        let annotation:MKPointAnnotation = MKPointAnnotation();
        annotation.coordinate = CLLocationCoordinate2DMake(user_let,user_lon);
        annotation.title = "テスト アノテーションA";
        annotation.subtitle = "サブタイトルA";
        //ピンを追加
        mapView.addAnnotation(annotation)
    }

    @IBAction func clickGet(sender: UIButton) {
        locationManager.startUpdatingLocation()

    }
    
    @IBAction func clickStop(sender: UIButton) {
        let status = locationManager.authorizationStatus
        if status == CLAuthorizationStatus.authorizedAlways{
            locationManager.stopUpdatingLocation()
        }
        mapView.userTrackingMode = MKUserTrackingMode.none
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        print("latitude: \(latitude!)\nlongitude: \(longitude!)")
        let map : MKPointAnnotation = MKPointAnnotation();
        map.coordinate = CLLocationCoordinate2DMake(latitude!,longitude! )
        map.title = "テスト　アノテーション";
        map.subtitle = "サブタイトル";
        mapView.addAnnotation(map);
        
        labelLat.text = String(latitude!)
        labelLon.text = String(longitude!)
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //現在地の印は変更しない
       if annotation is MKUserLocation{
        let annotationImageViewId:String = "imagePinId";
        var pinImageView:MKAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: annotationImageViewId)
        
            if pinImageView == nil{
                //
                pinImageView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationImageViewId)
                pinImageView?.image = UIImage(named: "player.png")
                pinImageView?.canShowCallout = true
            }
            else{
                //
                pinImageView?.annotation = annotation
            }
            return pinImageView;
        }
 
        let annotationViewId:String = "pinId";
        //保存してあるAnnotationView があるか　取り出して見る
        var pinView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewId) as? MKPinAnnotationView
        if pinView == nil{
            //無かったら新しくAnnotation用のView(見た目) を　作成する
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewId)
            if annotation.subtitle == "サブタイトルA"{
                pinView?.pinTintColor = UIColor.red
                pinView?.animatesDrop = true
            }
            else{
                pinView?.pinTintColor = UIColor.green
            }
        }
            
        else{
            // あったら　そのまま使用する
            pinView?.annotation = annotation
        }
        // 用意した見た目を返して使ってもらう
        return pinView
    }
    
    @IBAction func changePage(_ sender: UIPageControl) {
        // 緩やかにアニメーションして切り替わるようにする
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset.x = CGFloat(sender.currentPage) * self.innerView.frame.size.width
        }
        //中心の地位を利用者の現在地にする
        mapView.setCenter(locationList[sender.currentPage], animated: true)

    }
    
    // scrollViewのデリゲートに指定したのでスクロールした際に、このメソッドが反応する
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 現在のX座標の位置からpageControllの現在のページ番号を更新しておく
        pageControll.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //中心の地位を利用者の現在地にする
        mapView.setCenter(locationList[pageControll.currentPage], animated: true)
    }

}

