package cake.engine;

import haxe.macro.Context;
import haxe.macro.Expr;

@:allow(Main)
final class Scene {
	/** Currently loaded Scene. (Read Only) **/
	public static var currentScene(default, null):Scene;

	/** All root level entities from the current loaded Scene. (Read Only) **/
	public static var entities(default, null):ReadOnlyArray<Entity> = [];

	/** 
		Loads a Scene with a specified index.
		@param additive If `true`, new Scene entities will be added to the old Scene.
	**/
	public static function loadSceneByIndex(index:Int, additive:Bool = false):Scene {
		entities = [];
		parseScenes();
		return null;
	}

	/** 
		Loads a Scene with a specified name.
		@param additive If `true`, new Scene entities will be added to the old Scene.
	**/
	public static function loadSceneByName(name:String, additive:Bool = false):Scene {
		return loadSceneByIndex(0);
	}

	private static macro function parseScenes():Expr {
		var scenes = [sys.io.File.getContent(Sys.getCwd() + "../scene.xml")];
		var expr = "
			var entity:Entity = null;
			var parent:Entity = null;
			switch index {
		";
		var currentText:Null<String> = null;
		var entities = 0;
		for (i in 0...scenes.length) {
			expr += 'case ${i}:';
			var scene = scenes[i];
			var c = 0;
			while (c < scene.length) {
				var char = scene.charAt(c);
				if (currentText != null) {
					if (char == ">") {
						var split = currentText.split(" ");
						switch currentText.charAt(0) {
							case "e":
								var name = split[1].split("\"")[1];
								if (entities > 0) {
									expr += "parent = entity;";
								}
								expr += 'entity = new Entity("${name}");';
								if (entities == 0) {
									expr += "@:privateAccess entities.push(entity);";
								} else {
									expr += "entity.parent = parent;";
								}
								++entities;
							case "c":
								var type = split[1].split("\"")[1];
								expr += 'var component = new ${type}(); entity.attachComponent(component);';
							case "/":
								if (currentText.charAt(1) == "e") {
									--entities;
									expr += "entity = entity.parent;";
								}
						}
						currentText = null;
					} else {
						currentText += char;
					}
				} else if (char == "<") {
					currentText = "";
				}
				++c;
			}
		}
		return Context.parse('{${expr}}}', Context.currentPos());
	}
}
