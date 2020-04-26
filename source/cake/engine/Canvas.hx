// package cake.engine;

// import haxe.ds.GenericStack;

// class Canvas extends Component {
// 	private var elements:Array<Element>;

// 	public function loadDocument(data:String) {
// 		elements = new Array<Element>();
// 		var elementStack:GenericStack<Element> = new GenericStack<Element>();
// 		var currentText = "";
// 		var textOnly = true;
// 		var lineNumber = 0, charNumber = 0;
// 		var i = 0;
// 		while (i < data.length) {
// 			var char = data.charAt(i);
// 			switch char {
// 				case ">":
// 					if (!textOnly && currentText != "") {
// 						var element = parseElement(currentText);
// 						var parent = elementStack.first();
// 						if (parent != null) {
// 							parent.children.push(element);
// 						} else {
// 							elements.push(element);
// 						}
// 						elementStack.add(element);
//                         currentText = "";
//                         textOnly = true;
// 					} else {
// 						throw 'Unexpected ">" at line ${lineNumber} character ${charNumber}';
// 					}
// 				case "<":
// 					if (textOnly) {
// 						if (currentText != "") {
// 							elementStack.first().children.push(new Element("", currentText));
//                         }
//                         textOnly = false;
// 					} else {
// 						throw 'Unexpected "<" at line ${lineNumber} character ${charNumber}';
// 					}
// 				case "/":
// 					if (!textOnly) {
// 						var element = elementStack.pop();
// 						if (element != null && data.substr(i + 1, element.tag.length) == element.tag) {
// 							i += element.tag.length + 1;
// 						} else {
// 							throw 'Unexpected "</" at line ${lineNumber} character ${charNumber}';
// 						}
// 					} else {
// 						currentText += char;
// 					}
// 				case "\n":
// 					++lineNumber;
// 					charNumber = 0;
// 				default:
// 					currentText += char;
// 			}
// 			++charNumber;
// 			++i;
// 		}
// 	}

// 	private function parseElement(tag:String):Element {
// 		var i = 1;
// 		var tag = "";
// 		var hasTag = false;
// 		while (i < tag.length) {
// 			var char = tag.charAt(i);
// 			if (!hasTag) {
// 				if (char != " ") {
// 					tag += char;
// 				} else {
// 					hasTag = true;
// 				}
// 			}
// 			++i;
// 		}
// 		return new Element(tag, "");
// 	}

// 	public function getElement(query:String):Element {
// 		return null;
// 	}

// 	public function getElements(query:String):Array<Element> {
// 		return null;
// 	}
// }