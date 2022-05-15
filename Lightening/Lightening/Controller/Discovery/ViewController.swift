//
//  ViewController.swift
//  Lightening
//
//  Created by claire on 2022/5/15.
//

import UIKit

class ViewController: UIViewController {
    
    var rotatingViews = [RotatingView]()
    let numberOfViews = 5
    var circle = Circle(center: CGPoint(x: width / 2, y: 200), radius: 100
    )
    var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    var prevLocation = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...numberOfViews {
            let angleBetweenViews = (2 * Double.pi) / Double(numberOfViews)
            let viewOnCircle = RotatingView(circle: circle, imageView: imageView, angle: CGFloat(Double(i) * angleBetweenViews))
            rotatingViews.append(viewOnCircle)
            view.addSubview(viewOnCircle)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCircle))
            viewOnCircle.addGestureRecognizer(tapGesture)
            viewOnCircle.addImage()
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(panGesture:)))
        view.addGestureRecognizer(panGesture)
        
    }
    
    @objc func didTapCircle(tapGesture: UITapGestureRecognizer) {
        print("i")
    }
    
    @objc func didPan(panGesture: UIPanGestureRecognizer){
        switch panGesture.state {
        case .began:
            prevLocation = panGesture.location(in: view)
        case .changed, .ended:
            let nextLocation = panGesture.location(in: view)
            let angle = circle.angleBetween(firstPoint: prevLocation, secondPoint: nextLocation)
            
            rotatingViews.forEach({ $0.updatePosition(angle: angle)})
            prevLocation = nextLocation
        default: break
        }
    }
}


struct Circle {
    let center: CGPoint
    let radius: CGFloat
    
    func pointOnCircle(angle: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        
        return CGPoint(x: x, y: y)
    }
    
    func angleBetween(firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        let firstAngle = atan2(firstPoint.y - center.y, firstPoint.x - center.x)
        let secondAngle = atan2(secondPoint.y - center.y, secondPoint.x - center.x)
        let angleDiff = (firstAngle - secondAngle) * -1
        
        return angleDiff
    }
}


class RotatingView: UIView {
    var currentAngle: CGFloat
    let circle: Circle
    let imageView: UIImageView
    
    init(circle: Circle, imageView: UIImageView, angle: CGFloat) {
        self.currentAngle = angle
        self.circle = circle
        self.imageView = imageView
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        center = circle.pointOnCircle(angle: currentAngle)
        backgroundColor = .black
        layer.cornerRadius = 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePosition(angle: CGFloat) {
        currentAngle += angle
        center = circle.pointOnCircle(angle: currentAngle)
    }
    
    func addImage() {
        
        addSubview(imageView)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self.circle, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//
//        NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self.circle, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
//
//        NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
//
//        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        imageView.image = UIImage(named: "black_vinyl-PhotoRoom")
    }
}

