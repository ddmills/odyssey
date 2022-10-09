package data.storylines;

enum abstract StoryEffectType(String) to String from String
{
	var SET_STATE = 'SET_STATE';
	var ENTITY_SPAWN = 'ENTITY_SPAWN';
}
