//
//  VINPlate.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 21/1/21.
//

import SwiftUI

struct VINButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color(UIColor.lightGray) : Color.white).frame(height: 40).cornerRadius(8)
        }
    
}

struct VINPlate: View {
    var delegate: VINPlateDelegate?
    var series: String = "R32"
    var checkVerb: String = "Check"
    var failedSearch = false {
        didSet {
            if failedSearch == false {
                checkVerb = "Check"
            } else {
                checkVerb = "Recheck"
            }
        }
    }
    
    var font = Font.custom("NissanOpti", size: 10)
    
    var resultColour: Color {
        if failedSearch == true {
            return Color.black
        } else {
            return Color.clear
        }
    }
    
    var sideInsets = EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40)
    
    var body: some View {
        GeometryReader {geometry in
            ZStack(alignment: .top, content: {
                VStack(alignment: .center, spacing: 20, content: {
                    
                    Text("No result found")
                        .font(font)
                        .foregroundColor(resultColour)
                        .padding(.top, 20)
                    
                    Text("\(checkVerb) last 6 digits of chassis number")
                        .font(font)
                    
                    Image("\(series)VinPlate")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(sideInsets)
                    
                    Text("Check your number is in the VIN ranges for \(series)")
                        .font(font)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        delegate?.didTapVINRangesButton()
                    }, label: {
                        HStack {
                            Text("VIN Ranges")
                                .font(font)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.gray)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 13)
                        }
                    }).buttonStyle(VINButtonStyle())
                    .frame(width: 250, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 0.5))
                    //Spacer()
                    
                }).ignoresSafeArea()
            }).ignoresSafeArea()
            
        }.ignoresSafeArea(.keyboard)
    }
}


struct VINPlate_Previews: PreviewProvider {
    static var previews: some View {
        VINPlate()
            .previewLayout(.fixed(width: 350, height: 350))
            
    }
}
