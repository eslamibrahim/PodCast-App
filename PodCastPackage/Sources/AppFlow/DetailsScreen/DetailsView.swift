//
//  RequestDetails.swift
//  PodCastPackage
//
//  Created by islam Awaad on 27/12/2024.
//


import SwiftUI
import UI
import PDFKit

struct RequestDetailsView: View {
    @StateObject var viewModel: DetailsViewModel
    @State private var isShowingPopup = false
    
    var body: some View {
        
        switch viewModel.state.state {
        case .loading:
            ProgressView()
        case .success(let requestDetails):
            Form {
                Section {
                    HStack {
                        Text("Title: ")
                            .font(.subheadline)
                            .bold()
                        Text("\(requestDetails.requestId) - " + " \(requestDetails.englishName)")
                            .font(.headline)
                            .foregroundColor(.red)
                            .bold()
                    }
                }
                Section {
                    VStack(alignment: .leading) {
                        if  requestDetails.requestStatus != .IssueRejected {
                           
                            Button(action: {
                                isShowingPopup.toggle()
                            }) {
                                Text("Check your Actions")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(10)
                            }
                            .buttonStyle(.borderless)
                        }
                        Button(action: {
                            openGoogleMaps(latitude: 27.64646, longitude: 27.63535)
                        }) {
                            Text("Open Location in Google Maps")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                        }
                        .buttonStyle(.borderless)
                    }
                    Section {
                        if let offerAmount = requestDetails.offerAmount,
                           offerAmount > 0 ,
                            requestDetails.requestStatus == .PendingOfferApproval {
                            HStack {
                                Text("Offer Amount: ")
                                    .font(.subheadline)
                                    .bold()
                                Text("\(offerAmount)")
                                    .font(.title)
                                    .foregroundColor(.blue)
                                    .bold()
                            }
                            .padding()
                        }
                        Text("Support Level: \(requestDetails.supportLevel.description)")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        Text("Support Type: \(requestDetails.supportType.description)")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        Text("Issue Type: \(requestDetails.issueType.description)")
                            .font(.headline)
                            .padding(.bottom, 5)
                    }
                    
                    Section {
                        Text("Request Comment: \(requestDetails.requestComment ?? "")")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        if let acceptanceComment = requestDetails.acceptanceComment {
                            Text("Acceptance Comment: \(acceptanceComment)")
                                .font(.headline)
                                .padding(.bottom, 5)
                        }

                        Text("Quantity: \(requestDetails.quantity ?? 0)")
                            .font(.headline)
                            .padding(.bottom, 5)
                    }
                    
                    Section {
                        RequestStatusStepsView(requestStatus: requestDetails.requestStatus)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    Section {
                        if let imageUpload = requestDetails.imageUpload, let imageURL = URL(string: imageUpload) {
                            NavigationLink(destination: ZoomableImageView(imageURL: imageURL)) {
                                FillImage(imageURL)
                                    .frame(width: 300, height: 300)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    Section {
                        if let imageUpload = requestDetails.imageUploadAfterFix, let imageURL = URL(string: imageUpload) {
                            NavigationLink(destination: ZoomableImageView(imageURL: imageURL)) {
                                FillImage(imageURL)
                                    .frame(width: 300, height: 300)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    Section {
                        if let pdfUpload = requestDetails.pdfUpload,
                           let pdfURL = URL(string: pdfUpload) {
                            NavigationLink {
                                PDFViewer(url: pdfURL)
                            } label: {
                                Text("View Offer PDF")
                            }
                        }
                    }

                    Section {
                        if let pdfUpload = requestDetails.pdfUploadInvoice,
                           let pdfURL = URL(string: pdfUpload) {
                            NavigationLink {
                                PDFViewer(url: pdfURL)
                            } label: {
                                Text("View Invoice PDF")
                            }
                        }
                    }

                }
            }
            .overlay(isShowingPopup ?
                     PopupView(title: viewModel.state.actionTitle,
                               requestStatus: requestDetails.requestStatus, actionState: $viewModel.state.actionState, isAccepted: $viewModel.state.ActionForm.isAccepted, acceptanceComment: $viewModel.state.ActionForm.acceptanceComment, RequestComment: $viewModel.state.ActionForm.requestComment,
                               rejectionReason: $viewModel.state.ActionForm.rejectionReason,
                               requestDuration: $viewModel.state.ActionForm.requestDuration, rejectionComment: $viewModel.state.ActionForm.rejectionComment, selectedPDF: $viewModel.state.ActionForm.selectedPDF, isShowingPopup: $isShowingPopup,
                               offerAmount: $viewModel.state.ActionForm.offerAmount, selectedImage: $viewModel.state.ActionForm.selectedImage, onYesAction: {
                viewModel.HandleActionRequestState()
            })
                     : nil)
        case .error:
            EmptyView()
        case .idle:
            EmptyView()
        }
        
    }
//    
//    var isActionButtonEnabled: Bool {
//        switch viewModel.dependencies.session.user?.role {
//        case .Admin:
//            if viewModel.state.requestDetails?.requestStatus == .VerifyOnSolvedIssueFromAdmin {
//                return true
//            } else {
//                return false
//            }
//        case .SuperVisor:
//            if viewModel.state.requestDetails?.requestStatus == .PendingOfferApproval || viewModel.state.requestDetails?.requestStatus == .UploadInvoice || viewModel.state.requestDetails?.requestStatus == . {
//                return true
//            } else {
//                return false
//            }
//        case .Worker:
//            break
//        case .WorkerManager:
//            break
//        case .none:
//            return false
//        }
//    }
}


struct RequestStatusStepsView: View {
    var requestStatus: SupportEnums.RequestStatusEnum
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Request Status")
                .font(.headline)
                .padding(.bottom, 5)
            
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
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
        .animation(.easeInOut, value: requestStatus)
    }
}

struct ZoomableImageView: View {
    var imageURL: URL
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ScrollView([.vertical, .horizontal], showsIndicators: false) {
            VStack {
                
                FillImage(imageURL)
                    .scaledToFit()
                    .scaleEffect(scale)
                    .gesture(MagnificationGesture()
                        .onChanged { value in
                            scale = value.magnitude
                        })
                    .animation(.easeInOut, value: scale)
            }
            .padding()
        }
        .navigationBarTitle("Zoomable Image", displayMode: .inline)
    }
}

func openGoogleMaps(latitude: Double, longitude: Double) {
    let url = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)")!
    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
        // If Google Maps is not installed, open in a browser
        let browserUrl = URL(string: "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)")!
        UIApplication.shared.open(browserUrl, options: [:], completionHandler: nil)
    }
}

struct PopupView: View {
    let title: String
    let requestStatus: SupportEnums.RequestStatusEnum
    @Binding var actionState: DetailsViewModel.Status.ActionsState
    @Binding var isAccepted: Bool
    @Binding var acceptanceComment: String
    @Binding var RequestComment: String
    @Binding var rejectionReason: SupportEnums.RejectionReasonEnum?
    @Binding var requestDuration: RequestDurationEnum?
    @Binding var rejectionComment: String
    @Binding var selectedPDF: URL?
    @Binding var isShowingPopup: Bool
    @Binding var offerAmount: String
    @Binding var selectedImage: Image?
    @State var isShowingPDFPicker = false
    @State var isShowingImagePicker = false
    
    var onYesAction: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Button("Close") {
                    isShowingPopup = false
                }
                Text(title)
                    .padding()
                switch actionState {
                case .loading:
                    ProgressView()
                case .success, .idle:
                    Form {
                        Toggle("Is Accepted", isOn: $isAccepted)
                        TextField("Acceptance Comment", text: $acceptanceComment)
                        if requestStatus == .PendingSupervisorAction {
                            TextField("Request Comment", text: $RequestComment)

                        }
                        if requestStatus == .AssessmentAndGenerateOffer {
                            TextField("Offer Amont", text: $offerAmount)
                            
                            Section(header: Text("Request Duration")) {
                                Picker("Request Duration", selection: $requestDuration) {
                                    ForEach(RequestDurationEnum.allCases, id: \.self) { type in
                                        Text(type.title).tag(type)
                                    }
                                }
                                .pickerStyle(.automatic)
                            }
                        }
                        if requestStatus == .PendingSupervisorAction 
                        {
                            Section(header: Text("Select Rejection Reason Type")) {
                                Picker("Rejection Reason", selection: $rejectionReason) {
                                    ForEach(SupportEnums.RejectionReasonEnum.allCases, id: \.self) { rejectionReason in
                                        Text(rejectionReason.description).tag(rejectionReason)
                                    }
                                }
                                .pickerStyle(.automatic)
                            }
                            TextField("Rejection Comment", text: $rejectionComment)
                        }
                        if requestStatus == .AssessmentAndGenerateOffer || requestStatus == .IssueSolved  {
                            Button(action: {
                                isShowingPDFPicker = true
                            }) {
                                HStack {
                                    Image(systemName: "doc.on.doc")
                                    Text("Upload PDF")
                                }
                            }
                        }
                        if requestStatus == .WorkerDeparted || requestStatus == .WorkerStartSolvingTheRequest
                        {
                            Button(action: {
                                // Action to select Image
                                isShowingImagePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "doc.on.doc")
                                    Text("Upload Image")
                                }
                            }
                        }
                        
                        if let image = selectedImage {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200)
                        }
                        
                        if selectedPDF != nil {
                            Text("Selected PDF: \(selectedPDF!.absoluteString)")
                        }
                    }
                    HStack(spacing: 20) {
                        Button("Yes") {
                            self.onYesAction()
                            self.isShowingPopup = false
                        }
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                    }
                    .padding()
                    
                default:
                    EmptyView()
                }
            }
            .frame(width: 400)
            .background(Color.white)
            .cornerRadius(10)
            .padding()
            .sheet(isPresented: $isShowingPDFPicker) {
                  DocumentPicker { url in
                      selectedPDF = url
                  }
              }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}



struct PDFViewer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if let document = PDFDocument(url: url) {
            uiView.document = document
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    var onDocumentPicked: (URL?) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // No updates needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onDocumentPicked: onDocumentPicked)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onDocumentPicked: (URL?) -> Void

        init(onDocumentPicked: @escaping (URL?) -> Void) {
            self.onDocumentPicked = onDocumentPicked
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onDocumentPicked(urls.first)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            onDocumentPicked(nil)
        }
    }
}
