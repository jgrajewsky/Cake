package cake.engine;

import haxe.ds.GenericStack;

@:allow(Main)
final class Scene {
	public static var currentScene:Scene;

	public var entities:Array<Entity>;

	private function new(data:String) {
		var entityStack:GenericStack<Entity> = new GenericStack<Entity>();
		var currentText = "";
		var i = 0;
		while (i < data.length) {
			var char = data.charAt(i);
			switch char {
				case ">":
					if (!textOnly && currentText != "") {
						var entity = parseEntity(currentText);
						var parent = entityStack.first();
						if (parent != null) {
							parent.children.push(entity);
						} else {
							entities.push(entity);
						}
						entityStack.add(entity);
						currentText = "";
					} else {
						throw 'Unexpected ">"';
					}
				case "<":
					if (textOnly) {
						if (currentText != "") {
							entityStack.first().children.push(new Entity(""));
						}
						textOnly = false;
					} else {
						throw 'Unexpected "<"';
					}
				case "/":
					if (!textOnly) {
						var entity = entityStack.pop();
						if (entity != null && data.substr(i + 1, entity.tag.length) == entity.tag) {
							i += entity.tag.length + 1;
						} else {
							throw 'Unexpected "</"';
						}
					} else {
						currentText += char;
					}
				default:
					currentText += char;
			}
			++i;
		}
	}

	private function parseEntity(tag:String):Entity {
		// var i = 1;
		// var tag = "";
		// var hasTag = false;
		// while (i < tag.length) {
		// 	var char = tag.charAt(i);
		// 	if (!hasTag) {
		// 		if (char != " ") {
		// 			tag += char;
		// 		} else {
		// 			hasTag = true;
		// 		}
		// 	}
		// 	++i;
		// }
		return new Entity("");
	}

	/** Returns a Scene with a specified index. **/
	public static function getSceneByIndex(index:Int):Scene {
		return null;
	}

	public static function loadScene(scene:Scene):Void {}

	public static function loadSceneAdditive(scene:Scene):Void {}
}
