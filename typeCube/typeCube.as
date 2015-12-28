package 
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.materials.utils.MaterialsList;
	
	import charCube;
	
	/**
	 * ...
	 * @author Quinten Clause
	 */
	public class typeCube extends MovieClip 
	{
		// properties for papervision 
		public var viewport:Viewport3D;		
		public var renderer:BasicRenderEngine;
		public var default_scene:Scene3D;
		public var default_camera:Camera3D;
	
		public var charcube:Array = new Array();
		public var nCharCubes:int = 1;
		public var fontArr:Array = new Array();		
		public var gridSize:int = 20;
		public var gridWidth:int = 7;
		public var gridDepth:int = 9;
		public var zOffset:int = 650;
		
		public var sentence:String = "click me then type";
		public var word:Array;
		public var currentWord:int = 0;
		public var intervalID:uint;
		public var timeOutID:Array = new Array();
		
		private var paramObject:Object;
		
		public function typeCube():void 
		{	
			include "fieldFont9by11Matrix.as"
			
			//word = sentence.split(" ");
			paramObject = this.root.loaderInfo.parameters;
			sentence = (paramObject['titleStr']) ? paramObject['titleStr'] : sentence;
			word = new Array();
			for(var l=0; l < sentence.length; l++){
				word[l] = sentence.substr(l, 1);
			}
			//trace(word);
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			var vpWidth:Number = stage.stageWidth;
			var vpHeight:Number = stage.stageHeight;
			// create the 3D viewport, renderer, camera and scene
			init3Dengine(vpWidth, vpHeight);
			init3D();
		}
		
		private function init3Dengine(vpWidth:Number, vpHeight:Number):void 
		{
			viewport = new Viewport3D(vpWidth, vpHeight, true, true);
			addChild(viewport);
			renderer = new BasicRenderEngine();
			default_scene = new Scene3D();
			default_camera = new Camera3D();
		}
		
		// builds the 3D world
		public function init3D():void
		{
			// add objects to the scene here
			var flatShadeMaterial:FlatShadeMaterial = new FlatShadeMaterial(new PointLight3D(), 0x91ff22, 0x4e9b00);
			var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(flatShadeMaterial, "all");
			
			for (var c:int = 0; c < nCharCubes; c++ )
			{
				charcube[c] = new charCube(materialsList, gridSize);
				charcube[c].x = (c - ((nCharCubes - 1) / 2)) * gridSize * gridWidth;
				charcube[c].z = ((gridDepth / 2) * gridSize) - zOffset;
				default_scene.addChild(charcube[c]);
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			renderChar("xyz");
		}
		
		public function handleKeyUp(e:KeyboardEvent):void
		{
			var key_str:String = String.fromCharCode(e.charCode);
			renderChar(key_str);
		}
		
		public function renderChar(charKey:String):void
		{
			var dotContraction:Array = new Array();
			dotContraction[0] = [5, 5];
			for (var c:int = 0; c < nCharCubes; c++ )
			{
				var fontShape:Array = (fontArr[charKey]) ? fontArr[charKey] : dotContraction;
				charcube[c].changeChar(fontShape);
			}			
		}
		
		public function animationLoop():void
		{
			// animate objects here
			for (var c:int = 0; c < nCharCubes; c++ )
			{
				charcube[c].contract();
			}
		}
		
		// what happens every frame
		protected function onEnterFrame(e:Event):void 
		{
			animationLoop();
			renderer.renderScene(default_scene, default_camera, viewport);
		}
		
	}
	
}