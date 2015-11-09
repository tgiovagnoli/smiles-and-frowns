#!/usr/bin/python
'''
requires imagemagick to be installed. http://www.imagemagick.org/script/index.php
'''
import os
import sys
import subprocess
import argparse
import shutil
 
# found at https://developer.apple.com/library/ios/qa/qa1686/_index.html
outputs = {
	"Icon~iPhone": "60x60",
	"Icon~iPhone@2x": "120x120",
	"Icon~iPhone@3x": "180x180",

	"Icon~iPad": "76x76",
	"Icon~iPad@2x": "152x152",

	"iTunesArtwork": "512x512",
	"iTunesArtwork@2x": "1024x1024", 

	"iOS6-Spotlight~iPhone": "29x29", 
	"iOS6-Spotlight~iPhone@2x": "58x58", 
	"iOS6-Spotlight~iPhone@3x": "87x87", 

	"iOS6-Settings~iPhone": "29x29", 
	"iOS6-Settings~iPhone@2x": "58x58", 
	"iOS6-Settings~iPhone@3x": "87x87", 

	"iOS7-Spotlight~iPhone": "40x40", 
	"iOS7-Spotlight~iPhone@2x": "80x80", 
	"iOS7-Spotlight~iPhone@3x": "120x120",

	"Settings~iPad": "29x29", 
	"Settings~iPad@2x": "58x58", 

	"Spotlight~iPad": "40x40", 
	"Spotlight~iPad@2x": "80x80", 
}
 
def resizeImages(inputDir, outputDir):
	fileList = os.listdir(inputDir)
	print "converting image from " + inputDir
	print "to " + outputDir
	
	shutil.rmtree(outputDir)
	os.mkdir(outputDir)

	for fileName in fileList:
		if(validFile(fileName)):
			print "converting: " + fileName
			name, ext = os.path.splitext(fileName)
			inPath = inputDir + "/" + fileName
			for key in outputs:
				outPath = outputDir + "/" + key + ext
				command = ["convert", inPath, "-resize", outputs[key], outPath]
				print "\t" + outputs[key] + " " + fileName + " -> " + name + key + ext
				subprocess.call(command)

 
def validFile(filePath):
	extension = os.path.splitext(filePath)[1].lower()
	if(extension == ".png" or extension == ".jpeg" or extension == ".jpg"):
		return True
	return False
 
def checkArgs(args):
	if(args.output == None):
		print "Not enough arguments. You need to supply a output directory"
		exit(1)
	elif os.path.isdir(args.output) == False:
		print args.output + " is not a directory"
		exit(1)

	if(args.input == None):
		print "Not enough arguments. You need to supply a input directory"
		exit(1)
	elif os.path.isdir(args.input) == False:
		print args.input + " is not a directory"
		exit(1)


def checkImageMagick():
	# check for image magic
	try:
		subprocess.check_call(["convert"], stdout=open(os.devnull, "wb"))
	except subprocess.CalledProcessError:
		print "something went wrong with imagemagick"
		exit(1)
	except OSError:
		print "imagemagick needs to be installed. You can find it at: http://www.imagemagick.org/script/command-line-tools.php"
		exit(1)
 
def start():
	parser = argparse.ArgumentParser(description="Resizes images.")
	parser.add_argument("-i", "--input", metavar="", default="creative/icon", help="The image directory to use for sampling.")
	parser.add_argument("-o", "--output", metavar="", default="creative/icon/output", help="The image directory to use for output.")
	args = parser.parse_args()
 
	checkImageMagick()
	checkArgs(args)
	inputDir = os.path.abspath(args.input)
	outputDir = os.path.abspath(args.output)
	resizeImages(inputDir, outputDir)
 
start()