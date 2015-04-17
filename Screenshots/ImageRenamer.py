import os;

files = os.listdir('.');
index = 0;

for fileName in files:

    if fileName != "ImageRenamer.py":
        print(fileName);
        os.rename(fileName, "Screenshot_" + str(index) + ".png");
        index += 1;
