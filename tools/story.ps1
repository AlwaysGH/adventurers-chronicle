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

$final = 115   # the level the last step fills toward

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
       @{ type = 'talk'; lv = 1; title = 'The Knight at the Fountain'
          now = 'The Prontera Knights are looking for adventurers. Find Sir Leonhart near the central fountain of Prontera (157, 190).'
          done = 'You met Sir Leonhart of the Prontera Knights. He saw promise in you and offered you work: the fields around the capital are overrun.'
          say = @('An adventurer, fresh on the road? Good. The kingdom needs every sword it can get.', 'Monsters around Prontera have grown bold these past weeks, and my knights cannot be everywhere at once.', 'Clear the fields south of the city and I will see that you are paid. Here, take this journal. Write down what you see.') }
       @{ type = 'hunt'; lv = 2; title = 'Clearing the Southern Fields'; where = 'prt_fild08'
          mobs = @(@(1002, 'Poring', 20), @(1063, 'Lunatic', 15))
          now = 'Monsters around Prontera have grown bold. Hunt 20 Porings and 15 Lunatics in the fields south of Prontera (prt_fild08). Track the count in the quest window (Alt+U).'
          done = 'You thinned the Porings and Lunatics south of the capital. The farmers noticed, and so did Leonhart.' }
       @{ type = 'deliver'; lv = 6; title = 'Proof for the Knights'
          items = @(@(909, 'Jellopy', 10), @(705, 'Clover', 5))
          now = 'Leonhart needs proof for the Knight Captain. Bring him 10 Jellopy and 5 Clover in Prontera (157, 190).'
          done = 'You brought Leonhart his proof. He confided that the monsters are not only multiplying: they are coming up from below the city, out of the Culvert.'
          say = @('Good work. This will quiet the Captain for a while.', 'But listen. The guards found Thief Bugs in the cellars near the walls, far too many of them. They are coming up from the Culvert, the old waterways under the city.', 'The Culvert is sealed by royal decree. Sign up with the Recruiter in the north-west of the city, then go down to its second level and find out what is breeding them.', 'One warning. The old guards speak of a golden beetle, far larger than any Thief Bug, on the fourth and deepest level of the Culvert. The Golden Thief Bug. Do not go looking for it. Not yet.') }
       # The Culvert Guardian only lets in volunteers (rAthena quests_prontera.txt,
       # MISC_QUEST & 8), so the route leads to the Recruiter first.
       @{ type = 'boss'; lv = 10; title = 'Into the Culvert'; map = 'prt_sewb2'; mob = 1054; boss = 'Culvert Brood Lord'; hp = 8
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
       @{ type = 'report'; lv = 13; title = 'Report to Leonhart'
          now = 'Tell Sir Leonhart in Prontera (157, 190) what you found in the Culvert.'
          done = 'Leonhart listened in silence. Reports like yours are arriving from all over Rune-Midgard: monsters stirring where they slept for centuries. He sent you south to Payon, whose archers asked the crown for help.'
          say = @('A Brood Lord... beneath the capital. I would not have believed it from anyone else.', 'You are not the first to bring such news. From every corner of the kingdom, monsters are waking where they have slept for centuries.', 'The archers of Payon have asked the crown for help. Their cave of the dead is restless. Go south, my friend. Captain Hwarang will be waiting.', 'One more thing, if you have a day to spare before Payon. The Culvert drains into the sea at Izlude, and the harbour master there writes that sea creatures have been attacking boats near Byalan Island since the same week the bugs appeared. He could use a sword.') }
     ) }

  @{ n = 2; title = 'Whispers of Payon'; range = '15-30'
     town = 'payon'; townName = 'Payon'; npc = 'Captain Hwarang'; sprite = '4_M_ARCHER'; x = 154; y = 182
     costumes = @(5046, 2264, 5214); gift = @(,@(502, 30)); zeny = 8000
     intro = 'Payon is a village of archers in the forested mountains, built beside a cave where its ancestors were laid to rest.'
     steps = @(
       @{ type = 'talk'; lv = 15; title = 'The Archer Captain'
          now = 'Travel south to Payon, the mountain village of archers, and find Captain Hwarang (154, 182).'
          done = 'Captain Hwarang told you of the Payon Cave, a sacred burial ground. For weeks the dead have been walking out of it at night.'
          say = @('So the knights sent you. Good. My archers cannot be everywhere at once.', 'North of the Archer Village lies the Payon Cave, where our ancestors rest. For weeks now, they have not been resting.', 'The dead walk out of it at night. Thin their numbers on the first level, and I will tell the elders the crown keeps its word.', 'Two warnings I give every newcomer. The deepest level of the cave belongs to the Moonlight Flower, a fox spirit who plays cruel tricks on the living. And in the forest south of the village hunts Eddga, a great tiger. Leave both alone until you have grown.') }
       @{ type = 'hunt'; lv = 16; title = 'The Restless Dead'; where = 'pay_dun00'
          mobs = @(@(1015, 'Zombie', 25), @(1076, 'Skeleton', 20))
          now = 'Hunt 25 Zombies and 20 Skeletons on the first level of the Payon Cave (pay_dun00), north of the Archer Village.'
          done = 'You put the restless dead of the cave''s first level back to rest, for now.' }
       @{ type = 'deliver'; lv = 20; title = 'Bones and Nails'
          items = @(@(957, 'Decayed Nail', 10), @(932, 'Skel-Bone', 5))
          now = 'The village shaman wants to study what raises the dead. Bring Captain Hwarang 10 Decayed Nails and 5 Skel-Bones in Payon (154, 182).'
          done = 'The shaman found traces of an old binding on the bones: a seal laid long ago to keep the cave''s spirits asleep. It is fraying.'
          say = @('The shaman will want these. Wait here.', '...She says there was a binding on these bones. An old seal, laid by our ancestors to keep the cave asleep. It is coming apart.', 'Our soldiers of old were buried on the second level, with their captain. If he has risen, he must fall again. Go carefully.', 'The shaman needs time to prepare her wards before anyone goes down to the captain, so go when you are ready. Strange... a merchant from Alberta came begging this morning. The old wreck off his coast walks at night, drowned sailors on its deck. It sounds like our sickness.') }
       @{ type = 'boss'; lv = 24; title = 'The Captain Below'; map = 'pay_dun01'; mob = 1028; boss = 'Restless Cave Captain'; hp = 8
          now = 'Descend to the second level of the Payon Cave (pay_dun01). The soldiers buried there once had a commander; if he has risen, he must fall again.'
          done = 'You defeated the Restless Cave Captain, an ancient soldier still loyal to a war long forgotten. As he crumbled, he whispered of the seals breaking in the desert.' }
       @{ type = 'report'; lv = 27; title = 'Words of the Dead'
          now = 'Tell Captain Hwarang in Payon (154, 182) what the dead soldier said.'
          done = 'Hwarang paled. Payon''s elders remember the great seal beneath Morroc, where a demon king was bound long ago. He sent you across the desert to Morroc.'
          say = @('The seals breaking in the desert... that is what he said?', 'Our elders tell a story of Morroc. Long ago, a demon king was bound beneath the desert city, and the seal has held ever since.', 'If the dead are whispering about it, someone must go. There is a seer in Morroc, Nafisa. She reads the sands better than anyone.', 'The desert roads are closed by the Continental Guard, so do not try to walk. Ask a Kafra Employee here in Payon to send you to Morroc.') }
     ) }

  @{ n = 3; title = 'Sands of Morroc'; range = '30-45'
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
       @{ type = 'talk'; lv = 30; title = 'The Desert Seer'
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
       @{ type = 'hunt'; lv = 31; title = 'Restless Sands'; where = 'moc_fild16'
          mobs = @(@(1165, 'Sandman', 25), @(1127, 'Hode', 25))
          now = 'Hunt 25 Sandmen and 25 Hodes in the Sograt Desert (moc_fild16).'
          done = 'The desert creatures were fleeing something deeper in the sand. You turned them back.' }
       @{ type = 'deliver'; lv = 35; title = 'Grains of Truth'
          items = @(@(1056, 'Grit', 10), @(1055, 'Earthworm Peeling', 10))
          now = 'Nafisa reads omens in sand. Bring her 10 Grit and 10 Earthworm Peelings in Morroc (156, 286).'
          done = 'The sand spoke of the Pyramids, the tomb of Osiris, whose priests sealed the desert''s evils. The priests are awake again.'
          say = @('Let me pour these out... yes. Yes, I see it.', 'The Pyramids, northwest of the city. The priests of Osiris sealed the evils of the desert there long ago.', 'They are awake again, and they chant a ritual that no longer works. Go to the third level and silence them. No deeper: Osiris himself sleeps on the fourth, and he does not forgive those who wake him.', 'The sands show me something else too. A face of stone, west of the city. The same hands that built the Pyramids built the Sphinx, and whatever wakes in one stirs the other.') }
       @{ type = 'boss'; lv = 38; title = 'The Pyramid''s Priest'; map = 'moc_pryd03'; mob = 1041; boss = 'Bound Priest of Osiris'; hp = 9
          now = 'Enter the Pyramids northwest of Morroc and reach the third level (moc_pryd03).'
          done = 'You struck down the Bound Priest of Osiris, a mummy still chanting the ritual of a seal it could no longer hold.' }
       @{ type = 'report'; lv = 42; title = 'The Seer''s Warning'
          now = 'Return to Nafisa in Morroc (156, 286) and tell her about the priest.'
          done = 'Nafisa confirmed it: the seals across Rune-Midgard are weakening together. The oldest of them stands beneath the tower of Geffen, the city of magic. She sent you there with a letter for the magisters.'
          say = @('So the priests failed. Then it is as I feared.', 'Not one seal is weakening. All of them are, together, as if something is pulling at every knot at once.', 'The oldest seal of all lies beneath the tower of Geffen. Take this letter to the magisters there. Our Kafra can send you to Prontera; Geffen is a short walk west from there.', 'And adventurer... the sands say your road has only begun. Beneath the Pyramids lies an older tomb still, where Amon Ra waits. That is a road for another year.', 'One more vision before you go. Across the sea, in a land of temples, a tiger spirit stirs in an old shrine. It guarded a seal like ours, and the shrine has an older keeper still, Lady Tanee. My courier sails ahead of you with a pouch: the sands show me a shaman asking for what is in it.') }
     ) }

  @{ n = 4; title = 'Tower of Geffen'; range = '45-60'
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
       @{ type = 'talk'; lv = 45; title = 'A Letter for the Magister'
          now = 'Bring Nafisa''s letter to Magister Ivo in Geffen (206, 116). From Morroc, a Kafra Employee can teleport you to Prontera; Geffen is a walk west from there.'
          hint = @(
            'No open road leads out of Morroc. Talk to the Kafra Employee in the north of Morroc (160, 258), choose Teleport Service, then Prontera (1,200 zeny).'
            'From Prontera, the Route link leads west to Geffen. Magister Ivo stands near the east gate (206, 116) and is marked on your minimap when you arrive.'
          )
          done = 'Ivo read the letter twice. Beneath Geffen''s tower lies the gate to Geffenia, the sealed realm of demons. The orcs to the west have grown savage, and Ivo suspects why.'
          say = @('A letter from the desert seer? She never writes. ...Oh. Oh, dear.', 'What I tell you now, few outside the Magic Academy know. Beneath our tower lies the gate to Geffenia, the realm where demons were sealed away.', 'The orcs to the west have turned savage, and their shamans draw power from the ground. Break their warband and bring me proof.', 'And mind the Orc Hero. He walks those lands now and then, and he is no common orc. If you see him, go around.') }
       @{ type = 'hunt'; lv = 46; title = 'The Orc Warband'; where = 'gef_fild14'
          mobs = @(@(1213, 'High Orc', 30), @(1189, 'Orc Archer', 20))
          now = 'Hunt 30 High Orcs and 20 Orc Archers in the orc lands west of Geffen (gef_fild14).'
          done = 'You broke the orc warband. Its shamans had been drawing power from something below the ground.' }
       @{ type = 'deliver'; lv = 50; title = 'Trophies of War'
          items = @(@(7002, 'Ogre Tooth', 10), @(1063, 'Fang', 10))
          now = 'Bring Magister Ivo 10 Ogre Teeth and 10 Fangs from the orcs, in Geffen (206, 116).'
          done = 'The trophies hummed with dark mana, the same mana that leaks from Geffenia. The seal under the tower is cracking.'
          say = @('Let me feel... yes. Dark mana, soaked into the bone.', 'It is the same mana that leaks from Geffenia. The seal under the tower is cracking, and the orcs drink from the cracks.', 'One more thing about the orcs. A man we expelled from the Academy lives in their village, with a machine he swears shows the past. My scholar Wendel watches him. If you pass that way, help Wendel.', 'Something has already slipped through. Go down into the Geffen Dungeon, to its second level, and stop it before it reaches the city.', 'Dracula himself is said to haunt that same level, and the Doppelganger the one below. The Nightmare is your quarry, not them.') }
       @{ type = 'boss'; lv = 54; title = 'Beneath the Tower'; map = 'gef_dun01'; mob = 1061; boss = 'Nightmare of the Tower'; hp = 10
          now = 'Enter the Geffen Dungeon beneath the tower and reach its second level (gef_dun01).'
          done = 'You defeated the Nightmare of the Tower, a demon-touched steed that had slipped through the cracks of the seal.' }
       @{ type = 'report'; lv = 57; title = 'The Fallen Kingdom'
          now = 'Report to Magister Ivo in Geffen (206, 116).'
          done = 'Ivo will reinforce the seal, but he warned that Geffen''s wards were built with knowledge from Glast Heim, the fallen kingdom. He sent you to the knights of Al De Baran to learn what happened there.'
          say = @('You did it. The Academy will reinforce the seal tonight.', 'Two letters came this week, from opposite ends of the sea. In Amatsu, a fox spirit haunts the lord''s mother. In Kunlun, the chief''s ancestral sword was stolen. I sent Lise to Amatsu, and Kunlun''s scribe waits for you. If you have time to sail, go.', 'But I must confess something. Our wards were built with knowledge taken from Glast Heim, the kingdom that fell into darkness.', 'If the wards fail, the answer is there. A knight in Al De Baran still guards its memory. Find Sir Aldric.') }
     ) }

  @{ n = 5; title = 'Ghosts of Glast Heim'; range = '60-75'
     town = 'aldebaran'; townName = 'Al De Baran'; npc = 'Sir Aldric'; sprite = '4_M_KNIGHT_BLACK'; x = 142; y = 63
     costumes = @(5181, 5017, 5363); gift = @(@(504, 40), @(505, 20)); zeny = 40000
     intro = 'Al De Baran is the city of canals and the great Clock Tower, north of Prontera and close to the ruins of Glast Heim.'
     steps = @(
       @{ type = 'talk'; lv = 60; title = 'The Last Knight'
          now = 'Go to Al De Baran, the city of the Clock Tower, and find Sir Aldric near the south gate (142, 63).'
          done = 'Sir Aldric is the last of an order that once guarded Glast Heim. He told you how the kingdom fell: its king bargained with darkness, and the Dark Lord answered.'
          say = @('Ivo sent you? Then you already know more than most.', 'I am the last of the order that guarded Glast Heim. Our king bargained with darkness for power, and the Dark Lord answered. The kingdom fell in a single night.', 'Lately the Clock Tower here has been wrong. It was built to keep time with the old seals. Clear its first floor and we will see.', 'The great gears above and below are slipping too. The fourth floor and the fourth basement are sealed by the old alchemists'' gates, and their Gatekeepers want a key. That can wait until you are ready.') }
       @{ type = 'hunt'; lv = 61; title = 'Time Out of Joint'; where = 'c_tower1'
          mobs = @(@(1195, 'Rideword', 30), @(1199, 'Punk', 30))
          now = 'Strange things walk the Clock Tower. Hunt 30 Ridewords and 30 Punks on its first floor (c_tower1).'
          done = 'The Clock Tower''s haunted books and spores fell silent. Aldric said the tower was built to keep time with the seals.' }
       @{ type = 'deliver'; lv = 65; title = 'Pages of the Past'
          items = @(@(1097, 'Worn Out Page', 10), @(7001, 'Mould Powder', 10))
          now = 'Bring Sir Aldric 10 Worn Out Pages and 10 Mould Powder in Al De Baran (142, 63); he can piece together the old records.'
          done = 'The pages spoke of Glast Heim''s knights, cursed to guard their ruined halls forever.'
          say = @('These pages... I know this hand. These are records from Glast Heim.', 'My brothers of the order. Cursed to guard the ruined halls forever, the records say. Even in death they keep their posts.', 'And this one is no Glast Heim page. A ship''s voyage log, about an island where turtles march like soldiers under a general. The old sailors of Alberta still tell of it.', 'One of them walks the churchyard. If anyone can tell us what is happening to the seals, it is him. Go to Glast Heim, west of Geffen.', 'Beware: the Dark Lord himself walks that churchyard at times. If the air turns cold and the dead start to gather, leave.') }
       @{ type = 'boss'; lv = 68; title = 'The Churchyard'; map = 'gl_chyard'; mob = 1192; boss = 'Wraith of the Fallen Order'; hp = 10
          now = 'Travel to Glast Heim, west of Geffen, and enter its churchyard (gl_chyard).'
          done = 'You laid to rest the Wraith of the Fallen Order, once a knight of Aldric''s own order. Before it faded, it spoke of the machines beneath the floating city.' }
       @{ type = 'report'; lv = 72; title = 'A Knight''s Salute'
          now = 'Tell Sir Aldric in Al De Baran (142, 63) what the wraith said.'
          done = 'Aldric saluted you as a knight would. The floating city is Juno, capital of the Schwarzwald Republic. He wrote to the Sages there on your behalf.'
          say = @('He is at peace, then. Thank you. I could never have raised my sword against him.', 'The machines beneath the floating city... he means Juno, the capital of the Schwarzwald Republic, and the ruins of Juperos below it.', 'I have written to the Sages of Juno. Ask for Sage Elisha. And... it was an honor, friend.') }
     ) }

  @{ n = 6; title = 'The Floating City'; range = '75-90'
     town = 'yuno'; townName = 'Juno'; npc = 'Sage Elisha'; sprite = '4_M_SAGE_C'; x = 156; y = 47
     costumes = @(5170, 2246, 2258); gift = @(@(607, 3), @(504, 50)); zeny = 60000
     intro = 'Juno floats above the clouds as the capital of the Schwarzwald Republic, a land of sages and machines.'
     steps = @(
       @{ type = 'talk'; lv = 75; title = 'The Sage of Juno'
          now = 'Travel to Juno, the floating capital of the Schwarzwald Republic, and meet Sage Elisha near the southern entrance (156, 47).'
          done = 'Elisha studies Juperos, the ruins of an ancient civilization beneath the Republic. Its machines have begun to wake on their own.'
          say = @('Aldric''s letter arrived yesterday. Welcome to Juno.', 'Beneath the Republic lie the ruins of Juperos, a civilization older than any kingdom. Their machines have slept for ages.', 'Now they are waking on their own. Thin them out in the ruins, and I will learn what I can from what they leave behind.') }
       @{ type = 'hunt'; lv = 76; title = 'The Waking Machines'; where = 'juperos_01'
          mobs = @(,@(1676, 'Venatu', 40))
          now = 'Hunt 40 Venatu in the Juperos ruins (juperos_01).'
          done = 'You stopped the patrol of waking Venatu machines in the upper ruins.' }
       @{ type = 'deliver'; lv = 80; title = 'Salvage'
          items = @(@(7317, 'Rusty Screw', 15), @(999, 'Steel', 2))
          now = 'Bring Sage Elisha 15 Rusty Screws and 2 Steel from the machines, in Juno (156, 47).'
          done = 'The machines ran on a crystal energy older than the seals themselves, the same energy the seals were made from.'
          say = @('Fascinating. Look at the wear on these screws. These machines have been running for days.', 'And their power source... it is the same crystal energy the old seals are made from. The machines and the seals were built by the same hands.', 'At the heart of the ruins sits the Core. Whatever is waking them answers to it. Go and put it to sleep.') }
       # Navigation can't route into jupe_core: the way down is the Juperos
       # elevator (rAthena quests_juperos.txt), all scripted warps. The route
       # leads to its first step, and the hint walks through the rest.
       @{ type = 'boss'; lv = 83; title = 'The Core'; map = 'jupe_core'; mob = 1670; boss = 'Awakened Core Guardian'; hp = 10
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
       @{ type = 'report'; lv = 87; title = 'The Guardians'' Purpose'
          now = 'Report to Sage Elisha in Juno (156, 47).'
          done = 'Elisha believes the guardians were built to watch over the seals. With them failing, the seals'' last line is gone. She sent you to the Church of Freya in Rachel.'
          say = @('A map of Arunafeltz? Then I was right.', 'The guardians were built to watch over the seals. They woke because the seals are failing, and now they are failing too.', 'The Church of Freya in Rachel has watched the north for a thousand years. Find Sister Ilyana. Tell her a sage of Juno sent you.') }
     ) }

  @{ n = 7; title = 'Fire and Faith'; range = '90-99'
     town = 'rachel'; townName = 'Rachel'; npc = 'Sister Ilyana'; sprite = '4_F_SISTER'; x = 141; y = 146
     costumes = @(5306, 2282, 5414); gift = @(,@(607, 5)); zeny = 90000
     intro = 'Rachel is the holy city of the Arunafeltz States, seat of the Church of the goddess Freya.'
     steps = @(
       @{ type = 'talk'; lv = 90; title = 'The Church of Freya'
          now = 'Travel to Rachel, holy city of Arunafeltz, and find Sister Ilyana (141, 146).'
          done = 'Ilyana serves the goddess Freya. The church''s oracles have seen fire under Thor''s Volcano, and an old mark appearing in the cities: the Sign.'
          say = @('May Freya''s light guide you. Elisha wrote that you would come.', 'Our oracles see fire under Thor''s Volcano, south of Veins. And in the cities of the kingdom, an old mark has begun to appear. We call it the Sign.', 'Go to the volcano. Its creatures are restless, and we must know why.') }
       @{ type = 'hunt'; lv = 91; title = 'Under the Mountain'; where = 'thor_v01'
          mobs = @(@(1837, 'Fire Imp', 30), @(1833, 'Kasa', 15))
          now = 'Hunt 30 Fire Imps and 15 Kasa in Thor''s Volcano (thor_v01), south of Veins.'
          done = 'You drove back the fire creatures of the volcano''s first level.' }
       @{ type = 'deliver'; lv = 93; title = 'Embers for the Oracles'
          items = @(@(7097, 'Burning Heart', 5), @(7122, 'Burning Hair', 10))
          now = 'Bring Sister Ilyana 5 Burning Hearts and 10 Burning Hair, in Rachel (141, 146).'
          done = 'The embers were demon fire, Geffenia''s breath, leaking all the way to Arunafeltz.'
          say = @('Give them here... careful, they still burn.', 'This is not the volcano''s fire. It is demon fire. Geffenia''s breath, leaking all the way to Arunafeltz.', 'Something on the second level of the volcano is carrying it. The oracles saw it with the Sign on its brow. End it.') }
       @{ type = 'boss'; lv = 95; title = 'The Ember Herald'; map = 'thor_v02'; mob = 1833; boss = 'Ember Herald'; hp = 10
          now = 'Descend to the second level of Thor''s Volcano (thor_v02).'
          done = 'You quenched the Ember Herald, a fire spirit bearing the Sign on its brow.' }
       @{ type = 'report'; lv = 97; title = 'The Sign'
          now = 'Return to Sister Ilyana in Rachel (141, 146).'
          done = 'Ilyana understood at last: the Sign calls the hero who will stand at Geffenia''s gate. Look for the mysterious Sign near Prontera''s north gate (147, 305) to begin The Sign, Rune-Midgard''s own legend. When you are ready, a Valkyrie''s herald waits in Hugel.'
          say = @('The Herald bore the Sign? Then the prophecy is true.', 'The Sign calls a hero to stand at the gate of Geffenia. Freya has watched your road since Prontera, I think. It was no accident that it led you here.', 'Look for the Sign near Prontera''s north gate, and follow where it leads. And when you are ready, go to Hugel. A Valkyrie''s herald has been asking for you.') }
     ) }

  @{ n = 8; title = 'Twilight of the Gods'; range = '99+'
     town = 'hugel'; townName = 'Hugel'; npc = 'Brynjar the Herald'; sprite = '4_M_KNIGHT_GOLD'; x = 101; y = 56
     costumes = @(5171, 5292, 5584); gift = @(@(616, 1), @(607, 10)); zeny = 150000
     intro = 'Hugel is a quiet seaside village in the far north, where boats leave for the temple of Odin.'
     steps = @(
       @{ type = 'talk'; lv = 99; title = 'The Valkyrie''s Herald'
          now = 'Go to Hugel, the seaside village in the far north, and find Brynjar the Herald (101, 56).'
          done = 'Brynjar speaks for the Valkyries of Odin''s Temple. The seals were forged with divine power, and as the Twilight of the Gods, Ragnarok, draws near, that power is ebbing.'
          say = @('So you are the one the Sign has been calling. The Valkyries have watched you since Prontera.', 'Hear the truth. Every seal in Midgard was forged with the power of the gods. As the Twilight of the Gods draws near, that power ebbs, and the seals fail.', 'Odin''s Temple lies across the sea. Its fallen warrior-spirits no longer serve. Cut them down.', 'The Boatman by the eastern pier of Hugel sails there for a few coins.') }
       # Odin's Temple is reached only by the Boatman (rAthena quests_hugel.txt,
       # Boatman#hugel: 800 zeny, no quest), so Navigation can't route there.
       @{ type = 'hunt'; lv = 100; title = 'Fallen Spirits'; where = 'odin_tem02'
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
       @{ type = 'deliver'; lv = 103; title = 'Runes of the Gods'
          items = @(,@(7511, 'Rune of Darkness', 10))
          now = 'Bring Brynjar 10 Runes of Darkness in Hugel (101, 56).'
          hint = @(, $odinHomeHint)
          spots = $odinHome
          done = 'With the runes, Brynjar could read the gods'' own seal-craft: the seals hold only while heroes stand for them.'
          say = @('Runes of the gods, darkened. Let me read them.', 'It is written plainly. The seals were never meant to hold forever. They hold only while heroes stand for them.', 'One last shade haunts the temple''s upper hall, a Valkyrie who lost her way. Free her.') }
       @{ type = 'boss'; lv = 106; title = 'The Fallen Valkyrie'; map = 'odin_tem03'; mob = 1752; boss = 'Fallen Valkyrie''s Shade'; hp = 12
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
       @{ type = 'report'; lv = 110; title = 'Champion of Rune-Midgard'
          now = 'Return to Brynjar the Herald in Hugel (101, 56).'
          hint = @(, $odinHomeHint)
          spots = $odinHome
          done = 'Brynjar knelt. The Norns weave every fate in Midgard, but a hero who stands where the seals fail can change what was written. Your Chronicle is complete: you are a Champion of Rune-Midgard. Legends still wait: The Sign and Geffenia, Thanatos Tower, the Abyss Lakes and the Endless Tower.'
          say = @('The temple is quiet. The Valkyries thank you.', 'The Norns weave every fate in Midgard. But a hero who stands where the seals fail can change what was written. That is what you have done.', 'Rise, Champion of Rune-Midgard. Your Chronicle is complete, but legends still wait: the Sign, Thanatos Tower, the Abyss Lakes, the Endless Tower.') }
     ) }
)

return @{ chapters = $chapters; final = $final }
