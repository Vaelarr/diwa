// Configure all projects in the build
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set custom build directory
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

// Configure each project's build directory
subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    
    // Use afterEvaluate to ensure proper ordering
    afterEvaluate {
        // Any post-evaluation configuration can go here
    }
}