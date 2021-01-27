//
//  ScreenshotView.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 16/1/21.
//

import SwiftUI
import SceneKit

struct ScreenshotView: View {
    
    var title: String = "Test"
    var vin: String? = "Test"
    var grade: String? = "Test"
    var colour: String? = "Test"
    var productionDate: String? = "Test"
    var modelCode: String? = "Test"
    var seat: String? = "Test"
    var carImage: UIImage? = UIImage(named: "r34side")
    var interiorCode: String? = "Test"
    
    var edgeInset: CGFloat = 10
    var backgroundColour: Color = Color(.white)
    var textColour: Color = Color(.black)
    var mainTextSize: CGFloat = 12
    
    mutating func setup(title: String, vin: String?, grade: String?, colourText: String?, productionDate: String?, modelCode: String?, seat: String?, carImage: UIImage?, interiorCode: String?) {
        self.title = title
        self.vin = vin
        self.grade = grade
        self.colour = colourText
        self.productionDate = productionDate
        self.modelCode = modelCode
        self.seat = seat
        self.carImage = carImage
        self.interiorCode = interiorCode
    }
    
    var body: some View {
        GeometryReader {geometry in
            ZStack {
                Color(UIColor.white).ignoresSafeArea()
                //Gradient(colors: [Color(UIColor.white), Color(UIColor.gray)])
                
                VStack(alignment: .center, spacing: 0, content: {
                    HStack(alignment: .center, spacing: 0, content: {
                        ZStack {
                            Color(.black).frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15, alignment: .center).cornerRadius(8)
                            Image("logo").resizable().frame(width: geometry.size.width * 0.12, height: geometry.size.height * 0.12, alignment: .center).padding(edgeInset)
                        }
                        VStack(alignment: HorizontalAlignment.leading, spacing: nil, content: {
                            // MARK: Title
                            Text(title).foregroundColor(textColour).font(Font.custom("NissanOpti", size: 20))
                            // MARK: Subtitle
                            Text("Information retreived from gtr-registry.com").foregroundColor(textColour).font(Font.custom("Futura", size: 12))
                            
                        })
                        
                        Spacer()
                        
                    })
                    if stringIsValid(vin) {
                        HStack {
                            Text("VIN").foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                            Spacer()
                            Text(vin!).foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                        }
                    }
                    
                    if stringIsValid(grade) {
                        HStack {
                            Text("Grade").foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                            Spacer()
                            Text(grade!).foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                        }
                    }
                    
                    if stringIsValid(colour) {
                        HStack {
                            Text("Colour").foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                            Spacer()
                            Text(colour!).foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                        }
                    }
                    
                    if stringIsValid(productionDate) {
                        HStack {
                            Text("Production Date").foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                            Spacer()
                            Text(productionDate!).foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                        }
                    }
                    
                    if stringIsValid(modelCode) {
                        HStack {
                            Text("Model Code").foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                            Spacer()
                            Text(modelCode!).foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                        }
                    }
                    
                    if stringIsValid(seat) {
                        HStack {
                            Text("Seat").foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                            Spacer()
                            Text(seat!).foregroundColor(textColour).font(Font.custom("NissanOpti", size: mainTextSize)).padding(edgeInset)
                        }
                    }
                    
                    if carImage != nil {
                        Image(uiImage: carImage!).resizable().aspectRatio(contentMode: .fit).cornerRadius(8)

                    }
                    
                    //SceneView()
                    
                    
                }).padding(5)
            }
        }.ignoresSafeArea().ignoresSafeArea(.keyboard)
    }
    
    func stringIsValid(_ string: String?) -> Bool {
        guard string != nil else {
            return false
        }
        guard string != "" else {
            return false
        }
        guard string != " " else {
            return false
        }
        // We can force unwrap string here because it's already established to not be nil in the first check 
        guard string!.contains("Unknown") == false else {
            return false
        }
        
        return true
    }
}



struct ScreenshotView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotView(title: "Screenshot View")
            .previewLayout(.fixed(width: 375
                                  , height: 375))
    }
}

//struct SceneView: UIViewRepresentable {
//    let scene = SCNScene()
//
//    func makeUIView(context: Context) -> SCNView {
//
//        // create a box
//        scene.rootNode.addChildNode(createBox())
//
//        // code for creating the camera and setting up lights is omitted for simplicity
//        // …
//
//        // retrieve the SCNView
//        let scnView = SCNView()
//        scnView.scene = scene
//        return scnView
//    }
//
//    func updateUIView(_ scnView: SCNView, context: Context) {
//        scnView.scene = scene
//
//        // allows the user to manipulate the camera
//        scnView.allowsCameraControl = true
//
//        // configure the view
//        scnView.backgroundColor = UIColor.gray
//
//        // show statistics such as fps and timing information
//        scnView.showsStatistics = true
//        scnView.debugOptions = .showWireframe
//    }
//
//    func createBox() -> SCNNode {
//        let boxGeometry = SCNBox(width: 20, height: 24, length: 40, chamferRadius: 0)
//        let box = SCNNode(geometry: boxGeometry)
//        box.name = "box"
//        return box
//    }
//
//    func removeBox() {
//        // check if box exists and remove it from the scene
//        guard let box = scene.rootNode.childNode(withName: "box", recursively: true) else { return }
//        box.removeFromParentNode()
//    }
//
//    func addBox() {
//        // check if box is already present, no need to add one
//        if scene.rootNode.childNode(withName: "box", recursively: true) != nil {
//            return
//        }
//        scene.rootNode.addChildNode(createBox())
//    }
//}
