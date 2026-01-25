# Tesseract OCR ; process images as arguments to convert image to text 

## .bashrc:
# alias catpic='python3 $home/scripts/ocr.py'

## keybind that I use in my hyprland configuration file:
# bind = SUPER, o, exec, grim -g "$(slurp)" - | python3 $home/scripts/ocr.py | wl-copy



#!/usr/bin/env python3

import sys
import os
import argparse
import pytesseract
from PIL import Image
import io

    # Use Tesseract to do OCR on the image
    # Strip the trailing newlines and whitespace from the text

def ocr_image(image):
    text = pytesseract.image_to_string(image)
    return text.rstrip()

# Set up argument parser
parser = argparse.ArgumentParser(description='Perform OCR on an image.')
parser.add_argument('file', nargs='?', help='Image file to perform OCR on', type=argparse.FileType('rb'))

# Parse arguments
args = parser.parse_args()

# Check if a file was provided as an argument
if args.file:
    # Open the image file
    image = Image.open(args.file)
    text = ocr_image(image)
else:
    # Read the image stream from stdin if no file argument is provided
    image_stream = io.BytesIO(sys.stdin.buffer.read())
    image = Image.open(image_stream)
    text = ocr_image(image)

# Check if stdout is connected to a terminal
if os.isatty(sys.stdout.fileno()):
    # We are in a terminal; print as usual
    print(text)
else:
    # We are not in a terminal; avoid printing the extra newline
    print(text, end='')
