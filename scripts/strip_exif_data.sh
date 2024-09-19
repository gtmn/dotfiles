#/usr/bin/env bash

for file in "$@"; do
    # Extract the file extension
    extension="${file##*.}"

    # Rename the file with the suffix before the extension
    suffix="_noexif"
    new_file="${file%.*}$suffix.$extension"
    cp "$file" "$new_file"

    # Remove EXIF data
    exiftool -all= -overwrite_original -tagsfromfile @ -Orientation "$new_file"
done
