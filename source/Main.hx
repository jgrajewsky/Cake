import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.System;
import cake.engine.*;
#if js
import js.Browser.document;
import js.Browser.window;
import kha.Macros;
#end

final class Main {
	public static function main() {
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

			Assets.loadEverything(function() {
				Scene.loadSceneByIndex(0);

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
		for (entity in Scene.entities) {
			entity.onUpdate();
		}

		// render
		var graphics = framebuffer.g4;
		graphics.begin();
		graphics.clear(Color.fromFloats(0.2, 0.3, 0.3, 1.0));
		graphics.end();
	}
}
