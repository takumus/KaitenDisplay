import FileManager from './libs/files/FileManager';
import {View, ViewManager} from './libs/views/view';
import {Component, initComponent} from './libs/component/component'
import Views from './views/views';
import {Type1} from './types';
const viewManager:ViewManager = ViewManager.getInstance();
const init = ()=>{
	Views.init();
	viewManager.show("list", false);
	initComponent("components");
	const td:Array<Type1> = [];
	for(let i = 0; i < 10; i ++){
		td.push({
			name:i.toString(),
			data:null
		})
	}
	console.log(Views.views);
	Views.views.listViewController.setData(td);
}

const update = ()=>{
	TWEEN.update();
	viewManager.update();
	requestAnimationFrame(update);
}
update();

window.addEventListener("load", init);