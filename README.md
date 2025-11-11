# Guardian Angel

Un'applicazione mobile Flutter per la gestione della salute personale e della sicurezza in emergenze.

## Descrizione

Guardian Angel è un'app che consente agli utenti di:
- **Archiviare informazioni mediche personali** (allergie, condizioni mediche, gruppo sanguigno)
- **Gestire i farmaci** con promemoria automatici
- **Salvare contatti di emergenza** per situazioni critiche
- **Ricevere consigli sanitari personalizzati** tramite IA
- **Condividere la posizione** in caso di emergenza

## Requisiti

- Flutter 3.35.7+
- Dart 3.5.0+
- Android SDK (API 21+)

## Installazione

```bash
# Clonare il repository
git clone https://github.com/PeppPercoc/guardian_angel.git
cd guardian_angel

# Installare le dipendenze
flutter pub get

# Configurare il .env con la chiave API Gemini
echo "GEMINI_API_KEY=your_api_key_here" > .env

# Avviare l'app
flutter run
```

## Build

### APK Release
```bash
flutter build apk --release
```

## Licenza

Questo progetto è privato e non è disponibile per l'uso pubblico.
