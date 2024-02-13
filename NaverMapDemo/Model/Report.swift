//
//  Report.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/02/13.
//

import SwiftUI


struct Report: Identifiable, Codable {
    var id: String = UUID().uuidString // 신고 고유 ID
    var targetType: TargetType // 신고된 게시물 유형
    var targetID: String // 신고된 게시물 ID
    var reporterUserID: String // 신고한 사용자 ID
    var reason: ReportReason // 신고 이유
    var additionalComments: String? // 추가 코멘트 (옵션)
    var reportDate: Date // 신고 날짜

    enum TargetType: String, Codable{
        case post = "게시글"
        case chat = "채팅"
    }
    
    enum ReportReason: String, Codable, CaseIterable {
        case inappropriateContent = "허위/거짓 정보를 포함하고 있어요."
        case harassment = "욕설/비방/혐오 표현이 사용되었어요."
        case sensational = "선정적인 내용을 포함하고 있어요."
        case other = "기타"
    }
    
}
