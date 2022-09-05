package screens.entitySelect;

import domain.components.Moniker;
import domain.components.Sprite;
import ecs.Entity;
import h2d.Bitmap;
import screens.listSelect.ListSelectScreen;
import shaders.SpriteShader;

class EntitySelectScreen extends ListSelectScreen
{
	public var onSelect:(e:Entity) -> Void;

	private var entities:Array<Entity>;

	public var fetchEntities:() -> Array<Entity>;

	public function new(entities:Array<Entity>)
	{
		this.entities = entities;
		fetchEntities = () -> entities;
		super(entities.map(makeListItem));
	}

	function refreshList()
	{
		entities = fetchEntities();
		setItems(entities.map(makeListItem));
	}

	override function onResume()
	{
		super.onResume();
		refreshList();
	}

	function makeListItem(entity:Entity)
	{
		return {
			title: entity.get(Moniker).displayName,
			onSelect: () -> onSelect(entity),
			getIcon: () ->
			{
				var icon = new Bitmap();
				icon = entity.get(Sprite).getBitmapClone();
				icon.getShader(SpriteShader).clearBackground = 0;
				icon.getShader(SpriteShader).outline = 0x000000.toHxdColor(0);
				return icon;
			},
		};
	}
}
