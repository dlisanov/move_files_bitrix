#!/bin/bash
puth=("/home/user/site/volume1/site_gorodkuzneck/new/gorodkuzneck.ru/")
puthto=("/home/user/site/volume1/site_gorodkuzneck/new/gorodkuzneck.ru/upload/files/")
text="=\"/"
textto="=\"/upload/files/"
siteputh="/home/user/site/volume1/site_gorodkuzneck/new/gorodkuzneck.ru/"
expansion=".*\(doc\|docx\|xls\|xlsx\|pdf\|rar\|zip\|jpg\|JPG\|jpeg\|gif\|rtf\|7z\|png\)$"
date=$(date +"%Y-%m-%d")
if [ -f files.txt ]; then
    rm files.txt
fi
find $puth -maxdepth 1 -type f -regex $expansion -exec basename {} \; >file.txt
sed -i '/^ /d' file.txt
sed -i '/^-/d' file.txt
sed -i '/^!/d' file.txt
sed -i '/\%/d' file.txt
sed -i '/\[/d' file.txt
while read file; do
    datefile=$(date +"%Y-%m-%d" -r "$puth$file")
    puthtofile="$puthto$datefile/"
    if ! [ -d "$puthtofile" ]; then
        mkdir -p "$puthtofile"
    fi
    textsearch="$text$file"
    textreplace="$textto$datefile/$file"
    grepfile=$(grep -rl --include="*.php" --exclude-dir={bitrix,upload} "$textsearch" "$siteputh")
    if [[ -n "$grepfile" ]]; then
        cp -f "$puth$file" "$puthtofile$file"
        echo "$grepfile - $textsearch" >>files.txt
        sed -i "s%$textsearch%$textreplace%g" $grepfile >>files.txt
        if [ -f "$puthtofile$file" ]; then
            rm "$puth$file"
        fi
    fi
done <file.txt
