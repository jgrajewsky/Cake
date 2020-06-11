package cake.engine;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

class System {
	public function onCreate() {}

	public function onUpdate() {}

	/** Iterates over all entities matching the types in the `queryFunction`. **/
	public static macro function forEach(queryFunction:ExprOf<() -> Void>):ExprOf<Void> {
		switch queryFunction.expr {
			case EConst(c):
				switch c {
					case CIdent(s):
						//An actual function so call it
					case _:
				}
			case _:
		}
		var params:Dynamic = Context.typeof(queryFunction).getParameters()[0];
		for (i in 0...params.length) {
			var type:Type = params[i].t;
			switch type {
				case TInst(t, params):
					trace(t);
				case _:
			}
		}
		trace("******************************");
		return macro null;
	}
}
