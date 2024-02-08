//
//  ReportView.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/02/07.
//


import SwiftUI

struct ReportView: View {

    var body: some View {
        NavigationView{
            VStack{
                    Text("해당 게시글을 신고하는 이유를 알려주세요.")
                    .bold()
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .padding(.top, 20)
                    .padding(.bottom, 20)

                Divider()
                ReportLinkView(title: "허위/거짓 정보를 포함하고 있어요.", destination: AnyView(Text(".")) )
                ReportLinkView(title: "욕설/비방/혐오 표현이 사용되었어요.", destination: AnyView(Text(".")) )
                ReportLinkView(title: "선정적인 내용을 포함하고 있어요.", destination: AnyView(Text(".")) )
                ReportLinkView(title: "기타", destination: AnyView(Text(".")) )
                Spacer()
            }

        }.navigationBarTitle("신고하기", displayMode: .inline)
            .navigationBarItems(leading: CustomBackButtonView())
                 .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기


    }
}
struct TestView1: View {
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: ReportView()){
                    VStack{
                        Text("신고하기")
                    }
                }
            }
        }

    }
}
struct CustomBackButtonView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.backward")
                .frame(width: 32, height: 31)
                .foregroundColor(Color(hex: "000000"))
        }
    }
}

struct ReportLinkView: View {
    let title: String
    let destination: AnyView // 실제 목적지 타입에 따라 변경 가능합니다.

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(title)
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 17))
                    .foregroundStyle(Color(hex: "3C3C43"))
            }
            .padding(.horizontal, 15)
        }
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.white)
                .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
                .padding(.leading, 15)
                .padding(.trailing, 15)
        )
        .padding(.top, 10)
    }
}
