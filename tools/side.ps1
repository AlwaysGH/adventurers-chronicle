# Adventurer's Chronicle: Side Quests, the MVP Ledger and the Passport.
# build.ps1 reads this next to story.ps1. Edit here, then run build.ps1.
#
# A Side Quest is optional: it never blocks the next chapter. It opens when the
# main road passes its hook step (hook = the step g, 1..40, whose NPC lines
# mention it) and stays in the Journal's Side Quests tab until it is done.
# Step types: talk / report (the giver: a new NPC of its own, or the chapter
# NPC when npc is empty), reach (set foot on a map), hunt (quest-window kill
# counts), boss (a named boss rises on the map), ro (RO's own quest: done when
# the quest's variable reaches val, or its cond is true). items on a ro step are counted in the
# Journal, never taken. A spot with ro = n shows only while the variable is n.
# ASCII only: the client reads quest text in its own codepage.

$sides = @(
  @{ n = 1; ch = 1; hook = 5; title = 'The Sea Caves of Byalan'; range = '13-25'
     npc = 'Harbour Master Oswin'; sprite = '4W_SAILOR'; town = 'izlude'; townName = 'Izlude'; x = 197; y = 181
     idle = 'The sea gives and the sea takes. Lately it mostly takes.'
     after = 'The boats sail again, thanks to you. Fair winds, friend.'
     intro = 'Sir Leonhart: "The Culvert drains into the sea at Izlude, and the harbour master there writes that sea creatures have been attacking boats near Byalan Island since the same week the bugs appeared."'
     costume = @(5380, 5403); ids = @(50125, 50130); gift = @(@(502, 15), @(602, 3)); zeny = 2000
     steps = @(
       @{ type = 'talk'; title = 'The Harbour Master'
          now = 'Walk south from Prontera to Izlude (prt_fild08) and find Harbour Master Oswin on the Izlude dock (197, 181).'
          done = 'Harbour Master Oswin told you of the beast. Boats rowing past Byalan Island come back holed, or not at all.'
          say = @('Leonhart sent you? Bless that man. Sit, sit.', 'Three boats this month. Holed from below, as if something bit them. The fishermen swear it comes from the caves under Byalan Island.', 'The Sailor at the end of this dock rows out to the island. Clear the caves, and find what is biting my boats.') }
       @{ type = 'reach'; title = 'Your First Boat'; map = 'izlu2dun'
          route = @('izlude', 201, 181, 'Sailor: boat to Byalan Island')
          now = 'Ride the Sailor at the end of the Izlude dock (201, 181) to Byalan Island (150 zeny).'
          hint = @(
            'Talk to the Sailor at the end of the Izlude dock (201, 181) and choose Byalan Island -> 150 Zeny. Boats are how you reach islands: each one names its price before you board.'
            'The way back: the Sailor standing on the island (108, 27) rows you back to Izlude.'
          )
          done = 'You took your first boat, out to Byalan Island.' }
       @{ type = 'hunt'; title = 'The Undersea Tunnel'; where = 'iz_dun00'
          mobs = @(@(1161, 'Plankton', 20), @(1068, 'Hydra', 10))
          route = @('izlude', 201, 181, 'Sailor: boat to Byalan Island')
          now = 'Enter the cave in the middle of Byalan Island (108, 83) and hunt 20 Planktons and 10 Hydras on the first level of the Undersea Tunnel (iz_dun00).'
          spots = @(@{ map = 'izlu2dun'; x = 108; y = 83; name = 'Cave into the Undersea Tunnel' })
          done = 'The tunnel''s creatures were frenzied, swarming the shallows where the boats pass.' }
       @{ type = 'boss'; title = 'Something Bites the Boats'; map = 'iz_dun01'; mob = 1066; boss = 'Tidebreaker Vadon'; hp = 8
          route = @('izlude', 201, 181, 'Sailor: boat to Byalan Island')
          now = 'Go down to the second level of the Undersea Tunnel (iz_dun01). The beast that bites the boats waits there.'
          hint = @('First level: the way down is in the far north-east (352, 342) or in the south-west (39, 41). The Tidebreaker Vadon rises a few seconds after you arrive.')
          spots = @(
            @{ map = 'izlu2dun'; x = 108; y = 83; name = 'Cave into the Undersea Tunnel' }
            @{ map = 'iz_dun00'; x = 352; y = 342; name = 'Way down to level 2 (north-east)' }
            @{ map = 'iz_dun00'; x = 39; y = 41; name = 'Way down to level 2 (south-west)' }
          )
          done = 'You broke the shell of the Tidebreaker Vadon, a crab swollen huge by the same wrongness as the Brood Lord.' }
       @{ type = 'report'; title = 'Fair Winds'
          now = 'Tell Harbour Master Oswin on the Izlude dock (197, 181) that the caves are quiet.'
          spots = @(@{ map = 'izlu2dun'; x = 108; y = 27; name = 'Crewman: boat back to Izlude' })
          done = 'Oswin swore the boats would sail again, and sent word to Leonhart that the sickness below Prontera reaches all the way to the sea.'
          say = @('A crab the size of a cart? I believe it. I have seen the holes in my boats.', 'Whatever is stirring the monsters under Prontera reaches all the way out to sea. I will write to Leonhart tonight.', 'If you ever need to cross the sea, remember: Izlude is where the ships and, one day, the airships leave from.', 'Now, the fleet owes you. The fishermen chipped in for a hat, and could not agree on which. Pick the one you like.') }
     ) }

  @{ n = 2; ch = 2; hook = 8; title = 'The Drowned Crew'; range = '18-30'
     npc = 'Merchant Tolliver'; sprite = '4_M_04'; town = 'alberta'; townName = 'Alberta'; x = 186; y = 153
     idle = 'Cargo, cargo, cargo. Nobody will sail past the old wreck any more.'
     after = 'My ships pass the wreck again. You have a friend in Alberta.'
     intro = 'Captain Hwarang: "A merchant from Alberta came begging this morning. The old wreck off his coast walks at night, drowned sailors on its deck. It sounds like our sickness."'
     costume = @(5184, 2287); ids = @(50126, 50131); gift = @(@(502, 20), @(602, 5)); zeny = 3000
     steps = @(
       @{ type = 'talk'; title = 'The Port Town'; mvps = @(1112)
          now = 'Walk west from Payon to the port town of Alberta (pay_fild01, pay_fild02, pay_fild03) and find Merchant Tolliver by the docks (186, 153).'
          hint = @('Towns are joined by fields: leave Payon by its west gate and keep walking west through three fields. Nothing on the way attacks first. The Route link draws the whole path.')
          done = 'Merchant Tolliver told you of the wreck off Alberta, where drowned sailors walk the decks at night.'
          say = @('Hwarang''s friend! Thank the stars.', 'There is an old pirate wreck off our coast, the Sunken Ship. It has been quiet for years. Now the dead crew walk its decks at night, and my ships will not sail past it.', 'Fisk, the old sailor there on the dock, rows out to the wreck. One more thing: they say the ship''s captain, Drake, still keeps the lowest deck. Do not go down there. Just stop the crew.') }
       @{ type = 'reach'; title = 'Out to the Wreck'; map = 'treasure01'
          route = @('alberta', 189, 151, 'Fisk: boat to the Sunken Ship')
          now = 'Ride with Fisk on the Alberta dock (189, 151) to the Sunken Ship (250 zeny), then walk into the wreck (88, 111).'
          hint = @(
            'Talk to Fisk (189, 151) and choose Sunken Ship -> 250 zeny. He rows you to the wreck''s outer deck (alb2trea).'
            'On the outer deck, the way into the ship is at (88, 111).'
            'The way back: Fisk waits on the outer deck (39, 50) to row you to Alberta.'
          )
          spots = @(
            @{ map = 'alb2trea'; x = 88; y = 111; name = 'Into the Sunken Ship' }
            @{ map = 'alb2trea'; x = 39; y = 50; name = 'Fisk: boat back to Alberta' }
          )
          done = 'You rowed out with Fisk and set foot on the Sunken Ship.' }
       @{ type = 'hunt'; title = 'The Drowned Crew'; where = 'treasure01'
          mobs = @(, @(1071, 'Pirate Skeleton', 15))
          route = @('alberta', 189, 151, 'Fisk: boat to the Sunken Ship')
          spots = @(@{ map = 'alb2trea'; x = 88; y = 111; name = 'Into the Sunken Ship' })
          now = 'Hunt 15 Pirate Skeletons on the first deck of the Sunken Ship (treasure01).'
          done = 'You put down the drowned crew. They fought as if someone still gave them orders.' }
       @{ type = 'boss'; title = 'The First Mate'; map = 'treasure01'; mob = 1071; boss = 'The Drowned First Mate'; hp = 10
          route = @('alberta', 189, 151, 'Fisk: boat to the Sunken Ship')
          spots = @(@{ map = 'alb2trea'; x = 88; y = 111; name = 'Into the Sunken Ship' })
          now = 'Someone still gives the crew orders. Face the Drowned First Mate on the first deck of the Sunken Ship (treasure01).'
          done = 'The Drowned First Mate fell, still shouting orders to a crew long gone.' }
       @{ type = 'report'; title = 'Calm Waters'
          now = 'Tell Merchant Tolliver in Alberta (186, 153) that the crew rests again.'
          spots = @(
            @{ map = 'treasure01'; x = 69; y = 22; name = 'Way out of the wreck' }
            @{ map = 'alb2trea'; x = 39; y = 50; name = 'Fisk: boat back to Alberta' }
          )
          done = 'Tolliver''s ships sail past the wreck again. Hwarang would want to hear it: the dead of the sea woke in the same weeks as the dead of Payon.'
          say = @('The crew is quiet? Then my ships sail tomorrow!', 'You know, the old sailors say the wreck woke the same week the dead started walking out of the Payon Cave. Tell Hwarang that. It is all one sickness.', 'I have two hats from the wreck''s old cargo, and their owners will not be needing them. Take your pick.') }
     ) }

  @{ n = 3; ch = 3; hook = 13; title = 'The Face in the Sand'; range = '30-42'
     npc = ''
     intro = 'Nafisa: "The sands show me something else too. A face of stone, west of the city. The same hands that built the Pyramids built the Sphinx, and whatever wakes in one stirs the other."'
     costume = @(5490, 5591); ids = @(50127, 50132); gift = @(@(503, 15), @(602, 5)); zeny = 5000
     steps = @(
       @{ type = 'hunt'; title = 'Into the Sphinx'; where = 'in_sphinx1'
          mobs = @(@(1178, 'Zerom', 20), @(1111, 'Drainliar', 15))
          route = @('moc_fild19', 98, 99, 'Sphinx entrance: moc_fild19')
          now = 'Walk west out of Morroc to the Sphinx (moc_fild19, the entrance at 98, 99) and hunt 20 Zeroms and 15 Drainliars on its first floors (in_sphinx1, in_sphinx2).'
          hint = @('Some monsters in the Sphinx attack on sight. The first floor''s stairs down are at (80, 191).')
          spots = @(
            @{ map = 'in_sphinx1'; x = 80; y = 191; name = 'Stairs down to the second floor' }
            @{ map = 'payon'; x = 175; y = 226; name = 'Kafra: Teleport to Morocc (1,200 zeny)' }
            @{ map = 'prontera'; x = 146; y = 89; name = 'Kafra: Teleport to Morocc (1,200 zeny)' }
            @{ map = 'moc_fild20'; x = 203; y = 336; name = 'Continental Guard: a free ride to Morroc' }
          )
          done = 'The Sphinx''s halls were full of restless things, Zeroms and Drainliars stirred from the dark.' }
       @{ type = 'boss'; title = 'The Warden'; map = 'in_sphinx3'; mob = 1140; boss = 'Warden of the Sphinx'; hp = 7
          now = 'Go down to the third floor of the Sphinx (in_sphinx3). The guardian Nafisa saw waits there.'
          hint = @('First floor: stairs down at (80, 191). Second floor: the stairs to the third floor are in the far north-east (276, 272). The Warden rises a few seconds after you arrive.')
          spots = @(
            @{ map = 'in_sphinx1'; x = 80; y = 191; name = 'Stairs down to the second floor' }
            @{ map = 'in_sphinx2'; x = 276; y = 272; name = 'Stairs down to the third floor' }
            @{ map = 'payon'; x = 175; y = 226; name = 'Kafra: Teleport to Morocc (1,200 zeny)' }
            @{ map = 'prontera'; x = 146; y = 89; name = 'Kafra: Teleport to Morocc (1,200 zeny)' }
            @{ map = 'moc_fild20'; x = 203; y = 336; name = 'Continental Guard: a free ride to Morroc' }
          )
          done = 'You struck down the Warden of the Sphinx, a priest of the old desert still guarding a door it could not hold shut.' }
       @{ type = 'report'; title = 'One Seal'; mvps = @(1157)
          now = 'Tell Nafisa in Morroc (156, 286) what guards the Sphinx.'
          spots = @(
            @{ map = 'payon'; x = 175; y = 226; name = 'Kafra: Teleport to Morocc (1,200 zeny)' }
            @{ map = 'prontera'; x = 146; y = 89; name = 'Kafra: Teleport to Morocc (1,200 zeny)' }
            @{ map = 'moc_fild20'; x = 203; y = 336; name = 'Continental Guard: a free ride to Morroc' }
          )
          done = 'Nafisa said it plainly: the Sphinx and the Pyramids share one seal. Below the Sphinx''s fifth floor sleeps Pharaoh, and she begged you not to wake him yet.'
          say = @('A warden. Of course. The builders left guards at every door.', 'Then it is as I feared: the Sphinx and the Pyramids share one seal. Pull at one and the other trembles.', 'Below its fifth floor sleeps Pharaoh, who ruled these sands before Morroc was a city. Leave him be until you are far stronger.', 'For your trouble: the helm of the jackal-god who guards the dead, or the headdress of a desert prince. Which will it be?') }
     ) }

  @{ n = 4; ch = 3; hook = 15; title = 'The Tiger Across the Sea'; range = '39-49'
     npc = 'Kasim the Courier'; sprite = '4_M_04'; town = 'ayothaya'; townName = 'Ayothaya'; x = 146; y = 72; ro = $true
     idle = 'Nafisa sends her greetings. And her worries.'
     after = 'Nafisa has your letter by now. Safe sailing.'
     intro = 'Nafisa: "One more vision before you go. Across the sea, in a land of temples, a tiger spirit stirs in an old shrine. It guarded a seal like ours, and the shrine has an older keeper still, Lady Tanee."'
     # Nafisa foresees what the shaman will ask for, once: the first Holy
     # Thread (Nine Tails only drops from Lv 51 Nine Tail monsters, Holy Water
     # almost never). Her courier hands them over at step kitStep. The second,
     # stronger thread is the player's own hunt (the user, 2026-10-21): nokit
     # is what Kasim says when asked for more.
     kitStep = 2
     kit = @(@(1059, 1), @(1022, 1), @(7190, 1), @(523, 1))
     nokit = @('Another thread? Nafisa''s vision only showed the shaman asking once, so she packed for once.', 'Boon-what''s-his-name never said anything about more! I am a courier, not a hunter. These you will have to find yourself.', 'Where to look, at least: Fabric from the Whispers right there in the shrine. Nine Tails from the Nine Tail foxes in Payon Forest. Holy Water from an Acolyte, or the Mermen deep under Byalan Island. And Yggdrasil Leaves from the Brilights glowing in the Clock Tower''s second basement.')
     costume = @(5098, 5555); ids = @(50128, 50133); gift = @(@(504, 10), @(607, 1)); zeny = 10000
     steps = @(
       @{ type = 'reach'; title = 'Your First Ship Overseas'; map = 'ayothaya'
          route = @('alberta', 247, 42, 'Aibakthing: ship to Ayothaya')
          now = 'Sail to Ayothaya, across the sea: about 11,700 zeny in all. The ship leaves from the Alberta dock (Aibakthing, 247, 42, 10,000 zeny).'
          hint = @(
            'Morroc: a Kafra Employee (160, 258 or 156, 97) teleports you to Prontera (1,200 zeny). Morroc has no open road out.'
            'Prontera: walk south to Izlude (prt_fild08). The Sailor at the end of the Izlude dock (201, 181) sails to Alberta Marina for 500 zeny. Do not walk to Alberta from Prontera: Eddga hunts the forest on that road.'
            'Alberta: Aibakthing at the far end of the dock (247, 42) sails to Ayothaya for 10,000 zeny. Ships overseas cost much more than boats, so the Journal tells you the price up front.'
            'The way back: Aibakthing waits by the Ayothaya dock (152, 68) to sail you to Alberta.'
          )
          spots = @(
            @{ map = 'morocc'; x = 160; y = 258; name = 'Kafra: Teleport to Prontera (1,200 zeny)' }
            @{ map = 'izlude'; x = 201; y = 181; name = 'Sailor: Alberta Marina (500 zeny)' }
            @{ map = 'alberta'; x = 247; y = 42; name = 'Aibakthing: ship to Ayothaya (10,000 zeny)' }
          )
          done = 'You crossed the sea to Ayothaya, a land of temples and floating houses.' }
       @{ type = 'talk'; title = 'Nafisa''s Courier'
          now = 'Find Kasim, Nafisa''s courier, on the Ayothaya dock (146, 72). He sailed ahead of you with her pouch.'
          done = 'Kasim, Nafisa''s courier, met you on the dock with her pouch and the name of a man who knows the tiger''s tale: Dusit.'
          say = @('You made it! Nafisa sent me ahead on the last ship, with this.', 'She saw a shaman in her sands, asking for these very things: Fabric, Nine Tails, a Solid Husk and Holy Water. I stopped asking how she knows years ago.', 'The locals say a man called Dusit tells the old tale of the tiger, by the canals. Start with him. I will wait here for your news.') }
       @{ type = 'ro'; title = 'Dusit and the Shaman'; var = 'ayodunquest'; val = 2
          route = @('ayothaya', 83, 132, 'Dusit')
          # parts: the Journal ticks each one when the variable reaches at,
          # and routes to the first one not done yet.
          parts = @(
            @{ at = 1; name = 'Hear Dusit''s tale of the tiger'; route = @('ayothaya', 83, 132, 'Dusit') }
            @{ at = 2; name = 'Ask the shaman Boonthom for help'; route = @('ayothaya', 62, 104, 'Door to Boonthom''s house') }
          )
          now = 'RO quest: hear Dusit''s tale of the Sa-mhing Tiger (83, 132), then find the shaman Boonthom in a house in western Ayothaya (the door at 62, 104).'
          hint = @(
            'Talk to Dusit and choose What is it?, then Yes, I do and I think they''re scary! (the other answer ends the talk). He sends you to the shaman Boonthom.'
            'Boonthom sits inside the house behind the door at (62, 104), at (181, 193). Choose I want to explore the ancient ruins., then Sure!. He asks for materials to weave a Holy Thread.'
          )
          spots = @(@{ map = 'ayo_in01'; x = 181; y = 193; name = 'Boonthom the shaman' })
          done = 'Dusit told you of the Sa-mhing Tiger, a man-eater that wears the faces of its victims. Boonthom helped capture it ten years ago: it was locked in the Ancient Shrine, not killed.' }
       @{ type = 'ro'; title = 'The Holy Thread'; var = 'ayodunquest'; val = 3
          items = @(@(1059, 'Fabric', 1), @(1022, 'Nine Tails', 1), @(7190, 'Solid Husk', 1), @(523, 'Holy Water', 1))
          route = @('ayothaya', 62, 104, 'Door to Boonthom''s house')
          now = 'RO quest: bring Boonthom 1 Fabric, 1 Nine Tails (a fox tail), 1 Solid Husk and 1 Holy Water. He weaves the Holy Thread that lets you into the Ancient Shrine.'
          hint = @('Kasim''s pouch (he gave it to you on the dock) holds all four. Lost or sold them? Talk to Kasim on the Ayothaya dock (146, 72): he replaces them (once per step). Or hunt them: Fabric: Whispers (Sunken Ship, the Shrine). Nine Tails, the item: the Nine Tail monsters (Payon Forest pay_fild11, where Eddga hunts, or Payon Cave''s deepest floor). Solid Husk: Beetle Kings (the field outside the Shrine, or Umbala''s fields). Holy Water: an Acolyte''s Aqua Benedicta, or a player''s shop.')
          spots = @(@{ map = 'ayo_in01'; x = 181; y = 193; name = 'Boonthom the shaman' })
          done = 'Boonthom wove you a Holy Thread, so the Shrine''s evil spirits would let you pass.' }
       @{ type = 'ro'; title = 'The Six Slates'; var = 'ayodunquest'; val = 9
          parts = @(
            @{ at = 4; name = 'Read stone slate 1 (198, 164)' }
            @{ at = 5; name = 'Read stone slate 2 (87, 16)' }
            @{ at = 6; name = 'Read stone slate 3 (268, 214)' }
            @{ at = 7; name = 'Read stone slate 4 (147, 274)' }
            @{ at = 8; name = 'Read stone slate 5 (99, 118)' }
            @{ at = 9; name = 'Read stone slate 6 (16, 188)' }
          )
          route = @('ayo_fild01', 129, 197, 'Puraim: the way down to the Shrine')
          now = 'RO quest: enter the Ancient Shrine and read the six stone slates on its first level, in order.'
          hint = @(
            'Leave Ayothaya by the east road (276, 176). On that field (ayo_fild01), Puraim (129, 197) feels your Holy Thread: choose Yes. and he shoves you down the hill to the field below (ayo_fild02).'
            'The Shrine''s entrance is at the east end of that field (285, 149). Back up the hill: Aik (ayo_fild02, 25, 154).'
            'Read the slates in order; the Journal shows the next one while you are inside. Some monsters here attack on sight, and the Shrine has drops that kill you outright: keep to the paths.'
          )
          spots = @(
            @{ map = 'ayo_fild02'; x = 285; y = 149; name = 'Entrance to the Ancient Shrine' }
            @{ map = 'ayo_dun01'; x = 198; y = 164; name = 'Stone slate 1'; ro = 3 }
            @{ map = 'ayo_dun01'; x = 87; y = 16; name = 'Stone slate 2'; ro = 4 }
            @{ map = 'ayo_dun01'; x = 268; y = 214; name = 'Stone slate 3'; ro = 5 }
            @{ map = 'ayo_dun01'; x = 147; y = 274; name = 'Stone slate 4'; ro = 6 }
            @{ map = 'ayo_dun01'; x = 99; y = 118; name = 'Stone slate 5'; ro = 7 }
            @{ map = 'ayo_dun01'; x = 16; y = 188; name = 'Stone slate 6'; ro = 8 }
          )
          done = 'The six slates spelled a dead man''s warning: do not enter the second level without more holy power.' }
       @{ type = 'ro'; title = 'A Stronger Thread'; var = 'ayodunquest'; val = 11
          items = @(@(523, 'Holy Water', 2), @(610, 'Yggdrasil Leaf', 1), @(1059, 'Fabric', 2), @(1022, 'Nine Tails', 2))
          route = @('ayothaya', 62, 104, 'Door to Boonthom''s house')
          now = 'RO quest: show Boonthom the slate''s message, then bring him 2 Holy Water, 1 Yggdrasil Leaf, 2 Fabric and 2 Nine Tails for a stronger thread.'
          hint = @(
            'Talk to Boonthom once to show him the message; he names the materials. Nafisa''s pouch only covered the first thread: these you gather yourself, and the Journal counts them.'
            '2 Fabric: the Whispers (little ghosts) right here in the Ancient Shrine drop it often.'
            '2 Nine Tails, the item: the Nine Tail foxes in Payon Forest (pay_fild11) or on Payon Cave''s deepest floor (pay_dun04) drop it often. They are Lv 51: bring companions.'
            '2 Holy Water: an Acolyte or Priest makes it (Aqua Benedicta, standing in water), a player shop may sell it, or the Mermen on the deepest level of the Byalan Undersea Tunnel (iz_dun04) drop it rarely.'
            '1 Yggdrasil Leaf: the Brilights (glowing fireflies) in the Clock Tower''s second basement (alde_dun02) drop it rarely. Angelings and Baphomet Jr. drop it too.'
          )
          spots = @(@{ map = 'ayo_in01'; x = 181; y = 193; name = 'Boonthom the shaman' })
          done = 'Boonthom wove a stronger Holy Thread, enough to brave the Shrine''s second level.' }
       @{ type = 'ro'; title = 'The Second Level'; var = 'ayodunquest'; val = 12
          # Navigation can't route past Puraim (his push down the hill is a
          # script warp), so the route stops at him, like The Six Slates.
          route = @('ayo_fild01', 129, 197, 'Puraim: the way down to the Shrine')
          now = 'RO quest: carrying the stronger thread, go back into the Ancient Shrine, down to its second level, and find the remains of Boonthom''s friend (ayo_dun02, 268, 108).'
          hint = @(
            'Back to the Shrine: leave Ayothaya by the east road (276, 176), talk to Puraim on that field (129, 197) and choose Yes. to be pushed down the hill, then enter the Shrine at the east end of the lower field (285, 149).'
            'The way down is in the far north-west of the first level (24, 283). The second level is much harder (around Lv 52), so bring companions. Its MVP, Lady Tanee, is for much later.'
          )
          spots = @(
            @{ map = 'ayo_fild01'; x = 129; y = 197; name = 'Puraim: down the hill' }
            @{ map = 'ayo_fild02'; x = 285; y = 149; name = 'Entrance to the Ancient Shrine' }
            @{ map = 'ayo_dun01'; x = 24; y = 283; name = 'Way down to the second level' }
            @{ map = 'ayo_dun02'; x = 268; y = 108; name = 'The remains' }
          )
          done = 'Deep in the Shrine you found the remains of Boonthom''s friend, an old letter and a box.' }
       @{ type = 'ro'; title = 'The Old Letter'; var = 'ayodunquest'; val = 13
          route = @('ayothaya', 62, 104, 'Door to Boonthom''s house')
          now = 'RO quest: bring the old letter back to Boonthom (ayo_in01, 181, 193).'
          spots = @(@{ map = 'ayo_in01'; x = 181; y = 193; name = 'Boonthom the shaman' })
          done = 'Boonthom mourned his friend, who died making sure the tiger stayed sealed.' }
       @{ type = 'report'; title = 'A Letter for Nafisa'
          now = 'Tell Kasim on the Ayothaya dock (146, 72) what you found, so he can write to Nafisa.'
          done = 'Kasim wrote it all down for Nafisa: another seal, half a world away, still holding, because a man gave his life for it.'
          say = @('The remains of Boonthom''s friend? And the tiger still sealed below?', 'Then the seal holds, because one man refused to let it go. Nafisa will want every word of this. I will write tonight.', 'She asked me to give you something when you came back: a tiger''s mask, for the beast you went looking for, or a hat of the leaf cats that prowl the shrine. Which one?') }
     ) }

  # ---- Wave 2 ----------------------------------------------------------------
  # check steps (type ro) are done when cond (rAthena script) is true; var is
  # the variable whose value the Journal compares with a spot's ro.

  @{ n = 5; ch = 4; hook = 18; title = 'Orc''s Memory'; range = '50-80'
     npc = 'Scholar Wendel'; sprite = '4_LGTSCIENCE'; town = 'gef_fild10'; townName = 'the Orc Village'; x = 234; y = 199; ro = $true
     idle = 'The Magister wants every word that machine produces. Every word.'
     after = 'The Magister read my report twice. He has never done that before.'
     intro = 'Magister Ivo: "A scientist lives in the orcs'' village, expelled from our Academy for a machine he swore could show the past. My scholar Wendel is watching him. If the orcs remember who sealed them, I want to know."'
     costume = @(5375, 2299); ids = @(50134, 50135); gift = @(@(504, 10), @(12016, 3)); zeny = 8000
     steps = @(
       @{ type = 'reach'; title = 'The Orc Village'; map = 'gef_fild10'
          route = @('gef_fild10', 234, 199, 'Scholar Wendel: Orc Village')
          now = 'Walk west from Geffen to the Orc Village (gef_fild10): through gef_fild07, gef_fild13 and the orc lands of gef_fild14.'
          hint = @('The Orc Hero (Lv 77) sometimes walks gef_fild14, and the Orc Lord (Lv 74) the village itself. Both attack on sight: if you see one, walk around it.')
          done = 'You reached the Orc Village, where orcs mill around a strange stone statue.' }
       @{ type = 'talk'; title = 'The Magister''s Scholar'
          now = 'Find Scholar Wendel in the Orc Village (234, 199). The Magister sent him to watch the Mad Scientist.'
          done = 'Wendel told you of the Mad Scientist''s machine, a statue that lets you live an orc''s memory.'
          say = @('You are the one who broke the warband? The Magister said you would come.', 'That man over there, the Mad Scientist, was thrown out of our Academy for building that statue. He claims it carries you into an orc''s memory. Frightening thing is, I believe him.', 'Speak to him first, he likes to brag. His machine only takes those between level 30 and 80, mind. If you are stronger than that, come back to me: I have his notes.', 'And keep clear of the Orc Lord: he walks this village, and he is no memory.') }
       @{ type = 'ro'; title = 'The Mad Scientist'; var = 'mad'; cond = 'mad >= 1'; minLv = 50
          route = @('gef_fild10', 238, 202, 'Mad Scientist')
          now = 'RO quest: let the Mad Scientist (238, 202) explain his machine. He only talks to Lv 50 and up.'
          hint = @('Choose Orcs don''t attack you?, then Oh? Like what, travel to alternate space?, then ...Um, that doesn''t sound legal?, then Alright... What do I do?')
          done = 'The Mad Scientist showed you his statue, the Dimensional Gorge Piece, built from minerals of a gorge near Morroc.' }
       @{ type = 'ro'; title = 'An Orc''s Memory'; var = 'yong_odun'; cond = 'yong_odun >= 2'; minLv = 30; maxLv = 80
          # Over maxLv RO's statue turns you away: Wendel tells the memory from
          # the scientist's notes instead (alt), and the step counts as done.
          altAsk = 'You are too strong for the machine, it will not take you. But I copied the scientist''s notes on every memory he watched. Shall I read you this one?'
          alt = @('The notes tell of Kruger, a great warrior of the orc tribe, long before the orcs turned savage.', 'His daughter, the shaman Cargalache, found a dark power in the earth and drank from it. It twisted her, and through her, the tribe''s champion: the Depraved Orc Hero.', 'Kruger fought his way through his own corrupted people, lighting the old braziers one by one, to reach the altar where she waited.', 'He could not raise his axe against his daughter. Others did it for him. When the shaman fell, Kruger lay dying beside the altar, relieved that she was free.', 'Dark power from the earth, the same kind that leaks under our tower. The orcs were not born savage. Something poisoned them.')
          route = @('gef_fild10', 242, 202, 'Dimensional Gorge Piece')
          now = 'RO instance: enter Orc''s Memory through the statue (242, 202) and live it to the end, until you speak with the dying Kruger.'
          hint = @(
            'LEVEL LIMIT: RO''s statue only lets in Lv 30 to 80. Over Lv 80? Talk to Scholar Wendel (234, 199) instead: he reads you the memory from the scientist''s notes, and this step counts as done.'
            'The statue needs a party of 2 or more, everyone online and Lv 30 to 80 (companions too). The party leader talks to the statue first and chooses Reserve the Orc''s Memory, then Enter the Dungeon. After it ends, the statue needs 2 hours before the next try.'
            'First floor: you are an orc warrior, Kruger''s ally. Talk to Kruger. The basement is split into 4 zones: kill the one Enchanted Orc in each zone to open the way on. Fight as few other orcs as you can, every kill brings reinforcements.'
            'Second floor: talk to Kruger again. Only the party leader can light the braziers, one at a time, each opening the next path. Three guardians wait on the way: the Safeguard Chief, the Orc Sniper and the Depraved Orc Spirit.'
            'At the altar, Shaman Cargalache and the Depraved Orc Hero attack together. Defeat the Shaman, then talk to Kruger lying beside the altar. That ends the memory.'
          )
          done = 'Inside the memory you fought beside Kruger against Shaman Cargalache, his own daughter, lost to dark power. He died relieved that she was free.' }
       @{ type = 'report'; title = 'What the Orcs Remember'
          now = 'Tell Scholar Wendel in the Orc Village (234, 199) what you saw in the orc''s memory.'
          done = 'Wendel wrote it all down for Ivo: the orcs were once a proud people, broken by the same dark power that now cracks the seal under Geffen.'
          say = @('A shaman who turned on her own tribe, drunk on dark power? And her father could not raise his axe against her...', 'Then the orcs were not born savage. Something poisoned them, the same kind of power that leaks through the cracks under our tower. The Magister must hear this tonight.', 'He told me to reward you from the Academy''s stores. Two helms from the orc lands. Which will you wear?') }
     ) }

  @{ n = 6; ch = 4; hook = 20; title = 'The Fox of the Palace'; range = '45-65'
     npc = 'Envoy Lise'; sprite = '1_F_LIBRARYGIRL'; town = 'amatsu'; townName = 'Amatsu'; x = 199; y = 86; ro = $true
     idle = 'The lord wrote to the Academy for a healer. I am only a messenger.'
     after = 'Lord Ishida''s mother sends her thanks, and so does the Academy.'
     intro = 'Magister Ivo: "Two letters came this week, from opposite ends of the sea. Amatsu''s lord says a fox spirit haunts his mother. I have sent Lise, one of my people, ahead to Amatsu."'
     costume = @(5069, 5296); ids = @(50136, 50137); gift = @(@(504, 10), @(1029, 1)); zeny = 10000
     steps = @(
       @{ type = 'reach'; title = 'A Ship to Amatsu'; map = 'amatsu'
          route = @('alberta', 245, 93, 'Sea Captain: ship to Amatsu')
          now = 'Sail to Amatsu: the Sea Captain on the Alberta dock (245, 93) takes you there and back for 10,000 zeny.'
          hint = @(
            'Getting to Alberta from Geffen: a Kafra Employee teleports you to Prontera (1,200 zeny). From Prontera, walk south to Izlude and take the Sailor at the end of the dock (201, 181) to Alberta Marina (500 zeny).'
            'The Sea Captain stands near the south end of the Alberta dock (245, 93). In Amatsu, he waits by the dock (194, 79) to sail you back.'
          )
          done = 'You sailed east to Amatsu, a land of cherry trees and a great castle.' }
       @{ type = 'ro'; title = 'The Sick Mother'; var = 'event_amatsu'; cond = 'event_amatsu >= 1'
          route = @('amatsu', 164, 174, 'Gate Soldier')
          now = 'RO quest: ask the Gate Soldiers guarding a house in Amatsu (164, 174 or 171, 174) what is wrong.'
          done = 'The Gate Soldiers told you the lord''s mother lies sick in that house, and no doctor can help her.' }
       @{ type = 'ro'; title = 'The Lord of the Castle'; var = 'event_amatsu'; cond = 'event_amatsu >= 2'
          route = @('amatsu', 85, 235, 'Castle door')
          now = 'RO quest: climb the castle in north-west Amatsu (the door at 85, 235) to Lord Ishida (200, 176) and offer your help.'
          hint = @(
            'Inside, the castle''s stairs take you up floor by floor. When you are inside, the Journal lists each stair on your map.'
            'Talk to Lord Ishida Yoshinaga and choose I heard about your mother... He asks you to cure her.'
          )
          spots = @(
            @{ map = 'ama_in02'; x = 195; y = 44; name = 'Stairs up (1)' }
            @{ map = 'ama_in02'; x = 56; y = 44; name = 'Stairs up (2)' }
            @{ map = 'ama_in02'; x = 59; y = 160; name = 'Stairs up (3)' }
            @{ map = 'ama_in02'; x = 200; y = 176; name = 'Lord Ishida Yoshinaga' }
          )
          done = 'Lord Ishida Yoshinaga begged you to cure his mother, after every doctor had failed.' }
       @{ type = 'ro'; title = 'A Children''s Song'; var = 'event_amatsu'; cond = 'event_amatsu >= 3'
          route = @('amatsu', 189, 166, 'Kouji')
          now = 'RO quest: listen to Kouji, the boy who sings in the streets of Amatsu (189, 166). His song holds a clue.'
          done = 'Kouji''s song spoke of a fox following someone, and a priest at the north shrine.' }
       @{ type = 'ro'; title = 'The North Shrine'; var = 'event_amatsu'; cond = 'event_amatsu >= 4'
          route = @('ama_fild01', 174, 331, 'North shrine door')
          now = 'RO quest: find Takehue at the abandoned north shrine (ama_in01, 180, 173) and show him your spirit.'
          hint = @(
            'Leave Amatsu by the north-east road (248, 292) onto the field (ama_fild01). The shrine''s door is far to the north (174, 331).'
            'Talk to Takehue (the boy in the Kitsune Mask) and choose Taaaaah!!. He teaches you to shout the fox out.'
          )
          spots = @(@{ map = 'ama_in01'; x = 180; y = 173; name = 'Takehue' })
          done = 'Takehue taught you that a fox only leaves a body for a stronger spirit, and that vengeful foxes were wronged by someone first.' }
       @{ type = 'ro'; title = 'Driving Out the Fox'; var = 'event_amatsu'; cond = 'event_amatsu >= 5'; any = $true
          items = @(@(523, 'Holy Water', 1), @(948, 'Bear''s Footskin', 1), @(1029, 'Tiger Skin', 1))
          route = @('amatsu', 168, 182, 'Door of the guarded house')
          now = 'RO quest: go into the guarded house (the door at 168, 182), face the possessed mother (22, 111) and shout the fox out of her.'
          hint = @(
            'Choose Taaaah!!. It does not always work: if the fox laughs, you are thrown outside. Just walk back in and try again.'
            'Your odds are 1 in 4. Carry ONE of these and they become 1 in 2: Holy Water, a Bear''s Footskin or a Tiger Skin (the Journal counts them; you need only one, it is not used up). Acolytes and Monks get 1 in 2 anyway, Priests 3 in 4.'
            'When it works, the fox flees as a Nine Tail and leaves its tail behind: the item Nine Tails, your proof.'
          )
          spots = @(@{ map = 'ama_in01'; x = 22; y = 111; name = 'The possessed mother' })
          done = 'You drove the fox out of the lord''s mother. It fled cursing the Ishida family, and left its tail behind.' }
       @{ type = 'ro'; title = 'Proof for the Lord'; var = 'event_amatsu'; cond = 'event_amatsu >= 6'
          items = @(, @(1022, 'Nine Tails', 1))
          route = @('amatsu', 85, 235, 'Castle door')
          now = 'RO quest: bring the fox''s tail (Nine Tails) to Lord Ishida at the top of the castle (200, 176). Keep it in your bag: he wants proof.'
          spots = @(
            @{ map = 'ama_in02'; x = 195; y = 44; name = 'Stairs up (1)' }
            @{ map = 'ama_in02'; x = 56; y = 44; name = 'Stairs up (2)' }
            @{ map = 'ama_in02'; x = 59; y = 160; name = 'Stairs up (3)' }
            @{ map = 'ama_in02'; x = 200; y = 176; name = 'Lord Ishida Yoshinaga' }
          )
          done = 'Lord Ishida laughed with relief and gave you his Feudal Lord Permit, the pass to a gate he would rather no one saw.' }
       @{ type = 'reach'; title = 'The Gate Beneath'; map = 'ama_dun01'
          route = @('amatsu', 85, 235, 'Castle door')
          now = 'Show the Feudal Lord Permit to Jyuro, the soldier on the castle''s top floor (115, 177). He opens the hidden gate to the palace dungeon (ama_dun01).'
          hint = @(
            'Jyuro stands on the floor above the lord: climb the same stairs, then take one more (222, 161).'
            'Talk to Jyuro, choose Open the gate, then I will go in. The permit is not used up. In the dungeon, a Soldier by the entrance (229, 7) takes you back up. Its floors are around Lv 39 to 62; the Samurai Specter rules the third.'
          )
          spots = @(
            @{ map = 'ama_in02'; x = 195; y = 44; name = 'Stairs up (1)' }
            @{ map = 'ama_in02'; x = 56; y = 44; name = 'Stairs up (2)' }
            @{ map = 'ama_in02'; x = 59; y = 160; name = 'Stairs up (3)' }
            @{ map = 'ama_in02'; x = 222; y = 161; name = 'Stairs up (4)' }
            @{ map = 'ama_in02'; x = 115; y = 177; name = 'Jyuro: the hidden gate' }
          )
          done = 'Beyond Jyuro''s gate lay the lord''s secret: a dungeon full of caged things and forbidden magic.' }
       @{ type = 'report'; title = 'A Letter for Geffen'
          now = 'Tell Envoy Lise on the Amatsu dock (199, 86) how it ended.'
          spots = @(@{ map = 'ama_dun01'; x = 229; y = 7; name = 'Guard: back up to the castle' })
          done = 'Lise wrote to Ivo: the fox was a punishment for the lord''s forbidden magic, and his palace hides a dungeon of caged horrors.'
          say = @('The fox is gone? And the lord''s mother is herself again?', 'A fox does not take revenge without cause. And now you tell me there is a dungeon under his palace, full of caged monsters... The Magister will want to hear about Lord Ishida''s hobbies.', 'Thank you. The Academy sent me with a reward for whoever solved this. A fox''s mask, or a fox''s tails to wear. Your choice.') }
     ) }

  @{ n = 7; ch = 4; hook = 20; title = 'The Broken Sword of Kunlun'; range = '51-70'
     npc = 'Scribe Wang'; sprite = '4_M_ORIENT02'; town = 'gonryun'; townName = 'Kunlun'; x = 118; y = 128; ro = $true
     idle = 'I wrote the chief''s letter myself. I did not expect anyone to come.'
     after = 'The sword hangs in the chief''s hall again. Kunlun owes you.'
     intro = 'Magister Ivo: "And from Kunlun, high in the mountains, the village chief begs for help: a sword of his ancestors, stolen. His scribe is waiting for whoever answers."'
     fail = 'b_sword == 11 || b_sword == 12 || b_sword == 13 || b_sword == 15'
     failText = 'A wrong answer earlier closed RO''s Broken Sword quest for this character: it cannot be finished any more. Another character can still do it.'
     costume = @(5364, 5152); ids = @(50138, 50139); gift = @(@(504, 15), @(607, 2)); zeny = 15000
     steps = @(
       @{ type = 'reach'; title = 'The Mountain Village'; map = 'gonryun'
          route = @('alberta', 245, 69, 'Kunlun Envoy: ship to Kunlun')
          now = 'Sail to Kunlun: the Kunlun Envoy on the Alberta dock (245, 69) takes you for 10,000 zeny. You land on the field below the village: walk north into Kunlun (gonryun).'
          hint = @(
            'Getting to Alberta from Geffen: a Kafra Employee teleports you to Prontera (1,200 zeny); walk south to Izlude and take the Sailor (201, 181) to Alberta Marina (500 zeny).'
            'You land at the south of the field (gon_fild01, 258, 82). The village gate is at its north end (192, 265).'
            'The way back: the Kunlun Envoy in the village (153, 64) takes you down to the harbour for free, and the Envoy there (255, 79) sails you to Alberta.'
            'RO''s Broken Sword quest needs Lv 51 or higher: the chief won''t speak of it before.'
          )
          spots = @(@{ map = 'gon_fild01'; x = 192; y = 265; name = 'Into the village (north gate)' })
          done = 'You sailed to Kunlun, a village of floating stone and peach trees high above the clouds.' }
       @{ type = 'ro'; title = 'The Chief''s Treasure'; var = 'b_sword'; cond = 'callfunc("F_ChronKunlun") >= 4'
          parts = @(
            @{ at = 1; name = 'Greet the chief (17, 93)'; route = @('gonryun', 109, 131, 'Door of the chief''s hall') }
            @{ at = 2; name = 'Hear the hostess''s story in the tavern (152, 35)'; route = @('gonryun', 215, 114, 'Tavern door') }
            @{ at = 3; name = 'Offer the chief your help (3 answers)'; route = @('gonryun', 109, 131, 'Door of the chief''s hall') }
            @{ at = 4; name = 'Back to the hostess once more'; route = @('gonryun', 215, 114, 'Tavern door') }
          )
          route = @('gonryun', 109, 131, 'Door of the chief''s hall')
          now = 'RO quest: meet the chief, Shi Yan Wen, then the tavern hostess, and offer the chief your help. The Journal names every answer: NEVER choose any other.'
          hint = @(
            '1. The chief''s hall: the door at (109, 131), then the inner door (42, 35). Talk to the chief (17, 93) once; he only greets you.'
            '2. The tavern: the door at (215, 114). Talk to the hostess, Mei Yen Fang (152, 35). She tells you of the robbery.'
            '3. Back to the chief. Choose I heard that something was stolen..., then What was stolen?, then Can I find it for you?. WARNING: Hope you find it soon. closes the quest forever on this character.'
            '4. Back to the hostess once more: she points you to the drinker at the table.'
          )
          spots = @(
            @{ map = 'gon_in'; x = 42; y = 35; name = 'Inner door to the chief' }
            @{ map = 'gon_in'; x = 17; y = 93; name = 'Chief Shi Yan Wen' }
            @{ map = 'gon_in'; x = 152; y = 35; name = 'Hostess Mei Yen Fang' }
          )
          done = 'The chief''s family sword, an heirloom of many generations, was stolen in the night. You promised to find it.' }
       @{ type = 'ro'; title = 'The Drinker''s Story'; var = 'b_sword'; cond = 'callfunc("F_ChronKunlun") >= 7'
          parts = @(
            @{ at = 6; name = 'Give Xue Bong a Green Potion and hear him out (165, 16)'; route = @('gonryun', 215, 114, 'Tavern door') }
            @{ at = 7; name = 'Tell the chief (17, 93)'; route = @('gonryun', 109, 131, 'Door of the chief''s hall') }
          )
          items = @(, @(506, 'Green Potion', 1))
          route = @('gonryun', 215, 114, 'Tavern door')
          now = 'RO quest: bring the hungover drinker, Xue Bong, a Green Potion in the tavern (165, 16), hear what he saw, and tell the chief.'
          hint = @(
            'Talk to Xue Bong with a Green Potion in your bag. Choose Here, drink this!, then About a thief..., then Where to?. WARNING: choosing No. and then Sorry, I don''t have any. closes the quest forever.'
            'Then go back to the chief (17, 93): he thanks you with White Potions.'
            'Green Potions are sold by Tool Dealers in most towns.'
          )
          spots = @(
            @{ map = 'gon_in'; x = 165; y = 16; name = 'Xue Bong, the drinker' }
            @{ map = 'gon_in'; x = 17; y = 93; name = 'Chief Shi Yan Wen' }
          )
          done = 'Xue Bong saw something on the chief''s roof that night, fleeing towards a shrine. The chief warned that the thief was wounded and could not be far.' }
       @{ type = 'ro'; title = 'Traces in the Dark'; var = 'b_sword'; cond = 'callfunc("F_ChronKunlun") >= 10'
          parts = @(
            @{ at = 8; name = 'Blade piece on floor 1 (gon_dun01)' }
            @{ at = 9; name = 'Blade piece on floor 2 (gon_dun02)' }
            @{ at = 10; name = 'Blade piece on floor 3 (gon_dun03)' }
          )
          route = @('gonryun', 159, 201, 'Kunlun Dungeon entrance')
          now = 'RO quest: find the three pieces of the sword in the Kunlun Dungeon, one on each floor (gon_dun01, gon_dun02, gon_dun03). The entrance is in the village (159, 201).'
          hint = @(
            'The thief''s trace is INVISIBLE. On each floor it waits on one of the trace spots the Journal lists, and moves to another spot after a minute or so.'
            'At a trace spot: stand on it for 3 seconds, then walk 4 steps away and walk back onto it. The blade piece is hidden right there and only shows itself when you walk into it. If the message You found a piece of blade appears, that floor is done. If not, the trace was elsewhere: try the next spot.'
            'A piece you uncovered waits for you until the server restarts, so going back to a spot you tried is never wasted.'
            'Two of RO''s pieces fall away from their trace: floor 2''s trace at (65, 168) drops its piece at (202, 25), and floor 3''s trace at (162, 40) drops its piece at (68, 39). If you stood on one of those traces, walk to its piece spot.'
            'Floor 2 is a maze of warp tiles. The trace at (23, 105) is in the first area. Maze A (56, 119) leads to the trace at (65, 168). From there, maze B (92, 190) leads to the trace at (249, 39) and the piece spot (202, 25); maze C (44, 166) leads on to maze D (94, 118).'
            'Floor 2, after maze D: maze E (165, 189) leads to the trace at (247, 129), and maze F (276, 76) from there to the trace at (149, 74). Or take maze G (180, 189), then H (170, 161), I (86, 44) and J (148, 236) to the trace at (265, 200) and the way down to floor 3 (251, 268).'
            'Floor 1 is around Lv 35 to 55, floors 2 and 3 harder. The Evil Snake Lord (Lv 73) rules floor 3: bring companions.'
          )
          spots = @(
            @{ map = 'gon_dun01'; x = 201; y = 25; name = 'Trace spot'; ro = 7 }
            @{ map = 'gon_dun01'; x = 190; y = 160; name = 'Trace spot'; ro = 7 }
            @{ map = 'gon_dun01'; x = 163; y = 53; name = 'Trace spot'; ro = 7 }
            @{ map = 'gon_dun01'; x = 133; y = 183; name = 'Trace spot'; ro = 7 }
            @{ map = 'gon_dun01'; x = 139; y = 257; name = 'Trace spot'; ro = 7 }
            @{ map = 'gon_dun01'; x = 162; y = 273; name = 'Way down to floor 2'; ro = 8 }
            @{ map = 'gon_dun02'; x = 23; y = 105; name = 'Trace spot'; ro = 8 }
            @{ map = 'gon_dun02'; x = 56; y = 119; name = 'Maze A'; ro = 8 }
            @{ map = 'gon_dun02'; x = 65; y = 168; name = 'Trace spot (piece at 202, 25)'; ro = 8 }
            @{ map = 'gon_dun02'; x = 92; y = 190; name = 'Maze B'; ro = 8 }
            @{ map = 'gon_dun02'; x = 249; y = 39; name = 'Trace spot'; ro = 8 }
            @{ map = 'gon_dun02'; x = 202; y = 25; name = 'Piece of the trace at 65, 168'; ro = 8 }
            @{ map = 'gon_dun02'; x = 44; y = 166; name = 'Maze C'; ro = 8 }
            @{ map = 'gon_dun02'; x = 94; y = 118; name = 'Maze D'; ro = 8 }
            @{ map = 'gon_dun02'; x = 165; y = 189; name = 'Maze E'; ro = 8 }
            @{ map = 'gon_dun02'; x = 247; y = 129; name = 'Trace spot'; ro = 8 }
            @{ map = 'gon_dun02'; x = 276; y = 76; name = 'Maze F'; ro = 8 }
            @{ map = 'gon_dun02'; x = 149; y = 74; name = 'Trace spot'; ro = 8 }
            @{ map = 'gon_dun02'; x = 180; y = 189; name = 'Maze G'; ro = 8 }
            @{ map = 'gon_dun02'; x = 170; y = 161; name = 'Maze H'; ro = 8 }
            @{ map = 'gon_dun02'; x = 86; y = 44; name = 'Maze I'; ro = 8 }
            @{ map = 'gon_dun02'; x = 148; y = 236; name = 'Maze J'; ro = 8 }
            @{ map = 'gon_dun02'; x = 265; y = 200; name = 'Trace spot'; ro = 8 }
            @{ map = 'gon_dun01'; x = 162; y = 273; name = 'Way down to floor 2'; ro = 9 }
            @{ map = 'gon_dun02'; x = 56; y = 119; name = 'Maze A'; ro = 9 }
            @{ map = 'gon_dun02'; x = 44; y = 166; name = 'Maze C'; ro = 9 }
            @{ map = 'gon_dun02'; x = 94; y = 118; name = 'Maze D'; ro = 9 }
            @{ map = 'gon_dun02'; x = 180; y = 189; name = 'Maze G'; ro = 9 }
            @{ map = 'gon_dun02'; x = 170; y = 161; name = 'Maze H'; ro = 9 }
            @{ map = 'gon_dun02'; x = 86; y = 44; name = 'Maze I'; ro = 9 }
            @{ map = 'gon_dun02'; x = 148; y = 236; name = 'Maze J'; ro = 9 }
            @{ map = 'gon_dun02'; x = 251; y = 268; name = 'Way down to floor 3'; ro = 9 }
            @{ map = 'gon_dun03'; x = 11; y = 75; name = 'Trace spot'; ro = 9 }
            @{ map = 'gon_dun03'; x = 199; y = 103; name = 'Trace spot'; ro = 9 }
            @{ map = 'gon_dun03'; x = 14; y = 162; name = 'Trace spot'; ro = 9 }
            @{ map = 'gon_dun03'; x = 155; y = 263; name = 'Trace spot'; ro = 9 }
            @{ map = 'gon_dun03'; x = 169; y = 90; name = 'Trace spot'; ro = 9 }
            @{ map = 'gon_dun03'; x = 162; y = 40; name = 'Trace spot (piece at 68, 39)'; ro = 9 }
            @{ map = 'gon_dun03'; x = 68; y = 39; name = 'Piece of the trace at 162, 40'; ro = 9 }
            @{ map = 'gon_dun03'; x = 68; y = 212; name = 'Trace spot'; ro = 9 }
          )
          done = 'Deep in the dungeon you found all three pieces of the sword, and the bones of the thief, who broke it rather than give it up.' }
       @{ type = 'ro'; title = 'A Knife and a Name'; var = 'b_sword'; cond = 'callfunc("F_ChronKunlun") >= 13'
          parts = @(
            @{ at = 14; name = 'Agree to have the sword repaired (the chief)'; route = @('gonryun', 109, 131, 'Door of the chief''s hall') }
            @{ at = 17; name = 'Return Han Ran Jiao''s knife, then ask Zuo Hei about a smith'; route = @('gonryun', 237, 226, 'Han Ran Jiao') }
          )
          route = @('gonryun', 109, 131, 'Door of the chief''s hall')
          now = 'RO quest: agree to have the sword repaired, help Han Ran Jiao find her lost knife, and ask the stranger Zuo Hei where to find a smith.'
          hint = @(
            '1. The chief (17, 93): choose Alright. when he asks you to repair the sword. WARNING: No way. ends the quest here.'
            '2. Han Ran Jiao, by the cliff in the north-east of the village (237, 226): she dropped her family knife.'
            '3. The knife lies hidden under leaves on the field below the village (gon_fild01, 245, 257). Walk over the spot and it is yours.'
            '4. Back to Han Ran Jiao: choose Return the knife. (Refuse. only ends the talk: keep the knife and ask again.)'
            '5. Zuo Hei, the stranger on the village''s north-west edge (100, 241): choose Ask about the blacksmith., then Exactly.. He sends you to Geffen. (Talked to him before the knife? He sends you to help someone first: just do the knife, then come back.)'
          )
          spots = @(
            @{ map = 'gon_in'; x = 17; y = 93; name = 'Chief Shi Yan Wen' }
            @{ map = 'gonryun'; x = 237; y = 226; name = 'Han Ran Jiao' }
            @{ map = 'gon_fild01'; x = 245; y = 257; name = 'The hidden knife' }
            @{ map = 'gonryun'; x = 100; y = 241; name = 'Zuo Hei, the stranger' }
          )
          done = 'You returned Han Ran Jiao''s knife, and the gruff Zuo Hei, satisfied you keep your promises, named a smith in Geffen.' }
       @{ type = 'ro'; title = 'The Smith''s Granddaughter'; var = 'b_sword'; cond = 'callfunc("F_ChronKunlun") >= 19'
          parts = @(
            @{ at = 18; name = 'Tell Aumgarl you came to repair the sword'; route = @('geffen', 172, 174, 'Door of the smith''s house') }
            @{ at = 19; name = 'Keep visiting Aumgarl until he gives in (1 in 8)'; route = @('geffen', 172, 174, 'Door of the smith''s house') }
            @{ at = 20; name = 'Promise to cure his granddaughter (8 answers)'; route = @('geffen', 172, 174, 'Door of the smith''s house') }
            @{ at = 21; name = 'Ask Neil in Prontera (275, 86)'; route = @('prontera', 275, 86, 'Neil') }
            @{ at = 22; name = 'Ask Hisa in Juno (208, 164)'; route = @('yuno', 208, 164, 'Hisa') }
            @{ at = 23; name = 'Get let into Cylrnel''s house (1 in 10)'; route = @('yuno', 245, 147, 'Door of Cylrnel''s house') }
          )
          route = @('geffen', 172, 174, 'Door of the smith''s house')
          now = 'RO quest: win over the grieving smith Aumgarl in Geffen, then search Prontera and Juno for a doctor who can cure his granddaughter, Lyroo.'
          hint = @(
            '1. Geffen: the house door at (172, 174). The smith Aumgarl is inside (71, 112). Choose Sir...?, then I came to repair this sword.'
            '2. He shuts his shop and throws you out. Keep walking back in and talking to him: about 1 time in 8 he gives in.'
            '3. Then choose, in this order: Your granddaughter is such a pretty girl., Anything wrong?, I''ll make her happy., I want to take her with me., I am sorry., Well..., Sure., Yes, Sir.. He asks you to find a cure for Lyroo.'
            '4. Prontera: Neil, by the east wall (275, 86), was cured by a doctor from Juno.'
            '5. Juno: the girl Hisa (208, 164) names the doctor, Cylrnel.'
            '6. Juno: Cylrnel''s house, the door at (245, 147). A voice throws you out: keep walking in. About 1 time in 10 you are let in.'
          )
          spots = @(
            @{ map = 'gonryun'; x = 153; y = 64; name = 'Kunlun Envoy: down to the harbour' }
            @{ map = 'gon_fild01'; x = 255; y = 79; name = 'Kunlun Envoy: ship to Alberta' }
            @{ map = 'geffen_in'; x = 71; y = 112; name = 'Aumgarl the smith' }
            @{ map = 'prontera'; x = 275; y = 86; name = 'Neil' }
            @{ map = 'yuno'; x = 208; y = 164; name = 'Hisa' }
            @{ map = 'yuno'; x = 245; y = 147; name = 'Door of Cylrnel''s house' }
          )
          done = 'Aumgarl would not touch the sword while his granddaughter lay dying. You followed a trail of rumours from Prontera to Juno, to the doctor Cylrnel.' }
       @{ type = 'ro'; title = 'The Doctor''s Cure'; var = 'b_sword'; cond = 'callfunc("F_ChronKunlun") >= 22'
          parts = @(
            @{ at = 24; name = 'Win Cylrnel''s attention' }
            @{ at = 26; name = 'Describe Lyroo''s symptoms correctly' }
            @{ at = 27; name = 'Bring the ingredients for the medicine' }
          )
          items = @(@(608, 'Yggdrasil Seed', 2), @(704, 'Aloe', 3), @(748, 'Witherless Rose', 1), @(1061, 'Witch Starsand', 10), @(7097, 'Burning Heart', 5), @(7066, 'Ice Cubic', 5))
          route = @('yuno', 245, 147, 'Door of Cylrnel''s house')
          now = 'RO quest: get the busy doctor Cylrnel (yuno_in01, 99, 101) to listen, answer her questions about Lyroo correctly, and bring the ingredients for the medicine.'
          hint = @(
            '1. Cylrnel is moody: keep talking to her. When she asks if you want something, choose You''re so beautiful.. If she laughs at you, choose Yes, I fell in love at first sight., then Well, actually.... It can take many tries; this way she never throws you out.'
            '2. When she asks for the symptoms, choose Yes, Here., then exactly: Turns hot and cold repeatedly., No sweating at all., Becomes paralyzed often., Heart beats irregularly., then Yes, I am sure. and I''m sure.. (No need to visit Lyroo first: these are her symptoms.)'
            '3. WARNING: wrong symptoms give a shorter list that is the wrong medicine. It wastes those items and you start the questions again.'
            '4. Bring the full list (the Journal counts it): 2 Yggdrasil Seeds, 3 Aloe, 1 Witherless Rose, 10 Witch Starsand, 5 Burning Hearts, 5 Ice Cubics. She brews Aloevera.'
          )
          spots = @(@{ map = 'yuno_in01'; x = 99; y = 101; name = 'Cylrnel, the doctor' })
          done = 'Cylrnel named the illness, Amarhade, and brewed a medicine that would ease Lyroo''s pain.' }
       @{ type = 'ro'; title = 'Mending the Sword'; var = 'b_sword'; cond = 'callfunc("F_ChronKunlun") >= 28'
          parts = @(
            @{ at = 28; name = 'Give Lyroo her medicine (106, 106)'; route = @('geffen', 172, 174, 'Door of the smith''s house') }
            @{ at = 30; name = 'Ask Aumgarl to repair the sword'; route = @('geffen', 172, 174, 'Door of the smith''s house') }
            @{ at = 31; name = 'Bring Aumgarl the materials'; route = @('geffen', 172, 174, 'Door of the smith''s house') }
            @{ at = 32; name = 'Keep talking until the sword is done (1 in 5)'; route = @('geffen', 172, 174, 'Door of the smith''s house') }
            @{ at = 33; name = 'Give the sword to the chief in Kunlun'; route = @('alberta', 245, 69, 'Kunlun Envoy: ship to Kunlun') }
          )
          items = @(@(986, 'Anvil', 1), @(756, 'Rough Oridecon', 2), @(7110, 'Broken Sword', 5), @(999, 'Steel', 2), @(1005, 'Hammer of Blacksmith', 1), @(1000, 'Star Crumb', 2), @(7098, 'Live Coal', 5))
          route = @('geffen', 172, 174, 'Door of the smith''s house')
          now = 'RO quest: give Lyroo her medicine, bring Aumgarl the materials to mend the sword, and carry it home to the chief in Kunlun.'
          hint = @(
            '1. Lyroo is upstairs in the smith''s house (106, 106): choose It''s your medicine..'
            '2. Aumgarl (71, 112): choose Would you repair the sword for me?, then Alright, I''ll go get them..'
            '3. Bring him (the Journal counts them): 1 Anvil, 2 Rough Oridecon, 5 Broken Swords, 2 Steel, 1 Hammer of Blacksmith, 2 Star Crumbs, 5 Live Coal.'
            '4. Keep talking to him until the sword is done: about 1 time in 5. You receive the repaired sword (Haedonggum).'
            '5. Sail back to Kunlun and give the sword to the chief (17, 93).'
          )
          spots = @(
            @{ map = 'geffen_in'; x = 106; y = 106; name = 'Lyroo' }
            @{ map = 'geffen_in'; x = 71; y = 112; name = 'Aumgarl the smith' }
            @{ map = 'gon_fild01'; x = 192; y = 265; name = 'Into the village' }
            @{ map = 'gonryun'; x = 109; y = 131; name = 'Door of the chief''s hall' }
            @{ map = 'gon_in'; x = 42; y = 35; name = 'Inner door to the chief' }
            @{ map = 'gon_in'; x = 17; y = 93; name = 'Chief Shi Yan Wen' }
          )
          done = 'Aumgarl mended the sword, and you carried it back to Kunlun. The chief''s ancestors are no longer shamed.' }
       @{ type = 'report'; title = 'A Letter for Geffen'
          now = 'Tell Scribe Wang in Kunlun (118, 128) that the sword is home.'
          done = 'Wang wrote to Ivo: the sword is mended, and the thief broke it in a shrine where something old still watches.'
          say = @('The sword is back in the hall? I heard the chief laughing all the way from here.', 'I will write to your Magister tonight, as I promised. The thief fled towards the old shrine below, and died there... The chief says the shrine has felt wrong for months. Your Magister may want to know that too.', 'Kunlun pays its debts. Two treasures from the chief''s own chests: which will you take?') }
     ) }

  @{ n = 8; ch = 5; hook = 21; title = 'The Gears Below'; range = '60-70'
     npc = ''
     intro = 'Sir Aldric: "The great gears above and below are slipping too. The fourth floor and the fourth basement are sealed by the old alchemists'' gates. If you go that deep, a Gatekeeper will want a key."'
     costume = @(5544, 5086); ids = @(50140, 50141); gift = @(@(504, 15), @(602, 5)); zeny = 12000
     steps = @(
       @{ type = 'hunt'; title = 'Tick and Tock'; where = 'c_tower2'
          mobs = @(@(1269, 'Clock', 15), @(1193, 'Alarm', 15))
          route = @('c_tower1', 235, 226, 'Stairs up to floor 2')
          now = 'Climb the Clock Tower: hunt 15 Clocks on floor 2 (c_tower2) and 15 Alarms on floor 3 (c_tower3).'
          hint = @('Floor 1: the stairs up are in the north-east (235, 226). Floor 2: the stairs to floor 3 are in the north (142, 283).')
          spots = @(
            @{ map = 'c_tower1'; x = 235; y = 226; name = 'Stairs up to floor 2' }
            @{ map = 'c_tower2'; x = 142; y = 283; name = 'Stairs up to floor 3' }
          )
          done = 'The Clocks and Alarms of the upper floors were winding themselves faster and faster, as if the tower were running out of time.' }
       @{ type = 'ro'; label = 'Find'; title = 'The Key of the Tower'; cond = 'countitem(7026) >= 1'
          items = @(, @(7026, 'Key of Clock Tower', 1))
          route = @('c_tower2', 142, 283, 'Stairs up to floor 3')
          now = 'Find a Key of Clock Tower. Your best bet: a Clock Tower Manager, the big clock keeper (about 1 in 5). One walks each of floors 1 and 2, three walk floor 3.'
          hint = @('Alarms and Clocks drop the key too, but rarely (about 1 in 400). The odds are RO''s normal drop rates: your server''s drop rate setting makes them better.')
          spots = @(@{ map = 'c_tower2'; x = 142; y = 283; name = 'Stairs up to floor 3' })
          done = 'An Alarm dropped a Key of Clock Tower, an alchemist''s key to the sealed floor.' }
       @{ type = 'reach'; title = 'The Gatekeeper Boy'; map = 'c_tower4'
          route = @('c_tower3', 10, 249, 'Gatekeeper Boy')
          now = 'Give the key to the Gatekeeper Boy in the far north-west of floor 3 (10, 249) and go through to floor 4 (c_tower4).'
          hint = @('Talk to him and choose Move to the 4th Floor. He takes the key and sends you through.')
          spots = @(@{ map = 'c_tower3'; x = 10; y = 249; name = 'Gatekeeper Boy' })
          done = 'The Gatekeeper Boy took your key and let you through to the sealed fourth floor.' }
       @{ type = 'boss'; title = 'Wound Too Tight'; map = 'c_tower4'; mob = 1270; boss = 'The Overwound Keeper'; hp = 6; loot = @(7027, 1)
          route = @('c_tower3', 10, 249, 'Gatekeeper Boy: floor 4')
          now = 'Somewhere on floor 4 (c_tower4) the tower''s keeper has been wound far too tight. Stop it.'
          hint = @('It rises a few seconds after you arrive. Owl Dukes (Lv 75) haunt this floor: keep your companions close.')
          done = 'You stopped the Overwound Keeper, a clockwork guardian ticking itself apart. A Key of Underground fell out of its works.' }
       @{ type = 'ro'; label = 'Find'; title = 'The Key Below'; cond = 'countitem(7027) >= 1'
          items = @(, @(7027, 'Key of Underground', 1))
          route = @('c_tower1', 235, 226, 'Stairs up to floor 2')
          now = 'Keep the Key of Underground the Overwound Keeper dropped. Lost it? Elders (about 1 in 3, two walk floors 2 and 4) and Clock Tower Managers (1 in 5) drop one.'
          done = 'You carry a Key of Underground, for the gate in the basements.' }
       @{ type = 'reach'; title = 'The Gate Below'; map = 'alde_dun04'
          route = @('alde_dun03', 264, 16, 'Gatekeeper (basement 3)')
          now = 'Give the key to the Gatekeeper in basement 3 (alde_dun03, 264, 16) and go down to basement 4 (alde_dun04).'
          hint = @(
            'The quickest way to basement 3 is from floor 4 itself: the way at (37, 70) leads straight there (alde_dun03, 277, 54).'
            'Talk to the Gatekeeper and choose Move to the B4th Floor. He takes the key.'
          )
          spots = @(
            @{ map = 'c_tower4'; x = 37; y = 70; name = 'Way down to basement 3' }
            @{ map = 'alde_dun03'; x = 264; y = 16; name = 'Gatekeeper' }
          )
          done = 'The second Gatekeeper took your key and let you down into the fourth basement.' }
       @{ type = 'boss'; title = 'The Jester in the Dark'; map = 'alde_dun04'; mob = 1131; boss = 'The Jester of the Deep Gears'; hp = 7
          route = @('alde_dun03', 264, 16, 'Gatekeeper: basement 4')
          now = 'Something laughs in basement 4 (alde_dun04), where the great gear turns. Silence it.'
          hint = @('It rises a few seconds after you arrive. Bathories and Jokers fill this floor, and the cursed swords Mysteltainn and Tirfing wander it.')
          done = 'You silenced the Jester of the Deep Gears, and below you the great gear caught its rhythm again.' }
       @{ type = 'report'; title = 'On Time'
          now = 'Tell Sir Aldric in Al De Baran (142, 63) that the tower keeps time again.'
          done = 'Aldric listened to the bells strike the hour, exactly on time, for the first time in weeks.'
          say = @('Do you hear that? The bells. On the hour, exactly. For the first time in weeks.', 'The alchemists who built the tower tied its gears to the old seals. As long as it keeps time, the seals hold a little longer.', 'Take one of these. The tower''s keepers left them behind, and you have earned more than a hat.') }
     ) }

  @{ n = 9; ch = 5; hook = 23; title = 'The Turtle General'; range = '60-75'
     npc = 'Navigator Corvin'; sprite = '4W_SAILOR'; town = 'alberta'; townName = 'Alberta'; x = 243; y = 119; ro = $true
     idle = 'Turtle Island, eh? My grandfather sailed with Jornadan Niliria. Few came back.'
     after = 'Grandfather would have liked to hear you tell it. Fair winds.'
     intro = 'Sir Aldric: "One page among these was not ours: a ship''s voyage log, telling of an island where turtles walk like soldiers and serve a general. The old men of Alberta still tell of it."'
     costume = @(2275, 2205); ids = @(50142, 50143); gift = @(@(504, 15), @(607, 2)); zeny = 12000
     steps = @(
       @{ type = 'ro'; title = 'Grandpa Turtle'; var = 'TURTLE'; cond = 'TURTLE >= 1 || (MISC_QUEST & 65536)'
          route = @('alberta', 65, 233, 'Door of Grandpa Turtle''s house')
          now = 'RO quest: in Alberta, ask Grandpa Turtle how to reach Turtle Island. His house door is at (65, 233).'
          hint = @('Inside, go up through the room to the north (22, 130). Grandpa Turtle sits at (23, 104). Choose How can I get there?. He names the only navigator who knows the way, Gotanblue.')
          spots = @(
            @{ map = 'alberta_in'; x = 22; y = 130; name = 'Door to the north room' }
            @{ map = 'alberta_in'; x = 23; y = 104; name = 'Grandpa Turtle' }
          )
          done = 'Grandpa Turtle told you of Jornadan Niliria''s crew, who found Turtle Island, and of Gotanblue, the last of them who knows the way.' }
       @{ type = 'ro'; title = 'The Voyage Log'; var = 'TURTLE'; cond = 'TURTLE >= 2 || (MISC_QUEST & 65536)'
          route = @('alberta', 246, 117, 'Voyage Log')
          now = 'RO quest: read the old Voyage Log lying on the Alberta dock (246, 117).'
          hint = @('Click the log. Half the time the page you open is blank or unreadable: just read it again. The page you find decides which of the island''s secrets you will follow.')
          done = 'In the Voyage Log you found a page of the crew''s notes, and a key, pointing to one of Turtle Island''s hidden secrets.' }
       @{ type = 'reach'; title = 'The Only Navigator'; map = 'tur_dun01'
          route = @('alberta', 247, 122, 'Gotanblue: boat to Turtle Island')
          now = 'Ask Gotanblue, the old sailor on the dock (247, 122), to take you to Turtle Island (10,000 zeny).'
          hint = @(
            'Choose How can I get there?, then Turtle island -> 10000 zeny.'
            'The way back: a Sailor waits where you land (165, 29) to take you to Alberta.'
            'The island is dangerous at this level: Dragon Tails and Permeters on floor 1, Freezers and Assaulters below, all aggressive. Bring companions.'
          )
          done = 'Gotanblue steered you through the fog to Turtle Island.' }
       @{ type = 'ro'; title = 'The Island''s Secret'; var = 'TURTLE'; cond = 'MISC_QUEST & 65536'
          route = @('alberta', 247, 122, 'Gotanblue: boat to Turtle Island')
          now = 'RO quest: follow the page you found in the Voyage Log to one of the island''s hidden treasures. The Journal shows your next spot on each floor.'
          hint = @(
            'The skull page: the Skull Stone on floor 1 (160, 81).'
            'The turtle-crystal page: the Turtle Tree Roots on floor 2 (132, 251), then the pile of turtle crystals (46, 125), then the Turtle Pillar (49, 158).'
            'The turtle-stone page: the turtle stones on floor 1 (203, 155), floor 2 (75, 249) and floor 3 (118, 233), then the Turtle Statue on floor 4 (113, 178).'
            'Floor 1 to 2: (154, 241). Floor 2 to 3: (167, 19). Floor 3 to 4: (217, 71).'
          )
          spots = @(
            @{ map = 'tur_dun01'; x = 160; y = 81; name = 'Skull Stone'; ro = 2 }
            @{ map = 'tur_dun01'; x = 154; y = 241; name = 'Way down to floor 2'; ro = 3 }
            @{ map = 'tur_dun02'; x = 132; y = 251; name = 'Turtle Tree Roots'; ro = 3 }
            @{ map = 'tur_dun01'; x = 154; y = 241; name = 'Way down to floor 2'; ro = 7 }
            @{ map = 'tur_dun02'; x = 46; y = 125; name = 'Pile of turtle crystals'; ro = 7 }
            @{ map = 'tur_dun01'; x = 154; y = 241; name = 'Way down to floor 2'; ro = 8 }
            @{ map = 'tur_dun02'; x = 49; y = 158; name = 'Turtle Pillar'; ro = 8 }
            @{ map = 'tur_dun01'; x = 203; y = 155; name = 'Turtle stone (floor 1)'; ro = 4 }
            @{ map = 'tur_dun01'; x = 154; y = 241; name = 'Way down to floor 2'; ro = 10 }
            @{ map = 'tur_dun02'; x = 75; y = 249; name = 'Turtle stone (floor 2)'; ro = 10 }
            @{ map = 'tur_dun01'; x = 154; y = 241; name = 'Way down to floor 2'; ro = 11 }
            @{ map = 'tur_dun02'; x = 167; y = 19; name = 'Way down to floor 3'; ro = 11 }
            @{ map = 'tur_dun03'; x = 118; y = 233; name = 'Turtle stone (floor 3)'; ro = 11 }
            @{ map = 'tur_dun01'; x = 154; y = 241; name = 'Way down to floor 2'; ro = 12 }
            @{ map = 'tur_dun02'; x = 167; y = 19; name = 'Way down to floor 3'; ro = 12 }
            @{ map = 'tur_dun03'; x = 217; y = 71; name = 'Way down to floor 4'; ro = 12 }
            @{ map = 'tur_dun04'; x = 113; y = 178; name = 'Turtle Statue'; ro = 12 }
          )
          done = 'You uncovered one of Turtle Island''s sealed treasures, as Jornadan Niliria''s crew once did.' }
       @{ type = 'report'; title = 'Back from the Fog'
          now = 'Tell Navigator Corvin on the Alberta dock (243, 119) what you found on Turtle Island.'
          spots = @(@{ map = 'tur_dun01'; x = 165; y = 29; name = 'Sailor: boat back to Alberta' })
          done = 'Corvin, grandson of one of Jornadan''s crew, swore to write your voyage into the family log beside his grandfather''s.'
          say = @('You came back from Turtle Island? Sit down, sit down. Most do not.', 'My grandfather sailed with Jornadan Niliria. He said the island has a master, a general of the turtles, who sits on the fourth floor and never sleeps. Leave him be for a few more years.', 'I keep two things from his sea chest for the next sailor who comes back. Pick one.') }
     ) }
)

# The MVP Ledger: written in when someone mentions it (g = the main step whose
# lines name it; side = n with step k, or k = 0 for when the Side Quest opens).
$mvps = @(
  @{ id = 1086; name = 'Golden Thief Bug'; where = 'Culvert 4F'; map = 'prt_sewb4'; lv = 64; g = 3 }
  @{ id = 1150; name = 'Moonlight Flower'; where = 'Payon Cave 5F'; map = 'pay_dun04'; lv = 67; g = 6 }
  @{ id = 1115; name = 'Eddga'; where = 'Payon Forest'; map = 'pay_fild11'; lv = 65; g = 6 }
  @{ id = 1112; name = 'Drake'; where = 'Sunken Ship 2F'; map = 'treasure02'; lv = 70; side = 2; k = 1 }
  @{ id = 1038; name = 'Osiris'; where = 'Pyramid 4F'; map = 'moc_pryd04'; lv = 78; g = 13 }
  @{ id = 1511; name = 'Amon Ra'; where = 'Pyramid B2'; map = 'moc_pryd06'; lv = 88; g = 15 }
  @{ id = 1688; name = 'Lady Tanee'; where = 'Ancient Shrine 2F'; map = 'ayo_dun02'; lv = 89; side = 4; k = 0 }
  @{ id = 1157; name = 'Pharaoh'; where = 'Sphinx 5F'; map = 'in_sphinx5'; lv = 93; side = 3; k = 3 }
  @{ id = 1087; name = 'Orc Hero'; where = 'Orc lands'; map = 'gef_fild14'; lv = 77; g = 16 }
  @{ id = 1389; name = 'Dracula'; where = 'Geffen Dungeon 2F'; map = 'gef_dun01'; lv = 85; g = 18 }
  @{ id = 1046; name = 'Doppelganger'; where = 'Geffen Dungeon 3F'; map = 'gef_dun02'; lv = 72; g = 18 }
  @{ id = 1190; name = 'Orc Lord'; where = 'Orc Village'; map = 'gef_fild10'; lv = 74; side = 5; k = 2 }
  @{ id = 1492; name = 'Samurai Specter'; where = 'Amatsu Dungeon 3F'; map = 'ama_dun03'; lv = 71; side = 6; k = 0 }
  @{ id = 1418; name = 'Evil Snake Lord'; where = 'Kunlun Dungeon 3F'; map = 'gon_dun03'; lv = 73; side = 7; k = 0 }
  @{ id = 1272; name = 'Dark Lord'; where = 'Glast Heim Churchyard'; map = 'gl_chyard'; lv = 80; g = 23 }
  @{ id = 1312; name = 'Turtle General'; where = 'Turtle Island 4F'; map = 'tur_dun04'; lv = 97; side = 9; k = 0 }
)

# Passport ranks: a costume with a fixed bonus at so many stamps (one stamp per
# finished Side Quest).
$ranks = @(
  @{ need = 3; name = 'Wanderer'; base = 5579; id = 50129; stat = '+1 LUK'; script = 'bonus bLuk,1;' }
  @{ need = 6; name = 'Voyager'; base = 5058; id = 50144; stat = '+1 AGI, +1 DEX'; script = 'bonus bAgi,1; bonus bDex,1;' }
)

return @{ sides = $sides; mvps = $mvps; ranks = $ranks }
