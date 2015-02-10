# Untitled Multiplayer Incremental Game

## Combat

### Philosophy

For this phase of the prototype, we will be using D&D style leveling and attributes (ie. linear growth and very low level cap). Most of the game should be unlockable under 3 hours to ensure that we can test the game engine more thoroughly.

Later on, we can tweak it to a more "grindy" system like Diablo or (*gasp*) Disgaea.

### Attributes

Base unit attributes:

* HP - duh
* Evade - AC in D&D terms. Starts at 10. Without armor, an attack from the basic melee weapon will hit 95% of the time.
* Move - tiles moved per turn
* Defense - Damage reduction. Does not reduce damage below 1.

Weapon/equipment attributes:

* Slot - only 3 slots are available: weapon, armor, mobility
* Accuracy - Compared to Evade. Hits are rolled on a d20 with the minimum required for hit at `evade - accuracy`. 1 and 20 are always critical miss/hit respectively so the maximum/minimum chance of hitting are at 95% and 5%.
* Damage - duh. Reduced by defense.
* Range Min/Max - range of the weapon. Lowest minimum range is 1 (melee).
* Points - "weight" or "experience requirement". Each unit's slot has a maximum point allotment, preventing stronger weapons/items from being equipped by lower-level units.
### Leveling up

In this version, units do not level up. The XP they'll gain will be added to your XP, which in turn will unlock unit and inventory slots. Similarly, kills and missions completed will unlock new units and equipment for purchase.

## TODO

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

## Log format

    [
      [ 
        { 
          id: x,
          target: x, // no new target if not present
          move: [[q, r], [q, r]...] // still present if no move
          attack: {
            new_target: x, // no new target (i.e. same target) if not present
            hit: true,
            damage: x,
            kill: false
          }
        },
        ...
      ],
      ...
    ]
