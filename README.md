# 🏇 NextToGo

**NextToGo** is an iOS application that provides real-time race information and updates for upcoming races via the Neds racing API. With a clean and accessible UI, users can stay informed on the latest race events across different categories.

| iPhone Screenshot | iPad Screenshot |
|-------------------|-----------------|
| <img src="https://github.com/user-attachments/assets/3fd60a92-cb61-402f-a376-aa23d80b355c" alt="iPhone Screenshot" width="300"/> | <img src="https://github.com/user-attachments/assets/f0835e1c-eec3-42d8-bfeb-e75878ef6639" alt="iPad Screenshot" width="400"/> |

---

## ✨ Features

- **🔁 Real-Time Updates** – Automatically fetches upcoming races with polling every 15 seconds.
- **🎯 Race Filtering** – Filter races by category (e.g., horse, greyhound).
- **♿ Accessibility Support** – Designed with accessibility in mind for an inclusive user experience.

---

## 📱 Requirements

- **iOS**: 16.6 or later  
- **Xcode**: 16 or later  
- **Swift**: 6 or later  

---

## 🚀 Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/syd-srirak/NextToGo.git

2.	Open the project in Xcode:

open NextToGo.xcodeproj


3.	Build and run:
	•	Select your target device or simulator
	•	Press Cmd + R to build and launch the app

⸻

🧭 Usage
	
 1.	Launch the app on your device or simulator.
	
 2.	View upcoming races on the main Race List screen.
	
 3.	Use the filter bar to filter by race category (e.g., horses, greyhounds).
	
 4.	The app polls for updated race information every 15 seconds and highlights the next five races.

⸻

🛠️ Technologies Used
	•	Swift 6 – Primary programming language
	•	SwiftUI – For building modern declarative UI
	•	Swift Concurrency – async/await used for asynchronous data fetching and UI updates
	•	Combine – Used to reactively update UI
	•	REST API – To fetch race data from the Neds API

⸻

📄 License

This project is licensed under the MIT License. See the LICENSE file for more information.
