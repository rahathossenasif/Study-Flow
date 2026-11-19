#!/usr/bin/env bash
# Applies StudyFlow branding to the generated Capacitor Android project:
# launcher icons, splash screen, status-bar colour and portrait lock.
# Usage: scripts/customize-android.sh <android-dir> <icon-512.png>
set -euo pipefail

ANDROID_DIR="${1:-android}"
ICON="${2:-icon-512.png}"
BG="#0F0C29"
ACCENT="#8B5CF6"
RES="$ANDROID_DIR/app/src/main/res"

if command -v magick >/dev/null 2>&1; then IM="magick"; else IM="convert"; fi

[ -d "$RES" ] || { echo "Android res dir not found: $RES"; exit 1; }

# 1. Launcher icons (legacy square + round + adaptive foreground)
declare -A LEGACY=( [mdpi]=48 [hdpi]=72 [xhdpi]=96 [xxhdpi]=144 [xxxhdpi]=192 )
declare -A FOREGROUND=( [mdpi]=108 [hdpi]=162 [xhdpi]=216 [xxhdpi]=324 [xxxhdpi]=432 )
for d in "${!LEGACY[@]}"; do
  dir="$RES/mipmap-$d"
  mkdir -p "$dir"
  s=${LEGACY[$d]}
  f=${FOREGROUND[$d]}
  inner=$(( f * 80 / 100 ))
  $IM "$ICON" -resize "${s}x${s}" "$dir/ic_launcher.png"
  $IM "$ICON" -resize "${s}x${s}" \( +clone -alpha extract -threshold -1 -negate \
      -fill white -draw "circle $((s/2)),$((s/2)) $((s/2)),0" \) \
      -alpha off -compose CopyOpacity -composite "$dir/ic_launcher_round.png"
  $IM "$ICON" -resize "${inner}x${inner}" -background none -gravity center -extent "${f}x${f}" "$dir/ic_launcher_foreground.png"
done

cat > "$RES/values/ic_launcher_background.xml" <<XML
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">$BG</color>
</resources>
XML

# 2. Splash screen: dark background with the icon in the centre
find "$RES" -name 'splash.png' | while read -r f; do
  dim=$(identify -format '%wx%h' "$f")
  w=${dim%x*}; h=${dim#*x}
  m=$(( w < h ? w : h ))
  logo=$(( m / 3 ))
  $IM -size "${dim}" "xc:$BG" \( "$ICON" -resize "${logo}x${logo}" \) -gravity center -composite "$f"
done

# 3. Status bar / toolbar colours (match the app)
cat > "$RES/values/colors.xml" <<XML
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="colorPrimary">$BG</color>
    <color name="colorPrimaryDark">$BG</color>
    <color name="colorAccent">$ACCENT</color>
</resources>
XML

# 4. Lock to portrait (the layout is a 430px-wide phone UI)
MANIFEST="$ANDROID_DIR/app/src/main/AndroidManifest.xml"
if ! grep -q 'android:screenOrientation' "$MANIFEST"; then
  sed -i 's|android:launchMode="singleTask"|android:launchMode="singleTask"\n            android:screenOrientation="portrait"|' "$MANIFEST"
fi

echo "Android branding applied."
