//
//  AddRequestForm.swift
//  PodCastPackage
//
//  Created by islam Awaad on 25/12/2024.
//


import SwiftUI

struct FormData {
    var title: String = ""
    var description: String = ""
    var note: String = ""
    var location: String = ""
    var pdfName: String = ""
}

struct FormView: View {
    @State private var formData = FormData()
    @State private var isShowingImagePicker = false
    @State private var selectedImage: Image?
    @State private var isShowingPDFPicker = false
    @State private var selectedPDF: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Information")) {
                    TextField("Title", text: $formData.title)
                    TextField("Description", text: $formData.description)
                }

                Section(header: Text("Additional Details")) {
                    TextField("Note", text: $formData.note)
                    TextField("Location", text: $formData.location)
                }

                Section(header: Text("Uploads")) {
                    Button(action: {
                        // Action to select image
                        isShowingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Select Image")
                        }
                    }

                    if let image = selectedImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 200)
                    }

                    Button(action: {
                        // Action to select PDF
                        isShowingPDFPicker = true
                    }) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Upload PDF")
                        }
                    }

                    if !selectedPDF.isEmpty {
                        Text("Selected PDF: \(selectedPDF)")
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
            .navigationTitle("Form Screen")
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .fileImporter(isPresented: $isShowingPDFPicker, allowedContentTypes: [.pdf]) { result in
                do {
                    let fileURL = try result.get()
                    selectedPDF = fileURL.lastPathComponent
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

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
