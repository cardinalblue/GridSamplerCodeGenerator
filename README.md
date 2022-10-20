# GridCodeGenerator

It's a command line tool for auto-generating c++ code for the GridsSampler.
1. Export the json file from Figma by script.
2. copy-paste the json to the "addintion_svg.json" file, or any other file. 
You can change the target source in the file "Config"
3. run ```swift run GridSamplerGenerator``` to check the exported hpp/cpp files
4. run ```sh ./release.sh``` to release the command line tool. Then put it into some project need it (ex: CBGridGenerator)


`GridSamplerGenerator`

- the command line tool for generating code for grids from JSON downloaded from Figma.

`addition_svg.json`

- the file to put the JSON downloaded from Figma

`FigmaScript.js`

- the script to parse all grids and then generate related JSON.

##How to update grids from Figma

### Generate the JSON file from Figma:
1. Login Figma with an admin account (ex: product@cardxxxxxxx.xxx)
2. Open the [Figma page for Grids](https://www.figma.com/file/dzwRY4mjA3ug5aDE03ZrOz/Grid-options?node-id=19%3A19)
3. Select all grids in the page `Delivery` in Figma (including the old one, which deliver at iOS 8.13 Deliver)
4. Copy-paste them into a clean page in the same Figma file (ex: "Aaron: Grid layout")
5. Installed the plugIns Scripter first if you haven't do yet, link is [here](https://www.figma.com/community/plugin/757836922707087381/Scripter)
6. Start the plugIns Scripter in Figma. You can find it with the following steps:
	1. tap menu button (a figma icon on the top left side)
	2. select Plugins
	3. select Scripter
7. Stay in the current page, choose the first script `Grid generator`, then tap the run button (like this "▶︎")
	- You can create your own one if you can found that script, the code I've leaved it in `FigmaScript.js`, which is inside the folder GridSamplerGenerator.
	- Just copy the code from FigmaScript.js and paste to the plugIns Scripter, then run it.
8. scroll down, then you will see the generated JSON in a green area, select and copy the entire JSON.

### Generate the hpp/cpp file with `addition_svg.json`
1. Check out to the folder `GridSamplerGenerator` at mac Finder
2. Copy paste the result into `addition_svg.json` to override the content.
3. Run ```./GridSamplerGenerator ``` on command line
4. Then you can check the code at AdditionSVGSampler.cpp

**p.s. you can get more detail for GridSamplerGenerator at this [repo](https://github.com/cardinalblue/GridSamplerCodeGenerator)**