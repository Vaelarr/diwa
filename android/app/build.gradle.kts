plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.temp_diwa"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.temp_diwa"
        minSdkVersion(23)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Add this to ensure multidex support
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // Enable shrinking, optimization, and obfuscation
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Still using debug signing config
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Add multidex support
    implementation("androidx.multidex:multidex:2.0.1")
    
    // Use only the main Play Core library without the additional core-common
    implementation("com.google.android.play:core:1.10.3")
    
    // Exclude the core-common dependency from any other modules if needed
    configurations.all {
        exclude(group = "com.google.android.play", module = "core-common")
    }
}
