module properties;

/**
Params:
field = is assumed to have an (underscore) prefix character.
	The property will have the same name without the underscore.
*/
mixin template propertyGet(alias field)
{
	mixin("auto "~field.stringof[1..$]~"() { return "~field.stringof~"; }");
}