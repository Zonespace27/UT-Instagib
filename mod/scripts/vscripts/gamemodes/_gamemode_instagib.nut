global function GamemodeInstagib_Init

void function GamemodeInstagib_Init()
	{
	SetSpawnpointGamemodeOverride(FFA)
	SetShouldUseRoundWinningKillReplay(true)
	SetRespawnsEnabled(true)
	SetWeaponDropsEnabled(false)
	SetLoadoutGracePeriodEnabled(false)
	ClassicMP_ForceDisableEpilogue(true)

	Riff_ForceTitanAvailability(eTitanAvailability.Never)
	Riff_ForceBoostAvailability(eBoostAvailability.Disabled)

	AddCallback_OnPlayerRespawned(SetupPlayer)
	}

	void function SetupPlayer(entity player)
	{
		// These two are banned for the following reasons:
		// Cloak is banned because the time it takes to identify a cloaked player is usually long enough for the cloaked pilot to land an instagib hit
		// A-Wall is banned because it fundamentally goes against the intent of the gamemode, and is incredibly unfair to fight against when everyone has hitscan instant-kill guns
		array<string> bannedTacticals = ["mp_ability_cloak", "mp_weapon_deployable_cover"]

		foreach(entity weapon in player.GetMainWeapons())
			player.TakeWeaponNow(weapon.GetWeaponClassName())

		player.GiveWeapon("mp_weapon_instagib_chargerifle")
		player.SetActiveWeaponByName("mp_weapon_instagib_chargerifle")

		array<entity> offhand = player.GetOffhandWeapons()

		player.TakeWeaponNow(offhand[0].GetWeaponClassName())
		player.GiveOffhandWeapon("mp_weapon_thermite_grenade", OFFHAND_RIGHT)

		if (bannedTacticals.contains(offhand[1].GetWeaponClassName()))
		{
			player.TakeOffhandWeapon(1)
			player.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_SPECIAL)
			SendHudMessage(player, "Restricted tactical was replaced", -1, 0.4, 255, 255, 255, 255, 0.15, 3.0, 0.5)
		}

		player.stimmedForever = true
		StimPlayer(player, USE_TIME_INFINITE)

		player.kv.gravity = 0.6
	}
