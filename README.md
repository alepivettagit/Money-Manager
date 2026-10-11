<div align="center">
  <img src="assets/icon/app_icon.png" alt="Money Manager Logo" width="120" height="120" style="border-radius: 24px;" />

  # 💰 Money Manager
  **La tua app personale, semplice e 100% locale per gestire conti, spese ed entrate su smartphone.**

  [![Scarica APK Android](https://img.shields.io/badge/📲_SCARICA_L'APP_(ANDROID_APK)-v1.0.0-10B981?style=for-the-badge&logo=android&logoColor=white)](https://github.com/alepivettagit/Money-Manager/releases/latest/download/MoneyManager.apk)
  [![Versione Release](https://img.shields.io/github/v/release/alepivettagit/Money-Manager?style=for-the-badge&label=Release&color=0F172A)](https://github.com/alepivettagit/Money-Manager/releases/latest)
  [![Flutter](https://img.shields.io/badge/Flutter-Mobile_App-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
</div>

---

## 📥 Download Rapido (1-Click)

Vuoi installare subito l'applicazione sul tuo telefono Android? Clicca sul link qui sotto:

👉 **[📥 CLICCA QUI PER SCARICARE MONEY MANAGER (MoneyManager.apk)](https://github.com/alepivettagit/Money-Manager/releases/latest/download/MoneyManager.apk)**

*(In alternativa puoi visitare la sezione **[Releases](https://github.com/alepivettagit/Money-Manager/releases/latest)** a destra nella pagina della repository e scaricare il file `MoneyManager.apk`)*

---

## 📱 Cos'è Money Manager?

**Money Manager** è un'applicazione mobile realizzata in **Flutter** pensata per tenere sotto controllo le proprie finanze personali in modo rapido, chiaro e totalmente privato.

A differenza delle app tradizionali che richiedono registrazioni, abbonamenti o salvataggi su server esterni, questa versione di **Money Manager funziona al 100% in locale sul tuo dispositivo**:
- 🔒 **Massima Privacy (Zero Cloud)**: tutti i tuoi saldi e movimenti sono salvati esclusivamente nella memoria interna del tuo telefono tramite un database **SQLite** locale. Nessun dato viene inviato online.
- ⚡ **Funziona Offline**: non serve alcuna connessione a Internet per aggiungere spese, consultare il calendario o visualizzare i grafici.
- 🏦 **Gestione Multi-Saldo / Multi-Conto**: puoi creare e gestire più portafogli separati (es. *Conto Corrente*, *Contanti*, *Carta Prepagata*, *Risparmi*), ciascuno con il proprio saldo iniziale e storico dedicato.

### ✨ Funzionalità Principali

1. **Selettore Saldi & Portafogli (`AccountSelectionScreen`)**
   - Crea tutti i conti o salvadanai che desideri impostando un nome e il saldo di partenza.
   - Passa da un conto all'altro in qualsiasi momento o elimina un saldo quando non ti serve più.
2. **Dashboard Principale (`Home`)**
   - Visualizza a colpo d'occhio il **Saldo Attuale**, il totale delle **Entrate** e delle **Uscite** del mese selezionato.
   - Sfoglia i mesi precedenti o successivi con un tocco.
   - Registra nuove transazioni in pochi secondi scegliendo tra **Uscita** o **Entrata**, importo, data, nota facoltativa e **Categoria** dedicata con icone e colori:
     - *Categorie Uscite*: Spesa e Cibo, Ristoranti & Bar, Trasporti & Auto, Casa & Bollette, Svago & Tempo Libero, Shopping, Salute & Cura, Altro.
     - *Categorie Entrate*: Stipendio, Bonifico / Rimborso, Regalo, Investimenti, Altro.
3. **Calendario Interattivo (`Calendario`)**
   - Consulta una vista mensile interattiva che evidenzia i giorni in cui hai effettuato movimenti.
   - Tocca qualsiasi giorno del calendario per aprire il riepilogo dettagliato delle entrate e delle uscite di quella giornata.
4. **Statistiche e Grafici (`Ripartizione`)**
   - Analizza come spendi o incassi il tuo denaro grazie a un **grafico a torta interattivo** e alla lista dettagliata con le percentuali e gli importi per singola categoria.

---

## 📖 Tutorial Passo-Passo: Come Scaricare e Installare l'App

Poiché l'app viene distribuita direttamente tramite GitHub (senza passare dal Google Play Store), segui questi semplici passaggi sul tuo smartphone **Android**:

### Passo 1: Scarica il file di installazione (`MoneyManager.apk`)
1. Apri questa pagina GitHub dal browser del tuo telefono (es. **Chrome**, **Samsung Internet**, **Firefox**, ecc.).
2. Tocca il pulsante verde **[📲 SCARICA L'APP (ANDROID APK)](https://github.com/alepivettagit/Money-Manager/releases/latest/download/MoneyManager.apk)** che trovi in cima a questa guida.

### Passo 2: Conferma il download nel browser
1. Il browser potrebbe mostrarti un avviso standard di Android come *" Il file potrebbe essere dannoso. Vuoi scaricare comunque MoneyManager.apk?"* (questo messaggio compare per qualsiasi app scaricata fuori dal Play Store).
2. Tocca **"Scarica comunque"** (oppure **"OK"**) e attendi qualche secondo il completamento del download (~55 MB).

### Passo 3: Apri il file scaricato
1. Una volta terminato il download, tocca **"Apri"** direttamente nella notifica in basso/in alto nel browser.
2. Se hai chiuso la notifica, apri l'app **File / Archivio / Download** del tuo telefono e tocca il file **`MoneyManager.apk`**.

### Passo 4: Consenti l'installazione e avvia l'app
1. Se è la prima volta che installi un'app dal browser, Android ti mostrerà un messaggio di sicurezza: *"Per motivi di sicurezza, il telefono non è attualmente autorizzato a installare app sconosciute da questa origine"*.
2. Tocca **"Impostazioni"** nel popup e attiva l'interruttore **"Consenti da questa origine"** (o *"Autorizza da questa fonte"*), poi torna indietro di una schermata.
3. Tocca **"Installa"** nella finestra di conferma di **Money Manager**.
4. Qualora comparisse un avviso di *Google Play Protect* (perché l'app è personale e non registrata sullo store), tocca **"Ulteriori dettagli"** e poi **"Installa comunque"**.
5. Al termine dell'installazione, tocca **"Apri"**: crea il tuo primo saldo iniziale e inizia subito a usare **Money Manager**! 🎉

---

## 🛠️ Informazioni Tecniche e Sviluppo (Per Sviluppatori)

Il progetto è sviluppato in **Flutter (Dart)** utilizzando:
- `provider` per la gestione dello stato reattivo (`AccountProvider`, `TransactionProvider`)
- `sqflite` per la persistenza locale su database SQLite (`DatabaseHelper`)
- `table_calendar` per il calendario interattivo dei movimenti
- `fl_chart` per i grafici a torta nella sezione di analisi
- `intl` per la formattazione di valute (`€`) e date in lingua italiana (`it_IT`)

### Eseguire o compilare il progetto da codice sorgente

Assicurati di avere [Flutter SDK](https://docs.flutter.dev/get-started/install) installato sul tuo computer, quindi esegui nel terminale:

```bash
# 1. Clona la repository
git clone https://github.com/alepivettagit/Money-Manager.git
cd Money-Manager

# 2. Scarica le dipendenze
flutter pub get

# 3. Avvia l'app su un emulatore o dispositivo collegato
flutter run

# 4. Compila un nuovo file APK di release
flutter build apk --release
```
Il file compilato verrà generato in `build/app/outputs/flutter-apk/app-release.apk`.
