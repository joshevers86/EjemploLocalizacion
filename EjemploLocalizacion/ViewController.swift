//
//  ViewController.swift
//  EjemploLoc
//
//  Created by Jose Navarro Alabarta on 24/2/18.
//  Copyright © 2018 Jose Navarro Alabarta. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var LatitudEtiqueta: UILabel!
    @IBOutlet weak var ExHorEtiqueta: UILabel!
    @IBOutlet weak var LongitudEtiqueta: UILabel!
    @IBOutlet weak var AltitudEtiqueta: UILabel!
    @IBOutlet weak var ExVerEtiqueta: UILabel!
    @IBOutlet weak var norteGeografico: UILabel!
    @IBOutlet weak var norteMagnetico: UILabel!
    
    let manejador = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if  status == .authorizedWhenInUse {
            //manejador poara la localizacion
            manejador.startUpdatingLocation()
            //manejador para la brujula
            manejador.startUpdatingHeading()
        }else{
            manejador.stopUpdatingLocation()
            manejador.stopUpdatingHeading()
        }
    }
    //recibe los dato
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LongitudEtiqueta.text = "Lon: \(manager.location!.coordinate.longitude)"
        LatitudEtiqueta.text = "Lat: \(manager.location!.coordinate.latitude)"
        AltitudEtiqueta.text = "Alt: \(manager.location!.altitude)"
        ExHorEtiqueta.text = "Prec. Hor: \(manager.location!.horizontalAccuracy)"
        ExVerEtiqueta.text = "Prec. Vert: \(manager.location!.verticalAccuracy)"
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alerta = UIAlertController(title: "ERROR", message: "error \(error.localizedDescription)", preferredStyle: .alert)
        
        let accionBotonOk = UIAlertAction(title: "OK", style: .default, handler: {
            accion in
            //..
        })
        //se añade el boton a la alerta
        alerta.addAction(accionBotonOk)
        //
        //self.present(<#T##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        self.present(alerta, animated:true , completion: nil)
    }
    
    //recibe los datos de la brujula
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //nos da los grados de nuestra posicion respecto al norte magnetico y al geografico
        norteMagnetico.text = "Norte Mag: \(newHeading.magneticHeading)"
        norteGeografico.text = "Norte Geog: \(newHeading.trueHeading)"
        
    }
    
    
    
}

