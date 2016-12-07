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
	var view_1 = __webpack_require__(1);
	var component_1 = __webpack_require__(2);
	var views_1 = __webpack_require__(3);
	var viewManager = view_1.ViewManager.getInstance();
	var init = function () {
	    views_1.default.init();
	    viewManager.show("list", false);
	    component_1.initComponent("components");
	    var td = [];
	    for (var i = 0; i < 10; i++) {
	        td.push({
	            name: i.toString(),
	            data: null
	        });
	    }
	    console.log(views_1.default.views);
	    views_1.default.views.listViewController.setData(td);
	};
	var update = function () {
	    TWEEN.update();
	    viewManager.update();
	    requestAnimationFrame(update);
	};
	update();
	window.addEventListener("load", init);


/***/ },
/* 1 */
/***/ function(module, exports) {

	"use strict";
	var View = (function () {
	    function View(id, elementId) {
	        this.__x = 0;
	        if (!elementId)
	            elementId = id;
	        this._element = document.getElementById(elementId);
	        this._id = id;
	    }
	    Object.defineProperty(View.prototype, "id", {
	        get: function () {
	            return this._id;
	        },
	        enumerable: true,
	        configurable: true
	    });
	    Object.defineProperty(View.prototype, "element", {
	        get: function () {
	            return this._element;
	        },
	        enumerable: true,
	        configurable: true
	    });
	    Object.defineProperty(View.prototype, "_x", {
	        get: function () {
	            return this.__x;
	        },
	        set: function (value) {
	            this.__x = value;
	            this._element.style.left = value + "px";
	        },
	        enumerable: true,
	        configurable: true
	    });
	    Object.defineProperty(View.prototype, "_visible", {
	        set: function (value) {
	            this._element.style.display = value ? "block" : "none";
	        },
	        enumerable: true,
	        configurable: true
	    });
	    View.prototype.getElement = function (name) {
	        var elements = document.getElementsByName(name);
	        for (var i = 0; i < elements.length; i++) {
	            var element = elements[i];
	            if (this._element.contains(element)) {
	                return element;
	            }
	        }
	        console.warn(name + " is not found in " + this.id);
	        return null;
	    };
	    View.prototype._setIndex = function (value) {
	        this._element.style.zIndex = value.toString();
	    };
	    return View;
	}());
	exports.View = View;
	var Controller = (function () {
	    function Controller(view) {
	        this.view = view;
	    }
	    return Controller;
	}());
	exports.Controller = Controller;
	var ViewManager = (function () {
	    function ViewManager() {
	        if (!ViewManager.__fromGetInstance)
	            throw new Error("getInstanceを使おう");
	        this._history = [];
	        this._views = {};
	        this.initGuesture();
	    }
	    ViewManager.getInstance = function () {
	        this.__fromGetInstance = true;
	        if (!this.__instance)
	            this.__instance = new ViewManager();
	        this.__fromGetInstance = false;
	        return this.__instance;
	    };
	    ViewManager.prototype.add = function (controller) {
	        var view = controller.view;
	        this._views[view.id] = view;
	        view._visible = false;
	        view.element.style.position = "absolute";
	        console.log(view);
	    };
	    ViewManager.prototype.addAll = function (controllers) {
	        var _this = this;
	        Object.keys(controllers).forEach(function (key) {
	            _this.add(controllers[key]);
	        });
	    };
	    ViewManager.prototype.show = function (id, animate) {
	        if (animate === void 0) { animate = true; }
	        if (this._animating) {
	            console.warn("processing");
	            return;
	        }
	        if (!this._views[id]) {
	            console.warn(id + " is not found");
	            return;
	        }
	        var view = this._views[id];
	        if (view == this.prevView) {
	            console.warn(id + " is showing");
	            return;
	        }
	        this._history.push(view);
	        this._animating = animate;
	        view._visible = true;
	        this.view._setIndex(this._history.length);
	        //if(this.prevView) this.prevView.deactivate();
	        if (animate) {
	            this.showAnimate(true);
	        }
	        else {
	            view._x = 0;
	            if (this.prevView)
	                this.prevView._visible = false;
	        }
	        console.log(this._history);
	    };
	    ViewManager.prototype.back = function (animate) {
	        var _this = this;
	        if (animate === void 0) { animate = true; }
	        if (this._animating) {
	            console.warn("processing");
	            return;
	        }
	        if (!this.prevView) {
	            console.warn("cannot back");
	            return;
	        }
	        var view = this.view;
	        var prevView = this.prevView;
	        var w = window.innerWidth;
	        this._history.pop();
	        prevView._visible = true;
	        if (view._x < 0)
	            view._x = 0;
	        var per = view._x / w;
	        per = per > 1 ? 1 : per;
	        var time = 500 * (1 - per);
	        //this.view.deactivate();
	        //if(this.prevView) this.prevView.activate();
	        this._animating = animate;
	        if (animate) {
	            new TWEEN.Tween({ x: view._x })
	                .to({ x: w }, time)
	                .easing(TWEEN.Easing.Quadratic.Out)
	                .onUpdate(function () {
	                view._x = this.x;
	                prevView._x = -(w - view._x) / 2;
	            })
	                .onComplete(function () {
	                view._x = w;
	                view._visible = false;
	                prevView._x = 0;
	                _this._animating = false;
	            })
	                .start();
	        }
	        else {
	            view._x = w;
	        }
	        console.log(this._history);
	    };
	    ViewManager.prototype.showAnimate = function (reset) {
	        var _this = this;
	        var view = this.view;
	        var prevView = this.prevView;
	        var w = window.innerWidth;
	        if (reset)
	            view._x = w;
	        if (view._x < 0)
	            view._x = 0;
	        var per = view._x / w;
	        var time = 500 * (per);
	        new TWEEN.Tween({ v: view._x })
	            .to({ v: 0 }, time)
	            .easing(TWEEN.Easing.Quadratic.Out)
	            .onUpdate(function () {
	            view._x = this.v;
	            prevView._x = -(w - view._x) / 2;
	        })
	            .onComplete(function () {
	            view._x = 0;
	            prevView._x = -w / 2;
	            _this.prevView._visible = false;
	            _this._animating = false;
	        })
	            .start();
	    };
	    ViewManager.prototype.initGuesture = function () {
	        var _this = this;
	        var pressing = false;
	        var vx = 0;
	        var px = 0;
	        var nx = 0;
	        var begin = function (x) {
	            if (x > 30)
	                return;
	            if (_this._animating)
	                return;
	            if (!_this.prevView)
	                return;
	            pressing = true;
	            vx = 0;
	            px = x;
	            nx = x;
	            //前ビューを表示
	            _this.prevView._visible = true;
	            console.log("begin");
	            console.log(x);
	        };
	        var move = function (x) {
	            if (!pressing)
	                return;
	            nx = x;
	        };
	        var update = function () {
	            if (!pressing)
	                return;
	            vx = nx - px;
	            px = nx;
	            console.log("move");
	            console.log(vx);
	            //ビューをマウスへ。
	            _this.view._x += vx;
	            _this.prevView._x = -(window.innerWidth - _this.view._x) / 2;
	        };
	        var end = function () {
	            if (!pressing)
	                return;
	            if (vx > 20) {
	                _this.back();
	            }
	            else if (vx < -20) {
	                _this.showAnimate(false);
	            }
	            else {
	                console.log(nx, window.innerWidth);
	                if (nx > window.innerWidth / 2) {
	                    _this.back();
	                }
	                else {
	                    _this.showAnimate(false);
	                }
	            }
	            //前ビューを非表示。
	            console.log("end");
	            pressing = false;
	        };
	        document.addEventListener("mousedown", function (e) {
	            begin(e.clientX);
	        });
	        document.addEventListener("mousemove", function (e) {
	            move(e.clientX);
	        });
	        document.addEventListener("mouseup", function (e) {
	            end();
	        });
	        document.addEventListener("touchstart", function (e) {
	            if (e.touches.length > 1)
	                return;
	            begin(e.touches[0].clientX);
	        });
	        document.addEventListener("touchmove", function (e) {
	            if (e.touches.length > 1)
	                return;
	            move(e.touches[0].clientX);
	        });
	        document.addEventListener("touchend", function (e) {
	            if (e.touches.length > 0)
	                return;
	            end();
	        });
	        document.addEventListener("touchcancel", function (e) {
	            end();
	        });
	        this._update = function () {
	            update();
	        };
	    };
	    Object.defineProperty(ViewManager.prototype, "prevView", {
	        get: function () {
	            if (this._history.length > 1)
	                return this._history[this._history.length - 2];
	            return null;
	        },
	        enumerable: true,
	        configurable: true
	    });
	    Object.defineProperty(ViewManager.prototype, "view", {
	        get: function () {
	            if (this._history.length > 0)
	                return this._history[this._history.length - 1];
	            return null;
	        },
	        enumerable: true,
	        configurable: true
	    });
	    ViewManager.prototype.pop = function () {
	        if (this._history.length > 0)
	            return this._history.pop();
	        return null;
	    };
	    ViewManager.prototype.update = function () {
	        if (this._update)
	            this._update();
	    };
	    return ViewManager;
	}());
	exports.ViewManager = ViewManager;


/***/ },
/* 2 */
/***/ function(module, exports) {

	"use strict";
	var Component = (function () {
	    function Component(id) {
	        this._element = document.getElementById(id).cloneNode(true);
	        this._id = id;
	    }
	    Component.prototype.getElement = function (name) {
	        var elements = document.getElementsByName(name);
	        for (var i = 0; i < elements.length; i++) {
	            var element = elements[i];
	            if (this._element.contains(element)) {
	                return element;
	            }
	        }
	        console.warn(name + " is not found in component " + this._id);
	        return null;
	    };
	    Object.defineProperty(Component.prototype, "element", {
	        get: function () {
	            return this._element;
	        },
	        enumerable: true,
	        configurable: true
	    });
	    return Component;
	}());
	exports.Component = Component;
	var initComponent = function (parentId) {
	    var parent = document.getElementById(parentId);
	    parent.style.display = "none";
	};
	exports.initComponent = initComponent;


/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var listView_1 = __webpack_require__(4);
	var iconListView_1 = __webpack_require__(7);
	var dataView_1 = __webpack_require__(8);
	var view_1 = __webpack_require__(1);
	var views;
	var init = function () {
	    views = {
	        listViewController: new listView_1.default(),
	        iconListViewController: new iconListView_1.default(),
	        dataViewController: new dataView_1.default()
	    };
	    view_1.ViewManager.getInstance().addAll(views);
	};
	Object.defineProperty(exports, "__esModule", { value: true });
	exports.default = {
	    init: init,
	    views: views
	};


/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var view_1 = __webpack_require__(1);
	var components_1 = __webpack_require__(5);
	var _View = (function (_super) {
	    __extends(_View, _super);
	    function _View() {
	        _super.call(this, "list");
	        this.title = this.getElement("title");
	        this.list = this.getElement("list");
	        this.title.innerText = "リスト";
	    }
	    return _View;
	}(view_1.View));
	var _Controller = (function (_super) {
	    __extends(_Controller, _super);
	    function _Controller() {
	        _super.call(this, new _View());
	        this.init();
	    }
	    _Controller.prototype.init = function () {
	    };
	    _Controller.prototype.setData = function (data) {
	        var list = this.view.list;
	        data.forEach(function (d) {
	            var child = new components_1.ListChildComponent();
	            child.setData(d);
	            list.appendChild(child.element);
	        });
	    };
	    return _Controller;
	}(view_1.Controller));
	Object.defineProperty(exports, "__esModule", { value: true });
	exports.default = _Controller;


/***/ },
/* 5 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var listChildComponent_1 = __webpack_require__(6);
	exports.ListChildComponent = listChildComponent_1.default;


/***/ },
/* 6 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var component_1 = __webpack_require__(2);
	var ListChild = (function (_super) {
	    __extends(ListChild, _super);
	    function ListChild() {
	        _super.call(this, "component_list_child");
	        this._link = this.getElement("link");
	    }
	    ListChild.prototype.setData = function (data) {
	        this._link.textContent = data.name;
	    };
	    return ListChild;
	}(component_1.Component));
	Object.defineProperty(exports, "__esModule", { value: true });
	exports.default = ListChild;


/***/ },
/* 7 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var view_1 = __webpack_require__(1);
	var _View = (function (_super) {
	    __extends(_View, _super);
	    function _View() {
	        _super.call(this, "icon_list");
	        this.title = this.getElement("title");
	        this.title.innerText = "サブ";
	    }
	    return _View;
	}(view_1.View));
	var _Controller = (function (_super) {
	    __extends(_Controller, _super);
	    function _Controller() {
	        _super.call(this, new _View());
	    }
	    return _Controller;
	}(view_1.Controller));
	Object.defineProperty(exports, "__esModule", { value: true });
	exports.default = _Controller;


/***/ },
/* 8 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var view_1 = __webpack_require__(1);
	var _View = (function (_super) {
	    __extends(_View, _super);
	    function _View() {
	        _super.call(this, "data");
	        this.title = this.getElement("title");
	        this.title.innerText = "sub222";
	    }
	    return _View;
	}(view_1.View));
	var _Controller = (function (_super) {
	    __extends(_Controller, _super);
	    function _Controller() {
	        _super.call(this, new _View());
	        this.init();
	    }
	    _Controller.prototype.init = function () {
	    };
	    return _Controller;
	}(view_1.Controller));
	Object.defineProperty(exports, "__esModule", { value: true });
	exports.default = _Controller;


/***/ }
/******/ ]);