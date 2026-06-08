📸 PhotoApp
Kompleksowa aplikacja do zarządzania zdjęciami, albumami i udostępnieniami — zbudowana jako hybrydowy projekt:
Backend: ASP.NET Core Web API
Frontend: SwiftUI (iOS)

🚀 Funkcjonalności

🔐 Authentication
Rejestracja użytkownika
Logowanie
Hashowanie haseł (BCrypt)
JWT Authentication
Zabezpieczenie endpointów

🖼️ Photos
Pobieranie zdjęć użytkownika
Upload zdjęć (multipart/form-data)
Usuwanie zdjęć
Dodawanie zdjęć do albumów

📁 Albums
Tworzenie albumów
Usuwanie albumów
Przypisywanie zdjęć do albumów

🔗 Shares
Udostępnianie zdjęć innym użytkownikom
Usuwanie udostępnień

🧱 Architektura projektu
Repozytorium zawiera foldery backendu i frontendu:
Kod
PhotoApp/
 ├── Auth/
 ├── Controllers/
 ├── DTOs/
 ├── Data/
 ├── Migrations/
 ├── Models/
 ├── Services/
 ├── Uploads/
 ├── ViewModels/        # SwiftUI
 ├── Views/             # SwiftUI
 ├── Assets.xcassets/   # SwiftUI
 ├── ContentView.swift  # SwiftUI
 ├── PhotoAppApp.swift  # SwiftUI
 ├── Program.cs         # Backend entry point
 ├── PhotoApp.csproj    # Backend project file
 ├── PhotoApp.sln       # Solution
 ├── appsettings.json
 ├── appsettings.Development.json
 ├── photoapp.db        # SQLite database
 └── README.md
 
🗄️ Struktura bazy danych
Kod
User 1 --- * Photos
User 1 --- * Albums
Album 1 --- * Photos
Photo 1 --- * Shares

🔌 Endpointy API

Authentication
Metoda	Endpoint	Opis
POST	/api/auth/register	Rejestracja
POST	/api/auth/login	Logowanie


Photos
Metoda	Endpoint	Opis
GET	/api/photos	Pobierz zdjęcia użytkownika
POST	/api/photos/upload	Upload zdjęcia
DELETE	/api/photos/{id}	Usuń zdjęcie
PUT	/api/photos/{photoId}/album/{albumId}	Dodaj zdjęcie do albumu


Albums
Metoda	Endpoint	Opis
GET	/api/albums	Pobierz albumy
POST	/api/albums	Utwórz album
DELETE	/api/albums/{id}	Usuń album


Shares
Metoda	Endpoint	Opis
POST	/api/shares	Udostępnij zdjęcie
GET	/api/shares	Pobierz udostępnione zdjęcia
DELETE	/api/shares/{id}	Usuń udostępnienie


🛠️ Technologie
Backend
C# .NET 8
ASP.NET Core Web API
Entity Framework Core
SQLite
JWT Authentication
BCrypt
Frontend
SwiftUI
MVVM
AsyncImage
PhotosPicker
URLSession + async/await

▶️ Uruchamianie backendu
1. Klonowanie repozytorium
bash
git clone https://github.com/decentusername421/PhotoApp.git
cd PhotoApp
2. Migracje bazy
bash
dotnet ef database update
3. Start API
bash
dotnet run
Swagger dostępny pod:
https://localhost:<port>/swagger

📱 Uruchamianie frontendu (iOS)
Otwórz projekt w Xcode
Ustaw adres backendu w ApiService
Uruchom na simulatorze lub urządzeniu

📦 Upload zdjęć
Zdjęcia są:
wysyłane jako multipart/form-data,
zapisywane w folderze Uploads/,
przechowywane w bazie jako URL.
