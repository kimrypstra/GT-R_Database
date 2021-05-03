//
//  HeaderView.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 29/4/21.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("bannerTop"), Color("bannerBottom")]), startPoint: .top, endPoint: .bottom)
                VStack {
                    Spacer(minLength: 30)
                    HStack(alignment: .center, spacing: nil, content: {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(20)
                        Spacer(minLength: 125)
                        VStack(alignment: .trailing, content: {
                            Text("Supported by")
                                .font(Font.custom("NissanOpti", size: 10))
                                .foregroundColor(.white)
                                .padding([.top, .trailing], 10)
                            Button(action: {
                                      print("button pressed")
                                    }) {
                                        Image("torqueGT")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding([.trailing, .bottom], 10)
                                    }
                        }).ignoresSafeArea()
                    }).ignoresSafeArea()
                }
            }
        }).ignoresSafeArea()
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .previewLayout(.fixed(width: 385, height: 130))
    }
}
