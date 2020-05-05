import kha.graphics4.Graphics;
import kha.input.Keyboard;
import kha.Color;
import kha.Assets;
import kha.Framebuffer;
import kha.System;
import cake.engine.*;
import cake.editor.*;
#if js
import js.Browser.document;
import js.Browser.window;
import kha.Macros;
#end

final class Main {
	public static function main() {
		Keyboard.disableSystemInterventions(None);
		#if js
		document.documentElement.setAttribute("style", "height:100%");
		document.body.setAttribute("style", "margin:0;height:100%");
		function onResize() {
			Main.onResize(window.innerWidth, window.innerHeight);
		};
		window.onresize = onResize;
		onResize();
		#end
		System.start({title: "Cake"}, function(window) {
			#if js
			document.getElementById(Macros.canvasId()).setAttribute("style", "width:100%;height:100%");
			#end

			window.notifyOnResize(Main.onResize);
			Mesh.start();
			Canvas.start();

			Assets.loadEverything(function() {
				Scene.currentScene = new Scene(Assets.blobs.scene_xml.readUtf8String());
				var canvas:Canvas = cast Scene.currentScene.entities[0].getComponent(Canvas);
				canvas.loadDocument(Assets.blobs.window_xml.readUtf8String());

				System.notifyOnFrames(function(framebuffers) {
					render(framebuffers[0]);
				});
			});
		});
	}

	public static function onResize(width:Int, height:Int) {
		Screen.width = width;
		Screen.height = height;
	}

	public static function render(framebuffer:Framebuffer) {
		// update
		Time.update(System.time - Time.time);
		Input.update();
		for (entity in Scene.currentScene.entities) {
			entity.onUpdate();
		}

		// render
		var graphics = framebuffer.g4;
		graphics.begin();
		graphics.clear(Color.fromFloats(0.2, 0.3, 0.3, 1.0));

		Canvas.renderAll(graphics);

		graphics.end();
	}
}
