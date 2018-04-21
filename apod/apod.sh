#!/bin/bash
# Version 1.5
# A. Dominik, 23. Apr 2012

SCREEN_GEOMETRY="250x200"
APOD_URL="http://apod.nasa.gov/apod/"
FILE_URL="http://apod.nasa.gov/apod/astropix.html"
ORIGINAL="raw.html"
ORI_NO_HEAD="raw-no-head.html"
IMAGE_URL="http://dummy.jpg"
IMAGE_NAME="dummy.jpg"

APOD_PIC_NAME="apod.png"
APOD_PIC_TEMP_NAME="temp.png"
# WALLPAPER_TXT="apod.txt"

IMAGE_TITLE="dummy"
IMAGE_TITLE_FILE="title.txt"
IMAGE_EXPL="dummy"
IMAGE_EXPL_FILE="explanation.txt"

HOME_DIR=$HOME
WORK_DIR="${HOME}/workspaces/workspace/astrows/apod"

TEMP1="tempfile1"
TEMP2="tempfile2"
TEMP3="tempfile3"

#
# Read config file:
#
#. ${WORK_DIR}/apod-wallpaper.config


#
# Check for working dir:
if ! test -d $WORK_DIR
then
  echo "Directory $WORK_DIR not found"
  exit
fi

cd $WORK_DIR

#
# check for internet connection:
#
wget -q www.google.com

I_NET=$?

if ! test $I_NET -eq 0
then
  echo "No internet connection"
  exit
fi

#
# test for a filename to download
#
if test $# -gt 0
then
  FILE_URL="$1"
fi


#
# get html page
#
wget -q $FILE_URL -O $ORIGINAL

#
# extract image url
# extract image name
# and download hi-res image
#
IMAGE_URL=$(cat $ORIGINAL | grep 'href="image' | head -1 | \
                            sed 's/<a href="/  /g' | sed 's/"/ /g' | sed 's/>/ /g' |\
                            awk '{print( "http://apod.nasa.gov/" $1)}')

IMAGE_NAME=$(echo $IMAGE_URL | sed 's+/+ +g' | awk '{print( $NF)}' | sed 's/\"//g')

wget -q $IMAGE_URL -O $IMAGE_NAME

#
# extract title
# and remove html tags
#
# The following part of the code tries to find the lines in the APOD HTML 
# page, that holds title and explanation.
# Due to slight changes of the file format, it may not work properly for 
# all historic APOD pages.
#
# make files nice
# Some HTML tags lower:
#
cat $ORIGINAL | \
sed 's/<CENTER>/<center>/g;s/<\/CENTER>/<\/center>/g;s/<B>/<b>/g;s/<\/B>/<\/b>/g' > $TEMP1

# Add line breaks after center tags:
#
cat $TEMP1 | \
sed 's/<center><b>/<center>\n<b>/g' > $TEMP2

# Add line breaks after word Explanation:
#
cat $TEMP2 | \
sed 's/Explanation<\/b>/Explanation\n<\/b>/g;s/Explanation:<\/b>/Explanation:\n<\/b>/g;' > $TEMP1

# Remove empty lines
#
cat $TEMP1 | awk NF > $TEMP2
cp $TEMP2 $TEMP1

# Remove page header
# del all up to image link
#
cat $TEMP1 | \
awk 'BEGIN {MOD = 0} { if (MOD==1) {print}; if ($0 ~ "href=\"image") {MOD = 1}}' | \
awk 'NR>2 { print }' > $ORI_NO_HEAD
  
# del all up to 2nd center
cat $ORI_NO_HEAD | \
awk 'BEGIN {MOD = 0} { if (MOD==1) {print}; if ($0 ~ "<center>") {MOD = 1}}' > $TEMP1

# Extract line with title and
# trim title; i.e. remove html, trim and remove line breaks
#
cat $TEMP1 | awk 'NR==1 {print}' > $TEMP2
cat $TEMP2 | sed 's/<[^>]*>//g;s/^ *//g;s/ *$//g;s/ \{1,\}/ /g;s/[\n\r]/ /g' > $IMAGE_TITLE_FILE

# cat $IMAGE_TITLE_FILE

#
# extract explanation
# and remove html tags
#
# del all up to 1st Explanation
#
cat $ORI_NO_HEAD | \
awk 'BEGIN {MOD = 0} { if (MOD==1) {print}; if ($0 ~ "Explanation") {MOD = 1}}' > $TEMP1

# del all from next center
cat $TEMP1 | \
awk 'BEGIN {MOD = 1} { if ($0 ~ "<center>") {MOD = 0}; if (MOD==1) {print}}' > $TEMP2

# remove html, line breaks and unneeded spaces:
#
cat $TEMP2 | tr '\012' ' ' |  tr '\015' ' ' | \
  sed 's/<[^>]*>//g;s/^ *//;s/ *$//;s/ \{1,\}/ /g' > $IMAGE_EXPL_FILE

# cat $IMAGE_EXPL_FILE

#
# create annotated image with imagemagick
#
convert $IMAGE_NAME -resize ${SCREEN_GEOMETRY}^ $IMAGE_NAME
convert $IMAGE_NAME -gravity center -extent ${SCREEN_GEOMETRY}+0+0 $IMAGE_NAME

cp $IMAGE_NAME $APOD_PIC_NAME

# convert $IMAGE_NAME -fill white -pointsize 12 -gravity SouthWest -annotate +10+0 "@$IMAGE_EXPL_FILE" -pointsize 20 -annotate +10-10 "@$IMAGE_TITLE_FILE" $IMAGE_NAME

# composite -gravity NorthEast -geometry +0+100 ubuntu-550.png $IMAGE_NAME $APOD_PIC_TEMP_NAME
# if test -s $APOD_PIC_TEMP_NAME
# then
#   mv $APOD_PIC_TEMP_NAME $APOD_PIC_NAME
# fi




#
# create text file with annotation:
#
# IMAGE_ANNOTATION_TXT="${IMAGE_NAME}.txt"
# echo "$IMAGE_NAME"         > $IMAGE_ANNOTATION_TXT
# echo "\n Title: "         >> $IMAGE_ANNOTATION_TXT
# cat $IMAGE_TITLE_FILE     >> $IMAGE_ANNOTATION_TXT
# echo "\n Explanation: "   >> $IMAGE_ANNOTATION_TXT
# cat $IMAGE_EXPL_FILE      >> $IMAGE_ANNOTATION_TXT

# Remove all temporary files:
#
rm -f $TEMP1 $TEMP2 $TEMP3
rm -f $ORIGINAL $ORI_NO_HEAD
rm -f $IMAGE_TITLE_FILE $IMAGE_EXPL_FILE
# rm -r $IMAGE_NAME $APOD_PIC_TEMP_NAME
# mv $IMAGE_ANNOTATION_TXT $WALLPAPER_TXT
rm -f index.*

# archive older files
find . -maxdepth 1 -mtime +1 -name "*.jpg" -exec mv -f {} ./archive/ \;
