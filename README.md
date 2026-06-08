📸 PhotoApp

Nowoczesna aplikacja do zarządzania zdjęciami, albumami i udostępnieniami.
Projekt zawiera backend (.NET 8 Web API) oraz frontend (iOS SwiftUI) w jednym repozytorium.

✨ Funkcjonalności

🔐 Rejestracja i logowanie (JWT)

🖼️ Upload zdjęć (multipart/form-data)

📁 Albumy — tworzenie, usuwanie, przypisywanie zdjęć

🔗 Udostępnianie zdjęć innym użytkownikom

👤 Obsługa wielu użytkowników

📱 Aplikacja iOS w SwiftUI (MVVM)

🛠️ Technologie

Backend

.NET 8

ASP.NET Core Web API

Entity Framework Core

SQLite

JWT Authentication

BCrypt

Frontend

SwiftUI

MVVM

PhotosPicker

AsyncImage

URLSession + async/await

🔌 Endpointy API

Auth

Metoda	Endpoint	Opis

POST	/api/auth/register	Rejestracja

POST	/api/auth/login	Logowanie


Photos

Metoda	Endpoint	Opis

GET	/api/photos	Pobierz zdjęcia

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


▶️ Uruchamianie backendu

1. Klonowanie repozytorium
   
bash

git clone https://github.com/decentusername421/PhotoApp.git

cd PhotoApp

3. Migracje bazy
   
bash

dotnet ef database update

5. Start API
   
bash

dotnet run

https://localhost:<port>

📱 Uruchamianie frontendu (iOS)

Otwórz projekt w Xcode

Ustaw adres backendu w ApiService

Uruchom na simulatorze lub urządzeniu
