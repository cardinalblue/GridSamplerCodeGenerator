const layouts = figma.currentPage.children.filter(c => c.type === "FRAME") as FrameNode[];
	/**
	 * Parser: expected argument lengths
	 * @type {Object}
	 */
	const length = { a: 7, c: 6, h: 1, l: 2, m: 2, q: 4, s: 4, t: 2, v: 1, z: 0 };
	/**
	 * segment pattern
	 * @type {RegExp}
	 */
	const segment = /([astvzqmhlc])([^astvzqmhlc]*)/gi;
	/**
	 * parse an svg path data string. Generates an Array
	 * of commands where each command is an Array of the
	 * form `[command, arg1, arg2, ...]`
	 *
	 * @param {String} path
	 * @return {Array}
	 */
	function parse(path) {
		let data: any = [];
		if (!path) return
		path.replace(segment, function (_, command: any, args) {
			var type = command.toLowerCase();
			args = parseValues(args);
			// overloaded moveTo
			if (type == "m" && args.length > 2) {
				data.push([command].concat(args.splice(0, 2)));
				type = "l";
				command = command == "m" ? "l" : "L";
			}
			while (true) {
				if (args.length == length[type]) {
					args.unshift(command);
					return data.push(args);
				}
				if (args.length < length[type]) throw new Error("malformed path data");
				data.push([command].concat(args.splice(0, length[type])));
			}
		});
		return data;
	}
	var number = /-?[0-9]*\.?[0-9]+(?:e[-+]?\d+)?/gi;
	function parseValues(args) {
		var numbers = args.match(number);
		return numbers ? numbers.map(Number) : [];
	}
	// ------ parser end
	const normalizePos = (slot, layout: FrameNode) => {
		const fromX = slot?.["x"];
		const fromY = slot?.["y"];
		const toX = (slot?.["width"]);
		const toY = (slot?.["height"]);
		return [
			[fromX, fromY],
			[toX, toY],
		];
	};
	const getGridlayoutInfo = (layout: FrameNode) => {
		const parseName = layout.name.split("_");
		const gridName = parseName?.[0] + "-" + parseName?.[1];
		const slots = layout.children.map((slot) => {
			let path: string | null = null;
			if (slot.name.includes("svg")) {
				path = slot?.vectorPaths?.[0].data;
				const offsetX = slot?.["x"];
				const offsetY = slot?.["y"];
				const absolutePath = parse(path)?.map((p) => {
					// example: [["M", 0, 100], ["L", 100, 100], ["L", 50, 0], ["L", 0, 100], ["Z"]]
					if (p?.[0] === "M" || p?.[0] === "L") {
						return [p?.[0], p?.[1], p?.[2]];
					}
					return p;
				});
				path = absolutePath?.map((p) => p.join(" ")).join(" ");
			}
			return {
				rect: normalizePos(slot, layout),
				path,
			};
		});
		return {
			"name": gridName,
			"width": layout.width,
			"height": layout.height,
			"isVip": parseName?.[2] == "true" ? true : false,
			"isFilled": parseName?.[3] == "true" ? true : false,
			"slots": slots
		};
	};
	print(JSON.stringify(layouts.map(getGridlayoutInfo)));
