//
//  ReportViewModel.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/02/13.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class ReportViewModel: ObservableObject{
    
    @Published var report = Report(targetType: .post, targetID: "", reporterUserID: "", reason: .other, additionalComments: "", reportDate: Date())

    //사유 Update
    func updateReportReason(reason: Report.ReportReason) {
        report.reason = reason
    }
    
    let db = Firestore.firestore()

}

extension ReportViewModel {
    func saveReportToFirestore(report: Report){
        do {
            // reports 컬렉션에 새 문서를 추가, Report 객체를 이용하여 문서 데이터 설정
            try db.collection("Report").document(report.id).setData(from: report) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Report successfully added!")
                }
            }
        } catch let error {
            print("Error writing report to Firestore: \(error.localizedDescription)")
        }
        
    }
}
