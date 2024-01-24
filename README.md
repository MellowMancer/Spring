# Spring
### Flask server setup
#### Pre-requisites: Python
```
    cd spring-api
```
```
    python venv .venv
```
```
    .venv\Scripts\activate
```
```
    pip install flask
```
```
    cd api
```
```
    flask run
```
*(The localhost server may not be detected by Flutter, use your IP address as the address in that case)*

### Firebase setup
#### Pre-requisites: Node, NPM
###### For Firebase CLI either follow this guide: https://firebase.google.com/docs/cli?hl=en&authuser=0#install_the_firebase_cli
###### or do this:

```
    npm install -g firebase-tools
```
```
    firebase login
```

### Flutter setup
#### Pre-requisites: Android Emulator
###### Install flutter using this guide: https://docs.flutter.dev/get-started/install/windows/mobile
```
    cd ..
```
```
    cd spring-frontend
```
```
    dart pub global activate flutterfire_cli
```
```
    flutterfire configure --project=spring-a-ling
```
*(Will only work if your firebase login is added as a collaborator on the project)*
```
    dart pub get
```
```
    flutter run
```
*(This should get the project running, let me know if I missed anything)*
