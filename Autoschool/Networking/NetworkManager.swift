//
//  NetworkManager.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/1/21.
//

import Foundation

class NetworkManager {
    
    private init() {}
    
    static let shared = NetworkManager()
    
    let apiRoute = "http://localhost:5000"
    
    public enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    // MARK: - groups GET
    func fetchGroups(completionHandler: @escaping ([Group]) -> Void) {
        guard let url = URL(string: "\(apiRoute)/groups") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in

            if error != nil {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let groupsData = try JSONDecoder().decode([Group].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(groupsData)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    // MARK: - students GET
    func fetchStudents(withGroupId groupId: Int, completionHandler: @escaping ([Student]) -> Void) {
        guard let url = URL(string: "\(apiRoute)/students/group/\(groupId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in

            if error != nil {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let studentsData = try JSONDecoder().decode([Student].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(studentsData)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func fetchStudents(completionHandler: @escaping ([Student]) -> Void) {
        guard let url = URL(string: "\(apiRoute)/students") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in

            if error != nil {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let studentsData = try JSONDecoder().decode([Student].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(studentsData)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    // MARK: - teacher GET
    func fetchTeacher(completionHandler: @escaping ([Teacher]) -> Void) {
        guard let url = URL(string: "\(apiRoute)/teachers") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in

            if error != nil {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let teacherData = try JSONDecoder().decode([Teacher].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(teacherData)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func fetchTeacher(forGroupId groupId: Int, completionHandler: @escaping ([Teacher]) -> Void) {
        guard let url = URL(string: "\(apiRoute)/teachers/\(groupId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in

            if error != nil {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let teacherData = try JSONDecoder().decode([Teacher].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(teacherData)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    // MARK: - teacher GET
    func fetchInstructors(completionHandler: @escaping ([Instructor]) -> Void) {
        guard let url = URL(string: "\(apiRoute)/instructors") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in

            if error != nil {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let instructorsData = try JSONDecoder().decode([Instructor].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(instructorsData)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }

        }.resume()
    }
    
    // MARK: - cars GET
    func fetchCars(completionHandler: @escaping ([Car]) -> Void) {
        guard let url = URL(string: "\(apiRoute)/cars") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in

            if error != nil {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let carsData = try JSONDecoder().decode([Car].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(carsData)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }

        }.resume()
    }
    
    // MARK: - administrators GET
    func fetchAdministrators(completionHandler: @escaping ([Administrator]) -> Void) {
        guard let url = URL(string: "\(apiRoute)/administrators") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in

            if error != nil {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let administratorsData = try JSONDecoder().decode([Administrator].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(administratorsData)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }

        }.resume()
    }
    
    // MARK: - exams GET
    func fetchExams(completionHandler: @escaping ([Exam]) -> Void) {
        guard let url = URL(string: "\(apiRoute)/exams") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in

            if error != nil {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let examsData = try JSONDecoder().decode([Exam].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(examsData)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }

        }.resume()
    }
    
    
    
    // MARK: - POST
    func postStudent(_ student: Student) {

        guard let url = URL(string: "\(apiRoute)/create") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let post = "first_name=\(student.firstName)&last_name=\(student.lastName)&middle_name=\(student.middleName)&passport_number=\(student.passportNumber)&phone_number=\(student.phoneNumber)&instructor_id=\(student.instructorId)&group_id=\(student.groupId)"
            let postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)!
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let responce  = try JSONDecoder().decode(Student.self, from: data)
                    print("Success \(responce)")
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
            
        } catch let serializationError {
            print("serializationError: \(serializationError.localizedDescription)")
        }
    }
    
    // MARK: - DELETE

    func deleteStudent(withId studentId: Int) {
        guard let url = URL(string: "\(apiRoute)/deleteStudent/\(studentId)") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
//                guard let data = data, error == nil else {
//                    return
//                }
//                do {
//                    let responce  = try JSONDecoder().decode(Student.self, from: data)
//                    print("Success \(responce)")
//                } catch {
//                    print(error.localizedDescription)
//                }
            }.resume()
            
        } catch let serializationError {
            print("serializationError: \(serializationError.localizedDescription)")
        }
    }
    
    
}
