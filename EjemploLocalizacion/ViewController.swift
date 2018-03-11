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
    var posicionAnterior = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        //filtro para la localizacion --> manejador.distanceFilter = (en metros) por defecto --> kCLDistanceFilterNone
        //[Best, NearestTenMeters,HundredMeters,Kilometers,ThreeKilometers,kCLDistanceFilterNone
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : CLLocationManagerDelegate{
    //es obligatorio llamarlo para inicializar las lecturas si no no se realizan
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if  status == .authorizedWhenInUse {
            //manejador poara la localizacion
            manejador.startUpdatingLocation()
            //manejador para la brujula
            manejador.startUpdatingHeading()
            posicionAnterior = manager.location!
        }else{
            manejador.stopUpdatingLocation()
            manejador.stopUpdatingHeading()
        }
    }
    //recibe las lecturas
    //CLLocation contiene toda la informacion necesaria para la localizacion del dispositivo
    /*CLLocation da 6 propieades
      1) locations[0].coordinate.[latitude longitude] dadas en grados
      2) locations[0].horizontalAccuracy ratio de precision de la lectura
      3) locations[0].altitude altura sobre el nivel del mar
      4) locations[0].verticalAccuracy precision segun la altitud del dispositivo
      5) locations[0].floor altitud desde la base de un edificio
      6) locations[0].timestamp tiempo transcurrido desde la ultima lectura
     */
    //CLLocationManager tiene la ultima lectura que recibe la funcion usando esto no hace falta acceder al array
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LongitudEtiqueta.text = "Lon: \(manager.location!.coordinate.longitude)"
        LatitudEtiqueta.text = "Lat: \(manager.location!.coordinate.latitude)"
        AltitudEtiqueta.text = "Alt: \(manager.location!.altitude)"
        ExHorEtiqueta.text = "Prec. Hor: \(manager.location!.horizontalAccuracy)"
        ExVerEtiqueta.text = "Prec. Vert: \(manager.location!.verticalAccuracy)"
        
        //Para conocer la distancia ente una posicion y otra
        let distancia = manager.location!.distance(from: posicionAnterior) //retorna un objeto del tipo CLLocationDistance
        posicionAnterior = manager.location!
        print("Instante de la lectura: \(manager.location!.timestamp) distancia transcurrida: \(distancia)")
    }
    
    //cuando no hay señal gps ni nada disponible para la localizacion
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alerta = UIAlertController(title: "ERROR", message: "error \(error.localizedDescription)", preferredStyle: .alert)
        
        let accionBotonOk = UIAlertAction(title: "OK", style: .default, handler: {
            accion in
            //..
        })
        //se añade el boton a la alerta
        alerta.addAction(accionBotonOk)
        self.present(alerta, animated:true , completion: nil)
    }
    
    //recibe los datos de la brujula
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //nos da los grados de nuestra posicion respecto al norte magnetico y al geografico
        norteMagnetico.text = "Norte Mag: \(newHeading.magneticHeading)"
        norteGeografico.text = "Norte Geog: \(newHeading.trueHeading)"
    }
}

