package cake.engine;

import lime.graphics.opengl.GLProgram;
import lime.utils.Assets;

class Shader {
	public var program:GLProgram;

	public function new(vertShaderPath:String, fragShaderPath:String) {
		Assets.loadText(vertShaderPath).onComplete(function(vertSource) {
			var vertShader = Main.gl.createShader(Main.gl.VERTEX_SHADER);
			Main.gl.shaderSource(vertShader, vertSource);
			Main.gl.compileShader(vertShader);
			Assets.loadText(fragShaderPath).onComplete(function(fragSource) {
				var fragShader = Main.gl.createShader(Main.gl.FRAGMENT_SHADER);
				Main.gl.shaderSource(fragShader, fragSource);
				Main.gl.compileShader(fragShader);
				program = Main.gl.createProgram();
				Main.gl.attachShader(program, vertShader);
				Main.gl.attachShader(program, fragShader);
				Main.gl.linkProgram(program);
				Main.gl.deleteShader(vertShader);
				Main.gl.deleteShader(fragShader);
			});
		});
	}
}
