//
//  SelectLocationMapView.swift
//  Lightening
//
//  Created by claire on 2022/4/20.
//

import UIKit
import MapKit

class SelectLocationMapView: UIView {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    // 詢問使用者是否取得當前位置的授權
    let nibName = "SelectLocationMapView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
