//
//  HomeView.swift
//  ComplexAnimation
//
//  Created by Pouya Sadri on 07/03/2024.
//

import SwiftUI

let tags: [String] =  ["History", "Classical", "Biography", "Cartoon", "Adventure", "Fairy", "Fantasy"]

struct HomeView: View {
	
	@State var activeTag : String = "Biography"
	@Namespace private var animation
	
	@State var showDetail : Bool = false
	@State var selectedBook : Book?
	@State var animateCurrentBook : Bool = false
	
    var body: some View {
		VStack(spacing: 16){
			HStack{
				Text("Browse")
					.font(.largeTitle.bold())
				
			}
			.frame(maxWidth: .infinity,alignment: .leading)
			.padding(.horizontal,16)
			
			TagsView()
			
			GeometryReader{ reader in
				let size = reader.size
				
				ScrollView(.vertical,showsIndicators: false){
					VStack(spacing:35){
						ForEach(sampleBooks, id: \.self){ book in
								BookCardView(book: book)
								.onTapGesture {
									withAnimation(.easeIn(duration: 0.15)){
										animateCurrentBook = true
										selectedBook = book
									}
									DispatchQueue.main.asyncAfter(deadline: .now() + 0.15){
										withAnimation(.interactiveSpring(response: 0.6,dampingFraction: 0.7,blendDuration: 0.7)){
											showDetail = true
										}
									}
								}
						}
					}
					.padding(.bottom,bottomPadding(size:size))
					
				}
				.coordinateSpace(name: "SCROLLVIEW")
				
			}
		}
		.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
		.padding(.horizontal,16)
		.background(
			Rectangle()
				.fill(.white)
				.ignoresSafeArea()
				.opacity(showDetail ? 1 : 0)
		)
		.overlay{
			if let selectedBook = selectedBook, showDetail{
				DetailView(isShowing: $showDetail, book: selectedBook, animation: animation)
					.transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
			}
		}
		.onChange(of: showDetail){newValue in
			if !newValue{
				withAnimation(.linear(duration:0.3).delay(0.2)){
					animateCurrentBook = false
				}
			}
		}
    }
	
	func bottomPadding(size: CGSize) -> CGFloat{
		let cardHeight : CGFloat = 220
		let scrollHeight : CGFloat = size.height
		return scrollHeight - cardHeight
	}
	
	@ViewBuilder
	func BookCardView(book: Book) -> some View{
		GeometryReader{ reader in
			let size = reader.size
			let rect = reader.frame(in: .named("SCROLLVIEW"))
			
			HStack(spacing: -20){
				VStack(alignment:.leading,spacing:8){
					Text(book.title)
						.font(.title3)
						.fontWeight(.semibold)
					
					Text("By \(book.author)")
						.font(.caption)
						.foregroundStyle(.secondary)
					
					RatingView(rating: book.rating)
					
					Spacer(minLength: 4)
					
					HStack{
						Text("\(book.bookView)")
							.fontWeight(.semibold)
							.foregroundStyle(.cyan)
						
						Text("Views")
							.font(.caption)
							.foregroundStyle(.gray)
						
						Spacer(minLength: 0)
						
						Image(systemName: "chevron.right")
							.font(.caption)
							.foregroundStyle(.gray)
					}
					
				}
				.padding(20)
				.frame(width: size.width/2, height: size.height * 0.8)
				.background(
					RoundedRectangle(cornerRadius: 10,style: .continuous)
						.fill(.white)
						.shadow(color: .black.opacity(0.08), radius: 8,x: 5, y: 5)
						.shadow(color: .black.opacity(0.08), radius: 8,x: -5, y: -5)
				)
				.zIndex(1)
				.offset(x: animateCurrentBook && selectedBook?.id == book.id ? -(size.width/2 + 20) : 0)
				
				ZStack{
					if !(showDetail && selectedBook?.id == book.id){
						Image(book.imageName)
							.resizable()
							.scaledToFill()
							.frame(width: size.width / 2 , height: size.height)
							.clipShape(RoundedRectangle(cornerRadius: 12,style: .continuous))
							.matchedGeometryEffect(id: book.id, in: animation)
							.shadow(color: .black.opacity(0.1), radius: 5,x: 5, y: 5)
							.shadow(color: .black.opacity(0.1), radius: 5,x: -5, y: -5)
					}
				}
				.frame(maxWidth: .infinity,maxHeight: .infinity)
				
			}
			.frame(width: size.width)
			.padding(.vertical,16)
			.rotation3DEffect(.init(degrees: convertOffsetToRotation(rect: rect)),axis: (x:1, y: 0,z:0),
							  anchor: .bottom,
							  anchorZ: 1,
							  perspective: 0.8)
		}
		.frame(height: 220)
		.padding(.horizontal,16)
	}
	
	@ViewBuilder
	func TagsView() -> some View{
		ScrollView(.horizontal,showsIndicators: false){
			HStack(spacing:12){
				ForEach(tags, id: \.self){ tag in
						Text(tag)
						.font(.caption)
						.padding(.horizontal,16)
						.padding(.vertical,8)
						.background{
							if activeTag == tag {
								Capsule()
									.fill(.blue)
									.matchedGeometryEffect(id: "ACTIVETAB", in: animation)
							}else{
								Capsule()
									.fill(.secondary.opacity(0.2))
							}
						}
						.foregroundStyle(activeTag == tag ? .white : .secondary)
						.onTapGesture {
							withAnimation(.interactiveSpring(response: 0.5,dampingFraction: 0.7,blendDuration: 0.7)){
								activeTag = tag
							}
						}
				}
			}
		}
		.padding(.horizontal,16)
	}
	
	func convertOffsetToRotation(rect: CGRect) -> CGFloat{
		let cardHeight = rect.height
		let minY = rect.minY
		let progress = minY < 0 ? (minY / cardHeight) : 0
		let constrainedProgress = min(-progress, 1)
		return constrainedProgress * 90
	}
}

#Preview {
    HomeView()
}
