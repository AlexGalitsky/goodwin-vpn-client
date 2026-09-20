import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
if (keyPropertiesFile.isFile) {
    keyPropertiesFile.inputStream().use { stream -> keyProperties.load(stream) }
}
val hasReleaseKeystore =
    keyProperties.getProperty("storeFile")?.isNotBlank() == true &&
        keyProperties.getProperty("storePassword")?.isNotBlank() == true &&
        keyProperties.getProperty("keyPassword")?.isNotBlank() == true &&
        keyProperties.getProperty("keyAlias")?.isNotBlank() == true

android {
    namespace = "website.goodwin.vpnclient"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "website.goodwin.vpnclient"
        // trusttunnel-client-android AAR requires 26+
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86_64")
        }
    }

    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
                storePassword = keyProperties.getProperty("storePassword")
                storeFile = file(keyProperties.getProperty("storeFile")!!)
            }
        }
    }

    buildTypes {
        release {
            // Never fall back to the debug keystore. Missing key.properties →
            // node tools/setup_android_release_keystore.mjs
            if (hasReleaseKeystore) {
                signingConfig = signingConfigs.getByName("release")
            }
            // Flutter enables R8 for release; keep HevTunnelBridge for hev JNI RegisterNatives.
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

gradle.taskGraph.whenReady {
    val packagingRelease = gradle.taskGraph.allTasks.any { task ->
        val n = task.name
        n.contains("Release") &&
            (n.startsWith("assemble") || n.startsWith("bundle") || n.startsWith("package"))
    }
    if (packagingRelease && !hasReleaseKeystore) {
        throw GradleException(
            "Release APK is not signed with the debug key. " +
                "From the repo root run: node tools/setup_android_release_keystore.mjs",
        )
    }
    if (packagingRelease) {
        val repoRoot = rootProject.projectDir.resolve("../..").canonicalFile
        val check = ProcessBuilder("node", "tools/check_android_jni.mjs")
            .directory(repoRoot)
            .inheritIO()
            .start()
            .waitFor()
        if (check != 0) {
            throw GradleException(
                "Release needs 16 KB-aligned jniLibs (.so). " +
                    "From the repo root run: node tools/build_android_native.mjs",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.core:core-ktx:1.15.0")
}
