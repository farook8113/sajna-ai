import os

gradle_path = r"flutter_app/android/build.gradle"

if not os.path.exists(gradle_path):
    print("build.gradle not found at:", gradle_path)
    exit(1)

with open(gradle_path, "r", encoding="utf-8") as f:
    content = f.read()

# Groovy Metaprogramming hook to intercept and redirect jcenter() to mavenCentral()
patch = """// Bypass missing jcenter() method in Gradle 8+ for speech_to_text plugin
gradle.allprojects { project ->
    project.repositories.metaClass.jcenter = {
        mavenCentral()
    }
    project.buildscript.repositories.metaClass.jcenter = {
        mavenCentral()
    }
}

"""

# Prepend the patch
new_content = patch + content

with open(gradle_path, "w", encoding="utf-8") as f:
    f.write(new_content)

print("Successfully patched root build.gradle with jcenter() dynamic mapping.")
