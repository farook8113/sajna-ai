import os

# Locate the Gradle home directory in the user profile
user_home = os.path.expanduser("~")
gradle_init_dir = os.path.join(user_home, ".gradle", "init.d")
init_script_path = os.path.join(gradle_init_dir, "init.gradle")

# Define the Groovy jcenter() fallback mapping
init_gradle_content = """// Dynamic jcenter() fallback mapping to resolve speech_to_text compilation errors globally
org.gradle.api.artifacts.dsl.RepositoryHandler.metaClass.jcenter = { ->
    delegate.mavenCentral()
}
"""

try:
    if not os.path.exists(gradle_init_dir):
        os.makedirs(gradle_init_dir)
        print("Created Gradle initialization directory at:", gradle_init_dir)

    with open(init_script_path, "w", encoding="utf-8") as f:
        f.write(init_gradle_content)
        
    print("----------------------------------------------------------------")
    print("* Global Gradle bypass configured successfully!")
    print("  File written to:", init_script_path)
    print("  This fixes the speech_to_text 'jcenter()' error globally.")
    print("----------------------------------------------------------------")
except Exception as e:
    print("Error setting up Gradle init script:", e)
    exit(1)
