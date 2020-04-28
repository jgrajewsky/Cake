import kha.graphics4.BlendingFactor;
import kha.graphics4.ConstantLocation;
import kha.graphics4.IndexBuffer;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.input.Keyboard;
import kha.Color;
import kha.Assets;
import kha.Framebuffer;
import kha.System;
import cake.engine.*;
import cake.editor.*;
#if js
import kha.Macros;
import js.Browser.document;
import js.Browser.window;
#end

@:build(IncludeMacro.build())
final class Main {
	static var vertices:Array<Float> = [
		-0.5, -0.5, 0.0,
		 0.5, -0.5, 0.0,
		-0.5,  0.5, 0.0,
		 0.5,  0.5, 0.0
	];
	static var indices:Array<Int> = [0, 1, 2, 1, 3, 2];
	static var vertexBuffer:VertexBuffer;
	static var indexBuffer:IndexBuffer;
	static var pipeline:PipelineState;
	static var matrix:ConstantLocation;
	static var size:ConstantLocation;
	static var rectTransform:RectTransform;

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

			var structure = new VertexStructure();
			structure.add("pos", Float3);
			pipeline = new PipelineState();
			pipeline.inputLayout = [structure];
			pipeline.vertexShader = Shaders.simple_vert;
			pipeline.fragmentShader = Shaders.simple_frag;
			// pipeline.cullMode = Clockwise;
			pipeline.blendSource = BlendingFactor.SourceAlpha;
			pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;
			pipeline.compile();
			matrix = pipeline.getConstantLocation("u_matrix");
			size = pipeline.getConstantLocation("u_size");
			vertexBuffer = new VertexBuffer(Std.int(vertices.length / 3), structure, StaticUsage);
			var vbData = vertexBuffer.lock();
			for (i in 0...vbData.length) {
				vbData.set(i, vertices[i]);
			}
			vertexBuffer.unlock();
			indexBuffer = new IndexBuffer(indices.length, StaticUsage);
			var iData = indexBuffer.lock();
			for (i in 0...iData.length) {
				iData[i] = indices[i];
			}
			indexBuffer.unlock();

			window.notifyOnResize(Main.onResize);

			Assets.loadEverything(function() {
				Scene.currentScene = new Scene(Assets.blobs.scene_xml.readUtf8String());

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

		// render
		var graphics = framebuffer.g4;
		graphics.begin();
		graphics.clear(Color.fromFloats(0.2, 0.3, 0.3, 1.0));

		// graphics.setPipeline(pipeline);
		// rectTransform.position = (new Vector2(Screen.width, Screen.height) - rectTransform.size) / 2.0;
		// rectTransform.rotation += 1.0;
		// rectTransform.scale = Vector2.one() * Math.pingPong(Time.time, 1.0, 2.0);
		// graphics.setMatrix3(matrix, rectTransform.rebuildMatrix(new Matrix3()));
		// graphics.setFloat2(size, rectTransform.size.x, rectTransform.size.y);
		// graphics.setVertexBuffer(vertexBuffer);
		// graphics.setIndexBuffer(indexBuffer);
		// graphics.drawIndexedVertices();

		graphics.end();
	}

}