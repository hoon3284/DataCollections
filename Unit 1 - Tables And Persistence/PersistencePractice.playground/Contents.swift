import UIKit

struct Note: Codable {
    let title: String
    let text: String
    let timestamp: Date
}

let newNote = Note(title: "Grocery run", text: "Pick up mayonnaise, mustard, lettuce, tomato, and pickles.", timestamp: Date())

//let propertyListEncoder = PropertyListEncoder()
//if let encodedNote = try? propertyListEncoder.encode(newNote) {
//    print(encodedNote)
//
//    let propertyListDecoder = PropertyListDecoder()
//    if let decodedNote = try? propertyListDecoder.decode(Note.self, from: encodedNote) {
//        print(decodedNote)
//    }
//}

//let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//let archiveURL = documentsDirectory.appendingPathComponent("notes_test").appendingPathExtension("plist")
//
//
//let propertyListEncoder = PropertyListEncoder()
//let encodedNote = try? propertyListEncoder.encode(newNote)
//
//try? encodedNote?.write(to: archiveURL, options: .noFileProtection)
//
//let propertyListDecoder = PropertyListDecoder()
//if let retrievedNoteData = try? Data(contentsOf: archiveURL), let decodedNote = try? propertyListDecoder.decode(Note.self, from: retrievedNoteData) {
//    print(retrievedNoteData)
//    print(decodedNote)
//}

let note1 = Note(title: "Note One", text: "This is a sample note.", timestamp: Date())
let note2 = Note(title: "Note Two", text: "This is anohter sample note.", timestamp: Date())
let note3 = Note(title: "Note Three", text: "This is yet another sample note.", timestamp: Date())
let notes = [note1, note2, note3]

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = documentsDirectory.appendingPathComponent("notes_test").appendingPathExtension("plist")

let propertyListEncoder = PropertyListEncoder()
let encodedNotes = try? propertyListEncoder.encode(notes)

try? encodedNotes?.write(to: archiveURL, options: .noFileProtection)

let propertyListDecoder = PropertyListDecoder()
if let retrivedNotesData = try? Data(contentsOf: archiveURL), let decodedNotes = try? propertyListDecoder.decode(Array<Note>.self, from: retrivedNotesData) {
    print(retrivedNotesData)
    print(decodedNotes)
}
