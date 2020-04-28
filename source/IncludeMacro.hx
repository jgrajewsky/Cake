#if macro
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr;
#end

final class IncludeMacro {
	public static macro function build():Array<Field> {
		Compiler.include("cake.engine");
		// Add user sources
		// Compiler.include("", true, [], ["C:\\Projects\\KhaTest\\Sources"]);
		return Context.getBuildFields();
	}
}
