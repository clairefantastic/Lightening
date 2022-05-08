//
//  UserProfileView.swift
//  Lightening
//
//  Created by claire on 2022/4/23.
//

import UIKit

class UserProfileView: UIView {
    
    let profileImageView = UIImageView()
    
    var imageUrl: String? {
        
        didSet {
            
            if imageUrl == nil {
                
                profileImageView.image = UIImage(named: "black_vinyl-PhotoRoom")
                
                LKProgressHUD.dismiss()
                
            } else {
                
                profileImageView.image = UIImage(named: "black_vinyl-PhotoRoom")
                
                profileImageView.loadImage(imageUrl)
                
                LKProgressHUD.dismiss()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func centreArcPerpendicular(text str: String, context: CGContext, radius: CGFloat, angle theta: CGFloat, colour: UIColor, font: UIFont, clockwise: Bool) {

        let characters: [String] = str.map { String($0) } // An array of single character strings, each character in str
        let letter = characters.count
        let attributes = [NSAttributedString.Key.font: font]

        var arcs: [CGFloat] = [] // This will be the arcs subtended by each character
        var totalArc: CGFloat = 0 // ... and the total arc subtended by the string

        // Calculate the arc subtended by each letter and their total
        for count in 0 ..< letter {
            arcs += [chordToArc(characters[count].size(withAttributes: attributes).width, radius: radius)]
            totalArc += arcs[count]
        }

        // Are we writing clockwise (right way up at 12 o'clock, upside down at 6 o'clock)
        // or anti-clockwise (right way up at 6 o'clock)?
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection: CGFloat = clockwise ? -.pi / 2 : .pi / 2

        // The centre of the first character will then be at
        // thetaI = theta - totalArc / 2 + arcs[0] / 2
        // But we add the last term inside the loop
        var thetaI = theta - direction * totalArc / 2

        for count in 0 ..< letter {
            thetaI += direction * arcs[count] / 2
            // Call centerText with each character in turn.
            // Remember to add +/-90º to the slantAngle otherwise
            // the characters will "stack" round the arc rather than "text flow"
            centre(text: characters[count], context: context, radius: radius, angle: thetaI, colour: colour, font: font, slantAngle: thetaI + slantCorrection)
            // The centre of the next character will then be at
            // thetaI = thetaI + arcs[i] / 2 + arcs[i + 1] / 2
            // but again we leave the last term to the start of the next loop...
            thetaI += direction * arcs[count] / 2
        }
    }

    func chordToArc(_ chord: CGFloat, radius: CGFloat) -> CGFloat {
        // *******************************************************
        // Simple geometry
        // *******************************************************
        return 2 * asin(chord / (2 * radius))
    }

    func centre(text str: String, context: CGContext, radius: CGFloat, angle theta: CGFloat, colour: UIColor, font: UIFont, slantAngle: CGFloat) {
        // *******************************************************
        // This draws the String str centred at the position
        // specified by the polar coordinates (r, theta)
        // i.e. the x= r * cos(theta) y= r * sin(theta)
        // and rotated by the angle slantAngle
        // *******************************************************

        // Set the text attributes
        let attributes = [NSAttributedString.Key.foregroundColor: colour, NSAttributedString.Key.font: font]
        //let attributes = [NSForegroundColorAttributeName: c, NSFontAttributeName: font]
        // Save the context
        context.saveGState()
        // Undo the inversion of the Y-axis (or the text goes backwards!)
        context.scaleBy(x: 1, y: -1)
        // Move the origin to the centre of the text (negating the y-axis manually)
        context.translateBy(x: radius * cos(theta), y: -(radius * sin(theta)))
        // Rotate the coordinate system
        context.rotate(by: -slantAngle)
        // Calculate the width of the text
        let offset = str.size(withAttributes: attributes)
        // Move the origin by half the size of the text
        context.translateBy(x: -offset.width / 2, y: -offset.height / 2) // Move the origin to the centre of the text (negating the y-axis manually)
        // Draw the text
        str.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        // Restore the context
        context.restoreGState()
    }

    // *******************************************************************
    // Scale & translate the context to have 0,0
    // at the centre of the screen maths convention
    // Obviously change your origin to suit...
    // *******************************************************************

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }
        let size = self.bounds.size

        context.translateBy(x: size.width / 2, y: size.height / 2)
        context.scaleBy(x: 1, y: -1)

        centreArcPerpendicular(text: "H  e  l  l  o   L  i  g  h  t  y",
                               context: context, radius: 60,
                               angle: -30,
                               colour: UIColor.black,
                               font: UIFont(name: "American Typewriter", size: 16) ?? UIFont.systemFont(ofSize: 16),
                               clockwise: true)
        centreArcPerpendicular(text: "C  a  r  p  e   D  i  e  m",
                               context: context,
                               radius: 60,
                               angle: 29.7,
                               colour: UIColor.black,
                               font: UIFont(name: "American Typewriter", size: 16) ?? UIFont.systemFont(ofSize: 16),
                               clockwise: false)
        
    }
    
    func addProfileImageView() {
        
        addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: profileImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        NSLayoutConstraint(item: profileImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 80).isActive = true
        
        profileImageView.layer.masksToBounds = true
        
        profileImageView.layer.cornerRadius = 40
        
        profileImageView.layer.borderColor = UIColor.black.cgColor
        
        profileImageView.layer.borderWidth = 1
        
        profileImageView.contentMode = .scaleAspectFill
    
    }
    
}
