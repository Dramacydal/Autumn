;#include <WinAPI.au3>
$skilldatapart1 = "Attack,Kick,Throw,Unsummon,LeftHandThrow,LeftHandSwing,MagicArrow,FireArrow,InnerSight,CriticalStrike,Jab,ColdArrow,MultipleShot,Dodge,PowerStrike,PoisonJavelin,ExplodingArrow,SlowMissiles,Avoid,Impale,LightningBolt,IceArrow,GuidedArrow,Penetrate,ChargedStrike,PlagueJavelin,Strafe,ImmolationArrow,Dopplezon,Evade,Fend,FreezingArrow,Valkyrie,Pierce,LightningStrike,LightningFury,FireBolt,Warmth,ChargedBolt,IceBolt,FrozenArmor,Inferno,StaticField,Telekinesis,FrostNova,IceBlast,Blaze,FireBall,Nova,Lightning,ShiverArmor,FireWall,Enchant,ChainLightning,Teleport,GlacialSpike,Meteor,ThunderStorm,EnergyShield,Blizzard,ChillingArmor,FireMastery,Hydra,LightningMastery,FrozenOrb,ColdMastery,AmplifyDamage,Teeth,BoneArmor,SkeletonMastery,RaiseSkeleton,DimVision,Weaken,PoisonDagger,CorpseExplosion,ClayGolem,IronMaiden,Terror,BoneWall,GolemMastery,RaiseSkeletalMage,Confuse,LifeTap,PoisonExplosion,BoneSpear,Bloodgolem,Attract,Decrepify,BonePrison,SummonResist,IronGolem,LowerResist,PoisonNova,BoneSpirit,Firegolem,Revive,Sacrifice,Smite,Might,Prayer,ResistFire,HolyBolt,HolyFire,Thorns,Defiance,ResistCold,Zeal,Charge,BlessedAim,Cleansing,ResistLightning,Vengeance,BlessedHammer,Concentration,HolyFreeze,Vigor,Conversion,HolyShield,HolyShock,Sanctuary,Meditation,FistOfTheHeavens,Fanaticism,Conviction,Redemption,Salvation,Bash,SwordMastery,AxeMastery,MaceMastery,Howl,FindPotion,Leap,DoubleSwing,PoleArmMastery,ThrowingMastery,SpearMastery,Taunt,Shout,Stun,DoubleThrow,IncreasedStamina,FindItem,LeapAttack,Concentrate,IronSkin,BattleCry,Frenzy,IncreasedSpeed,BattleOrders,GrimWard,Whirlwind,Berserk,NaturalResistance,WarCry,BattleCommand,FireHit,Unholybolt,Skeletonraise,MaggotEgg,ShamanFire,MagottUp,MagottDown,MagottLay,AndrialSpray,Jump,SwarmMove,Nest,QuickStrike,Vampirefireball,Vampirefirewall,Vampiremeteor,GargoyleTrap,SpiderLay,VampireHeal,VampireRaise,SubMerge,FetishAura,FetishInferno,ZakarumHeal,Emerge,Resurrect,Bestow,MissileSkill1,MonsterTeleport,PrimeLightning,PrimeBolt,PrimeBlaze,PrimeFirewall,PrimeSpike,PrimeIceNova,PrimePoisonBall,PrimePoisonNova,DiabloLight,DiabloCold,DiabloFire,FingerMageSpider,"
$killdatapart2 = "DiabloFirestorm,DiabloRun,DiabloPrison,PoisonBallTrap,AndyPoisonBolt,HireableMissile,DesertTurret,ArcaneTower,MonsterBlizzard,Mosquito,Cursedballtrapright,Cursedballtrapleft,MonsterFrozenArmor,MonsterBoneArmor,MonsterBoneSpirit,MonsterCurseCast,HellMeteor,RegurgitatorEat,MonsterFrenzy,QueenDeath,ScrollOfIdentify,BookOfIdentify,ScrollOfTownportal,BookOfTownportal,Raven,PoisonCreeper,Wearwolf,ShapeShifting,Firestorm,OakSage,SummonSpiritWolf,Wearbear,MoltenBoulder,ArcticBlast,CycleOfLife,FeralRage,Maul,Fissure,CycloneArmor,HeartOfWolverine,SummonDireWolf,Rabies,FireClaws,Twister,Vines,Hunger,ShockWave,Volcano,Tornado,SpiritOfBarbs,SummonGrizzly,Fury,Armageddon,Hurricane,FireBlast,ClawMastery,PsychicHammer,TigerStrike,DragonTalon,ShockWeb,BladeSentinel,BurstOfSpeed,FistsOfFire,DragonClaw,ChargedBoltSentry,WakeOfFire,WeaponBlock,CloakOfShadows,CobraStrike,BladeFury,Fade,ShadowWarrior,ClawsOfThunder,DragonTail,LightningSentry,WakeOfInferno,MindBlast,BladesOfIce,DragonFlight,DeathSentry,BladeShield,Venom,ShadowMaster,PhoenixStrike,WakeOfDestructionSentry,ImpInferno,ImpFireball,BaalTaunt,BaalCorpseExplode,BaalMonsterSpawn,CatapultChargedBall,CatapultSpikeBall,SuckBlood,CryHelp,HealingVortex,Teleport2,Selfresurrect,VineAttack,OverseerWhip,BarbsAura,WolverineAura,OakSageAura,ImpFireMissile,Impregnate,SiegeBeastStomp,MinionSpawner,CatapultBlizzard,CatapultPlague,CatapultMeteor,BoltSentry,CorpseCycler,DeathMaul,DefenseCurse,BloodMana,InfernoSentry2,DeathSentry2,SentryLightning,FenrisRage,BaalTentacle,BaalNova,BaalInferno,BaalColdMissiles,MegaDemonInferno,EvilHutSpawner,CountessFirewall,ImpBolt,HorrorArcticBlast,DeathSentryLightning,VineCycler,BearSmite,Resurrect2,BloodLordFrenzy,BaalTeleport,ImpTeleport,BaalCloneTeleport,ZakarumLightning,VampireMissile,MephistoMissile,DoomKnightMissile,RogueMissile,HydraMissile,NecromageMissile,MonsterBow,MonsterFireArrow,MonsterColdArrow,MonsterExplodingArrow,MonsterFreezingArrow,MonsterPowerStrike,SuccubusBolt,MephistoFrostNova,MonsterIceSpear,ShamanIce,DiabloArmageddon,Delirium,NihlathakCorpseExplosion,SerpentCharge,TrapNova,UnHolyBoltEx,ShamanFireEx,ImpFireMissileEx"
$skilldata = $skilldatapart1 & $killdatapart2
$skilldata = StringSplit($skilldata,",")

;// http://www.assembla.com/code/d2bs/subversion/nodes/branches/patch-113/D2Structs.h?rev=1116
; Start making _DiaAPI funcs :P Here is most of the memory map of d2 haha at least the useful stuff
; dw = DWORD, w = WORD, i = INT, p = PTR, sz = String, b = BYTE
; i think WORD and INT are same thing, and BOOL and BYTE are same too lol
; good luck man this took me a few hours to make and organize nicely :P
Global Const $D2Client = 0x6FAB0000
Global Const $D2Common = 0x6FD50000
Global Const $D2Gfx = 0x6FA80000
Global Const $D2Win = 0x6F8E0000
Global Const $D2Lang = 0x6FC00000
Global Const $D2Cmp = 0x6FE10000
Global Const $D2Multi = 0x6F9D0000
Global Const $BNClient = 0x6FF20000
Global Const $D2Net = 0x6FFB0000 ;// conflict with STORM.DLL
Global Const $Storm = 0x6FBF0000
Global Const $Fog = 0x6FF50000
Global Const $GameStructInfo = 0x11B980
Global Const $PlayerXOffset = 0x3F6C0
Global Const $GlobalPlayerUnit = 0x6FBCBBFC
Global Const $AreaLevel = 0x11C374
	Global Const $pUnitAnyStruct = 0x11BBFC
		Global Const $dwTypeUA = 	0x00
		Global Const $dwTxtFileNoUA =	0x04
		Global Const $dwUnitIDUA =	0x0C
		Global Const $dwModeUA =	0x10
		Global Const $dwActUA =	0x18
		Global Const $pActStructUA				= 0x1C
			Global Const $dwMapSeedOffsetA	= 0x0C
			Global Const $pRoom1StructA	= 0x10
				Global Const $pRoomsNearR1 =	0x00
				Global Const $pRoom2StructR1 =	0x10
					Global Const $pRoom2NearR2 =	0x08
					Global Const $pRoom2NextR2 =	0x24
					Global Const $dwRoomFlagsR2 =	0x28
					Global Const $dwRoomsNearR2 =	0x2C
					Global Const $pRoom1StructR2 = 0x30
					Global Const $dwPosXR2 =	0x34
					Global Const $dwPosYR2 =	0x38
					Global Const $dwSizeXR2 =	0x3C
					Global Const $dwSizeYR2 =	0x40
					Global Const $dwPresetTypeR2 =	0x48
					Global Const $pRoomTileStructR2 =	0x4C
						Global Const $pRoom2StructRT = 0x00
						Global Const $pRoomTileNextRT = 0x04
						Global Const $dwNumRT = 0x10
					Global Const $pLevelStructR2 =	0x58
						Global Const $pRoom2FirstL =	0x10
						Global Const $dwPosXL =	0x1C
						Global Const $dwPosYL =	0x20
						Global Const $dwSizeXL =	0x24
						Global Const $dwSizeYL =	0x28
						Global Const $pNextLevelL =	0x1AC
						Global Const $pActMiscStructL =	0x1B4
						Global Const $dwLevelNoL =	0x1D0
					Global Const $pPresetUnitStruct =	0x5C
						Global Const $dwTxtFileNoPU =	0x04
						Global Const $dwPosXPU =	0x08
						Global Const $pPresetNextPU =	0x0C
						Global Const $dwTypePU =	0x14
						Global Const $dwPosYPU =	0x18
				Global Const $CollMapStruct =	0x20
					Global Const $dwPosGameXCM = 0x00
					Global Const $dwPosGameYCM = 0x04
					Global Const $dwSizeGameXCM = 0x08
					Global Const $dwSizeGameYCM = 0x0C
					Global Const $dwPosRoomXCM = 0x10
					Global Const $dwPosRoomYCM = 0x14
					Global Const $dwSizeRoomXCM = 0x18
					Global Const $dwSizeRoomYCM = 0x1C
					Global Const $pMapStartCM = 0x20
					Global Const $pMapEndCM = 0x22
				Global Const $dwRoomsNearR1 =	0x24
				Global Const $dwPosXR1 =	0x4C
				Global Const $dwPosYR1 = 	0x50
				Global Const $dwSizeXR1 =	0x54
				Global Const $dwSizeYR1 =	0x58
				Global Const $pUnitFirstR1 =	0x74
				Global Const $pRoomNextR1 = 0x7C
			Global Const $dwActA	= 0x14
			Global Const $pActMiscStructA =	0x48
				Global Const $dwStaffTombLevelAM =	0x94
				Global Const $pActStructAM = 0x46C
				Global Const $pLevelFirstAM = 0x47C
		Global Const $dwSeedUA =	0x20
		Global Const $dwGfxFrameUA =	0x44
		Global Const $wFrameRateUA =	0x4C
		Global Const $pGfxUnkUA =	0x50
		Global Const $pGfxInfoUA =	0x54
		Global Const $pStatListStructUA =	0x5C
			Global Const $pUnitSL = 0x04
			Global Const $dwUnitTypeSL =	0x08
			Global Const $dwUnitIDSL =	0x0C
			Global Const $dwFlagsSL =	0x10
			Global Const $pStatStructSL = 0x24
				Global Const $wSubIndexS =	0x00
				Global Const $wStatIndexS =	0x20
				Global Const $dwStatValueS =	0x04
			Global Const $wStatCount1SL =	0x28
			Global Const $wSizeSL =	0x2A
			Global Const $pPrevLinkSL =	0x2C
			Global Const $pPrevSL =	0x34
			Global Const $pNextSL =	0x3C
			Global Const $pSetListSL =	0x40
			Global Const $pSetStatSL =	0x48
			Global Const $wSetStatCountSL =	0x4C
		Global Const $pInventoryStructUA =	0x60
			Global Const $dwSignatureI =	0x00
			Global Const $bGame1CI =	0x04
			Global Const $pOwnerI =	0x08
			Global Const $pFirstItemI =	0x0C
			Global Const $pLastItemI =	0x10
			Global Const $dwLeftItemUidI =	0x1C
			Global Const $pCursorItemI =	0x20
			Global Const $dwOwnerIDI =	0x24
			Global Const $dwItemCountI =	0x28
		Global Const $pLightUA =	0x64
			Global Const $dwTypeL =	0x0C
			Global Const $dwStaticValidL =	0x2C
			Global Const $iStaticMapL =	0x30
		Global Const $wXUA =	0x8C
		Global Const $wYUA =	0x8E
		Global Const $dwOwnerTypeUA = 0x94
		Global Const $dwOwnerIDUA =	0x98
		Global Const $pOMsgUA =	0xA4
		Global Const $pInfoStructUA =	0xA8
			Global Const $pGame1CI = 0x00
			Global Const $FirstSkillI =	0x04
			Global Const $pLeftSkillI =	0x08
			Global Const $pRightSkillI =	0x0C
		Global Const $dwFlagsUA =	0xC4
		Global Const $dwFlags2UA =	0xC8
		Global Const $pChangedNextUA =	0xE0
		Global Const $pListNextUA =	0xD8 ;0xE4 ?
		Global Const $pRoomNextUA =	0xE8
	Global Const $pRosterUnitStruct = 0x11BC14
		Global Const $szNameRU = 0x00
		Global Const $dwUnitIDRU = 0x10
		Global Const $dwPartyLifeRU = 0x14
		Global Const $dwClassIDRU = 0x1C
		Global Const $wLevelRU = 0x20
		Global Const $wPartyIDRU = 0x22
		Global Const $dwLevelIDRU = 0x24
		Global Const $dwPosXRU = 0x28
		Global Const $dwPosYRU = 0x2C
		Global Const $dwPartyFlagsRU = 0x30
		Global Const $szName2RU = 0x66
		Global Const $pNextRU = 0x80
	;Global Const $GlobalPlayerUnit	= 0x11BBFC
		Global Const $Point1 =	0x5C
			Global Const $Point2 =	0x24
				Global Const $Point3 =	0x1F
				Global Const $dwLife =	0x06		;Added with pointer3 before reading i think
				Global Const $dwMaxLife =	0x0E	;Its strange because i cant find documentation for this 'struct'
				Global Const $dwMana =	0x16		;Globalplayerunit is mysterious to me :P
				Global Const $dwStamina =	0x26
				Global Const $dwLevel =	0x35
				Global Const $dwExp =	0x3D
				Global Const $dwStr =	-27
				Global Const $dwEnergy =	-19
				Global Const $dwDex =	-11
				Global Const $dwVit =	-3
	Global Const $pGameInfoStruct		= 0x11B980
		Global Const $szGameNameGI	= 0x1B
		Global Const $szGameIPGI		= 0x33
		Global Const $szAccNameGI		= 0x89
		Global Const $szCharNameGI	= 0xB9
		Global Const $szRealmNameGI 	= 0xD1
		Global Const $szGamePassGI	= 0x241
	;Global Const $SkillStruct  Gotten to from Info struct
		Global Const $pSkillInfoStructS = 0x00
			Global Const $wSkillIDSI = 0x00
		Global Const $pNextSkillS =	0x04
		Global Const $dwSkillLevelS =	0x28
		Global Const $dwFlagsS =	0x30
	;Global Const $ItemDataStruct  Gotten to from Inventory struct
		Global Const $dwQualityID = 0x00
		Global Const $dwItemFlagsID = 0x0C ; 1= Owned , 0xFFFFFFFF = Not Owned
		Global Const $dwFlagsID = 0x18
		Global Const $dwQuality2ID = 0x28
		Global Const $dwItemLevelID = 0x2C
		Global Const $wPrefixID =	0x38
		Global Const $wSuffixID =	0x3E
		Global Const $bBodyLocationID = 0x44
		Global Const $bItemLocationID = 0x45 ; Non Body/Belt Location; body/belt = 0xFF
		Global Const $pOwnerInventoryID = 0x5C
		Global Const $pNextInvItemID = 0x64
		Global Const $bNodePageID = 0x69 ; Actual location most reliable
		Global Const $pOwnerID = 0x84



