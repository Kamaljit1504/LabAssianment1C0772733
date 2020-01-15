//
//  ViewController.swift
//  LabAssianment1C0772733
//
//  Created by MacStudent on 2020-01-14.
//  Copyright © 2020 MacStudent. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate
{
   
    @IBOutlet weak var trBy: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    
@IBOutlet weak var zoomStepper: UIStepper!
var userLocation = [CLLocation]()
var locationManager = CLLocationManager()
  var requiredCoordinate: CLLocationCoordinate2D!
  var pinLocation: CLLocationCoordinate2D!
  var pin : Int = 0
  var distance = [Double]()
   
    @IBOutlet weak var mapView: MKMapView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //stepper
     zoomStepper.value = 0
     zoomStepper.minimumValue = -5
     zoomStepper.maximumValue = 5
    //set latitude na d longitude
    let latitude:CLLocationDegrees = 43.64
    let longitude:CLLocationDegrees = -79.38
     
    //set delta longitude and latitude
    let latDelta:CLLocationDegrees = 0.05
    let longDelta:CLLocationDegrees = 0.05
     

    let span=MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
     

    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

    let region = MKCoordinateRegion(center: location, span: span)
     
    //set the region on map
    mapView.setRegion(region, animated: true)
    // Do any additional setup after loading the view.
     
    mapView.delegate = self
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    adddoubleTap()
  }
   
  @IBAction func btnRoute(_ sender: Any) {
     
    direction(sourcePlaceMark: MKPlacemark(coordinate: locationManager.location!.coordinate), destinationPlacMark: MKPlacemark(coordinate: pinLocation))
     
  }
  func direction(sourcePlaceMark: MKPlacemark , destinationPlacMark: MKPlacemark){
          
          let request = MKDirections.Request()
          request.source = MKMapItem(placemark: sourcePlaceMark)
          request.destination = MKMapItem(placemark: destinationPlacMark)
    if segment.selectedSegmentIndex == 0
    {
       
        request.transportType = .automobile
        trBy.text="by car"
        
    }
     else if segment.selectedSegmentIndex == 1
        {
            trBy.text = "Walking"
            request.transportType = .automobile
        }
    else if segment.selectedSegmentIndex == 2
    {
        trBy.text = "By bus"
        request.transportType = .automobile
    }
    else
    {
        trBy.text = "By Train"
        request.transportType = .automobile
    }
    
    let directions = MKDirections(request: request)
    directions.calculate { [unowned self] response, error in
      guard let unwrappedResponse = response else { return }
            for route in unwrappedResponse.routes {
            self.mapView.addOverlay(route.polyline)
                         
    }
    }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
      renderer.strokeColor = UIColor.blue
      return renderer
    }
    
    
    @IBAction func trvelBy(_ sender: UISegmentedControl)
    {
        
    }
    
    
    
    func zoomMap(byFactor delta: Double) {
      var region: MKCoordinateRegion = self.mapView.region
      var span: MKCoordinateSpan = mapView.region.span
      span.latitudeDelta *= delta
      span.longitudeDelta *= delta
      region.span = span
      mapView.setRegion(region, animated: true)
    }
     
     
     
    @IBAction func zoomStepperPressed(_ sender: UIStepper)
    {
      if sender.value < 0
      {
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        mapView.setRegion(region, animated: true)
        zoomStepper.value = 0
      }
      else
      {
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mapView.setRegion(region, animated: true)
        zoomStepper.value = 0
      }
    }
    
}
extension ViewController : UIGestureRecognizerDelegate, MKMapViewDelegate {
  func adddoubleTap() {
    
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
    doubleTap.numberOfTapsRequired = 2
    doubleTap.delegate = self
    mapView.addGestureRecognizer(doubleTap)
      }
  @objc func dropPin(sender: UITapGestureRecognizer) {
    
    deletePin()
    pin = pin + 1
    mapView.removeOverlays(mapView.overlays)
    let touchPoint = sender.location(in: mapView)
    let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
    let annotation = Pin(coordinate: coordinate, identifier: "pin")
    mapView.addAnnotation(annotation)

    
    pinLocation = coordinate
//
//  if (pin==2)
//  {
//    deletePin()
//  }
//  else
//  {
//
//  }
  requiredCoordinate = coordinate  }
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
      }
    let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
    pinAnnotation.animatesDrop = true
    return pinAnnotation
    
  }
  
  func deletePin() {
  for annotation in mapView.annotations {
    mapView.removeAnnotation(annotation)
      }
    
  }
 }
