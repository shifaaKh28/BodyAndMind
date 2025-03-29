![image_alt](https://github.com/shifaaKh28/BodyAndMind/blob/main/BodyAndMind/Screenshot%202025-03-29%20140005.png)
# **Body & Mind Gym - Flutter App**  

## **📌 Overview**  
**Body & Mind Gym** is a  designed for **trainers and trainees**. The app facilitates **session scheduling, exercise tracking, real-time chat, push notifications, and feedback collection** to enhance gym management and user experience. The backend services are managed using **Firebase**.

## **🚀 Features**  
### **👥 User Roles**  
- **Trainees**: View and enroll in **workout sessions**, track progress, chat with trainers, receive notifications, and submit feedback.  
- **Trainers**: Create and manage **training sessions**, send notifications, view enrolled trainees, chat, and review trainee feedback.  

### **📅 Scheduling & Training Management**  
- **Trainees** can enroll in available **workout sessions**.  
- **Trainers** can create, edit, and manage **custom workout sessions** with date, time, and capacity limits.  

### **📲 Real-time Notifications**  
- Push notifications powered by **Firebase Cloud Messaging (FCM)**.  
- Trainees receive updates on upcoming sessions, trainer messages, and alerts.  

### **💬 Chat System**  
- Real-time **trainee-trainer messaging** stored in **Firestore**.  
- Supports **one-on-one messaging** for better communication.  

### **📝 Feedback System**  
- **Trainees** can submit feedback on training sessions.  
- **Trainers** can **view trainee feedback** and make improvements.  
- Feedback stored in **Firebase Firestore** for future reference.  

### **📊 Progress Tracking**  
- Trainees can view **exercise plans and body statistics** to monitor fitness goals.  

## **🛠️ Tech Stack**  
### **Frontend**  
- **Flutter & Dart** - UI development and app logic.  
- **Provider** - State management.  

### **Backend & Database**  
- **Firebase Authentication** - Secure login & role-based authentication.  
- **Firebase Firestore** - Data storage for users, sessions, chat, and feedback.  
- **Firebase Cloud Messaging (FCM)** - Push notifications.  

## **🔧 Installation & Setup**  
1️⃣ **Clone the repository**  
```bash
git clone https://github.com/shifaaKh28/SW_project.git
cd SW_project
```
2️⃣ **Install dependencies**  
```bash
flutter pub get
```
3️⃣ **Set up Firebase**  
- Configure **Firebase Authentication, Firestore, and FCM**.  
- Add `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS).  

4️⃣ **Run the app**  
```bash
flutter run
```
👨‍💻 **Team Members:**  
- **Shifaa Khatib** 
- **[saleh sawaed]**
- **[wasim shebalny]**
   

## **📎 Repository Link**  
🔗 [GitHub Repository](https://github.com/shifaaKh28/SW_project)  

---
