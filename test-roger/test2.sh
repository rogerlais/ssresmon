#!/bin/bash

clear


samplerFile="/media/bash-ifpb/sampler/run.yml"

/usr/local/bin/sampler -c "${samplerFile}"


exit

dataFile="${PWD}/test-roger/miniTemplate.html"
htmlFile="file:/${dataFile}"
echo "${htmlFile}"
yad --html --width=800 --height=600 --uri="${htmlFile}"
yad --html --browser --width=800 --height=600 --uri="${htmlFile}"
cat "${dataFile}"
yad --html --browser --width=800 --height=600 < "${dataFile}"

htmlFile="file:/${PWD}/test-roger/template.html"
echo "${htmlFile}"
yad --html --width=800 --height=600 --uri="${htmlFile}"
yad --html --browser --width=800 --height=600 --uri="${htmlFile}"

yad --html --browser --uri="http://wttr.in/$location" --width=900 --height=700 --button="Return!gtk-ok:0" --button="Exit!gtk-cancel:1" --title="Weather"
if (($? == 1)); then
    exit
fi
