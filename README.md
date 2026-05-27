Funkcjonalności
Authentication
Rejestracja użytkownika
Logowanie użytkownika
Hashowanie haseł przy użyciu BCrypt
JWT Authentication
Zabezpieczenie endpointów
Photos
Pobieranie zdjęć użytkownika
Upload zdjęć
Usuwanie zdjęć
Dodawanie zdjęć do albumów
Zapisywanie plików na dysku
Albums
Tworzenie albumów
Pobieranie albumów użytkownika
Usuwanie albumów
Przypisywanie zdjęć do albumów
Shares
Udostępnianie zdjęć innym użytkownikom
Pobieranie udostępnionych zdjęć
Usuwanie udostępnień
Architektura projektu
Backend/
│
├── Controllers/
├── Models/
├── DTOs/
├── Data/
├── Auth/
├── Migrations/
├── Uploads/
├── Program.cs
├── appsettings.json
└── README.md
Struktura bazy danych
Relacje
User 1 --- * Photos
User 1 --- * Albums
Album 1 --- * Photos
Photo 1 --- * Shares
Endpointy API
Authentication
Register
POST /api/auth/register
Login
POST /api/auth/login
Photos
Get user photos
GET /api/photos
Upload photo
POST /api/photos/upload
Delete photo
DELETE /api/photos/{id}
Add photo to album
PUT /api/photos/{photoId}/album/{albumId}
Albums
Get albums
GET /api/albums
Create album
POST /api/albums
Delete album
DELETE /api/albums/{id}
Shares
Share photo
POST /api/shares
Get shared photos
GET /api/shares
Delete share
DELETE /api/shares/{id}
JWT Authentication

Autoryzacja odbywa się przy użyciu JWT.

Nagłówek:

Authorization: Bearer TOKEN
Upload zdjęć

Zdjęcia są:

uploadowane przez multipart/form-data,
zapisywane w folderze Uploads/,
przechowywane w PostgreSQL jako URL.


Uruchomienie projektu
1. Klonowanie repozytorium
git clone REPOSITORY_URL
2. Konfiguracja bazy danych

W pliku appsettings.json:

{
  "ConnectionStrings": {
    "DefaultConnection":
      "Host=localhost;Port=5432;Database=photoapp;Username=postgres;Password=1234"
  }
}
3. Migracje
dotnet ef database update
4. Uruchomienie backendu
dotnet run
Swagger

Swagger dostępny pod:

https://localhost:PORT/swagger
