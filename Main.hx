import lime.ui.MouseButton;
import lime.app.Application;
import lime.graphics.*;
import lime.graphics.opengl.*;
import lime.utils.*;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import cake.engine.*;

@:noCompletion class Main extends Application {
	public static var gl:WebGLRenderContext;

	public static var shader:Shader;

	var vbo:GLBuffer;
	var colors:GLBuffer;
	var camera:Camera;

	public function new() {
		super();

		var c = new Entity("Camera");
		c.addComponent(Transform);
		camera = cast c.addComponent(Camera);
		for (_ in 0...100000) {
			var mesh = new Entity("Mesh");
			var tttt = cast mesh.addComponent(Transform);
			tttt.position = new Vector3(Math.random() * 2000.0 - 1000.0, Math.random() * 2000.0 - 1000.0, Math.random() * 2000.0 - 1000.0);
			tttt.rotation = new Vector3(Math.random() * 360.0, Math.random() * 360.0, Math.random() * 360.0);
			tttt.scale = Vector3.one() * 0.2;
			var aa = mesh.addComponent(MeshRenderer);
			aa.onCreate();
		}

		@:privateAccess Input.start();
	}

	public override function onWindowCreate() {
		window.frameRate = 1000;
		window.resizable = true;
		Screen.width = window.width;
		Screen.height = window.height;

		gl = window.context.webgl;
		gl.clearColor(0.2, 0.3, 0.3, 1.0);

		vbo = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, vbo);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
			0, 0, 0, 0, 150, 0, 30, 0, 0, 0, 150, 0, 30, 150, 0, 30, 0, 0, // top rung front
			30, 0, 0, 30, 30, 0, 100, 0, 0, 30, 30, 0, 100, 30, 0, 100, 0, 0,
			30, 60, 0, 30, 90, 0, 67, 60, 0, 30, 90, 0, 67, 90, 0, 67, 60, 0, // left column back
			0, 0, 30, 30, 0, 30, 0, 150, 30, 0, 150, 30, 30, 0, 30, 30,
			150, 30, // top rung back
			30, 0, 30, 100, 0, 30, 30, 30, 30, 30, 30, 30, 100, 0, 30, 100, 30, 30, // middle rung back
			30, 60, 30, 67, 60, 30, 30,
			90, 30, 30, 90, 30, 67, 60, 30, 67, 90, 30, // top
			0, 0, 0, 100, 0, 0, 100, 0, 30, 0, 0, 0, 100, 0, 30, 0, 0, 30, // top rung right
			100, 0, 0, 100,
			30, 0, 100, 30, 30, 100, 0, 0, 100, 30, 30, 100, 0, 30, // under top rung
			30, 30, 0, 30, 30, 30, 100, 30, 30, 30, 30, 0, 100, 30, 30, 100, 30,
			0, // between top rung and middle
			30, 30, 0, 30, 60, 30, 30, 30, 30, 30, 30, 0, 30, 60, 0, 30, 60, 30, // top of middle rung
			30, 60, 0, 67, 60, 30,
			30, 60, 30, 30, 60, 0, 67, 60, 0, 67, 60, 30, // right of middle rung
			67, 60, 0, 67, 90, 30, 67, 60, 30, 67, 60, 0, 67, 90, 0, 67, 90,
			30, // bottom of middle rung.
			30, 90, 0, 30, 90, 30, 67, 90, 30, 30, 90, 0, 67, 90, 30, 67, 90, 0, // right of bottom
			30, 90, 0, 30, 150, 30, 30,
			90, 30, 30, 90, 0, 30, 150, 0, 30, 150, 30, // bottom
			0, 150, 0, 0, 150, 30, 30, 150, 30, 0, 150, 0, 30, 150, 30, 30, 150, 0, // left side
			0, 0, 0,
			0, 0, 30, 0, 150, 30, 0, 0, 0, 0, 150, 30, 0, 150, 0
		]), gl.STATIC_DRAW);

		colors = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, colors);
		gl.bufferData(gl.ARRAY_BUFFER, new UInt8Array([
			// left column front
			200, 70, 120, 200, 70, 120, 200, 70, 120, 200, 70, 120, 200, 70, 120, 200, 70, 120, // top rung front

			200, 70, 120, 200, 70,
			120, 200, 70, 120, 200, 70, 120, 200, 70, 120, 200, 70, 120, // middle rung front

			200, 70, 120, 200, 70, 120, 200, 70, 120, 200, 70, 120, 200, 70,
			120, 200, 70, 120, // left column back

			80, 70, 200, 80, 70, 200, 80, 70, 200, 80, 70, 200, 80, 70, 200, 80, 70, 200, // top rung back

			80, 70, 200,
			80, 70, 200, 80, 70, 200, 80, 70, 200, 80, 70, 200, 80, 70, 200, // middle rung back

			80, 70, 200, 80, 70, 200, 80, 70, 200, 80, 70, 200, 80, 70,
			200, 80, 70, 200, // top

			70, 200, 210, 70, 200, 210, 70, 200, 210, 70, 200, 210, 70, 200, 210, 70, 200, 210, // top rung right

			200, 200, 70, 200,
			200, 70, 200, 200, 70, 200, 200, 70, 200, 200, 70, 200, 200, 70, // under top rung

			210, 100, 70, 210, 100, 70, 210, 100, 70, 210, 100, 70, 210,
			100, 70, 210, 100, 70, // between top rung and middle

			210, 160, 70, 210, 160, 70, 210, 160, 70, 210, 160, 70, 210, 160, 70, 210, 160, 70,

			// top of middle rung
			70, 180, 210, 70, 180, 210, 70, 180, 210, 70, 180, 210, 70, 180, 210, 70, 180, 210, // right of middle rung

			100, 70, 210, 100,
			70, 210, 100, 70, 210, 100, 70, 210, 100, 70, 210, 100, 70, 210, // bottom of middle rung.

			76, 210, 100, 76, 210, 100, 76, 210, 100, 76, 210, 100,
			76, 210, 100, 76, 210, 100, // right of bottom

			140, 210, 80, 140, 210, 80, 140, 210, 80, 140, 210, 80, 140, 210, 80, 140, 210, 80, // bottom

			90,
			130, 110, 90, 130, 110, 90, 130, 110, 90, 130, 110, 90, 130, 110, 90, 130, 110, // left side

			160, 160, 220, 160, 160, 220, 160, 160, 220, 160, 160,
			220, 160, 160, 220, 160, 160, 220
		]), gl.STATIC_DRAW);

		preloader.onComplete.add(function() {
			shader = new Shader("Assets/vert.glsl", "Assets/frag.glsl");
		});
	}

	public override function onKeyDown(key:KeyCode, modifier:KeyModifier):Void {
		@:privateAccess Input.keyUpdate(key, true);
	}

	public override function onKeyUp(key:KeyCode, modifier:KeyModifier):Void {
		@:privateAccess Input.keyUpdate(key, false);
	}

	public override function onMouseDown(x:Float, y:Float, button:MouseButton) {
		switch button {
			case LEFT:
				@:privateAccess Input.setKey(MOUSE_0, true);
			case MIDDLE:
				@:privateAccess Input.setKey(MOUSE_2, true);
			case RIGHT:
				@:privateAccess Input.setKey(MOUSE_1, true);
		}
		window.cursor = MOVE;
	}

	public override function onMouseUp(x:Float, y:Float, button:MouseButton) {
		switch button {
			case LEFT:
				@:privateAccess Input.setKey(MOUSE_0, false);
			case MIDDLE:
				@:privateAccess Input.setKey(MOUSE_2, false);
			case RIGHT:
				@:privateAccess Input.setKey(MOUSE_1, false);
		}
		window.cursor = ARROW;
	}

	public override function onMouseMove(x:Float, y:Float) {
		Input.mousePosition.set(x, y);
	}

	public override function onMouseMoveRelative(x:Float, y:Float) {
		Input.mouseDelta.set(x, y);
	}

	public override function onWindowResize(width:Int, height:Int) {
		Screen.width = width;
		Screen.height = height;
		gl.viewport(0, 0, width, height);
	}

	public override function update(deltaTime:Int) {
		@:privateAccess Time.update(deltaTime);
		@:privateAccess Input.update();
		trace(1.0 / Time.unscaledDeltaTime);
		@:privateAccess camera.entity.onUpdate();
		Input.mouseDelta.set(0.0, 0.0);
	}

	public override function render(context:RenderContext):Void {
		gl.vertexAttribPointer(0, 2, gl.FLOAT, false, 0, 0);
		gl.enableVertexAttribArray(0);

		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
		gl.enable(gl.CULL_FACE);
		gl.enable(gl.DEPTH_TEST);

		if (shader != null && shader.program != null) {
			gl.useProgram(shader.program);

			var positionLocation = gl.getAttribLocation(shader.program, "a_position");
			gl.enableVertexAttribArray(positionLocation);

			gl.bindBuffer(gl.ARRAY_BUFFER, vbo);

			gl.vertexAttribPointer(positionLocation, 3, gl.FLOAT, false, 0, 0);

			var colorLocation = gl.getAttribLocation(shader.program, "a_color");
			gl.enableVertexAttribArray(colorLocation);

			gl.bindBuffer(gl.ARRAY_BUFFER, colors);

			gl.vertexAttribPointer(colorLocation, 3, gl.UNSIGNED_BYTE, true, 0, 0);

			@:privateAccess camera.render();
		}
	}
}
