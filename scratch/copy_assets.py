import os
import shutil

src_dir = r"C:\Users\fathi\.gemini\antigravity\scratch\sajna_ai\web_simulator"
dst_dir = r"C:\Users\fathi\.gemini\antigravity\scratch\sajna_ai\flutter_app\assets\web"

if not os.path.exists(dst_dir):
    os.makedirs(dst_dir)

files = [
    "index.html", 
    "app.css", 
    "app.js", 
    "manifest.json", 
    "icon-192.png", 
    "icon-512.png", 
    "sw.js", 
    "material_symbols.woff2"
]

for f in files:
    src = os.path.join(src_dir, f)
    dst = os.path.join(dst_dir, f)
    if os.path.exists(src):
        shutil.copy(src, dst)
        print(f"Copied {f} to assets/web.")
    else:
        print(f"Warning: {f} not found in source.")
