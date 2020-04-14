import kha.Color;
import kha.Assets;
import kha.Framebuffer;
import kha.System;
import cake.engine.*;

class Main {
	public static function main() {
		System.start({title: "Kha", width: 800, height: 600}, function(_) {
			Assets.loadEverything(function() {
				System.notifyOnFrames(function(framebuffers) {
					render(framebuffers[0]);
				});
			});
		});
	}

	public static function render(framebuffer:Framebuffer) {
		// update
		@:privateAccess Time.update(System.time - Time.time);
		@:privateAccess Input.update();
		trace(1.0 / Time.deltaTime);
		// render
		framebuffer.g4.begin();

		framebuffer.g4.clear(Color.Cyan);

		framebuffer.g4.end();
	}
}
