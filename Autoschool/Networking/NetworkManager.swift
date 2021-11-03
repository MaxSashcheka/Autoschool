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
    
    // MARK: - Groups
    func fetchGroups(completionHandler: @escaping ([Group]) -> Void) {
        // fetch all groups
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
    
    func postGroup(_ group: Group) {
        guard let url = URL(string: "\(apiRoute)/groups/create") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            let post = "name=\(group.name)&lessons_start_date=\(group.lessonsStartDate)&lessons_end_date=\(group.lessonsEndDate)&category_id=\(group.categoryId)&teacher_id=\(group.teacherId)&lessons_time_id=\(group.lessonsTimeId)"
            let postData = post.data(using: .utf8, allowLossyConversion: true)! //String.Encoding.ascii
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let responce  = try JSONDecoder().decode(Group.self, from: data)
                    print("Success \(responce)")
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
            
        } catch let serializationError {
            print("serializationError: \(serializationError.localizedDescription)")
        }
    }
    
    // MARK: - Students
    // fetch students for certain group
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
    
    // fetch all students
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
    
    func postStudent(_ student: Student) {
        guard let url = URL(string: "\(apiRoute)/students/create") else { return }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let post = "first_name=\(student.firstName)&last_name=\(student.lastName)&middle_name=\(student.middleName)&passport_number=\(student.passportNumber)&phone_number=\(student.phoneNumber)&instructor_id=\(student.instructorId)&group_id=\(student.groupId)"
            let postData = post.data(using: .utf8, allowLossyConversion: true)!
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
    
    // MARK: - Teachers
    // fetch all teachers
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
    // fetch teacher for certain group
    func fetchTeachers(forGroup group: Group, completionHandler: @escaping ([Teacher]) -> Void) {
        guard let url = URL(string: "\(apiRoute)/teachers/\(group.teacherId)") else { return }
        
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
    
    func postTeacher(_ teacher: Teacher) {
        guard let url = URL(string: "\(apiRoute)/teachers/create") else { return }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let post = "first_name=\(teacher.firstName)&last_name=\(teacher.lastName)&middle_name=\(teacher.middleName)&passport_number=\(teacher.passportNumber)&phone_number=\(teacher.phoneNumber)"
            let postData = post.data(using: .utf8, allowLossyConversion: true)!
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let responce  = try JSONDecoder().decode(Teacher.self, from: data)
                    print("Success \(responce)")
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
            
        } catch let serializationError {
            print("serializationError: \(serializationError.localizedDescription)")
        }
    }
    
    // MARK: - Instructors
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
    
    func postInstructor(_ instructor: Instructor) {
        guard let url = URL(string: "\(apiRoute)/instructors/create") else { return }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let post = "first_name=\(instructor.firstName)&last_name=\(instructor.lastName)&middle_name=\(instructor.middleName)&driving_experience=\(instructor.drivingExperience)&passport_number=\(instructor.passportNumber)&phone_number=\(instructor.phoneNumber)&car_id=\(instructor.carId)&driver_license_id=\(instructor.driverLicenseId)"
            let postData = post.data(using: .utf8, allowLossyConversion: true)!
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let responce  = try JSONDecoder().decode(Instructor.self, from: data)
                    print("Success \(responce)")
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
            
        } catch let serializationError {
            print("serializationError: \(serializationError.localizedDescription)")
        }
    }
    
    // MARK: - Cars
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
    
    func postCar(_ car: Car) {
        guard let url = URL(string: "\(apiRoute)/cars/create") else { return }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let post = "number=\(car.number)&name=\(car.name)&color=\(car.color)"
            let postData = post.data(using: .utf8, allowLossyConversion: true)!
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let responce  = try JSONDecoder().decode(Car.self, from: data)
                    print("Success \(responce)")
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
            
        } catch let serializationError {
            print("serializationError: \(serializationError.localizedDescription)")
        }
    }
    
    // MARK: - Administrators
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
    
    func post(_ administrator: Administrator) {
        guard let url = URL(string: "\(apiRoute)/administrators/create") else { return }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let post = "first_name=\(administrator.firstName)&last_name=\(administrator.lastName)&middle_name=\(administrator.middleName)&phone_number=\(administrator.phoneNumber)&email=\(administrator.email)"
            let postData = post.data(using: .utf8, allowLossyConversion: true)!
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let responce  = try JSONDecoder().decode(Administrator.self, from: data)
                    print("Success \(responce)")
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
            
        } catch let serializationError {
            print("serializationError: \(serializationError.localizedDescription)")
        }
    }
    
    // MARK: - Exams
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
    
    func post(_ exam: Exam) {
        guard let url = URL(string: "\(apiRoute)/exams/create") else { return }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let post = "date=\(exam.date)&exam_type_id=\(exam.examTypeId)&group_id=\(exam.groupId)"
            let postData = post.data(using: .utf8, allowLossyConversion: true)!
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let responce  = try JSONDecoder().decode(Exam.self, from: data)
                    print("Success \(responce)")
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
            
        } catch let serializationError {
            print("serializationError: \(serializationError.localizedDescription)")
        }
    }
    
    // MARK: - Agreements
    func fetchAgreements(completionHandler: @escaping ([Agreement]) -> Void) {
        guard let url = URL(string: "\(apiRoute)/agreements") else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in

            if error != nil {
                print("error: \(error?.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let agreementsData = try JSONDecoder().decode([Agreement].self, from: data)
                DispatchQueue.main.async {
                    completionHandler(agreementsData)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }

        }.resume()
    }
    
    func post(_ agreement: Agreement) {
        guard let url = URL(string: "\(apiRoute)/agreements/create") else { return }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let post = "amount=\(agreement.amount)&singing_date=\(agreement.signingDate)&administrator_id=\(agreement.administratorId)&student_id=\(agreement.studentId)"
            let postData = post.data(using: .utf8, allowLossyConversion: true)!
            request.httpBody = postData
            
            URLSession.shared.dataTask(with: request) { (data, res, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let responce  = try JSONDecoder().decode(Agreement.self, from: data)
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
