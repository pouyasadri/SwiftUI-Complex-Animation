//
//  DetailView.swift
//  ComplexAnimation
//
//  Created by Pouya Sadri on 07/03/2024.
//

import SwiftUI

struct DetailView: View {
	@Binding var isShowing : Bool
	var book : Book
	var animation : Namespace.ID
	@State var animationContent : Bool = false
	@State var offsetAnimation: Bool = false
	
	
    var body: some View {
		VStack(spacing:16){
			Button(action: {
				withAnimation(.easeIn(duration: 0.2)){
					offsetAnimation = false
				}
				withAnimation(.easeInOut(duration: 0.35)){
					isShowing = false
					animationContent = false
				}
			}){
				Image(systemName: "chevron.left")
					.font(.title3)
					.fontWeight(.semibold)
					.foregroundStyle(.black)
					.contentShape(Rectangle())
			}
			.padding(.vertical,16)
			.frame(maxWidth: .infinity,alignment: .leading)
			.opacity(animationContent ? 1 : 0)
			
			GeometryReader{
				reader in
				let size = reader.size
				
				HStack(spacing:20){
					Image(book.imageName)
						.resizable()
						.scaledToFill()
						.frame(width: size.width / 2, height: size.height)
						.clipShape(RoundedRectangle(cornerRadius: 12))
						.matchedGeometryEffect(id: book.id, in: animation)
						.shadow(color: .black.opacity(0.1), radius: 5,x: 5,y: 5)
						.shadow(color: .black.opacity(0.1), radius: 5,x: -5,y: -5)
					
					VStack{
						Text(book.title)
							.font(.title)
							.fontWeight(.bold)
						
						Text("By \(book.author)")
							.font(.callout)
							.foregroundStyle(.gray)
						
						RatingView(rating: book.rating)
					}
					.offset(y: offsetAnimation ? 0 : 100)
					.opacity(offsetAnimation ? 1 : 0)
				}
			}
			.frame(height: 220)
			
			GeometryReader{ reader in
				let size = reader.size
				
				VStack(alignment:.leading){
					Text("Book Description Here")
						.font(.title)
						.fontWeight(.semibold)
						.foregroundStyle(.black)
				}
				.frame(maxWidth: .infinity,maxHeight: .infinity)
				.background(Rectangle().fill(.gray.opacity(0.2)))
				.clipShape(RoundedRectangle(cornerRadius: 16))
				.offset(x: offsetAnimation ? 0 : -(size.width + 32))
				
			}
			.padding(.vertical,16)
		}
		.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
		.padding(.horizontal,16)
		.background(
			Rectangle()
				.fill(.thinMaterial)
				.ignoresSafeArea()
				.opacity(animationContent ? 1 : 0)
		)
		.onAppear{
			withAnimation(.easeIn(duration: 0.35)){
				animationContent = true
			}
			withAnimation(.easeIn(duration: 0.35).delay(0.15)){
				offsetAnimation = true
			}
		}
    }
}

