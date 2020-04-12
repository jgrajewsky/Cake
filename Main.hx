import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	static function update():Void {
		trace("hello world!");
	}

	static function render(framebuffer:Framebuffer):Void {}

	public static function main() {
		System.start({title: "Kha", width: 800, height: 600}, function(_) {
			// Just loading everything is ok for small projects
			Assets.loadEverything(function() {
				// Avoid passing update/render directly,
				// so replacing them via code injection works
				Scheduler.addTimeTask(function() {
					update();
				}, 0, timeFPS);
				System.notifyOnFrames(function(framebuffers) {
					render(framebuffers[0]);
				});
			});
		});
	}
}
