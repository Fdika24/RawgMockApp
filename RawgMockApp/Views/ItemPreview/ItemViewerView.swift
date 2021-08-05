//
//  ItemViewerView.swift
//  RawgMockApp
//
//  Created by Farhandika Zahrir Mufti guenia on 04/08/21.
//


import SwiftUI

struct ItemViewerView: View {
   @State var isDrag:Bool = false
   @ViewBuilder var body: some View {
        ZStack(alignment:.bottom){
            Color.black
            VStack {
                RemoteImage(url: "https://media.rawg.io/media/screenshots/999/9996d2692128d717880d2be9f9351765.jpg")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.width, height: UIScreen.height*0.4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Spacer()
            }
            //MARK: Scroll View Content
            ScrollViewContent(isDrag: $isDrag)
            //MARK: Navbar
            Rectangle()
                .fill(Color.white.opacity(isDrag ? 1:0))
                .frame(width: UIScreen.width, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .shadow(color: .black.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                .offset(y:-UIScreen.height*0.90)
                .animation(.easeInOut)
            NavbarItemViewer(isDrag: $isDrag)
        }.ignoresSafeArea(edges: .top)
    }
}

struct ItemViewerView_Previews: PreviewProvider {
    static var previews: some View {
        ItemViewerView()
    }
}

struct NavbarItemViewer: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isDrag:Bool
    @ViewBuilder var body: some View {
        VStack{
            HStack{
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .shadow(color:.black.opacity(isDrag ? 0:0.2),radius: 2)
                        )
                }
                Spacer()
                Text("Rumah Makan Ampera")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                    .opacity(isDrag ? 1:0)
                    .animation(.easeInOut)
                Spacer()
                Image(systemName: "bookmark.fill")
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(99)
            }
            .padding(.horizontal)
            .offset(y:UIScreen.height*0.07)
            Spacer()
        }
    }
}


struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct ScrollViewContent: View {
    @State private var location: CGFloat = CGFloat.zero
    @Binding var isDrag:Bool
    @ObservedObject var itemPreviewVM = ItemPreviewVM()
    
    @ViewBuilder  var body: some View {
        ScrollView{
            VStack(alignment:.leading){
                HStack {
                    VStack(alignment:.leading){
                        Text("Rumah Makan Ampera")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .padding(.top,20)
                            .padding(.horizontal)
                        Text("Valve Software")
                            .font(.caption)
                            .fontWeight(.light)
                            .padding(.horizontal)
                    }
                    Spacer()
                    Image("teen")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                }
                HStack{
                    ForEach(0..<5){_ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }.padding(.horizontal)
                HStack{
                    Text("Shooter")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .fontWeight(.regular)
                        .padding(5)
                        .padding(.horizontal,10)
                        .background(Color.black)
                        .cornerRadius(99)
                }
                .padding(.horizontal)
                Text("Description")
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.horizontal)
                Text(itemPreviewVM.desc)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                //MARK: Makanan
                Rectangle()
                    .fill(Color.white)
                    .frame(height:UIScreen.height*0.45)
                Spacer()
                
            }
            .frame(minHeight:UIScreen.height)
            .background(GeometryReader {
                Color.white.preference(key: ViewOffsetKey.self,
                                       value: -$0.frame(in: .named("memes")).origin.y)
            })
            .cornerRadius(15)
            .offset(y:UIScreen.height*0.34)
            .frame(width:UIScreen.width)
            .onPreferenceChange(ViewOffsetKey.self) {
                if $0 > -66 {
                    self.isDrag = true
                } else {
                    self.isDrag = false
                }
                self.location = $0 //This is for debug, when production, end it
            }
        }
        .coordinateSpace(name: "memes")
        .frame(height:UIScreen.height)
    }
}
