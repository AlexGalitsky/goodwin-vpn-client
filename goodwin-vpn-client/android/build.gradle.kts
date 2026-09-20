allprojects {
    fun gprKey(): String? {
        val fromProp = (findProperty("gpr.key") as String?)?.trim()
        if (!fromProp.isNullOrEmpty()) return fromProp
        val fromEnv = System.getenv("GPR_KEY")?.trim()
        if (!fromEnv.isNullOrEmpty()) return fromEnv
        val secretFile = rootProject.projectDir.resolve("../../configs/secrets/github-pat")
        if (secretFile.isFile) {
            val fromFile = secretFile.readText().trim()
            if (fromFile.isNotEmpty()) return fromFile
        }
        return null
    }

    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.pkg.github.com/TrustTunnel/TrustTunnelClient")
            credentials {
                username = ""
                password = gprKey() ?: ""
            }
            authentication {
                create<BasicAuthentication>("basic")
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}
subprojects {
    // vpn_plugin still sets compileSdk 34; androidx.core 1.16 needs 35+.
    // Only touch vpn_plugin — afterEvaluate on already-evaluated :app fails.
    if (name != "vpn_plugin") return@subprojects
    fun bumpCompileSdk() {
        extensions.findByType(com.android.build.api.dsl.LibraryExtension::class.java)?.apply {
            compileSdk = 36
        }
    }
    if (state.executed) {
        bumpCompileSdk()
    } else {
        afterEvaluate { bumpCompileSdk() }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
