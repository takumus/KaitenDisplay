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
	var renderer = PIXI.autoDetectRenderer(800, 800);
	var stage = new PIXI.Container();
	var init = function () {
	    renderer.view.style.width = "100%";
	    renderer.view.style.height = "100%";
	    document.getElementById("content").appendChild(renderer.view);
	    window.addEventListener("resize", resize);
	    main_1.Drawer.init(stage);
	    resize();
	    draw();
	};
	var draw = function () {
	    TWEEN.update();
	    renderer.render(stage);
	    main_1.Drawer.update();
	    requestAnimationFrame(draw);
	};
	var resize = function () {
	    var width = window.innerWidth * 2;
	    var height = window.innerHeight * 2;
	    renderer.resize(width, height);
	    main_1.Drawer.resize(width, height);
	};
	window.onload = init;


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var drawer_1 = __webpack_require__(2);
	var Drawer;
	(function (Drawer) {
	    var _stage;
	    var background = new PIXI.Graphics();
	    function init(stage) {
	        _stage = stage;
	        _stage.addChild(background);
	        drawer_1.DrawerCanvas.init();
	        _stage.addChild(drawer_1.DrawerCanvas.canvas);
	    }
	    Drawer.init = init;
	    function update() {
	    }
	    Drawer.update = update;
	    function resize(width, height) {
	        background.clear();
	        background.beginFill(0xFFFFFF);
	        background.drawRect(0, 0, width, height);
	    }
	    Drawer.resize = resize;
	})(Drawer || (Drawer = {}));
	exports.Drawer = Drawer;


/***/ },
/* 2 */
/***/ function(module, exports) {

	"use strict";
	var DrawerCanvas;
	(function (DrawerCanvas) {
	    DrawerCanvas.canvas = new PIXI.Graphics();
	    function resize(width, height) {
	    }
	    DrawerCanvas.resize = resize;
	    function init() {
	        initMouseEvent();
	    }
	    DrawerCanvas.init = init;
	    function initMouseEvent() {
	        console.log(1);
	        //タッチ禁止
	        document.addEventListener("touchstart", function (e) { return e.preventDefault(); });
	        var drawing = false;
	        DrawerCanvas.canvas.lineStyle(10);
	        document.addEventListener("mousedown", function (e) {
	            drawing = true;
	            DrawerCanvas.canvas.moveTo(e.clientX * 2, e.clientY * 2);
	        });
	        document.addEventListener("mousemove", function (e) {
	            if (!drawing)
	                return;
	            DrawerCanvas.canvas.lineTo(e.clientX * 2, e.clientY * 2);
	        });
	        document.addEventListener("mouseup", function (e) {
	            drawing = false;
	        });
	    }
	})(DrawerCanvas || (DrawerCanvas = {}));
	exports.DrawerCanvas = DrawerCanvas;


/***/ }
/******/ ]);