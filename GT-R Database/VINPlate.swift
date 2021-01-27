//
//  VINPlate.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 21/1/21.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct VINButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color(UIColor.lightGray) : Color.white).frame(height: 40).cornerRadius(8)
    }
}

struct TableViewButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color(UIColor.lightGray) : Color.white).frame(height: 40)
    }
}

struct TableViewTopButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color(UIColor.lightGray) : Color.white).frame(height: 40).cornerRadius(8, corners: [.topLeft, .topRight])
    }
}

struct TableViewBottomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color(UIColor.lightGray) : Color.white).frame(height: 40).cornerRadius(8, corners: [.bottomLeft, .bottomRight])
    }
}

struct VINPlate: View {
    var delegate: VINPlateDelegate?
    var series: String = "R32"
    var checkString: String = "No result found. Recheck last 6 digits of chassis number"
    var failedSearch = false {
        didSet {
            if failedSearch == false {
                checkString = "Check last 6 digits of chassis number"
            } else {
                checkString = "No result found. Recheck last 6 digits of chassis number"
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
                ScrollView {
                    VStack(alignment: .center, spacing: 20, content: {
                        
                        Text(checkString)
                            .font(font)
                            .padding()
                        
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
                        
                        Text("If your car has a 17 digit VIN starting with JNI try:")
                            .font(font)
                        
                        VStack(alignment: .center, spacing: 0) {
                            Button(action: {
                                delegate?.didTapVINRangesButton()
                            }, label: {
                                HStack {
                                    Text("Great Britain")
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
                            }).buttonStyle(TableViewTopButtonStyle())
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   minHeight: 0,
                                   maxHeight: .infinity)
                            .overlay(Divider(), alignment: .bottom)
                            
                            Button(action: {
                                delegate?.didTapVINRangesButton()
                            }, label: {
                                HStack {
                                    Text("Hong Kong")
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
                            }).buttonStyle(TableViewButtonStyle())
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   minHeight: 0,
                                   maxHeight: .infinity)
                            .overlay(Divider(), alignment: .bottom)
                            
                            Button(action: {
                                delegate?.didTapVINRangesButton()
                            }, label: {
                                HStack {
                                    Text("New Zealand")
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
                            }).buttonStyle(TableViewButtonStyle())
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   minHeight: 0,
                                   maxHeight: .infinity)
                            .overlay(Divider(), alignment: .bottom)
                            
                            Button(action: {
                                delegate?.didTapVINRangesButton()
                            }, label: {
                                HStack {
                                    Text("Singapore")
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
                            }).buttonStyle(TableViewButtonStyle())
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   minHeight: 0,
                                   maxHeight: .infinity)
                            .overlay(Divider(), alignment: .bottom)
                            
                            Button(action: {
                                delegate?.didTapVINRangesButton()
                            }, label: {
                                HStack {
                                    Text("Australia")
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
                            }).buttonStyle(TableViewBottomButtonStyle())
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }.overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 0.5)).frame(minWidth: 0, maxWidth: 250, minHeight: 201, maxHeight: 201)
                        
                        Text("Still having problems finding your car?").font(font)
                        
                        Button(action: {
                            delegate?.didTapVINRangesButton()
                        }, label: {
                            HStack {
                                Text("Contact Us")
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
                        .padding(.bottom, 10)
                        
                    }).ignoresSafeArea()
                }
            }).ignoresSafeArea()
        }.ignoresSafeArea(.keyboard)
    }
}


struct VINPlate_Previews: PreviewProvider {
    static var previews: some View {
        VINPlate()
            .previewLayout(.fixed(width: 350, height: 700))
        
    }
}
