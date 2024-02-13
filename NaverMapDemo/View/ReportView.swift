//
//  ReportView.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/02/07.
//


import SwiftUI

struct ReportView: View {

    @State private var isTitleHidden: Bool = false
    @StateObject var reportVM: ReportViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                    Text("게시물 제목란:")
                    .bold()
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 21)
                    .padding(.top, 15)


                Text("해당 게시글을 신고하는 이유를 알려주세요.")
                .bold()
                .font(.system(size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 21)
                                    .padding(.bottom, 15)
                
                Divider()
                
                ForEach(Report.ReportReason.allCases, id: \.self){ reason in
                    NavigationLink(destination: ReportDetailView(reportVM: reportVM, title: reason.rawValue)){
                        ReportCellView(contents: reason.rawValue)
                            .onDisappear(){
                                reportVM.updateReportReason(reason: reason)
                                reportVM.report.targetType = .post //임시로 게시물로 해놓음
                            }
                    }
                    
                }

                Spacer()
            }
        }.navigationBarTitle("신고하기", displayMode: .inline)
        .navigationBarItems(leading: CustomBackButtonView())
        .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기

    }
}
struct TestView1: View {
    var body: some View {
        NavigationStack{
            VStack{
                NavigationLink(destination: ReportView(reportVM: ReportViewModel())){
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

struct ReportCellView: View {
    let contents: String

    var body: some View {
            HStack {
                Text(contents)
                    .padding(.vertical, 10)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 17))
                    .foregroundStyle(Color(hex: "3C3C43"))
            }
            .padding(.horizontal, 21)
            .padding(.top, 10)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(.white)
                    .shadow(color: Color.init(hex: "B3B3B3"), radius: 0, x: 0, y: 1)
                    .padding(.leading, 21)
                    .padding(.trailing, 21)
            )

    }
}
