<div align="center">
  <img src="assets/icon/app_icon.png" alt="Money Manager Logo" width="120" height="120" style="border-radius: 24px;" />

  # 💰 Money Manager (Android APK)
  **Gestione finanze personali, conti multipli, sincronizzazione Cloud Firestore e Scansione Scontrini con Google Gemini AI.**

  [![Scarica APK Android](https://img.shields.io/badge/📲_SCARICA_L'APP_(ANDROID_APK)-v2.0.0-10B981?style=for-the-badge&logo=android&logoColor=white)](https://github.com/alepivettagit/Money-Manager/releases/latest/download/MoneyManager.apk)
  [![Versione Release](https://img.shields.io/github/v/release/alepivettagit/Money-Manager?style=for-the-badge&label=Release&color=0F172A)](https://github.com/alepivettagit/Money-Manager/releases/latest)
  [![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Firebase](https://img.shields.io/badge/Firebase-Auth_%26_Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
  [![Google Gemini](https://img.shields.io/badge/Gemini_AI-Receipt_OCR-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://aistudio.google.com)
</div>

---

## 📱 Cos'è Money Manager?

**Money Manager** è un'applicazione mobile moderna sviluppata in **Flutter** che ti permette di tenere sotto controllo le tue finanze personali, monitorare le entrate e le uscite su più portafogli e automatizzare l'inserimento delle spese scansionando gli scontrini con l'intelligenza artificiale di **Google Gemini**.

Tutti i dati sono sincronizzati in tempo reale tramite **Firebase (Cloud Firestore)**, garantendo accesso sicuro e simultaneo sia dal tuo smartphone che dalla versione Web / PWA.

---

## ✨ Funzionalità Principali

- 🏦 **Gestione Multi-Saldo & Portafogli**:
  - Crea e gestisci portafogli separati (es. *Conto Corrente*, *Contanti*, *Carta Prepagata*, *Risparmi*).
  - Imposta un saldo iniziale personalizzato e passa istantaneamente da un conto all'altro.
- ⚡ **Scansione Scontrini Intelligente con Gemini AI**:
  - Scatta una foto allo scontrino o selezionala dalla galleria.
  - L'IA multimodale di Google Gemini analizza l'immagine ed estrae in pochi secondi: **importo totale**, **esercente/negozio**, **data della spesa** e suggerisce la **categoria** appropriata.
- 🏷️ **Categorie Dinamiche Personalizzabili**:
  - Crea, modifica ed elimina categorie di spesa ed entrata direttamente dall'app.
  - Assegna icone e colori personalizzati per rendere ogni spesa riconoscibile a colpo d'occhio.
- 📊 **Dashboard & Statistiche Mensili**:
  - Saldo totale calcolato in tempo reale, riepilogo mensile con entrate, uscite e margine netto.
  - Grafico interattivo a torta e lista dettagliata delle percentuali di spesa per categoria.
- 📅 **Calendario Interattivo delle Spese**:
  - Vista mensile con evidenziazione dei giorni in cui sono stati registrati movimenti.
  - Tocca qualsiasi giorno per visualizzare il dettaglio delle transazioni giornaliere.
- 🔐 **Autenticazione Sicura**:
  - Login e registrazione con email e password gestiti tramite **Firebase Authentication**.
  - Possibilità di disconnettere l'account o passare a un altro profilo in qualsiasi momento.

---

## 📥 Download e Installazione Rapida (1-Click)

Per installare subito l'applicazione sul tuo smartphone **Android**:

👉 **[📥 SCARICA MONEY MANAGER (MoneyManager.apk)](https://github.com/alepivettagit/Money-Manager/releases/latest/download/MoneyManager.apk)**

*(In alternativa, visita la sezione [Releases](https://github.com/alepivettagit/Money-Manager/releases/latest) sulla destra della repository).*

### Come installare il file APK su Android:
1. Scarica il file `MoneyManager.apk` dal link sopra usando il browser del tuo telefono (Chrome, Firefox, Samsung Internet).
2. Se compare l'avviso *"Il file potrebbe essere dannoso"* (messaggio standard di Android per le app scaricate all'esterno del Play Store), tocca **Scarica comunque**.
3. Al termine del download, tocca **Apri** dalla notifica o dalla cartella *Download* del telefono.
4. Se richiesto, attiva l'opzione **Consenti installazione da questa origine** nelle impostazioni di sicurezza.
5. Tocca **Installa** e poi **Apri** per iniziare ad usare l'app!

---

## 🛠️ Guida Sviluppatore: Configurazione e Compilazione

Se desideri clonare il progetto, personalizzarlo o compilare il codice sorgente:

### 1. Prerequisiti
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versione `>= 3.13.5`)
- [Android Studio](https://developer.android.com/studio) con Android SDK installato
- Un account Google per accedere a [Firebase Console](https://console.firebase.google.com/) e [Google AI Studio](https://aistudio.google.com/)

---

### 2. Configurazione Firebase
1. Vai su [Firebase Console](https://console.firebase.google.com/) e crea un nuovo progetto (es. `money-manager`).
2. **Abilita Firebase Authentication**:
   - Vai nella sezione **Authentication** -> **Sign-in method** -> abilita il provider **Email/Password**.
3. **Abilita Cloud Firestore**:
   - Vai nella sezione **Firestore Database** -> **Crea database** (in modalità di produzione o test).
   - Imposta le seguenti regole di sicurezza in Firestore (`firestore.rules`):
     ```javascript
     rules_version = '2';
     service cloud.firestore {
       match /databases/{database}/documents {
         match /users/{userId}/{document=**} {
           allow read, write: if request.auth != null && request.auth.uid == userId;
         }
       }
     }
     ```
4. **Registra l'app Android**:
   - Nelle impostazioni del progetto Firebase, clicca su **Aggiungi app** -> **Android**.
   - Package name: `com.example.money_manager` (o il tuo applicationId personalizzato).
   - Scarica il file `google-services.json` e posizionalo in:
     ```text
     android/app/google-services.json
     ```
     *(Puoi consultare `android/app/google-services.json.example` come riferimento).*

---

### 3. Configurazione Google Gemini API (Per Scanner Scontrini)
1. Vai su [Google AI Studio](https://aistudio.google.com/apikey) e crea una chiave API gratuita.
2. Copia il file template `lib/constants/api_constants.dart.example`:
   ```bash
   cp lib/constants/api_constants.dart.example lib/constants/api_constants.dart
   ```
3. Apri `lib/constants/api_constants.dart` e inserisci la tua chiave:
   ```dart
   const String geminiApiKey = 'LA_TUA_CHIAVE_API_GEMINI';
   const String geminiModelName = 'gemini-2.5-flash';
   ```
   > [!TIP]
   > Assicurati che su Google AI Studio la chiave non abbia restrizioni di HTTP Referrer che bloccherebbero le richieste native da Android.

---

### 4. Configurazione `firebase_options.dart`
Copia il file template:
```bash
cp lib/firebase_options.dart.example lib/firebase_options.dart
```
Inserisci l'API Key, il Project ID e l'App ID del tuo progetto Firebase (oppure genera il file automaticamente eseguendo `flutterfire configure`).

---

### 5. Compilazione ed Esecuzione

```bash
# 1. Clona la repository
git clone https://github.com/alepivettagit/Money-Manager.git
cd Money-Manager

# 2. Scarica le dipendenze
flutter pub get

# 3. Avvia in modalità debug su dispositivo o emulatore collegato
flutter run

# 4. Compila l'APK di release
flutter build apk --release
```
L'APK generato sarà disponibile in `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📂 Struttura del Progetto

```text
lib/
├── constants/          # Costanti di configurazione (Gemini API)
├── models/             # Modelli dati (Account, Transaction, CategoryItem)
├── providers/          # Gestione stato reattivo con Provider
├── screens/            # Schermate principali (Auth, Home, Calendario, Ripartizione, Saldi)
├── services/           # Servizi backend (AuthService, DatabaseHelper, GeminiReceiptService)
└── widgets/            # Componenti UI (Scanner scontrini, grafici, dialoghi)
```

---

## 📄 Licenza
Rilasciato sotto licenza MIT. Libero per uso personale e modifiche.
