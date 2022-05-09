# GridCodeGenerator

It's a command line tool for auto-generating c++ code for the GridsSampler.
1. Export the json file from Figma by script.
2. copy-paste the json to the "addintion_svg.json" file, or any other file. 
You can change the target source in the file "Config"
3. run ```swift run GridSamplerGenerator``` to check the exported hpp/cpp files
4. run ```sh ./release.sh``` to release the command line tool. Then put it into some project need it (ex: CBGridGenerator)

## How to generate the json file from Figma
- install Plugin - Scripter: https://www.figma.com/community/plugin/757836922707087381/Scripter
- open the plugin Scripter in Figma, then add a new script.
- copy-paste the script from FigmaScript.js into scripter window.
- choose the Figma sheet which includes the grids you want to export.
- run script, then copy-paste the result from the same window's bottom side to addintion_svg.json.
