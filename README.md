# GridCodeGenerator

It's a command line tool for auto-generating c++ code for the GridsSampler.
1. Export the json file from Figma by script.
2. copy-paste the json to the "Source.json" file, or any other file. 
You can change the target source in the file "Config"
3. run ```swift run GridSamplerGenerator``` to check the exported hpp/cpp files
4. run ```sh ./release.sh``` to release the command line tool. Then put it into some project need it (ex: CBGridGenerator)
