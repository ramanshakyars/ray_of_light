import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

// FIX 1: Use file("key.properties") to match your folder structure
val keystoreProperties = Properties()
val keystorePropertiesFile = file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.wrappedweb.rayoflight"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

   defaultConfig {
    applicationId = "com.wrappedweb.rayoflite"
    minSdk = flutter.minSdkVersion
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
}

    signingConfigs {
        create("release") {
            // FIX 2: Null safety to avoid casting errors and give clear error message
            val keyAlias = keystoreProperties["keyAlias"] as String?
            val keyPassword = keystoreProperties["keyPassword"] as String?
            val storeFile = keystoreProperties["storeFile"] as String?
            val storePassword = keystoreProperties["storePassword"] as String?

            if (keyAlias != null && keyPassword != null && storeFile != null && storePassword != null) {
                this.keyAlias = keyAlias
                this.keyPassword = keyPassword
                this.storeFile = file(storeFile)
                this.storePassword = storePassword
            } else {
                throw GradleException("Missing signing config values in key.properties. Please ensure all: keyAlias, keyPassword, storeFile, storePassword are set.")
            }
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = true          // **Enable code shrinking**
            isShrinkResources = true        // **Enable resource shrinking**
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )

            // Optional: disable if you need debug logs
            // isDebuggable = false
        }
    }
}
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
