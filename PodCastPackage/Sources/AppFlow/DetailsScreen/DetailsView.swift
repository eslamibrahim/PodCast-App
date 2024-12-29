//
//  RequestDetails.swift
//  PodCastPackage
//
//  Created by islam Awaad on 27/12/2024.
//


import SwiftUI
import UI

struct RequestDetailsView: View {
    @StateObject var viewModel: DetailsViewModel
    var body: some View {
        if let requestDetails = viewModel.state.requestDetails {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("English Name: \(requestDetails.englishName)")
                    .foregroundColor(.blue)
                Text("Arabic Name: \(requestDetails.arabicName)")
                    .foregroundColor(.red)
                Text("Support Level: \(requestDetails.supportLevel.description)")
                    .font(.headline)
                    .foregroundColor(.green)
                Text("Support Type: \(requestDetails.supportType.description)")
                    .font(.headline)
                    .foregroundColor(.orange)
                Text("Issue Type: \(requestDetails.issueType.description)")
                    .font(.headline)
                    .foregroundColor(.purple)
                Text("Request Comment: \(requestDetails.requestComment)")
                    .foregroundColor(.blue)
                Text("Quantity: \(requestDetails.quantity)")
                    .foregroundColor(.red)
                RequestStatusStepsView(requestStatus: requestDetails.requestStatus)

                if let imageURL = URL(string: requestDetails.imageUpload) {
                    FillImage(imageURL)
                        .frame(width: 200, height:100)
                }
            }
        }

    }

    }

}


struct RequestStatusStepsView: View {
    var requestStatus: SupportEnums.RequestStatusEnum

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Request Status")
                .font(.headline)
            ForEach(SupportEnums.RequestStatusEnum.allCases, id: \.self) { status in
                HStack(spacing: 10) {
                    Circle()
                        .fill(status == self.requestStatus ? Color.blue : Color.gray)
                        .frame(width: 10, height: 10)
                    Text(status.description)
                        .foregroundColor(status == self.requestStatus ? .blue : .black)
                }
            }
        }
        .padding()
        .animation(.easeInOut)
    }
}

//@available(iOS 15.0, *)
//struct RequestDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleRequestDetails = RequestDetails(requestDetailsId: 48, requestId: 20, englishName: "test3", arabicName: "test3", supportLevel: .Critical, supportType: .Purchase, issueType: .Type3, requestComment: "test comment 3", imageUpload: "https://bassemwwe9-001-site1.otempurl.com/UploadsAdmin/9519edbe-f9ad-4e11-9c0f-ee911a7e57c330bfafbb-a66a-4399-a1f0-424df8c421a0.png", requestStatus: .AssessmentAndGenerateOffer, quantity: 2, createdOn: Date())
//        RequestDetailsView(requestDetails: sampleRequestDetails)
//    }
//}
