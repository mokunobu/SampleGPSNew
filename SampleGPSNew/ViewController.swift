//
//  ViewController.swift
//  SampleGPSNew
//
//  Created by 先生 on 2021/01/21.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {
    //GPS系の処理を任せてもらうため必要なルール
    @IBOutlet weak var labelLat: UILabel!
    @IBOutlet weak var labelLon: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var inputLat: UITextField!
    @IBOutlet weak var inputLon: UITextField!
    
    var locationManager: CLLocationManager!
    
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
        
        //中心の地位を利用者のの現在にする
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.userTrackingMode = MKUserTrackingMode.follow
        //mapView.userTrackingMode = MKUserTrackingMode.FollowWithHeading
        //ピンを全て削除
        mapView.removeAnnotations(mapView.annotations);
         // 新しいピンを作成
        let annotation: MKPointAnnotation = MKPointAnnotation();
        annotation.coordinate = CLLocationCoordinate2DMake(43.065888,141.354594);
        annotation.title = "テスト　アノテーション";
        annotation.subtitle = "サブタイトル";
        mapView.delegate = self

        //ピンを追加
        mapView.addAnnotation(annotation);
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clikGet(sender: UIButton) {
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
                pinImageView?.image = UIImage(named: "playerr.jpg")
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
            if annotation.subtitle!! == "サブタイトルA"{
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
}

