package cake.engine;

import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;

@:allow(Main, cake.engine)
class Mesh {
	public static var cube:Mesh;
	public static var quad:Mesh;

	private static var structure:VertexStructure;
	private var vertexBuffer:VertexBuffer;
	private var indexBuffer:IndexBuffer;

	public function new(vertices:Array<Float>, indices:Array<Int>) {
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
	}

	private static function start() {
		structure = new VertexStructure();
		structure.add("pos", Float3);
		cube = new Mesh([
			-0.5, -0.5, 0.0,
			 0.5, -0.5, 0.0,
			-0.5,  0.5, 0.0,
			 0.5,  0.5, 0.0
		], [0, 1, 2, 1, 3, 2]);
		quad = new Mesh([
			-0.5, -0.5, 0.0,
			 0.5, -0.5, 0.0,
			-0.5,  0.5, 0.0,
			 0.5,  0.5, 0.0
		], [0, 1, 2, 1, 3, 2]);
	}
}
