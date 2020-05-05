package cake.engine;

import haxe.ds.GenericStack;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.Graphics;

@:allow(Main)
final class Canvas extends CanvasElement {
	private static var all:Array<Canvas> = [];
	private static var pipeline:PipelineState;

	public override function onCreate() {
		all.push(this);
		tag = "canvas";
		super.onCreate();
	}

	public override function onDestroy() {
		all.remove(this);
	}

	private static function start() {
		pipeline = new PipelineState();
		pipeline.inputLayout = [Mesh.structure];
		pipeline.blendSource = SourceAlpha;
		pipeline.blendDestination = InverseSourceAlpha;
		pipeline.vertexShader = Shaders.simple_vert;
		pipeline.fragmentShader = Shaders.simple_frag;
		pipeline.compile();
		CanvasElement.colorLocation = pipeline.getConstantLocation("u_color");
		CanvasElement.sizeLocation = pipeline.getConstantLocation("u_size");
		CanvasElement.matrixLocation = pipeline.getConstantLocation("u_matrix");
	}

	public function loadDocument(data:String):Void {
		var elementStack:GenericStack<CanvasElement> = new GenericStack<CanvasElement>();
		elementStack.add(this);
		var currentText:String = "";
		var textOnly:Bool = true;
		var lineNumber:Int = 1, charNumber:Int = 1;
		var i = 0;
		while (i < data.length) {
			var char = data.charAt(i);
			switch char {
				case "<":
					if (textOnly) {
						if (currentText != "") {
							var parent = elementStack.first();
							var entity = new Entity("Text");
							entity.parent = parent.entity;
							var element:CanvasElement = cast entity.addComponent(CanvasElement);
							element.text = currentText;
							parent.children.push(element);
							currentText = "";
						}
						textOnly = false;
					} else {
						throw 'Unexpected "<" at line ${lineNumber} character ${charNumber}';
					}
				case ">":
					if (!textOnly && currentText != "") {
						var parent = elementStack.first();
						var entity = new Entity("Element");
						entity.parent = parent.entity;
						var element:CanvasElement = cast entity.addComponent(CanvasElement);
						var hasTag = false;
						var i = 0;
						while (i < currentText.length) {
							var char = currentText.charAt(i);
							if (!hasTag) {
								if (char != " ") {
									element.tag += char;
								} else {
									hasTag = true;
								}
							}
							++i;
						}
						parent.children.push(element);
						elementStack.add(element);
						currentText = "";
						textOnly = true;
					} else {
						throw 'Unexpected ">" at line ${lineNumber} character ${charNumber}';
					}
				case "/":
					if (!textOnly) {
						var element = elementStack.pop();
						if (element != null && data.substr(i + 1, element.tag.length) == element.tag) {
							i += element.tag.length + 1;
							textOnly = true;
						} else {
							throw 'Unexpected "</" at line ${lineNumber} character ${charNumber}';
						}
					} else {
						currentText += char;
					}
				case "\n":
					++lineNumber;
					charNumber = 0;
				default:
					currentText += char;
			}
			++charNumber;
			++i;
		}
	}

	private static function renderAll(graphics:Graphics):Void {
		graphics.setPipeline(pipeline);
		graphics.setVertexBuffer(Mesh.quad.vertexBuffer);
		graphics.setIndexBuffer(Mesh.quad.indexBuffer);
		for (canvas in all) {
			canvas.render(graphics);
		}
	}
}
