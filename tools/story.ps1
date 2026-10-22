# Adventurer's Chronicle: the whole story in one place.
# build.ps1 reads this and writes db/quest_db.yml, System/OngoingQuestInfoList.lub,
# npc/chronicle_data.txt and client/data.js. Edit here, then run build.ps1.
#
# Step types: talk (speak to the chapter NPC), hunt (quest-window kill counts),
# deliver (bring items to the NPC), boss (reach a map; a named boss appears),
# report (back to the NPC: chapter reward and a costume of your choice).
# lv = the level the step expects; finishing a step fills EXP toward the next
# step's lv (times the "Quest EXP" setting). 'now' = what to do (journal,
# quest window), 'done' = what happened (journal recap). 'say' = NPC lines.
# ASCII only: the client reads quest text in its own codepage.
#
# id = the step's fixed id: its quest id is 77000 + id, and a character's
# progress remembers it (CHRON_SID), so a step put in before it later doesn't
# move anyone. Never change or reuse an id. Pre-renewal's steps are 1-40 (their
# old positions); new Renewal-only steps get ids from 101 up.
#
# Two eras: build.ps1 writes the mod's files from this story as it is
# (Pre-renewal), and a second set into renewal/ with every 're' applied: a
# step's or a chapter's re = @{ key = value } replaces those keys on Renewal
# (levels, monsters, maps, items, text). Renewal's monsters are far higher
# level and drop about half as often (rAthena db/re), so its steps differ.
# A chapter with era = 'renewal' is only in the Renewal route; its costumes
# take three new item ids from its costumeId (50125 on). Chapters are numbered
# by their place in each era's route (n below is the Pre-renewal number).

$final = 115   # the level the last step fills toward
$finalRe = 175 # the same on Renewal (its level cap)

# The way home from Odin's Temple (Chapter 8's Hugel steps): only its Boatman
# sails back, so Navigation can't route out.
$odinHome = @(
  @{ map = 'odin_tem03'; x = 121; y = 49; name = 'Way down to the second floor' }
  @{ map = 'odin_tem02'; x = 21; y = 180; name = 'Way down to the first floor' }
  @{ map = 'odin_tem01'; x = 93; y = 146; name = 'Boatman: sail back to Hugel' }
)
$odinHomeHint = 'In Odin''s Temple? Go down to the first floor (odin_tem01) and ask the Boatman there (93, 146) to sail you back to Hugel.'

$chapters = @(
  @{ n = 1; title = 'A New Adventurer'; range = '1-15'
     town = 'prontera'; townName = 'Prontera'; npc = 'Sir Leonhart'; sprite = '4_M_KNIGHT_SILVER'; x = 157; y = 190
     costumes = @(5035, 2214, 2213); gift = @(,@(501, 30)); zeny = 3000
     intro = 'Prontera is the capital of the Rune-Midgard Kingdom, seat of King Tristan III and the Prontera Knights. Every adventurer''s road starts somewhere, and yours starts here.'
     steps = @(
       @{ id = 1; type = 'talk'; lv = 1; title = 'The Knight at the Fountain'
          now = 'The Prontera Knights are looking for adventurers. Find Sir Leonhart near the central fountain of Prontera (157, 190).'
          done = 'You met Sir Leonhart of the Prontera Knights. He saw promise in you and offered you work: the fields around the capital are overrun.'
          say = @('An adventurer, fresh on the road? Good. The kingdom needs every sword it can get.', 'Monsters around Prontera have grown bold these past weeks, and my knights cannot be everywhere at once.', 'Clear the fields south of the city and I will see that you are paid. Here, take this journal. Write down what you see.') }
       @{ id = 2; type = 'hunt'; lv = 2; title = 'Clearing the Southern Fields'; where = 'prt_fild08'
          mobs = @(@(1002, 'Poring', 20), @(1063, 'Lunatic', 15))
          now = 'Monsters around Prontera have grown bold. Hunt 20 Porings and 15 Lunatics in the fields south of Prontera (prt_fild08). Track the count in the quest window (Alt+U).'
          done = 'You thinned the Porings and Lunatics south of the capital. The farmers noticed, and so did Leonhart.' }
       @{ id = 3; type = 'deliver'; lv = 6; title = 'Proof for the Knights'
          items = @(@(909, 'Jellopy', 10), @(705, 'Clover', 5))
          now = 'Leonhart needs proof for the Knight Captain. Bring him 10 Jellopy and 5 Clover in Prontera (157, 190).'
          done = 'You brought Leonhart his proof. He confided that the monsters are not only multiplying: they are coming up from below the city, out of the Culvert.'
          say = @('Good work. This will quiet the Captain for a while.', 'But listen. The guards found Thief Bugs in the cellars near the walls, far too many of them. They are coming up from the Culvert, the old waterways under the city.', 'The Culvert is sealed by royal decree. Sign up with the Recruiter in the north-west of the city, then go down to its second level and find out what is breeding them.') }
       # The Culvert Guardian only lets in volunteers (rAthena quests_prontera.txt,
       # MISC_QUEST & 8), so the route leads to the Recruiter first.
       @{ id = 4; type = 'boss'; lv = 10; title = 'Into the Culvert'; map = 'prt_sewb2'; mob = 1054; boss = 'Culvert Brood Lord'; hp = 8
          route = @('prt_in', 88, 105, 'Culvert Recruiter: prt_in')
          now = 'Volunteer with the Recruiter in Prontera, then enter the Prontera Culvert and reach its second level (prt_sewb2). Whatever is driving the Thief Bugs waits there.'
          hint = @(
            'Prontera: go into the north-west building (door at 45, 346). The Recruiter stands inside (88, 105).'
            'Talk to the Recruiter and choose Volunteer. You get a few potions, and the Recruiter can send you straight to the Culvert entrance (now and any time later).'
            'Field west of Prontera (prt_fild05): the Culvert Guardian (270, 212) lets volunteers in.'
            'Culvert level 1: take the stairs in the east (188, 247) down to level 2. The Culvert Brood Lord appears a few seconds after you arrive.'
          )
          spots = @(
            @{ map = 'prontera'; x = 45; y = 346; name = 'Door to the Recruiter (north-west)' }
            @{ map = 'prt_in'; x = 88; y = 105; name = 'Recruiter: choose Volunteer' }
            @{ map = 'prt_fild05'; x = 270; y = 212; name = 'Culvert Guardian (the way in)' }
            @{ map = 'prt_sewb1'; x = 188; y = 247; name = 'Stairs down to level 2' }
          )
          done = 'Deep in the Culvert you slew the Culvert Brood Lord, a Thief Bug swollen far beyond its kind. Its body reeked of something old and wrong.' }
       @{ id = 5; type = 'report'; lv = 13; title = 'Report to Leonhart'
          now = 'Tell Sir Leonhart in Prontera (157, 190) what you found in the Culvert.'
          done = 'Leonhart listened in silence. Reports like yours are arriving from all over Rune-Midgard: monsters stirring where they slept for centuries. He sent you south to Payon, whose archers asked the crown for help.'
          say = @('A Brood Lord... beneath the capital. I would not have believed it from anyone else.', 'You are not the first to bring such news. From every corner of the kingdom, monsters are waking where they have slept for centuries.', 'The archers of Payon have asked the crown for help. Their cave of the dead is restless. Go south, my friend. Captain Hwarang will be waiting.') }
     ) }

  @{ n = 2; title = 'Whispers of Payon'; range = '15-30'
     re = @{ range = '15-35' }
     town = 'payon'; townName = 'Payon'; npc = 'Captain Hwarang'; sprite = '4_M_ARCHER'; x = 154; y = 182
     costumes = @(5046, 2264, 5214); gift = @(,@(502, 30)); zeny = 8000
     intro = 'Payon is a village of archers in the forested mountains, built beside a cave where its ancestors were laid to rest.'
     steps = @(
       @{ id = 6; type = 'talk'; lv = 15; title = 'The Archer Captain'
          now = 'Travel south to Payon, the mountain village of archers, and find Captain Hwarang (154, 182).'
          done = 'Captain Hwarang told you of the Payon Cave, a sacred burial ground. For weeks the dead have been walking out of it at night.'
          say = @('So the knights sent you. Good. My archers cannot be everywhere at once.', 'North of the Archer Village lies the Payon Cave, where our ancestors rest. For weeks now, they have not been resting.', 'The dead walk out of it at night. Thin their numbers on the first level, and I will tell the elders the crown keeps its word.') }
       @{ id = 7; type = 'hunt'; lv = 16; title = 'The Restless Dead'; where = 'pay_dun00'
          re = @{ lv = 17 }
          mobs = @(@(1015, 'Zombie', 25), @(1076, 'Skeleton', 20))
          now = 'Hunt 25 Zombies and 20 Skeletons on the first level of the Payon Cave (pay_dun00), north of the Archer Village.'
          done = 'You put the restless dead of the cave''s first level back to rest, for now.' }
       @{ id = 8; type = 'deliver'; lv = 20; title = 'Bones and Nails'
          re = @{ lv = 22 }
          items = @(@(957, 'Decayed Nail', 10), @(932, 'Skel-Bone', 5))
          now = 'The village shaman wants to study what raises the dead. Bring Captain Hwarang 10 Decayed Nails and 5 Skel-Bones in Payon (154, 182).'
          done = 'The shaman found traces of an old binding on the bones: a seal laid long ago to keep the cave''s spirits asleep. It is fraying.'
          say = @('The shaman will want these. Wait here.', '...She says there was a binding on these bones. An old seal, laid by our ancestors to keep the cave asleep. It is coming apart.', 'Our soldiers of old were buried on the second level, with their captain. If he has risen, he must fall again. Go carefully.') }
       @{ id = 9; type = 'boss'; lv = 24; title = 'The Captain Below'; map = 'pay_dun01'; mob = 1028; boss = 'Restless Cave Captain'; hp = 8
          re = @{ lv = 28 }
          now = 'Descend to the second level of the Payon Cave (pay_dun01). The soldiers buried there once had a commander; if he has risen, he must fall again.'
          done = 'You defeated the Restless Cave Captain, an ancient soldier still loyal to a war long forgotten. As he crumbled, he whispered of the seals breaking in the desert.' }
       @{ id = 10; type = 'report'; lv = 27; title = 'Words of the Dead'
          # Renewal: Satan Morroc has already broken loose and left Morroc in ruins.
          re = @{ lv = 32
             done = 'Hwarang paled. Payon''s elders remember the great seal beneath Morroc, where a demon king was bound long ago, until he tore free and left the city in ruins. He sent you across the desert to Morroc.'
             say = @('The seals breaking in the desert... that is what he said?', 'Our elders tell a story of Morroc. Long ago, a demon king was bound beneath the desert city. Not long ago he tore free of his seal, and the city has lain in ruins ever since.', 'If the dead are whispering about seals again, someone must go. There is a seer in Morroc, Nafisa. She reads the sands better than anyone.', 'The desert roads are closed by the Continental Guard, so do not try to walk. Ask a Kafra Employee here in Payon to send you to Morroc.') }
          now = 'Tell Captain Hwarang in Payon (154, 182) what the dead soldier said.'
          done = 'Hwarang paled. Payon''s elders remember the great seal beneath Morroc, where a demon king was bound long ago. He sent you across the desert to Morroc.'
          say = @('The seals breaking in the desert... that is what he said?', 'Our elders tell a story of Morroc. Long ago, a demon king was bound beneath the desert city, and the seal has held ever since.', 'If the dead are whispering about it, someone must go. There is a seer in Morroc, Nafisa. She reads the sands better than anyone.', 'The desert roads are closed by the Continental Guard, so do not try to walk. Ask a Kafra Employee here in Payon to send you to Morroc.') }
     ) }

  @{ n = 3; title = 'Sands of Morroc'; range = '30-45'
     re = @{ range = '35-55'; intro = 'Morroc was the desert city of the Sograt, home to thieves and merchants. When the demon king bound beneath it broke free, the city fell into ruin; its people still live among the rubble.' }
     town = 'morocc'; townName = 'Morroc'; npc = 'Nafisa the Seer'; sprite = '1_F_GYPSY'; x = 156; y = 286
     costumes = @(5053, 2222, 5080); gift = @(,@(503, 30)); zeny = 15000
     intro = 'Morroc is the desert city of the Sograt, home to thieves and merchants, built on sand that hides older things.'
     # No open road leads into Morroc on this server: the Continental Guard
     # closes the desert around it (moc_fild20 has no exits but its guards),
     # so Navigation can't route there. Every Chapter 3 step shows the way back
     # in when you are in Payon, Prontera or the closed desert (after a death
     # or a Butterfly Wing, say).
     spots = @(
       @{ map = 'payon'; x = 175; y = 226; name = 'Kafra: Teleport to Morocc (1,200 zeny)' }
       @{ map = 'prontera'; x = 146; y = 89; name = 'Kafra: Teleport to Morocc (1,200 zeny)' }
       @{ map = 'moc_fild20'; x = 203; y = 336; name = 'Continental Guard: a free ride to Morroc' }
     )
     away = 'Away from Morroc? No open road leads back in: a Kafra Employee in Payon (175, 226) or Prontera (146, 89) can teleport you to Morocc (1,200 zeny).'
     steps = @(
       # rAthena kafras/functions_kafras.txt: Payon's Kafras teleport to Morocc.
       @{ id = 11; type = 'talk'; lv = 30; title = 'The Desert Seer'
          re = @{ lv = 35
             now = 'Travel to Morroc, now a city in ruins (a Kafra Employee in Payon can teleport you there), and find Nafisa the seer in the north of the city (156, 286).' }
          route = @('payon', 175, 226, 'Kafra in Payon: Teleport to Morocc')
          now = 'Travel to Morroc (a Kafra Employee in Payon can teleport you there) and find Nafisa the seer in the north of the city (156, 286).'
          hint = @(
            'No open road leads into Morroc: the Continental Guard has closed the desert around it. Talk to a Kafra Employee in Payon (175, 226), choose Teleport Service, then Morocc (1,200 zeny). The Kafras in Prontera can send you too.'
            'In Morroc, Nafisa stands in the north of the city (156, 286). She is marked on your minimap when you arrive.'
            'Walked into the closed desert (moc_fild20) anyway? Talk to a Continental Guard at its edge and choose Ask What Happened, then Ask About Guard''s Location, then Please do. He sends you to Morroc for free.'
          )
          spots = @(
            @{ map = 'morocc'; x = 156; y = 286; name = 'Nafisa the Seer' }
          )
          done = 'Nafisa read your fortune and frowned: your thread is knotted around the old seals of Rune-Midgard. She would say no more, but agreed to help, because the desert has been trembling.'
          say = @('Sit. Give me your hand. ...How strange.', 'Every soul in Midgard is a thread in the great weave. Yours is knotted around something old. The seals our ancestors laid.', 'Never mind that. The desert has been trembling for weeks, and the creatures of the sand flee from something. Find out what drives them.') }
       @{ id = 12; type = 'hunt'; lv = 31; title = 'Restless Sands'; where = 'moc_fild16'
          # Renewal: Sandmen and Hodes are level 61-63 here; the Sphinx's first
          # level, a walk west of Morroc, has Drainliars (47) and Matyrs (58),
          # with aggressive Requiems and Zeroms (70-71) around them.
          re = @{ lv = 40; title = 'Beneath the Sphinx'; where = 'in_sphinx1'
             mobs = @(@(1111, 'Drainliar', 30), @(1146, 'Matyr', 10))
             now = 'Hunt 30 Drainliars and 10 Matyrs on the first level of the Sphinx (in_sphinx1), a short walk west of Morroc.'
             hint = @(
               'Leave Morroc by its west gate (24, 164). In the desert beyond (moc_fild19), the entrance to the Sphinx stands near the middle of the map (98, 99).'
               'Requiems and Zeroms (level 70) roam the same level and attack on sight. Bring potions, and keep close to the entrance if they swarm you.'
             )
             spots = @(
               @{ map = 'morocc'; x = 26; y = 164; name = 'West gate: the way to the Sphinx' }
               @{ map = 'moc_fild19'; x = 100; y = 99; name = 'Entrance to the Sphinx' }
             )
             done = 'The creatures of the sand were fleeing the Sphinx, and the things inside it were restless too. You thinned them out.' }
          mobs = @(@(1165, 'Sandman', 25), @(1127, 'Hode', 25))
          now = 'Hunt 25 Sandmen and 25 Hodes in the Sograt Desert (moc_fild16).'
          done = 'The desert creatures were fleeing something deeper in the sand. You turned them back.' }
       @{ id = 13; type = 'deliver'; lv = 35; title = 'Grains of Truth'
          re = @{ lv = 44; title = 'Omens of the Desert'
             items = @(@(7006, 'Wing of Red Bat', 8), @(919, 'Animal Skin', 5))
             now = 'Nafisa reads omens in what the Sphinx''s creatures carry. Bring her 8 Wings of Red Bat and 5 Animal Skins in Morroc (156, 286).'
             done = 'The omens spoke of the Pyramids, the tomb of Osiris, whose priests sealed the desert''s evils. The priests are awake again.'
             say = @('Let me lay these out... yes. Yes, I see it.', 'The Pyramids, northwest of the city. The priests of Osiris sealed the evils of the desert there long ago.', 'They are awake again, and they chant a ritual that no longer works. Go to the third level and silence them.') }
          items = @(@(1056, 'Grit', 10), @(1055, 'Earthworm Peeling', 10))
          now = 'Nafisa reads omens in sand. Bring her 10 Grit and 10 Earthworm Peelings in Morroc (156, 286).'
          done = 'The sand spoke of the Pyramids, the tomb of Osiris, whose priests sealed the desert''s evils. The priests are awake again.'
          say = @('Let me pour these out... yes. Yes, I see it.', 'The Pyramids, northwest of the city. The priests of Osiris sealed the evils of the desert there long ago.', 'They are awake again, and they chant a ritual that no longer works. Go to the third level and silence them.') }
       @{ id = 14; type = 'boss'; lv = 38; title = 'The Pyramid''s Priest'; map = 'moc_pryd03'; mob = 1041; boss = 'Bound Priest of Osiris'; hp = 9
          re = @{ lv = 50 }
          now = 'Enter the Pyramids northwest of Morroc and reach the third level (moc_pryd03).'
          done = 'You struck down the Bound Priest of Osiris, a mummy still chanting the ritual of a seal it could no longer hold.' }
       @{ id = 15; type = 'report'; lv = 42; title = 'The Seer''s Warning'
          re = @{ lv = 53 }
          now = 'Return to Nafisa in Morroc (156, 286) and tell her about the priest.'
          done = 'Nafisa confirmed it: the seals across Rune-Midgard are weakening together. The oldest of them stands beneath the tower of Geffen, the city of magic. She sent you there with a letter for the magisters.'
          say = @('So the priests failed. Then it is as I feared.', 'Not one seal is weakening. All of them are, together, as if something is pulling at every knot at once.', 'The oldest seal of all lies beneath the tower of Geffen. Take this letter to the magisters there. Our Kafra can send you to Prontera; Geffen is a short walk west from there.', 'And adventurer... the sands say your road has only begun.') }
     ) }

  @{ n = 4; title = 'Tower of Geffen'; range = '45-60'
     re = @{ range = '55-75' }
     town = 'geffen'; townName = 'Geffen'; npc = 'Magister Ivo'; sprite = '1_M_WIZARD'; x = 206; y = 116
     costumes = @(5045, 5094, 2252); gift = @(@(504, 30), @(505, 10)); zeny = 25000
     intro = 'Geffen, the city of magic, is built around a great tower. Every mage in the kingdom studied there.'
     # No open road leads out of Morroc either: its Kafras teleport to
     # Prontera, and the Route to Geffen works from there. Shown on every
     # Chapter 4 step, for anyone whose save point is still in Morroc.
     spots = @(
       @{ map = 'morocc'; x = 160; y = 258; name = 'Kafra: Teleport to Prontera (1,200 zeny)' }
       @{ map = 'morocc'; x = 156; y = 97; name = 'Kafra (south): Teleport to Prontera (1,200 zeny)' }
       @{ map = 'moc_fild20'; x = 203; y = 336; name = 'Continental Guard: back to Morroc (then the Kafra)' }
     )
     away = 'Still in Morroc? No open road leads out: its Kafra Employee (160, 258) can teleport you to Prontera (1,200 zeny), and Geffen is a walk west from there.'
     steps = @(
       @{ id = 16; type = 'talk'; lv = 45; title = 'A Letter for the Magister'
          re = @{ lv = 55
             say = @('A letter from the desert seer? She never writes. ...Oh. Oh, dear.', 'What I tell you now, few outside the Magic Academy know. Beneath our tower lies the gate to Geffenia, the realm where demons were sealed away.', 'The orcs to the west have turned savage, and their shamans draw power from the ground. Go down into their dungeon, break their warband and bring me proof.') }
          now = 'Bring Nafisa''s letter to Magister Ivo in Geffen (206, 116). From Morroc, a Kafra Employee can teleport you to Prontera; Geffen is a walk west from there.'
          hint = @(
            'No open road leads out of Morroc. Talk to the Kafra Employee in the north of Morroc (160, 258), choose Teleport Service, then Prontera (1,200 zeny).'
            'From Prontera, the Route link leads west to Geffen. Magister Ivo stands near the east gate (206, 116) and is marked on your minimap when you arrive.'
          )
          done = 'Ivo read the letter twice. Beneath Geffen''s tower lies the gate to Geffenia, the sealed realm of demons. The orcs to the west have grown savage, and Ivo suspects why.'
          say = @('A letter from the desert seer? She never writes. ...Oh. Oh, dear.', 'What I tell you now, few outside the Magic Academy know. Beneath our tower lies the gate to Geffenia, the realm where demons were sealed away.', 'The orcs to the west have turned savage, and their shamans draw power from the ground. Break their warband and bring me proof.') }
       @{ id = 17; type = 'hunt'; lv = 46; title = 'The Orc Warband'; where = 'gef_fild14'
          # Renewal: gef_fild14 has no monsters at all; the Orc Dungeon's second level
          # has Zenorcs (54) and Orc Skeletons (53).
          re = @{ lv = 56; where = 'orcsdun02'
             mobs = @(@(1177, 'Zenorc', 30), @(1152, 'Orc Skeleton', 20))
             now = 'Hunt 30 Zenorcs and 20 Orc Skeletons on the second level of the Orc Dungeon (orcsdun02), beneath the orc village west of Geffen.'
             hint = @(, 'The Kafra Employees in Geffen can teleport you to the Orc Dungeon (1,700 zeny), or the Route link walks you there.') }
          mobs = @(@(1213, 'High Orc', 30), @(1189, 'Orc Archer', 20))
          now = 'Hunt 30 High Orcs and 20 Orc Archers in the orc lands west of Geffen (gef_fild14).'
          done = 'You broke the orc warband. Its shamans had been drawing power from something below the ground.' }
       @{ id = 18; type = 'deliver'; lv = 50; title = 'Trophies of War'
          re = @{ lv = 60
             items = @(@(1044, 'Zenorc''s Fang', 10), @(922, 'Orc''s Fang', 6))
             now = 'Bring Magister Ivo 10 Zenorc''s Fangs and 6 Orc''s Fangs from the orcs, in Geffen (206, 116).' }
          items = @(@(7002, 'Ogre Tooth', 10), @(1063, 'Fang', 10))
          now = 'Bring Magister Ivo 10 Ogre Teeth and 10 Fangs from the orcs, in Geffen (206, 116).'
          done = 'The trophies hummed with dark mana, the same mana that leaks from Geffenia. The seal under the tower is cracking.'
          say = @('Let me feel... yes. Dark mana, soaked into the bone.', 'It is the same mana that leaks from Geffenia. The seal under the tower is cracking, and the orcs drink from the cracks.', 'Something has already slipped through. Go down into the Geffen Dungeon, to its second level, and stop it before it reaches the city.') }
       @{ id = 19; type = 'boss'; lv = 54; title = 'Beneath the Tower'; map = 'gef_dun01'; mob = 1061; boss = 'Nightmare of the Tower'; hp = 10
          re = @{ lv = 65 }
          now = 'Enter the Geffen Dungeon beneath the tower and reach its second level (gef_dun01).'
          done = 'You defeated the Nightmare of the Tower, a demon-touched steed that had slipped through the cracks of the seal.' }
       @{ id = 20; type = 'report'; lv = 57; title = 'The Fallen Kingdom'
          re = @{ lv = 70 }
          now = 'Report to Magister Ivo in Geffen (206, 116).'
          done = 'Ivo will reinforce the seal, but he warned that Geffen''s wards were built with knowledge from Glast Heim, the fallen kingdom. He sent you to the knights of Al De Baran to learn what happened there.'
          say = @('You did it. The Academy will reinforce the seal tonight.', 'But I must confess something. Our wards were built with knowledge taken from Glast Heim, the kingdom that fell into darkness.', 'If the wards fail, the answer is there. A knight in Al De Baran still guards its memory. Find Sir Aldric.') }
     ) }

  @{ n = 5; title = 'Ghosts of Glast Heim'; range = '60-75'
     re = @{ range = '75-90' }
     town = 'aldebaran'; townName = 'Al De Baran'; npc = 'Sir Aldric'; sprite = '4_M_KNIGHT_BLACK'; x = 142; y = 63
     costumes = @(5181, 5017, 5363); gift = @(@(504, 40), @(505, 20)); zeny = 40000
     intro = 'Al De Baran is the city of canals and the great Clock Tower, north of Prontera and close to the ruins of Glast Heim.'
     steps = @(
       @{ id = 21; type = 'talk'; lv = 60; title = 'The Last Knight'
          re = @{ lv = 75 }
          now = 'Go to Al De Baran, the city of the Clock Tower, and find Sir Aldric near the south gate (142, 63).'
          done = 'Sir Aldric is the last of an order that once guarded Glast Heim. He told you how the kingdom fell: its king bargained with darkness, and the Dark Lord answered.'
          say = @('Ivo sent you? Then you already know more than most.', 'I am the last of the order that guarded Glast Heim. Our king bargained with darkness for power, and the Dark Lord answered. The kingdom fell in a single night.', 'Lately the Clock Tower here has been wrong. It was built to keep time with the old seals. Clear its first floor and we will see.') }
       @{ id = 22; type = 'hunt'; lv = 61; title = 'Time Out of Joint'; where = 'c_tower1'
          re = @{ lv = 76 }
          mobs = @(@(1195, 'Rideword', 30), @(1199, 'Punk', 30))
          now = 'Strange things walk the Clock Tower. Hunt 30 Ridewords and 30 Punks on its first floor (c_tower1).'
          done = 'The Clock Tower''s haunted books and spores fell silent. Aldric said the tower was built to keep time with the seals.' }
       @{ id = 23; type = 'deliver'; lv = 65; title = 'Pages of the Past'
          re = @{ lv = 80
             items = @(@(1097, 'Worn Out Page', 5), @(7001, 'Mould Powder', 5))
             now = 'Bring Sir Aldric 5 Worn Out Pages and 5 Mould Powder in Al De Baran (142, 63); he can piece together the old records.' }
          items = @(@(1097, 'Worn Out Page', 10), @(7001, 'Mould Powder', 10))
          now = 'Bring Sir Aldric 10 Worn Out Pages and 10 Mould Powder in Al De Baran (142, 63); he can piece together the old records.'
          done = 'The pages spoke of Glast Heim''s knights, cursed to guard their ruined halls forever.'
          say = @('These pages... I know this hand. These are records from Glast Heim.', 'My brothers of the order. Cursed to guard the ruined halls forever, the records say. Even in death they keep their posts.', 'One of them walks the churchyard. If anyone can tell us what is happening to the seals, it is him. Go to Glast Heim, west of Geffen.') }
       @{ id = 24; type = 'boss'; lv = 68; title = 'The Churchyard'; map = 'gl_chyard'; mob = 1192; boss = 'Wraith of the Fallen Order'; hp = 10
          re = @{ lv = 84 }
          now = 'Travel to Glast Heim, west of Geffen, and enter its churchyard (gl_chyard).'
          done = 'You laid to rest the Wraith of the Fallen Order, once a knight of Aldric''s own order. Before it faded, it spoke of the machines beneath the floating city.' }
       @{ id = 25; type = 'report'; lv = 72; title = 'A Knight''s Salute'
          now = 'Tell Sir Aldric in Al De Baran (142, 63) what the wraith said.'
          done = 'Aldric saluted you as a knight would. The floating city is Juno, capital of the Schwarzwald Republic. He wrote to the Sages there on your behalf.'
          say = @('He is at peace, then. Thank you. I could never have raised my sword against him.', 'The machines beneath the floating city... he means Juno, the capital of the Schwarzwald Republic, and the ruins of Juperos below it.', 'I have written to the Sages of Juno. Ask for Sage Elisha. And... it was an honor, friend.')
          # Renewal: Chapter 6 (Einbech) comes first.
          re = @{ lv = 88
             done = 'Aldric saluted you as a knight would. The machines the wraith spoke of lie in the Schwarzwald Republic, and an old friend of his, the foreman of the Einbech mine, has written of crystals that hum in the dark. Aldric sent you to him.'
             say = @('He is at peace, then. Thank you. I could never have raised my sword against him.', 'The machines beneath the floating city... that is the Schwarzwald Republic. Juno, and the ruins of Juperos below it.', 'But there is a closer road. An old friend of mine, Gustav, is foreman of the mine in Einbech. His last letter spoke of black crystals that hum in the dark, and of dead miners walking.', 'Go to him first. I have written to the Sages of Juno as well. And... it was an honor, friend.') } }
     ) }

  # Renewal only: the Schwarzwald's mining town, between Glast Heim and Juno.
  @{ era = 'renewal'; title = 'Smoke over the Schwarzwald'; range = '90-105'
     town = 'einbech'; townName = 'Einbech'; npc = 'Foreman Gustav'; sprite = '4_M_EINMINER'; x = 142; y = 244
     costumes = @(5031, 5009, 5679); costumeId = 50125; gift = @(@(504, 50), @(505, 20)); zeny = 50000
     intro = 'Einbech is the mining town of the Schwarzwald Republic, a short train ride from Einbroch, the city of steel and smoke. Its mine runs deep beneath the town.'
     # From Al De Baran: a Kafra to Juno, the airship to Einbroch, the train
     # to Einbech. Shown on every step, for anyone who is still on the way.
     spots = @(
       @{ map = 'aldebaran'; x = 143; y = 119; name = 'Kafra: Teleport to Juno (1,200 zeny)' }
       @{ map = 'yuno'; x = 53; y = 214; name = 'Juno Airport' }
       @{ map = 'y_airport'; x = 143; y = 43; name = 'Airport Staff: board the airship (1,200 zeny)' }
       @{ map = 'y_airport'; x = 145; y = 63; name = 'Domestic Boarding: Einbroch, Lighthalzen, Hugel' }
       @{ map = 'einbroch'; x = 232; y = 272; name = 'Train Station Staff: to Einbech (200 zeny)' }
     )
     away = 'Far from Einbech? From Al De Baran, a Kafra Employee (143, 119) teleports you to Juno (1,200 zeny). Juno''s airship stops in Einbroch, and Einbroch''s train (232, 272) runs to Einbech (200 zeny).'
     steps = @(
       @{ id = 101; type = 'talk'; lv = 90; title = 'The Foreman of Einbech'
          now = 'Travel to Einbech, the mining town of the Schwarzwald Republic, and find Foreman Gustav by the mine entrance (142, 244).'
          hint = @(
            'From Al De Baran, a Kafra Employee (143, 119) can teleport you to Juno (1,200 zeny).'
            'In Juno, enter the airport in the west of the city (53, 214). Pay the Airport Staff (1,200 zeny), go through Domestic Boarding and ride the airship until it lands in Einbroch.'
            'In Einbroch, the Train Station Staff (232, 272) takes you to Einbech for 200 zeny. Gustav stands by the mine entrance in the north of the town (142, 244) and is marked on your minimap when you arrive.'
          )
          done = 'Gustav runs the Einbech mine. His miners broke into a seam of black crystal deep under the town; since then poison fills the tunnels and the miners who died there long ago walk again.'
          say = @('Aldric sent you? Then you are welcome here, smoke and all.', 'Three weeks ago my miners broke into a seam of black crystal, deep under the town. It hums at night. Since then the tunnels have filled with poison, and the miners who died down there long ago have started walking again.', 'Nobody will go down any more. Clear the first level of the mine for me, and we can find out what we woke up.') }
       @{ id = 102; type = 'hunt'; lv = 92; title = 'The Restless Mine'; where = 'ein_dun01'
          mobs = @(@(1616, 'Pitman', 30), @(1620, 'Noxious', 20))
          now = 'Hunt 30 Pitmen and 20 Noxious on the first level of the Einbech Mine (ein_dun01). Its entrance is in the north of Einbech (138, 252).'
          hint = @(, 'The mine entrance is in the north of Einbech (138, 252), next to Foreman Gustav. Pitmen and Noxious fill its first level.')
          spots = @(
            @{ map = 'einbech'; x = 138; y = 249; name = 'Entrance to the mine' }
          )
          done = 'You drove back the dead miners and the poison that drifts with them, for now.' }
       @{ id = 103; type = 'deliver'; lv = 95; title = 'Samples for the Foreman'
          items = @(@(7318, 'Old Pick', 5), @(7320, 'Dust Pollutant', 8))
          now = 'Gustav wants to know what is poisoning his mine. Bring him 5 Old Picks from the Pitmen and 8 Dust Pollutants from the Noxious, in Einbech (142, 244).'
          done = 'The picks were black with crystal dust, and the poison came off the crystal itself. Gustav sent you down to its source, on the second level of the mine.'
          say = @('These picks... look at the dust on them. Black, and warm to the touch.', 'And this poison is not from the coal. It comes off the crystal itself, like breath. Something down there is alive, or wants to be.', 'The seam is on the second level of the mine. Whatever guards it, put it down.') }
       @{ id = 104; type = 'boss'; lv = 98; title = 'The Black Seam'; map = 'ein_dun02'; mob = 1615; boss = 'Warden of the Black Crystal'; hp = 10
          now = 'Descend to the second level of the Einbech Mine (ein_dun02). The way down is at the far north-east end of the first level (261, 255).'
          hint = @(
            'Enter the mine in the north of Einbech (138, 252).'
            'Mine level 1: cross to its north-east corner (261, 255) and take the way down to level 2. The Warden of the Black Crystal appears a few seconds after you arrive.'
          )
          spots = @(
            @{ map = 'einbech'; x = 138; y = 249; name = 'Entrance to the mine' }
            @{ map = 'ein_dun01'; x = 261; y = 258; name = 'Way down to level 2' }
          )
          done = 'You shattered the Warden of the Black Crystal, a living shard of the seam. At its heart was the same crystal the old seals were made of.' }
       @{ id = 105; type = 'report'; lv = 101; title = 'Crystal and Steel'
          now = 'Bring Foreman Gustav in Einbech (142, 244) news of the Warden.'
          done = 'Gustav knew the crystal at once: the ruins of Juperos beneath Juno are built of it, and their machines are waking too. He sent you on to Sage Elisha in Juno.'
          say = @('A living crystal. My grandfather told stories like that, and I laughed at him.', 'Seal crystal, Aldric would call it. The ruins of Juperos beneath Juno are built from the same stone, and the sages say its old machines are waking.', 'Go to Juno, to Sage Elisha. Aldric has written to her already, and I will send word that you are coming. The airship from Einbroch will take you there.', 'And take this. Every miner in Einbech owes you a drink.') }
     ) }

  @{ n = 6; title = 'The Floating City'; range = '75-90'
     re = @{ range = '105-120' }
     town = 'yuno'; townName = 'Juno'; npc = 'Sage Elisha'; sprite = '4_M_SAGE_C'; x = 156; y = 47
     costumes = @(5170, 2246, 2258); gift = @(@(607, 3), @(504, 50)); zeny = 60000
     intro = 'Juno floats above the clouds as the capital of the Schwarzwald Republic, a land of sages and machines.'
     steps = @(
       @{ id = 26; type = 'talk'; lv = 75; title = 'The Sage of Juno'
          now = 'Travel to Juno, the floating capital of the Schwarzwald Republic, and meet Sage Elisha near the southern entrance (156, 47).'
          done = 'Elisha studies Juperos, the ruins of an ancient civilization beneath the Republic. Its machines have begun to wake on their own.'
          re = @{ lv = 105
             hint = @(
               'From Einbech, the Train Station Staff (39, 215) takes you back to Einbroch (200 zeny).'
               'In Einbroch, enter the airport (64, 207), pay the Airport Staff (1,200 zeny) and ride the airship until it lands in Juno. Sage Elisha stands near Juno''s southern entrance (156, 47).'
             )
             say = @('Aldric wrote to me, and Gustav''s message came on the morning airship. Welcome to Juno.', 'Beneath the Republic lie the ruins of Juperos, a civilization older than any kingdom. Their machines have slept for ages.', 'Now they are waking on their own. Thin them out in the ruins, and I will learn what I can from what they leave behind.') }
          say = @('Aldric''s letter arrived yesterday. Welcome to Juno.', 'Beneath the Republic lie the ruins of Juperos, a civilization older than any kingdom. Their machines have slept for ages.', 'Now they are waking on their own. Thin them out in the ruins, and I will learn what I can from what they leave behind.') }
       @{ id = 27; type = 'hunt'; lv = 76; title = 'The Waking Machines'; where = 'juperos_01'
          re = @{ lv = 107 }
          mobs = @(,@(1676, 'Venatu', 40))
          now = 'Hunt 40 Venatu in the Juperos ruins (juperos_01).'
          done = 'You stopped the patrol of waking Venatu machines in the upper ruins.' }
       @{ id = 28; type = 'deliver'; lv = 80; title = 'Salvage'
          # Renewal: these Venatu drop no Steel; the other kind on the map (1677) does.
          re = @{ lv = 110
             items = @(@(7317, 'Rusty Screw', 8), @(999, 'Steel', 1))
             now = 'Bring Sage Elisha 8 Rusty Screws and 1 Steel from the machines, in Juno (156, 47).' }
          items = @(@(7317, 'Rusty Screw', 15), @(999, 'Steel', 2))
          now = 'Bring Sage Elisha 15 Rusty Screws and 2 Steel from the machines, in Juno (156, 47).'
          done = 'The machines ran on a crystal energy older than the seals themselves, the same energy the seals were made from.'
          say = @('Fascinating. Look at the wear on these screws. These machines have been running for days.', 'And their power source... it is the same crystal energy the old seals are made from. The machines and the seals were built by the same hands.', 'At the heart of the ruins sits the Core. Whatever is waking them answers to it. Go and put it to sleep.') }
       # Navigation can't route into jupe_core: the way down is the Juperos
       # elevator (rAthena quests_juperos.txt), all scripted warps. The route
       # leads to its first step, and the hint walks through the rest.
       @{ id = 29; type = 'boss'; lv = 83; title = 'The Core'; map = 'jupe_core'; mob = 1670; boss = 'Awakened Core Guardian'; hp = 10
          re = @{ lv = 114 }
          items = @(@(7356, 'Crest Piece (Purple)', 1), @(7357, 'Crest Piece (Green)', 1), @(7358, 'Crest Piece (Orange)', 1), @(7359, 'Crest Piece (Blue)', 1))
          route = @('juperos_01', 100, 91, 'The way down: juperos_01')
          now = 'Reach the heart of the ruins, the Juperos Core (jupe_core), through the old elevator beneath Juperos. Bring 4 Crest Pieces from Venatu.'
          hint = @(
            'Collect the 4 Crest Pieces (Purple, Green, Orange, Blue). Only Venatu drop them, in the Juperos ruins. The elevator lever needs all 4.'
            'Juperos 1: step on the strange spot at (100, 91) and agree, or wait 10 seconds. You drop down to Juperos 2.'
            'Juperos 2: destroy the 3 Gate Switches on the outer islands, at (24, 275), (240, 29) and (282, 183). The ground shakes, and a portal opens in the centre (130, 149) for about 10 minutes. Broken switches come back after 20 minutes.'
            'Security halls: each pedestal checks one Crest Piece (it is not taken). Then an alarm sends Venatu and Dimik at you. Survive, and a portal takes you on.'
            'Elevator room: put all 4 Crest Pieces in the lever (they are used up) and pull it. Defeat the 9 guards within 2 minutes, or you are thrown out.'
            'Elevator ride: 4 waves of 8 guards, a new wave every 30 seconds. Kill all 32 within about 2 minutes, or you are thrown out to the gate hall (the 4 pieces are lost). When the last one falls, step on the portal at (41, 33), or wait and you are moved to the Core anyway. The Awakened Core Guardian rises a few seconds later.'
            'If you fall in the elevator, the lever has kept your 4 pieces. Bring a new set of 4 and start again from Juperos 1. The elevator rooms only work while the lever is running, so no Warper or teleport can take you there.'
          )
          # Clickable spots per map: the Journal shows the ones of the map you
          # are on (Navigation draws a path inside your own map even where it
          # can't route between maps). sw = a watched monster (see watch).
          spots = @(
            @{ map = 'juperos_01'; x = 100; y = 91; name = 'Strange spot: the way down to Juperos 2' }
            @{ map = 'juperos_02'; x = 24; y = 275; name = '1st Gate Switch'; sw = 1 }
            @{ map = 'juperos_02'; x = 240; y = 29; name = '2nd Gate Switch'; sw = 2 }
            @{ map = 'juperos_02'; x = 282; y = 183; name = '3rd Gate Switch'; sw = 3 }
            @{ map = 'juperos_02'; x = 130; y = 149; name = 'Centre portal'; sw = 0 }
            @{ map = 'jupe_gate'; x = 28; y = 145; name = 'Left hall gate' }
            @{ map = 'jupe_gate'; x = 71; y = 145; name = 'Right hall gate' }
            @{ map = 'jupe_gate'; x = 49; y = 55; name = 'Elevator gate (after a hall''s lever)' }
            @{ map = 'jupe_area1'; x = 88; y = 224; name = 'Pedestal 1 (Purple)' }
            @{ map = 'jupe_area1'; x = 25; y = 238; name = 'Pedestal 2 (Green)' }
            @{ map = 'jupe_area1'; x = 36; y = 146; name = 'Pedestal 3 (Orange)' }
            @{ map = 'jupe_area1'; x = 50; y = 49; name = 'Pedestal 4 (Blue)' }
            @{ map = 'jupe_area1'; x = 112; y = 162; name = 'Hall lever (back to the gate)' }
            @{ map = 'jupe_area2'; x = 74; y = 224; name = 'Pedestal 1 (Purple)' }
            @{ map = 'jupe_area2'; x = 138; y = 238; name = 'Pedestal 2 (Green)' }
            @{ map = 'jupe_area2'; x = 127; y = 146; name = 'Pedestal 3 (Orange)' }
            @{ map = 'jupe_area2'; x = 113; y = 49; name = 'Pedestal 4 (Blue)' }
            @{ map = 'jupe_area2'; x = 51; y = 162; name = 'Hall lever (back to the gate)' }
            @{ map = 'jupe_ele_r'; x = 51; y = 98; name = 'Elevator lever (uses all 4 Crest Pieces)' }
            @{ map = 'jupe_ele'; x = 41; y = 33; name = 'Portal to the Core (after the 4th wave)' }
          )
          # The Gate Switches are monsters of rAthena's "3F Gate Switch#jupe";
          # the server tells the Journal which are still standing.
          watch = @{ map = 'juperos_02'; event = '3F Gate Switch#jupe::OnMyMobDead'; names = @('1st Gate Switch', '2nd Gate Switch', '3rd Gate Switch') }
          done = 'You destroyed the Awakened Core Guardian. Its last broadcast was a map of Arunafeltz, far to the north.' }
       @{ id = 30; type = 'report'; lv = 87; title = 'The Guardians'' Purpose'
          now = 'Report to Sage Elisha in Juno (156, 47).'
          done = 'Elisha believes the guardians were built to watch over the seals. With them failing, the seals'' last line is gone. She sent you to the Church of Freya in Rachel.'
          say = @('A map of Arunafeltz? Then I was right.', 'The guardians were built to watch over the seals. They woke because the seals are failing, and now they are failing too.', 'The Church of Freya in Rachel has watched the north for a thousand years. Find Sister Ilyana. Tell her a sage of Juno sent you.')
          # Renewal: the New World chapters come first.
          re = @{ lv = 117
             done = 'Elisha believes the guardians were built to watch over the seals. The Core''s last broadcast showed two places: Arunafeltz, and the rift that opened when Morroc fell. The Allied Expedition beyond the rift had asked the Sages for help, so she sent you through it first.'
             say = @('A map of Arunafeltz? And this one... the rift beneath Morroc. Then I was right.', 'The guardians were built to watch over the seals. They woke because the seals are failing, and the deepest wound of all is the rift that opened when Morroc fell.', 'The Allied Expedition went through it into a new world, and their captain has asked the Sages for help. Go to Captain Varrick at their camp. Rachel can wait until you return.', 'An Allied Scout keeps watch over the rift, east of Morroc. Show him your Chronicle and he will let you through.') } }
     ) }

  # Renewal only: the New World beyond the rift under Morroc (rAthena
  # quests_13_1.txt). The way in is quest-locked (ep13_ryu), so the Allied
  # Scout (gates below) lets Chronicle bearers through to the Allied camp.
  # The camp's own guards are locked too: the Teleport Cats take you out.
  @{ era = 'renewal'; title = 'Beyond the Rift'; range = '118-124'
     town = 'mid_camp'; townName = 'the Allied Forces Post'; npc = 'Captain Varrick'; sprite = '852'; x = 200; y = 282
     costumes = @(5018, 2283, 5378); costumeId = 50128; gift = @(@(504, 50), @(505, 30)); zeny = 70000
     intro = 'Beyond the rift under Morroc lies a world no map of Rune-Midgard shows: the land of the Laphine of Splendide and the Sapha of Manuk. The Allied Expedition of the three kingdoms keeps its camp just past the rift.'
     spots = @(
       @{ map = 'moc_fild20'; x = 345; y = 182; name = 'Allied Scout: through the rift to the camp' }
       @{ map = 'mid_camp'; x = 207; y = 234; name = 'Teleport Cat: Near Splendide or Manuk Field (10,000 zeny)' }
     )
     away = 'Outside the New World? The Allied Scout east of Morroc (moc_fild20, 345, 182) lets you through the rift to the Allied camp. Once you have been there, a Waykeeper can send you back too.'
     steps = @(
       @{ id = 106; type = 'talk'; lv = 118; title = 'Through the Rift'
          route = @('moc_fild20', 345, 182, 'Allied Scout: moc_fild20')
          now = 'Go through the rift under Morroc to the Allied Forces Post, and find Captain Varrick in the camp (200, 282).'
          hint = @(
            'From Morroc, follow the Route link to the Allied Scout on the Sograt Desert east of the city (moc_fild20, 345, 182), next to the rift guards.'
            'Show him your Chronicle and choose to go through. He sends you to the Allied Forces Post (mid_camp), where Captain Varrick stands near the arrival spot (200, 282).'
          )
          done = 'Captain Varrick leads the Allied Expedition''s camp. Since the rift opened, the monsters of this new world have grown wild, and both the Laphine and the Sapha blame the humans who came through it.'
          say = @('A sage of Juno sends us a Chronicle bearer? Good. We need one.', 'When Morroc fell, the seal under it tore open, and through the tear we found this place. The Laphine of Splendide call it their home. So do the Sapha of Manuk.', 'Since we came, their monsters have gone wild. The Laphine say we brought it with us, and I am not sure they are wrong.', 'The fields north of Splendide are the worst. Clear them, and maybe the Laphine will talk to us again. Our Teleport Cat by the supply tents will take you to Splendide''s fields.') }
       @{ id = 107; type = 'hunt'; lv = 119; title = 'The Wild Fields'; where = 'spl_fild01'
          mobs = @(@(1993, 'Naga', 30), @(1992, 'Cornus', 20))
          now = 'Hunt 30 Naga and 20 Cornus in the fields north of Splendide (spl_fild01).'
          hint = @(
            'The camp''s gate guards only let the Expedition''s own people out. Take the Teleport Cat in the camp (207, 234) to Near Splendide (10,000 zeny).'
            'You arrive on spl_fild02. Its way north (293, 379) leads to spl_fild01, the hunting ground.'
          )
          spots = @(
            @{ map = 'spl_fild02'; x = 293; y = 379; name = 'Way north to spl_fild01' }
          )
          done = 'You drove back the Naga and the Cornus that had overrun the fields north of Splendide.' }
       @{ id = 108; type = 'deliver'; lv = 121; title = 'Proof of Good Faith'
          items = @(@(936, 'Scale Shell', 8), @(6023, 'Mystic Horn', 8))
          now = 'Varrick wants proof to show the Laphine. Bring him 8 Scale Shells from the Naga and 8 Mystic Horns from the Cornus, in the Allied camp (200, 282).'
          hint = @(
            'From spl_fild01, the way south (289, 28) leads back to spl_fild02. Its east edge (382, 143) leads into the camp.'
          )
          spots = @(
            @{ map = 'spl_fild01'; x = 289; y = 28; name = 'Way south to spl_fild02' }
            @{ map = 'spl_fild02'; x = 382; y = 143; name = 'Way east into the camp' }
          )
          done = 'The Laphine accepted the proof, but their elders had a warning: the madness is not coming from the humans. It seeps up out of the rift itself, and the Tatacho of Manuk''s fields have caught it worst.'
          say = @('Scale and horn. The Laphine will believe their own eyes, if not my word.', 'Their answer came this morning. They say the madness is not ours. It seeps up out of the rift itself, like smoke from a wound.', 'And the worst of it is in the fields of Manuk, the Sapha''s land. One Tatacho there has gone so mad that even the Sapha hunters will not go near it. Put it down.') }
       @{ id = 109; type = 'boss'; lv = 122; title = 'The Rift-Mad Beast'; map = 'man_fild02'; mob = 1986; boss = 'Rift-Mad Tatacho'; hp = 8
          now = 'Go to Manuk Field (man_fild02), the Sapha''s land, and put down the Rift-Mad Tatacho.'
          hint = @(
            'Take the Teleport Cat in the camp (207, 234) to Manuk Field (10,000 zeny). The Rift-Mad Tatacho appears a few seconds after you arrive.'
          )
          done = 'You put down the Rift-Mad Tatacho. Its eyes burned with the same light as the seal crystals of Juperos.' }
       @{ id = 110; type = 'report'; lv = 124; title = 'A Word from the Sapha'
          now = 'Return to Captain Varrick in the Allied camp (200, 282).'
          hint = @(
            'From Manuk Field, the Teleport Cat (135, 49) takes you back to the Allied camp (10,000 zeny). Or walk west: man_fild01''s west edge (35, 232) leads into the camp.'
          )
          spots = @(
            @{ map = 'man_fild02'; x = 135; y = 49; name = 'Teleport Cat: back to the camp (10,000 zeny)' }
          )
          done = 'The Sapha heard of the hunt. Their warden at the gate of El Dicastes, their capital, sent word: he wants to meet the one who did it, and he has seen the same light under Kamidal Mountain.'
          say = @('The Sapha heard what you did. That is a first: they have never sent us anything but arrows.', 'Their warden at the gate of El Dicastes, Kahlis, wants to meet you. He says the same light burns under Kamidal Mountain, in the Scaraba hive.', 'No human has set foot in El Dicastes. But he will meet you outside the gate. Take this, and go.') }
     ) }

  # Renewal only: El Dicastes, the Sapha capital. Its gate is quest-locked
  # (ep13_3_invite and the Bradium Earring), so Kahlis meets you outside it.
  @{ era = 'renewal'; title = 'The Sapha''s Gate'; range = '124-129'
     town = 'dic_fild01'; townName = 'El Dicastes'; npc = 'Warden Kahlis'; sprite = '492'; x = 156; y = 270
     costumes = @(2284, 5002, 2224); costumeId = 50131; gift = @(@(504, 50), @(608, 3)); zeny = 80000
     intro = 'El Dicastes is the capital of the Sapha, built into the slopes of Kamidal Mountain. Its gates are shut to every other race, and beneath the mountain lies the hive of the Scaraba.'
     spots = @(
       @{ map = 'mid_camp'; x = 207; y = 234; name = 'Teleport Cat: Manuk Field (10,000 zeny)' }
       @{ map = 'man_fild02'; x = 135; y = 49; name = 'Teleport Cat: Near El Dicastes (20,000 zeny)' }
     )
     away = 'Far from El Dicastes? From the Allied camp, the Teleport Cat (207, 234) goes to Manuk Field, and the Teleport Cat there (135, 49) to Near El Dicastes. The Allied Scout east of Morroc (moc_fild20, 345, 182) lets you through the rift to the camp.'
     steps = @(
       @{ id = 111; type = 'talk'; lv = 124; title = 'The Warden of El Dicastes'
          now = 'Go to Kamidal Mountain and find Warden Kahlis outside the gate of El Dicastes (dic_fild01, 156, 270).'
          hint = @(
            'From the Allied camp, take the Teleport Cat (207, 234) to Manuk Field (10,000 zeny).'
            'On Manuk Field, the Teleport Cat (135, 49) goes to Near El Dicastes (20,000 zeny). Warden Kahlis stands just south of the city gate (156, 270).'
          )
          done = 'Kahlis guards the gate of El Dicastes. Since the rift opened, the Scaraba under Kamidal Mountain have been breeding out of season, and they have begun to dig toward the city.'
          say = @('So you are the human who quieted the Tatacho. Kahlis, warden of this gate. I will not ask you in. The law forbids it, and I keep the law.', 'Since your rift opened, the Scaraba under the mountain breed out of season. Their workers swarm the slopes, and the hive digs toward the city.', 'Thin the swarm on the mountain first. Then we will talk about the hive.') }
       @{ id = 112; type = 'hunt'; lv = 125; title = 'The Swarm on the Mountain'; where = 'dic_fild01'
          mobs = @(@(1987, 'Centipede', 30), @(2092, 'Dolomedes', 10))
          now = 'Hunt 30 Centipedes and 10 Dolomedes on the slopes of Kamidal Mountain (dic_fild01), outside El Dicastes.'
          done = 'You thinned the creatures swarming over Kamidal Mountain, and the slopes fell quiet.' }
       @{ id = 113; type = 'deliver'; lv = 126; title = 'What the Swarm Leaves'
          items = @(@(1042, 'Bug Leg', 8), @(6325, 'White Spider Limb', 5))
          now = 'Bring Warden Kahlis 8 Bug Legs from the Centipedes and 5 White Spider Limbs from the Dolomedes, at the gate of El Dicastes (156, 270).'
          done = 'Kahlis read the remains as the Sapha read omens: the swarm was not hunting, it was fleeing. Something in the Scaraba hive drives them out.'
          say = @('Hm. These are not wounds from your weapons alone. Look, the joints are scorched.', 'The swarm was not hunting. It was fleeing. Something in the Scaraba hive is driving everything out of the mountain.', 'The hive''s mouth is at the west end of these slopes. Go in, and find what rules it now.') }
       @{ id = 114; type = 'boss'; lv = 127; title = 'The Hive Under Kamidal'; map = 'dic_dun01'; mob = 2083; boss = 'Rift-Touched Scaraba'; hp = 8
          now = 'Enter the Scaraba Hole under Kamidal Mountain (dic_dun01). Its entrance is at the west end of dic_fild01 (24, 79).'
          spots = @(
            @{ map = 'dic_fild01'; x = 24; y = 79; name = 'Entrance to the Scaraba Hole' }
          )
          done = 'You slew the Rift-Touched Scaraba. In its shell was a shard of black crystal, the same seal crystal Gustav found in Einbech.' }
       @{ id = 115; type = 'report'; lv = 129; title = 'A Shard of the Seal'
          now = 'Return to Warden Kahlis at the gate of El Dicastes (156, 270).'
          hint = @(
            'From the Scaraba Hole, the way out (371, 44) leads back to dic_fild01. Kahlis waits by the city gate (156, 270).'
          )
          spots = @(
            @{ map = 'dic_dun01'; x = 371; y = 44; name = 'Way out to dic_fild01' }
          )
          done = 'Kahlis knew the shard: the Sapha''s oldest songs tell of a seal-fire that broke through from another world. He sent you home, to the Church of Freya in Rachel, whose sisters keep the same songs.'
          say = @('Seal crystal. The oldest songs of my people tell of it: a fire from another world, sealed away long before there were Sapha or humans.', 'The songs say the priests of the goddess across the rift keep the other half of the story. Your Church of Freya, in Rachel.', 'Go home, human, and take this shard to them. The gate of El Dicastes will remember your name, even if the law will not let you through it.') }
     ) }

  @{ n = 7; title = 'Fire and Faith'; range = '90-99'
     re = @{ range = '130-140' }
     town = 'rachel'; townName = 'Rachel'; npc = 'Sister Ilyana'; sprite = '4_F_SISTER'; x = 141; y = 146
     costumes = @(5306, 2282, 5414); gift = @(,@(607, 5)); zeny = 90000
     intro = 'Rachel is the holy city of the Arunafeltz States, seat of the Church of the goddess Freya.'
     steps = @(
       @{ id = 31; type = 'talk'; lv = 90; title = 'The Church of Freya'
          # Renewal: you come home from El Dicastes, through the rift.
          re = @{ lv = 130
             hint = @(
               'From El Dicastes: on dic_fild01, the way south (69, 23) leads to dic_fild02. Its Dimensional Transporter (241, 31) takes you into the Dimensional Gap.'
               'In the Gap, the way south (122, 48) leads to the rift gorge (moc_fild22b). The Rift Guard there (37, 196) walks you out to Morroc''s fields (moc_fild20).'
               'From there, follow the Route link to Rachel, holy city of Arunafeltz. Sister Ilyana is at (141, 146).'
             )
             spots = @(
               @{ map = 'dic_fild01'; x = 69; y = 23; name = 'Way south to dic_fild02' }
               @{ map = 'dic_fild02'; x = 241; y = 31; name = 'Dimensional Transporter: into the Gap' }
               @{ map = 'dali'; x = 122; y = 48; name = 'Way to the rift gorge' }
               @{ map = 'moc_fild22b'; x = 37; y = 196; name = 'Rift Guard: out to Morroc''s fields' }
             )
             say = @('May Freya''s light guide you. Elisha wrote that you would come, and a letter from beyond the rift came after hers.', 'A shard of seal crystal, from the Sapha? Then the songs on both sides of the rift tell the same story.', 'Our oracles see fire under Thor''s Volcano, south of Veins. And in the cities of the kingdom, an old mark has begun to appear. We call it the Sign.', 'Go to the volcano. Its creatures are restless, and we must know why.') }
          now = 'Travel to Rachel, holy city of Arunafeltz, and find Sister Ilyana (141, 146).'
          done = 'Ilyana serves the goddess Freya. The church''s oracles have seen fire under Thor''s Volcano, and an old mark appearing in the cities: the Sign.'
          say = @('May Freya''s light guide you. Elisha wrote that you would come.', 'Our oracles see fire under Thor''s Volcano, south of Veins. And in the cities of the kingdom, an old mark has begun to appear. We call it the Sign.', 'Go to the volcano. Its creatures are restless, and we must know why.') }
       @{ id = 32; type = 'hunt'; lv = 91; title = 'Under the Mountain'; where = 'thor_v01'
          re = @{ lv = 131 }
          mobs = @(@(1837, 'Fire Imp', 30), @(1833, 'Kasa', 15))
          now = 'Hunt 30 Fire Imps and 15 Kasa in Thor''s Volcano (thor_v01), south of Veins.'
          done = 'You drove back the fire creatures of the volcano''s first level.' }
       @{ id = 33; type = 'deliver'; lv = 93; title = 'Embers for the Oracles'
          re = @{ lv = 133
             items = @(@(7097, 'Burning Heart', 3), @(7122, 'Burning Hair', 5))
             now = 'Bring Sister Ilyana 3 Burning Hearts and 5 Burning Hair, in Rachel (141, 146).' }
          items = @(@(7097, 'Burning Heart', 5), @(7122, 'Burning Hair', 10))
          now = 'Bring Sister Ilyana 5 Burning Hearts and 10 Burning Hair, in Rachel (141, 146).'
          done = 'The embers were demon fire, Geffenia''s breath, leaking all the way to Arunafeltz.'
          say = @('Give them here... careful, they still burn.', 'This is not the volcano''s fire. It is demon fire. Geffenia''s breath, leaking all the way to Arunafeltz.', 'Something on the second level of the volcano is carrying it. The oracles saw it with the Sign on its brow. End it.') }
       @{ id = 34; type = 'boss'; lv = 95; title = 'The Ember Herald'; map = 'thor_v02'; mob = 1833; boss = 'Ember Herald'; hp = 10
          re = @{ lv = 136 }
          now = 'Descend to the second level of Thor''s Volcano (thor_v02).'
          done = 'You quenched the Ember Herald, a fire spirit bearing the Sign on its brow.' }
       @{ id = 35; type = 'report'; lv = 97; title = 'The Sign'
          re = @{ lv = 138 }
          now = 'Return to Sister Ilyana in Rachel (141, 146).'
          done = 'Ilyana understood at last: the Sign calls the hero who will stand at Geffenia''s gate. Look for the mysterious Sign near Prontera''s north gate (147, 305) to begin The Sign, Rune-Midgard''s own legend. When you are ready, a Valkyrie''s herald waits in Hugel.'
          say = @('The Herald bore the Sign? Then the prophecy is true.', 'The Sign calls a hero to stand at the gate of Geffenia. Freya has watched your road since Prontera, I think. It was no accident that it led you here.', 'Look for the Sign near Prontera''s north gate, and follow where it leads. And when you are ready, go to Hugel. A Valkyrie''s herald has been asking for you.') }
     ) }

  @{ n = 8; title = 'Twilight of the Gods'; range = '99+'
     re = @{ range = '140-146' }
     town = 'hugel'; townName = 'Hugel'; npc = 'Brynjar the Herald'; sprite = '4_M_KNIGHT_GOLD'; x = 101; y = 56
     costumes = @(5171, 5292, 5584); gift = @(@(616, 1), @(607, 10)); zeny = 150000
     intro = 'Hugel is a quiet seaside village in the far north, where boats leave for the temple of Odin.'
     steps = @(
       @{ id = 36; type = 'talk'; lv = 99; title = 'The Valkyrie''s Herald'
          re = @{ lv = 140 }
          now = 'Go to Hugel, the seaside village in the far north, and find Brynjar the Herald (101, 56).'
          done = 'Brynjar speaks for the Valkyries of Odin''s Temple. The seals were forged with divine power, and as the Twilight of the Gods, Ragnarok, draws near, that power is ebbing.'
          say = @('So you are the one the Sign has been calling. The Valkyries have watched you since Prontera.', 'Hear the truth. Every seal in Midgard was forged with the power of the gods. As the Twilight of the Gods draws near, that power ebbs, and the seals fail.', 'Odin''s Temple lies across the sea. Its fallen warrior-spirits no longer serve. Cut them down.', 'The Boatman by the eastern pier of Hugel sails there for a few coins.') }
       # Odin's Temple is reached only by the Boatman (rAthena quests_hugel.txt,
       # Boatman#hugel: 800 zeny, no quest), so Navigation can't route there.
       @{ id = 37; type = 'hunt'; lv = 100; title = 'Fallen Spirits'; where = 'odin_tem02'
          re = @{ lv = 141 }
          mobs = @(@(1752, 'Skogul', 30), @(1753, 'Frus', 30))
          route = @('hugel', 209, 109, 'Boatman to Odin''s Temple: hugel')
          now = 'Hunt 30 Skogul and 30 Frus on the second floor of Odin''s Temple (odin_tem02). The Boatman in Hugel (209, 109) sails there.'
          hint = @(
            'Hugel: talk to the Boatman (209, 109) and choose Sure! (800 zeny). He sails you to the first floor of Odin''s Temple (odin_tem01).'
            'First floor: walk to the east end. The paths at (378, 182) and (383, 334) lead up to the second floor (odin_tem02), the hunting ground.'
            'To go home, the Boatman on the first floor (93, 146) sails you back to Hugel.'
          )
          spots = @(
            @{ map = 'odin_tem01'; x = 378; y = 182; name = 'Way up to the second floor' }
            @{ map = 'odin_tem01'; x = 383; y = 334; name = 'Way up to the second floor (north)' }
          )
          done = 'You cut down the fallen warrior-spirits that once served the Valkyries.' }
       @{ id = 38; type = 'deliver'; lv = 103; title = 'Runes of the Gods'
          re = @{ lv = 142
             items = @(,@(7511, 'Rune of Darkness', 5))
             now = 'Bring Brynjar 5 Runes of Darkness in Hugel (101, 56).' }
          items = @(,@(7511, 'Rune of Darkness', 10))
          now = 'Bring Brynjar 10 Runes of Darkness in Hugel (101, 56).'
          hint = @(, $odinHomeHint)
          spots = $odinHome
          done = 'With the runes, Brynjar could read the gods'' own seal-craft: the seals hold only while heroes stand for them.'
          say = @('Runes of the gods, darkened. Let me read them.', 'It is written plainly. The seals were never meant to hold forever. They hold only while heroes stand for them.', 'One last shade haunts the temple''s upper hall, a Valkyrie who lost her way. Free her.') }
       @{ id = 39; type = 'boss'; lv = 106; title = 'The Fallen Valkyrie'; map = 'odin_tem03'; mob = 1752; boss = 'Fallen Valkyrie''s Shade'; hp = 12
          re = @{ lv = 144 }
          route = @('hugel', 209, 109, 'Boatman to Odin''s Temple: hugel')
          now = 'Ascend to the upper hall of Odin''s Temple (odin_tem03). The Boatman in Hugel (209, 109) sails there.'
          hint = @(
            'Hugel: talk to the Boatman (209, 109) and choose Sure! (800 zeny). He sails you to the first floor of Odin''s Temple (odin_tem01).'
            'First floor: walk to the east end. The paths at (378, 182) and (383, 334) lead up to the second floor (odin_tem02).'
            'Second floor: the ways up at (153, 349) and (261, 377) lead to the upper hall (odin_tem03). The Fallen Valkyrie''s Shade appears a few seconds after you arrive.'
          )
          spots = @(
            @{ map = 'odin_tem01'; x = 378; y = 182; name = 'Way up to the second floor' }
            @{ map = 'odin_tem01'; x = 383; y = 334; name = 'Way up to the second floor (north)' }
            @{ map = 'odin_tem02'; x = 153; y = 349; name = 'Way up to the upper hall' }
            @{ map = 'odin_tem02'; x = 261; y = 377; name = 'Way up to the upper hall (east)' }
          )
          done = 'You defeated the Fallen Valkyrie''s Shade, and the temple fell quiet for the first time in years.' }
       @{ id = 40; type = 'report'; lv = 110; title = 'Champion of Rune-Midgard'
          now = 'Return to Brynjar the Herald in Hugel (101, 56).'
          hint = @(, $odinHomeHint)
          spots = $odinHome
          done = 'Brynjar knelt. The Norns weave every fate in Midgard, but a hero who stands where the seals fail can change what was written. Your Chronicle is complete: you are a Champion of Rune-Midgard. Legends still wait: The Sign and Geffenia, Thanatos Tower, the Abyss Lakes and the Endless Tower.'
          say = @('The temple is quiet. The Valkyries thank you.', 'The Norns weave every fate in Midgard. But a hero who stands where the seals fail can change what was written. That is what you have done.', 'Rise, Champion of Rune-Midgard. Your Chronicle is complete, but legends still wait: the Sign, Thanatos Tower, the Abyss Lakes, the Endless Tower.')
          # Renewal: not the end yet. On to Mora, beyond the rift.
          re = @{ lv = 146; title = 'The Light of Bifrost'
             done = 'Brynjar thanked you in the Valkyries'' name, but the temple had shown them one more failing light: Bifrost, the rainbow bridge beyond the rift, where the Laphine of Mora live. He sent you there.'
             say = @('The temple is quiet. The Valkyries thank you.', 'But from the upper hall they saw one more light failing. Bifrost, the rainbow bridge of the gods, stands beyond the rift you crossed, in the land of the Laphine.', 'The Laphine village of Mora lies at its foot. Its elder, Mirrel, has kept the bridge''s light for longer than any human has lived. Go to him.', 'The Allied Scout east of Morroc will let you back through the rift.') } }
     ) }

  # Renewal only: Mora, the Laphine village at the foot of Bifrost. From the
  # Allied camp: Teleport Cats to Splendide's field, then to Bifrost's.
  @{ era = 'renewal'; title = 'The Light of Bifrost'; range = '147-150'
     town = 'mora'; townName = 'Mora'; npc = 'Elder Mirrel'; sprite = '4_M_RAFLE_OLD'; x = 114; y = 96
     costumes = @(2215, 5064, 2207); costumeId = 50134; gift = @(@(607, 10), @(608, 5)); zeny = 100000
     intro = 'Mora is a Laphine village of healers and gardeners, hidden in the hills at the foot of Bifrost, the rainbow bridge beyond the rift. Its Small Holes in the hillside are its only doors.'
     spots = @(
       @{ map = 'moc_fild20'; x = 345; y = 182; name = 'Allied Scout: through the rift to the camp' }
       @{ map = 'mid_camp'; x = 207; y = 234; name = 'Teleport Cat: Near Splendide (10,000 zeny)' }
       @{ map = 'spl_fild02'; x = 53; y = 242; name = 'Teleport Cat: Entrance to Mora (55,000 zeny)' }
       @{ map = 'bif_fild02'; x = 285; y = 332; name = 'Small Hole: into Mora' }
     )
     away = 'Far from Mora? Through the rift (the Allied Scout east of Morroc, moc_fild20, 345, 182) to the Allied camp, its Teleport Cat (207, 234) to Near Splendide, the Teleport Cat there (53, 242) to Entrance to Mora, then knock on the Small Hole (285, 332).'
     steps = @(
       @{ id = 116; type = 'talk'; lv = 147; title = 'The Village Under the Bridge'
          route = @('moc_fild20', 345, 182, 'Allied Scout: moc_fild20')
          now = 'Go to Mora, the Laphine village at the foot of Bifrost, and find Elder Mirrel (114, 96).'
          hint = @(
            'Follow the Route link to the Allied Scout east of Morroc (moc_fild20, 345, 182). He lets you through the rift to the Allied camp.'
            'In the camp, the Teleport Cat (207, 234) goes to Near Splendide (10,000 zeny). On spl_fild02, the Teleport Cat (53, 242) goes to Entrance to Mora (55,000 zeny).'
            'On bif_fild02, knock on the Small Hole in the hill (285, 332). It opens into Mora. Elder Mirrel stands in the village centre (114, 96).'
          )
          done = 'Mirrel keeps the light of Bifrost. Since the rift opened, the fairy-folk of the bridge''s fields have turned on the Laphine, and the bridge''s colours are fading.'
          say = @('A human, with a Valkyrie''s blessing on him? Then Brynjar''s message was true. Sit, sit.', 'I keep the light of Bifrost. For a thousand years it has shone in seven colours. This spring it shines in five.', 'The little spirits of the bridge fields, the Fatum and the Miming, have turned on my people. They were never cruel. Something has made them so.', 'Drive them back from the village, so my gardeners can work again.') }
       @{ id = 117; type = 'hunt'; lv = 147; title = 'The Bridge Fields'; where = 'bif_fild02'
          mobs = @(@(2136, 'Little Fatum', 30), @(2137, 'Miming', 20))
          now = 'Hunt 30 Little Fatum and 20 Miming on the fields of Bifrost outside Mora (bif_fild02).'
          hint = @(
            'Mora''s east door (182, 74) leads out to bif_fild02, the hunting ground.'
          )
          spots = @(
            @{ map = 'mora'; x = 182; y = 74; name = 'Way out to bif_fild02' }
          )
          done = 'You drove the maddened spirits back from Mora''s gardens.' }
       @{ id = 118; type = 'deliver'; lv = 148; title = 'Dust of the Rainbow'
          items = @(@(6395, 'Angel Magic Powder', 5), @(6394, 'Golden Feather', 5))
          now = 'Bring Elder Mirrel 5 Angel Magic Powder from the Little Fatum and 5 Golden Feathers from the Miming, in Mora (114, 96).'
          done = 'The powder and feathers had lost their colour. Mirrel saw why: the bridge''s light was being drunk by a thorn-hearted mantis in the fields.'
          say = @('Look. Fatum powder should shimmer in every colour, and Miming feathers should be warm as sunlight. These are grey.', 'Something is drinking the light of Bifrost before it reaches them. My gardeners have seen it: a mantis with a heart of thorns, bigger than any they have seen.', 'It hides in the bridge fields. Find it, and the bridge will shine again.') }
       @{ id = 119; type = 'boss'; lv = 149; title = 'The Thornheart'; map = 'bif_fild02'; mob = 2133; boss = 'Thornheart Mantis'; hp = 10
          now = 'Return to the fields of Bifrost outside Mora (bif_fild02) and slay the Thornheart Mantis.'
          hint = @(
            'Mora''s east door (182, 74) leads out to bif_fild02. The Thornheart Mantis appears a few seconds after you arrive.'
          )
          spots = @(
            @{ map = 'mora'; x = 182; y = 74; name = 'Way out to bif_fild02' }
          )
          done = 'You slew the Thornheart Mantis. As it fell, the light it had drunk streamed back up into Bifrost.' }
       @{ id = 120; type = 'report'; lv = 150; title = 'Seven Colours'
          now = 'Return to Elder Mirrel in Mora (114, 96).'
          hint = @(
            'On bif_fild02, knock on the Small Hole in the hill (285, 332). It opens into Mora.'
          )
          spots = @(
            @{ map = 'bif_fild02'; x = 285; y = 332; name = 'Small Hole: into Mora' }
          )
          done = 'Bifrost shone in seven colours again. But Mirrel knew the mantis had not been the cause: the bridge draws its light from the World Tree, and in Eclage, the Laphine city on the tree, it is withering.'
          say = @('Seven colours. I had almost forgotten what that looks like. Thank you.', 'But the mantis was a thief, not the cause. Bifrost draws its light from the World Tree itself, Yggdrasil, and the tree is sick.', 'The Laphine of Eclage live on its branches. Their guard captain, Sylwen, keeps watch outside the city gate. Tell her Mirrel sent you, and take this for the road.') }
     ) }

  # Renewal only: Eclage, the Laphine city on the World Tree. Its gate is
  # quest-locked (ep14_2_oliver), so Sylwen meets you outside it.
  @{ era = 'renewal'; title = 'Under the World Tree'; range = '151-158'
     town = 'ecl_fild01'; townName = 'Eclage'; npc = 'Captain Sylwen'; sprite = '4_M_FAIRYSOLDIER'; x = 102; y = 307
     costumes = @(5303, 5284, 2254); costumeId = 50137; gift = @(@(607, 10), @(608, 5)); zeny = 120000
     intro = 'Eclage is the capital of the Laphine, built in the branches of Yggdrasil, the World Tree. Its gate admits only those the Laphine have registered, and the old tower of the tree''s keepers stands in the field below.'
     spots = @(
       @{ map = 'mora'; x = 182; y = 74; name = 'Way out to bif_fild02' }
       @{ map = 'bif_fild02'; x = 292; y = 351; name = 'Way north to the fields of Eclage' }
     )
     away = 'Far from Eclage? From Mora, the east door (182, 74) leads to bif_fild02, and its north-east way (292, 351) to ecl_fild01. Captain Sylwen stands outside the city gate (102, 307).'
     steps = @(
       @{ id = 121; type = 'talk'; lv = 151; title = 'The Gate of Eclage'
          now = 'Go to the fields of Eclage (ecl_fild01) and find Captain Sylwen outside the city gate (102, 307).'
          hint = @(
            'From Mora, the east door (182, 74) leads out to bif_fild02.'
            'On bif_fild02, the way in the north-east (292, 351) leads to ecl_fild01. Walk north-west to the city gate; Captain Sylwen stands just outside it (102, 307).'
          )
          done = 'Sylwen guards the gate of Eclage. The keepers'' tower in the field below the city, where the Laphine once tended the tree''s roots, has filled with ash and walking books, and no keeper has come out of it.'
          say = @('Mirrel sent you? Then you may stand here. Inside the gate, I am afraid, is another matter: the council lets no stranger in.', 'You see that tower in the field? The keepers of the World Tree lived there. They tended its roots for a thousand years.', 'Since spring it has filled with ash and dust, and their old books walk the halls on their own. No keeper has come out.', 'Go up into the tower. Clear its halls, and we will learn what happened to them.') }
       @{ id = 122; type = 'hunt'; lv = 152; title = 'The Ashen Halls'; where = 'ecl_tdun02'
          mobs = @(@(2365, 'Cenere', 25), @(2366, 'Antique Book', 20))
          now = 'Hunt 25 Cenere and 20 Antique Books on the second floor of the keepers'' tower (ecl_tdun02).'
          hint = @(
            'The tower''s door is in the south of ecl_fild01 (182, 82).'
            'Floor 1: the stairs up (67, 106) lead to the second floor (ecl_tdun02), the hunting ground.'
          )
          spots = @(
            @{ map = 'ecl_fild01'; x = 182; y = 82; name = 'Door of the keepers'' tower' }
            @{ map = 'ecl_tdun01'; x = 67; y = 106; name = 'Stairs up to the second floor' }
          )
          done = 'You cleared the ash spirits and the restless books from the tower''s second floor.' }
       @{ id = 123; type = 'deliver'; lv = 154; title = 'Ash and Pages'
          items = @(@(7001, 'Mould Powder', 5), @(1097, 'Worn Out Page', 5))
          now = 'Bring Captain Sylwen 5 Mould Powder from the Cenere and 5 Worn Out Pages from the Antique Books, outside the gate of Eclage (102, 307).'
          done = 'The pages were the keepers'' last records: the roots of the World Tree were rotting, and the keepers'' old steward had gone up to the top floor to stop it, and never come down.'
          say = @('Ash from the roots... and these pages are the keepers'' own records. Let me read.', '"The roots are rotting from below. Something under the world is drinking from them." And the last page: "The steward has gone up to stop it."', 'The steward never came down. Go to the top floor, friend. Whatever he has become, end it.') }
       @{ id = 124; type = 'boss'; lv = 156; title = 'The Last Keeper'; map = 'ecl_tdun03'; mob = 2371; boss = 'Withered Steward'; hp = 8
          now = 'Climb to the third floor of the keepers'' tower (ecl_tdun03) and free the Withered Steward.'
          hint = @(
            'The tower''s door is in the south of ecl_fild01 (182, 82). Floor 1: the stairs up (67, 106). Floor 2: the stairs up (52, 9) lead to the third floor.'
            'The Withered Steward appears a few seconds after you arrive.'
          )
          spots = @(
            @{ map = 'ecl_fild01'; x = 182; y = 82; name = 'Door of the keepers'' tower' }
            @{ map = 'ecl_tdun01'; x = 67; y = 106; name = 'Stairs up to the second floor' }
            @{ map = 'ecl_tdun02'; x = 52; y = 9; name = 'Stairs up to the third floor' }
          )
          done = 'You freed the Withered Steward. With his last breath he named what drinks from the roots: an ancient machine city, buried under the Schwarzwald, where the first seal was made.' }
       @{ id = 125; type = 'report'; lv = 158; title = 'The Roots Below'
          now = 'Return to Captain Sylwen outside the gate of Eclage (102, 307).'
          hint = @(
            'From the tower, take the stairs down to the first floor and its door (61, 11) back out to ecl_fild01. Sylwen stands outside the city gate (102, 307).'
          )
          spots = @(
            @{ map = 'ecl_tdun03'; x = 49; y = 11; name = 'Stairs down to the second floor' }
            @{ map = 'ecl_tdun02'; x = 60; y = 90; name = 'Stairs down to the first floor' }
            @{ map = 'ecl_tdun01'; x = 61; y = 11; name = 'Door out to ecl_fild01' }
          )
          done = 'Sylwen knew the city the steward named: Verus, the buried city beneath the Juperos ruins. The machines there are digging toward the first seal, and the World Tree''s roots run through it. She sent you back across the rift, to Verus.'
          say = @('A machine city, under the Schwarzwald... the Laphine call it the Iron Root. Your people call it Verus.', 'The ruins of Juperos are its upper floors. Below them, the machines that built the seals are still digging, and the roots of the World Tree run right through their tunnels.', 'If they reach the first seal, there will be no tree, no bridge and no rift left to close. Go to Verus, champion. The Laphine will sing of you either way.') }
     ) }

  # Renewal only: the finale in Verus (rAthena Episode 15), under Juperos:
  # juperos_01's east tunnel leads to the excavation and the city.
  @{ era = 'renewal'; title = 'The First Seal'; range = '160-171'
     town = 'verus04'; townName = 'Verus'; npc = 'Professor Hendrik'; sprite = '4_M_OLDSCHOLAR'; x = 190; y = 180
     costumes = @(5357, 5205, 2235); costumeId = 50140; gift = @(@(616, 1), @(607, 20)); zeny = 200000
     intro = 'Verus is a city of the ancients, buried beneath the ruins of Juperos and only now dug out by the Republic''s excavators. Its machines built the seals of Rune-Midgard, and some of them still run.'
     spots = @(
       @{ map = 'juperos_01'; x = 245; y = 87; name = 'East tunnel: to the excavation (ver_eju)' }
       @{ map = 'ver_eju'; x = 107; y = 36; name = 'Way down to the tunnel (ver_tunn)' }
       @{ map = 'ver_tunn'; x = 10; y = 36; name = 'Way to Verus (verus04)' }
     )
     away = 'Far from Verus? From Juno, go down into the Juperos ruins (juperos_01). Its east tunnel (245, 87) leads to the excavation (ver_eju), its south way (107, 36) to the tunnel (ver_tunn), and the tunnel''s west end (10, 36) to Verus (verus04).'
     steps = @(
       @{ id = 126; type = 'talk'; lv = 160; title = 'The Buried City'
          route = @('juperos_01', 245, 87, 'The way to Verus: juperos_01')
          now = 'Go to Verus, the buried city beneath Juperos, and find Professor Hendrik at the excavation camp (verus04, 190, 180).'
          hint = @(
            'From Juno, follow the Route link into the Juperos ruins (juperos_01). Its east tunnel (245, 87) leads to the excavation site (ver_eju).'
            'On ver_eju, the way south (107, 36) leads into the tunnel (ver_tunn). The tunnel''s west end (10, 36) opens into Verus (verus04). Professor Hendrik works near the excavators'' camp (190, 180).'
          )
          done = 'Hendrik leads the Republic''s dig in Verus. The city''s repair machines have woken and joined its old diggers: all of them are tunnelling down, toward something sealed under the city.'
          say = @('Careful where you step, this floor is older than the kingdom. Hendrik, of the Juno Academy.', 'Elisha''s letters said you might come. The Laphine one I did not expect. The World Tree''s roots, here? Then it is worse than I feared.', 'This city built the seals. Every crystal in Juperos, in Einbech, under Morroc, was cut here. And its machines have woken, all of them, and they are digging down.', 'Start with the old city south of my camp. Its repair machines and rovers have gone wild. Stop them.') }
       @{ id = 127; type = 'hunt'; lv = 161; title = 'The Waking City'; where = 'verus03'
          mobs = @(@(3155, 'Repair Robot', 30), @(3156, 'Exploration Rover', 15))
          route = @('verus04', 121, 267, 'Way to the old city: verus04')
          now = 'Hunt 30 Repair Robots and 15 Exploration Rovers in the old city of Verus (verus03).'
          hint = @(
            'From Professor Hendrik''s camp, the ways north (121, 267) and (44, 267) lead to the old city (verus03), the hunting ground.'
          )
          spots = @(
            @{ map = 'verus04'; x = 121; y = 267; name = 'Way north to the old city (verus03)' }
          )
          done = 'You broke the swarm of repair machines and rovers that had woken in the old city.' }
       @{ id = 128; type = 'deliver'; lv = 164; title = 'Iron and Orders'
          items = @(@(7319, 'Used Iron Plate', 5), @(998, 'Iron', 10))
          now = 'Bring Professor Hendrik 5 Used Iron Plates from the Repair Robots and 10 Iron from the Exploration Rovers, in Verus (190, 180).'
          done = 'Etched inside the plates were the machines'' orders, older than any kingdom: dig to the first seal and open it. One machine gives those orders, the great Excavator at the dig site above.'
          say = @('Look inside the plate. These marks are orders, burned in by the machines themselves.', '"Dig to the first seal. Open it." Every machine in this city carries the same order. And it comes from one source.', 'The great Excavator, at the dig site you walked through on your way down. It is not one of ours. It woke before we came. Stop it, and the city sleeps.') }
       @{ id = 129; type = 'boss'; lv = 167; title = 'The Excavator Prime'; map = 'ver_eju'; mob = 3153; boss = 'Excavator Prime'; hp = 10
          now = 'Go back up to the excavation site (ver_eju) and destroy the Excavator Prime.'
          hint = @(
            'From Verus, the way east (204, 163) leads into the tunnel (ver_tunn), and its north end (84, 86) up to the excavation site (ver_eju). The Excavator Prime appears a few seconds after you arrive.'
          )
          spots = @(
            @{ map = 'verus04'; x = 204; y = 163; name = 'Way to the tunnel (ver_tunn)' }
            @{ map = 'ver_tunn'; x = 84; y = 86; name = 'Way up to the excavation site (ver_eju)' }
          )
          done = 'You destroyed the Excavator Prime. All through the city the machines fell still, one by one, and far below them the first seal held.' }
       @{ id = 130; type = 'report'; lv = 171; title = 'Champion of Rune-Midgard'
          now = 'Return to Professor Hendrik in Verus (190, 180).'
          hint = @(
            'From the excavation site, the way south (107, 36) leads into the tunnel (ver_tunn), and its west end (10, 36) to Verus. Hendrik is at his camp (190, 180).'
          )
          spots = @(
            @{ map = 'ver_eju'; x = 107; y = 36; name = 'Way down to the tunnel (ver_tunn)' }
            @{ map = 'ver_tunn'; x = 10; y = 36; name = 'Way to Verus (verus04)' }
          )
          done = 'The first seal holds. From Prontera''s fields to the roots of the World Tree, you stood wherever the seals failed. Your Chronicle is complete: you are a Champion of Rune-Midgard. Legends still wait: The Sign and Geffenia, Thanatos Tower, the Abyss Lakes and the Endless Tower.'
          say = @('Silence. For the first time since we broke ground, the whole city is silent.', 'Under Morroc, in Einbech, beyond the rift, on the World Tree, and now here, at the first seal itself. You stood wherever the seals failed, and they held.', 'The Valkyries have a word for that, I am told. Rise, Champion of Rune-Midgard. Your Chronicle is complete, but legends still wait: the Sign, Thanatos Tower, the Abyss Lakes, the Endless Tower.') }
     ) }
)

# Passages the Chronicle opens: a Renewal NPC who lets a character through
# from step id 'from' on (the New World's own way in is quest-locked). Only
# built into a route that has that step.
$gates = @(
  @{ from = 106; map = 'moc_fild20'; x = 345; y = 182; dir = 4; sprite = '707'; name = 'Allied Scout'; to = @('mid_camp', 210, 288)
     say = @('You carry a Chronicle, and the Sages of Juno vouch for you. The Allied Expedition will be glad of you.', 'Beyond the rift is the Allied Forces Post. Its own Teleport Cats and Dimensional Device can take you on from there.')
     shut = 'The rift is closed to all but the Allied Expedition and those it calls for. I cannot let you through.' }
)

return @{ chapters = $chapters; final = $final; finalRe = $finalRe; gates = $gates }
