allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("http://android.metric.africa:8081/artifactory/metric-sdk-sdk")
            isAllowInsecureProtocol = true
            credentials {
                username = "USERNAME-HERE"
                password = "PASSWORD-HERE"
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
