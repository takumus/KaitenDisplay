/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var main_1 = __webpack_require__(1);
	var renderer_1 = __webpack_require__(3);
	var stage = new PIXI.Container();
	var width;
	var height;
	var init = function () {
	    renderer_1.Renderer.init(stage);
	    document.getElementById("content").appendChild(renderer_1.Renderer.renderer.view);
	    window.addEventListener("resize", resize);
	    main_1.Drawer.init(stage);
	    resize();
	    draw();
	    var webSocket = new WebSocket("ws://takumus.com:3002");
	    webSocket.onopen = function () {
	        webSocket.send(JSON.stringify({
	            key: location.hash.substr(1)
	        }));
	        console.log(location.hash.substr(1));
	    };
	    webSocket.onclose = function () {
	        //alert("接続解除されました。\n遊んでいただきありがとうございます。");
	    };
	    main_1.Drawer.onSend = function () {
	        var data = {
	            data: {
	                line: main_1.Drawer.getData(),
	                width: width,
	                height: height
	            },
	            key: location.hash.substr(1)
	        };
	        if (webSocket.readyState != 1) {
	            alert("外からは送信できません。\nもう一度遊ぶ場合は、\nまたお越しください。");
	            return;
	        }
	        webSocket.send(JSON.stringify(data));
	        alert("タイヤに送信しました");
	    };
	};
	var draw = function () {
	    TWEEN.update();
	    requestAnimationFrame(draw);
	};
	var resize = function () {
	    width = document.documentElement.clientWidth * 2;
	    height = document.documentElement.clientHeight * 2;
	    renderer_1.Renderer.resize(width, height);
	    main_1.Drawer.resize(width, height);
	    renderer_1.Renderer.update();
	    main_1.Drawer.update();
	};
	window.onload = init;


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var drawer_1 = __webpack_require__(2);
	var button_1 = __webpack_require__(4);
	var Drawer;
	(function (Drawer) {
	    var _stage;
	    var canvas = new drawer_1.default();
	    var background = new PIXI.Graphics();
	    var clearButton = new button_1.default("消す", 0x333333, 0xFFFFFF);
	    var sendButton = new button_1.default("タイヤに送る！", 0xFF6666, 0xFFFFFF);
	    Drawer.onSend = null;
	    function init(stage) {
	        _stage = stage;
	        _stage.addChild(background);
	        canvas.init();
	        _stage.addChild(canvas);
	        _stage.addChild(sendButton, clearButton);
	        clearButton.on("tap", function () {
	            if (window.confirm("全て消しますか?")) {
	                canvas.reset();
	            }
	        });
	        sendButton.on("tap", function () {
	            if (Drawer.onSend)
	                Drawer.onSend();
	        });
	    }
	    Drawer.init = init;
	    function update() {
	    }
	    Drawer.update = update;
	    function resize(width, height) {
	        background.clear();
	        background.beginFill(0xFFFFFF);
	        background.drawRect(0, 0, width, height);
	        canvas.resize(width, width);
	        var bh = (height - width) / 2;
	        clearButton.resize(width, bh);
	        sendButton.resize(width, bh);
	        clearButton.y = width;
	        sendButton.y = width + bh;
	    }
	    Drawer.resize = resize;
	    function getData() {
	        return canvas.getData();
	    }
	    Drawer.getData = getData;
	})(Drawer || (Drawer = {}));
	exports.Drawer = Drawer;


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var renderer_1 = __webpack_require__(3);
	var DrawerCanvas = (function (_super) {
	    __extends(DrawerCanvas, _super);
	    function DrawerCanvas() {
	        var _this = _super.call(this) || this;
	        _this._graphics = new PIXI.Graphics();
	        _this.__mask = new PIXI.Graphics();
	        _this._wheel = new PIXI.Graphics();
	        _this.addChild(_this._graphics);
	        _this.addChild(_this.__mask);
	        _this.addChild(_this._wheel);
	        _this._graphics.mask = _this.__mask;
	        return _this;
	    }
	    DrawerCanvas.prototype.resize = function (width, height) {
	        this.__mask.clear();
	        this.__mask.beginFill(0xFFFFFF);
	        var cx = width / 2;
	        var cy = width / 2;
	        this._wheel.x = cx;
	        this._wheel.y = cy;
	        var cr = width * 0.05;
	        this.__mask.drawCircle(cx, cy, width / 2);
	        this._wheel.clear();
	        this._wheel.lineStyle(40, 0x000000);
	        this._wheel.drawCircle(0, 0, width / 2 - 20);
	        this._wheel.lineStyle(40, 0x333333);
	        this._wheel.drawCircle(0, 0, width / 2 - 30);
	        this._wheel.lineStyle(30, 0x999999);
	        this._wheel.drawCircle(0, 0, width / 2 - 40);
	        this._wheel.lineStyle(40, 0x999999);
	        this._wheel.beginFill(0xcccccc);
	        this._wheel.drawCircle(0, 0, cr - 5);
	        this._wheel.lineStyle();
	        this._wheel.beginFill(0x333333);
	        this._wheel.drawCircle(0, 0, cr * 0.1);
	        this.drawWheel(width / 2 - 40, cr, 16);
	    };
	    DrawerCanvas.prototype.drawWheel = function (len, cr, count) {
	        var wireLength = count;
	        var twist = 0.8;
	        this._wheel.endFill();
	        for (var i = 0; i < wireLength; i++) {
	            var radian = i / wireLength * (Math.PI * 2);
	            var bx = Math.cos(radian - twist) * cr + 0;
	            var by = Math.sin(radian - twist) * cr + 0;
	            var ex = Math.cos(radian) * len + 0;
	            var ey = Math.sin(radian) * len + 0;
	            this._wheel.lineStyle();
	            this._wheel.beginFill(0x666666);
	            this._wheel.drawCircle(bx, by, 5);
	            this._wheel.drawCircle(ex, ey, 5);
	            this._wheel.endFill();
	            this._wheel.lineStyle(4, 0xCCCCCC);
	            this._wheel.moveTo(bx, by);
	            this._wheel.lineTo(ex, ey);
	        }
	        var diff = (Math.PI * 2) * (1 / wireLength) / 2;
	        for (var i = 0; i < wireLength; i++) {
	            var radian = i / wireLength * (Math.PI * 2);
	            var bx = Math.cos(radian + twist + diff) * cr + 0;
	            var by = Math.sin(radian + twist + diff) * cr + 0;
	            var ex = Math.cos(radian + diff) * len + 0;
	            var ey = Math.sin(radian + diff) * len + 0;
	            this._wheel.lineStyle();
	            this._wheel.beginFill(0x666666);
	            this._wheel.drawCircle(bx, by, 5);
	            this._wheel.drawCircle(ex, ey, 5);
	            this._wheel.endFill();
	            this._wheel.lineStyle(4, 0xCCCCCC);
	            this._wheel.moveTo(bx, by);
	            this._wheel.lineTo(ex, ey);
	        }
	    };
	    DrawerCanvas.prototype.init = function () {
	        this.initMouseEvent();
	        this.reset();
	    };
	    DrawerCanvas.prototype.reset = function () {
	        this._data = "";
	        this._graphics.clear();
	        renderer_1.Renderer.update();
	    };
	    DrawerCanvas.prototype.getData = function () {
	        return this._data;
	    };
	    DrawerCanvas.prototype.initMouseEvent = function () {
	        var _this = this;
	        //タッチ禁止
	        var drawing = false;
	        document.addEventListener("touchstart", function (e) {
	            e.preventDefault();
	            _this._graphics.lineStyle(20, 0xff0000);
	            var x = e.touches[0].clientX * 2;
	            var y = e.touches[0].clientY * 2;
	            _this._graphics.moveTo(x, y);
	            _this._data += "b,";
	            _this._data += x + ":" + y + ",";
	        });
	        document.addEventListener("touchmove", function (e) {
	            e.preventDefault();
	            var x = e.touches[0].clientX * 2;
	            var y = e.touches[0].clientY * 2;
	            _this._graphics.lineTo(x, y);
	            _this._data += x + ":" + y + ",";
	            renderer_1.Renderer.update();
	        });
	        document.addEventListener("touchend", function (e) {
	            e.preventDefault();
	        });
	    };
	    return DrawerCanvas;
	}(PIXI.Container));
	Object.defineProperty(exports, "__esModule", { value: true });
	exports.default = DrawerCanvas;


/***/ },
/* 3 */
/***/ function(module, exports) {

	"use strict";
	var Renderer;
	(function (Renderer) {
	    function init(_stage) {
	        Renderer.renderer = new PIXI.CanvasRenderer();
	        Renderer.renderer.view.style.width = "100%";
	        Renderer.renderer.view.style.height = "100%";
	        Renderer.stage = _stage;
	    }
	    Renderer.init = init;
	    function resize(width, height) {
	        Renderer.renderer.resize(width, height);
	    }
	    Renderer.resize = resize;
	    function update() {
	        Renderer.renderer.render(Renderer.stage);
	    }
	    Renderer.update = update;
	})(Renderer = exports.Renderer || (exports.Renderer = {}));


/***/ },
/* 4 */
/***/ function(module, exports) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var Button = (function (_super) {
	    __extends(Button, _super);
	    function Button(label, bgColor, labelColor) {
	        var _this = _super.call(this) || this;
	        _this.interactive = true;
	        _this.bgColor = bgColor;
	        _this.labelColor = labelColor;
	        _this.background = new PIXI.Graphics();
	        var labelStyle = new PIXI.TextStyle();
	        labelStyle.fontSize = 50;
	        labelStyle.fill = _this.labelColor;
	        _this.label = new PIXI.Text(label, labelStyle);
	        _this.label.anchor.set(0.5, 0.5);
	        _this.addChild(_this.background);
	        _this.addChild(_this.label);
	        return _this;
	    }
	    Button.prototype.resize = function (width, height) {
	        this.background.clear();
	        this.background.beginFill(this.bgColor);
	        this.background.drawRect(0, 0, width, height);
	        this.label.x = width / 2;
	        this.label.y = height / 2;
	    };
	    return Button;
	}(PIXI.Container));
	Object.defineProperty(exports, "__esModule", { value: true });
	exports.default = Button;


/***/ }
/******/ ]);