plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_notification"
    compileSdk = 35     // CHANJE: Mete 35 (ou te gen 34)
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17  // CHANJE: Mete 17 (ou te gen 11)
        targetCompatibility = JavaVersion.VERSION_17  // CHANJE: Mete 17 (ou te gen 11)
        // Enable core library desugaring to support libraries that use newer Java APIs
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()  // PA CHANJE: Sa byen
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.flutter_notification"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion     // CHANJE: Mete 21 (flutter.minSdkVersion kap pote 16, nou bezwen 21)
        targetSdk = 35  // CHANJE: Mete 35 (ou te gen 34)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Required for core library desugaring (allows use of java.time and other APIs on older
    // Android devices and supports libraries that require it)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")  // CHANJE: Mete 2.1.4 (ou te gen 1.2.2)
}
