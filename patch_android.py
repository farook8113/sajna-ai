import os

manifest_path = "flutter_app/android/app/src/main/AndroidManifest.xml"

if not os.path.exists(manifest_path):
    print("AndroidManifest.xml not found at:", manifest_path)
    exit(1)

with open(manifest_path, "r", encoding="utf-8") as f:
    content = f.read()

# Declare RECORD_AUDIO and INTERNET permissions
permissions = """
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.INTERNET" />
"""

if "android.permission.RECORD_AUDIO" not in content:
    # Locate the opening <manifest> element
    idx = content.find("<manifest")
    if idx != -1:
        # Locate the closing bracket of the manifest element
        end_idx = content.find(">", idx)
        if end_idx != -1:
            new_content = content[:end_idx+1] + permissions + content[end_idx+1:]
            with open(manifest_path, "w", encoding="utf-8") as f:
                f.write(new_content)
            print("Successfully patched AndroidManifest.xml with microphone permissions.")
        else:
            print("Error: Could not locate closing bracket of manifest tag.")
            exit(1)
    else:
        print("Error: Could not locate manifest tag.")
        exit(1)
else:
    print("Permissions already configured in manifest.")
