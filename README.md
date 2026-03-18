# rayoflite

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

// for create web build 
flutter clean
flutter build web --release
And after deploy on aws run this commad on console of aws
"
aws cloudfront create-invalidation \
  --distribution-id EXJDLLVU47D25 \
  --paths "/*"  "

// for create android build 
flutter build appbundle --release
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

for creating new sha file or key for requesting google to approve these file 

PS D:\flutter-apps\Ray-of-light\ray_of_light\ray_of_light> keytool -genkey -v -keystore my-upload-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias upload
Enter keystore password:  

Re-enter new password: 

They don't match. Try again
Enter keystore password:  

Re-enter new password: 

Enter the distinguished name. Provide a single dot (.) to leave a sub-component empty or press ENTER to use the default value in braces.
What is your first and last name?
  [Unknown]:  Raman shakya 
What is the name of your organizational unit?
  [Unknown]:   Ray of light
What is the name of your organization?
  [Unknown]:  Delhi
What is the name of your City or Locality?
  [Unknown]:  Delhi
What is the name of your State or Province?
  [Unknown]:  Delhi
What is the two-letter country code for this unit?
  [Unknown]:  In
Is CN="Raman shakya ", OU=" Ray of light", O=Delhi, L=Delhi, ST=Delhi, C=In correct?
  [no]:  yes

Generating 2,048 bit RSA key pair and self-signed certificate (SHA384withRSA) with a validity of 10,000 days
        for: CN="Raman shakya ", OU=" Ray of light", O=Delhi, L=Delhi, ST=Delhi, C=In
[Storing my-upload-key.keystore]
PS D:\flutter-apps\Ray-of-light\ray_of_light\ray_of_light> 