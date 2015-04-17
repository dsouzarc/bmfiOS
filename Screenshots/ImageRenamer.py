import os;


#Written by Ryan Dsouza
#Quickly renames all the photos in a directory with the format
#'Screenshot_X.png', where X is that file's place in the directory

#Run instructions: 'python ImageRenamer.py'


files = os.listdir('.');
index = 0;

for fileName in files:

    if fileName != "ImageRenamer.py":
        print(fileName);
        os.rename(fileName, "Screenshot_" + str(index) + ".png");
        index += 1;
