//
//  AddRequestForm.swift
//  PodCastPackage
//
//  Created by islam Awaad on 25/12/2024.
//


import SwiftUI

struct FormView: View {
    @StateObject var viewModel: AddRequestViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Support Level")) {
                    Picker("Support Level", selection: $viewModel.state.selectedSupportLevel) {
                        ForEach(SupportEnums.SupportLevelEnum.allCases, id: \.self) { level in
                            Text(level.description).tag(level)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Select Support Type")) {
                    Picker("Support Type", selection: $viewModel.state.selectedSupportType) {
                        ForEach(SupportEnums.SupportTypeEnum.allCases, id: \.self) { type in
                            Text(type.description).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Select Issue Type")) {
                    Picker("Issue Type", selection: $viewModel.state.selectedIssueType) {
                        ForEach(SupportEnums.IssueTypeEnum.allCases, id: \.self) { issueType in
                            Text(issueType.description).tag(issueType)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                Section(header: Text("Information")) {
                    TextField("Title", text: $viewModel.state.formData.title)
                    TextField("Description", text: $viewModel.state.formData.description)
                }

                Section(header: Text("Additional Details")) {
                    TextField("Note", text: $viewModel.state.formData.note)
                    TextField("Location", text: $viewModel.state.formData.location)
                }

                Section(header: Text("Uploads")) {
                    Button(action: {
                        // Action to select image
                        viewModel.state.isShowingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Select Image")
                        }
                    }

                    if let image = viewModel.state.selectedImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 200)
                    }

                    Button(action: {
                        // Action to select PDF
                        viewModel.state.isShowingPDFPicker = true
                    }) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Upload PDF")
                        }
                    }

                    if !viewModel.state.selectedPDF.isEmpty {
                        Text("Selected PDF: \(viewModel.state.selectedPDF)")
                    }
                }
                Button(action: {
                   
                }) {
                    Text("Submit")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .sheet(isPresented: $viewModel.state.isShowingImagePicker) {
                ImagePicker(selectedImage: $viewModel.state.selectedImage)
            }
            .fileImporter(isPresented: $viewModel.state.isShowingPDFPicker, allowedContentTypes: [.pdf]) { result in
                do {
                    let fileURL = try result.get()
                    viewModel.state.selectedPDF = fileURL.lastPathComponent
                } catch {
                    print("Error selecting PDF file: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: Image?

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = Image(uiImage: image)
            }
        }
    }
}

