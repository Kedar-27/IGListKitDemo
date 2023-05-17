//
//  ProfileView.swift
//  IGListKitDemo
//
//  Created by Koo on 13/03/23.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var scrollOffset = CGPoint()
    
  
    
    
    var body: some View {
    
        GeometryReader{ proxy in
            ZStack(alignment: .top){
                Image("batman")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    
                    .frame(
                        width: proxy.size.width,
                        height: getHeightForHeaderImage(proxy)
                    )
                    .clipped()
                    .onTapGesture {
                        print(proxy.size.height)
                    }
                ProfileContentView(scrollOffset: $scrollOffset)
    
            }
            .edgesIgnoringSafeArea(.all)
            .frame(width: proxy.size.width,height: proxy.size.height)
            
        }
    
    }

    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = self.scrollOffset.y
        let imageHeight = geometry.size.width

        if offset < 0 {
            return imageHeight - offset
        }

        return imageHeight
    }
    
    
}


struct ProfileContentView: View {

    @State var isScrollEnabled: Bool = true

    @Binding var scrollOffset: CGPoint
    
        
    
    var body: some View {
        GeometryReader{ proxy in
            OffsetObservingScrollView(offset: $scrollOffset,isScrollEnabled: $isScrollEnabled) {
                VStack {
                    Color.clear
                        .frame(height: proxy.size.width * 0.9)
                    ZStack(alignment: .top) {
                        Color.white
                            .cornerRadius(20)
                        
                        ProfileSheetView(scrollOffset: $scrollOffset,isScrollEnabled: $isScrollEnabled)
                
                    }
                    
                    
                }
//                .onChange(of: self.scrollOffset) { _ in
//                    print(scrollOffset)
//                    if self.scrollOffset.y >= proxy.size.width * (0.9 - 0.2){
//                        self.isScrollEnabled = false
//
//                    }else{
//                        self.isScrollEnabled = true
//                    }
//                }

                .frame(height: getAvailableHeight(proxy: proxy))
            }
        }
    }
    
    func getAvailableHeight(proxy: GeometryProxy) -> CGFloat{
        let screenHeight = proxy.size.height
        let thresholdOffsetFromTop: CGFloat = 0.2
        let upperTabAreaHeight: CGFloat = 150 + 20
        let transparentViewHeight = proxy.size.width * (0.9 - thresholdOffsetFromTop)
        
        return screenHeight + upperTabAreaHeight + transparentViewHeight
    }
        
    
    
}
struct ProfileSheetView: View {
   // var list = ["plus","minus","square.and.arrow.up", "heart"]

    @State var tabs: [Tabs] =
    [
        Tabs(title: "Koo", id: "koo", image: "plus", bgColor: .red),
        Tabs(title: "Like", id: "like", image: "minus", bgColor: .yellow),
        Tabs(title: "Comment", id: "comment", image: "square.and.arrow.up", bgColor: .blue),
        Tabs(title: "ReKoo", id: "rekoo", image: "heart", bgColor: .brown),
    ]
    @State var selectedTabs: Tabs? = nil
    
    @Binding var scrollOffset: CGPoint
    
    // External Scroll
    @Binding var isScrollEnabled: Bool
    
    @State var isInternalScrollEnabled: Bool = false

    @State var headerYPoint: CGFloat = 0
    
    
    let spacerHeight: CGFloat = 20

    var body: some View {
        GeometryReader{ proxy in
            
            VStack(alignment: .leading,spacing: 0){
                Spacer()
                    .frame(height: spacerHeight)
                Text("Batman is a superhero published by DC Comics. Operating in Gotham City, he serves as its protector, using the symbol of a bat to strike fear into the hearts of criminals. Unlike other superheroes, Batman is often depicted to lack any \"superpowers\", instead using lifelong training and equipment to fight crime. His secret identity is Bruce Wayne, a rich playboy and philanthropist who swore to fight crime after witnessing his parents' brutal murder")
                    .multilineTextAlignment(.leading)
                    .frame(width: proxy.size.width * 0.88, height: 150)
                    .alignmentGuide(.leading) { d in
                        d[.leading] - 20
                    }
                
                GeometryReader { geo in
                    HStack(alignment: .center) {
                        
                        ForEach( self.tabs) { tab in
                            Spacer()
                            Button {
                                print("Switch Tabs")
                            } label: {
                                Image(systemName: tab.image)
                            }
                            
                            Spacer()
                            
                        }
                        
                        
                        
                    }
                    .frame(width: proxy.size.width,height: 70)
                    .background(Color.gray.opacity(0.3))
//                    .anchorPreference(key: FooAnchorPreferenceKey.self,
//                                      value: .bounds,
//                                      transform: {FooAnchorData(anchor: $0) })
//                    .onPreferenceChange(FooAnchorPreferenceKey.self) { data in
//                        self.headerAnchorPoint = proxy[data.anchor!].origin
//
//                    }
                    .onAppear{
                        headerYPoint = geo.frame(in: .global).origin.y
                    }
                    
                }
                .frame(width: proxy.size.width,height: 70)

                TabView(selection: $selectedTabs) {
                    ForEach(self.tabs) { tab in
                        MyView(bgColor: tab.bgColor, isScrollEnabled: $isInternalScrollEnabled)
                        
                    }

                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                
                
            }
            .onChange(of: self.scrollOffset) { _ in
                print(scrollOffset)
                if self.scrollOffset.y >= (headerYPoint - proxy.size.width * 0.2){
                    self.isInternalScrollEnabled = true
                    
                }else{
                   self.isInternalScrollEnabled = false
                }
                
            }.onChange(of: self.isInternalScrollEnabled) { _ in
                self.isScrollEnabled = !isInternalScrollEnabled
            }
            
        }
    }
  

}
struct FooAnchorData: Equatable {
    var anchor: Anchor<CGRect>? = nil
    static func == (lhs: FooAnchorData, rhs: FooAnchorData) -> Bool {
        return false
    }
}

struct FooAnchorPreferenceKey: PreferenceKey {
    static let defaultValue = FooAnchorData()
    static func reduce(value: inout FooAnchorData, nextValue: () -> FooAnchorData) {
        value.anchor = nextValue().anchor ?? value.anchor
    }
}
//struct ProfileView_Previews: PreviewProvider {
//   static var previews: some View {
//        ProfileView()
//    }
//}
