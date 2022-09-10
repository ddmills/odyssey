package domain.components;

import core.Game;
import data.SoundResources;
import data.WeaponFamilyType;
import domain.events.ConsumeEnergyEvent;
import domain.events.MeleeEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.ReloadEvent;
import domain.events.ShootEvent;
import domain.weapons.Weapons;
import ecs.Component;

class Weapon extends Component
{
	@save public var family:WeaponFamilyType;
	@save public var die:Int = 6;
	@save public var modifier:Int = 0;
	@save public var accuracy:Int = 0;
	@save public var baseCost:Int = 80;
	@save public var reloadCost:Int = 100;
	@save public var range:Int = 6;
	@save public var ammo:Int;
	@save public var ammoCapacity:Int;

	public var isLoaded(get, never):Bool;

	public function new(family:WeaponFamilyType)
	{
		this.family = family;
		addHandler(MeleeEvent, (evt) -> onMelee(cast evt));
		addHandler(ShootEvent, (evt) -> onShoot(cast evt));
		addHandler(ReloadEvent, (evt) -> onReload(cast evt));
		addHandler(QueryInteractionsEvent, (evt) -> onQueryInteractions(cast evt));
	}

	public function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (ammo < ammoCapacity)
		{
			evt.interactions.push({
				name: 'Reload ($ammo/$ammoCapacity)',
				evt: new ReloadEvent(evt.interactor),
			});
		}
	}

	public function onReload(evt:ReloadEvent)
	{
		var f = Weapons.Get(family);

		if (f.isRanged && ammo < ammoCapacity)
		{
			if (evt.reloader.has(IsPlayer))
			{
				Game.instance.world.playAudio(evt.reloader.pos.toIntPoint(), SoundResources.RELOAD_CLIP_1);
			}
			ammo = ammoCapacity;
			evt.reloader.fireEvent(new ConsumeEnergyEvent(reloadCost));
			evt.isHandled = true;
		}
	}

	public function onMelee(evt:MeleeEvent)
	{
		Weapons.Get(family).doMelee(evt.attacker, evt.defender, this);
		evt.isHandled = true;
	}

	public function onShoot(evt:ShootEvent)
	{
		var f = Weapons.Get(family);
		if (f.isRanged)
		{
			if (isLoaded)
			{
				f.doRange(evt.attacker, evt.target, this);
				evt.isHandled = true;
			}
			else
			{
				f.doRangeNoAmmo(evt.attacker, this);
			}
		}
	}

	public inline function get_isLoaded():Bool
	{
		return ammo > 0;
	}
}
