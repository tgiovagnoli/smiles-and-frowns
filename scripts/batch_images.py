#!/usr/bin/python
'''
requires imagemagick to be installed. http://www.imagemagick.org/script/index.php
'''
import os
import sys
import subprocess
import argparse
import shutil
 
# outputs in the scale we want to use them
'''
outputs = {
	"@2x~ipad": "100%",
	"~ipad": "50%",
	"@3x~iphone": "75%",
	"@2x~iphone": "50%", 
	"~iphone": "25%"
}
'''
outputs = {
	#"@3x": "150%",
	"@2x": "100%", 
	"": "50%"
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
				outPath = outputDir + "/" + name + key + ext
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
	parser.add_argument("-i", "--input", metavar="", default="source_images", help="The image directory to use for sampling.")
	parser.add_argument("-o", "--output", metavar="", default="ios/SmileAndFrowns/images", help="The image directory to use for output.")
	args = parser.parse_args()
 
	# checkImageMagick()
	checkArgs(args)
	inputDir = os.path.abspath(args.input)
	outputDir = os.path.abspath(args.output)
	resizeImages(inputDir, outputDir)
 
start()