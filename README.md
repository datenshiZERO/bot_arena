= Untitled Multiplayer Incremental Game

== TODO

User 
* username
* credits
* missions
* kills
* xp
* (clan)
* (affiliation)


Units
- name
- bt user
- bt template
- strategy
- xp
- (bonuses?)

Templates
- price
- min kills
- min missions
- base-hp
- base-ev
- base-mv
- base-def
- weapon-default
- weapon-max
- armor-default
- armor-max
- mobility-max
- mobility-default

Equipment
- part
- base-acc
- base-dmg
- min-range
- max-range
- bonus-hp
- bonus-ev
- bonus-mv
- bonus-def
- bonus-acc
- price
- points
- min kills
- min missions

User Equipment
- bt equipment
- bt unit
- (bonuses?)

Arenas
* map-type
  * bot hunt
  * deathmatch
  * team deathmatch
  * horde
  * survival (cat and mice)
* length
* width
* layout (odd-r)
* min-pts
* max-pts
* reward-join
* reward-kill
* reward-win
* reward-survive
* teams
* min players
* schedule

Battle
* bt arena
* outcome
* battle log
* timestamp

Unit Battle Outcome
* bt battle
* bt unit
* survived
* xp received
* kills
* assists


Bots
* bt arena
* bt template
* filler - true if for filling empty slots

ex:

    * shooting bots - bot hunt

    X X X X X X X X X X
     . . . . . . . . . .
    . . . . . . . . . .
     . . . . . . . . . .
    . . . . . . . . . . 
     A A A A A A A A A A
    
    * Chess - tdm

    A A A A A A A A
     A A A A A A A A
    . . . . . . . .
     . . . . . . . .
    . . . . . . . . 
     . . . . . . . .
    B B B B B B B B
     B B B B B B B B

    * Triangle - dm
  
    X X X X A X X X X
     X X X . . X X X X
    X X X A . A X X X
     X X . . . . X X X
    X X A . A . A X X
     X . . . . . . X X 
    X A . A . A . A X
     . . . . . . . . X
    A . A . A . A . A 

