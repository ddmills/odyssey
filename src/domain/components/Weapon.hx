package domain.components;

import core.Game;
import data.AudioKey;
import data.WeaponFamilyType;
import domain.events.ConsumeEnergyEvent;
import domain.events.GetAmmoEvent;
import domain.events.MeleeEvent;
import domain.events.QueryInteractionsEvent;
import domain.events.ReloadEvent;
import domain.events.ShootEvent;
import domain.events.UnloadEvent;
import domain.prefabs.Spawner;
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
	@save public var ammo:Int = 0;
	@save public var ammoCapacity:Int;
	@save public var reloadAudio:AudioKey = RELOAD_CLIP_1;
	@save public var unloadAudio:AudioKey = LOOT_PICKUP_1;
	public var isLoaded(get, never):Bool;

	public function new(family:WeaponFamilyType)
	{
		this.family = family;
		addHandler(MeleeEvent, onMelee);
		addHandler(ShootEvent, onShoot);
		addHandler(ReloadEvent, onReload);
		addHandler(UnloadEvent, onUnload);
		addHandler(QueryInteractionsEvent, onQueryInteractions);
	}

	public function onQueryInteractions(evt:QueryInteractionsEvent)
	{
		if (ammo < ammoCapacity)
		{
			evt.add({
				name: 'Reload ($ammo/$ammoCapacity)',
				evt: new ReloadEvent(evt.interactor),
			});
		}

		if (ammo > 0)
		{
			evt.add({
				name: 'Unload ($ammo/$ammoCapacity)',
				evt: new UnloadEvent(evt.interactor),
			});
		}
	}

	public function onUnload(evt:UnloadEvent)
	{
		if (ammo <= 0)
		{
			return;
		}

		var f = Weapons.Get(family);
		evt.unloader.fireEvent(new ConsumeEnergyEvent(reloadCost));

		var spawnedAmmo = Spawner.Spawn(Ammo.GetSpawnable(f.ammo), entity.pos);
		spawnedAmmo.get(Stackable).quantity = ammo;
		ammo = 0;

		if (evt.unloader.has(Inventory))
		{
			evt.unloader.get(Inventory).addLoot(spawnedAmmo);
			if (evt.unloader.has(IsPlayer))
			{
				Game.instance.world.playAudio(evt.unloader.pos.toIntPoint(), unloadAudio);
			}
		}
	}

	public function onReload(evt:ReloadEvent)
	{
		var f = Weapons.Get(family);

		if (!f.isRanged || ammo >= ammoCapacity)
		{
			return;
		}

		var ammoEvent = new GetAmmoEvent(f.ammo, ammoCapacity - ammo);
		evt.reloader.fireEvent(ammoEvent);

		if (ammoEvent.amount <= 0)
		{
			evt.isHandled = false;
			return;
		}

		if (evt.reloader.has(IsPlayer))
		{
			Game.instance.world.playAudio(evt.reloader.pos.toIntPoint(), reloadAudio);
		}
		ammo += ammoEvent.amount;
		evt.reloader.fireEvent(new ConsumeEnergyEvent(reloadCost));
		evt.isHandled = true;
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
