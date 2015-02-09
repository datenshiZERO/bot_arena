= Untitled Multiplayer Incremental Game

== TODO

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

== Log format

    {
      arena: {
        name: 'xxx',
        mode: 'xxx',
        outcome: 'xxxxx'
      },
      participants: [
        { 
          bot: false,
          name: 'xxx',
          team: 'x',
          spawning_point: [q, r],
          ...
        },
        ...
      ]
      unit_battle_outcomes: [
        { 
          id: x,
          outcome: 'xxx',
          xp: x,
          kills: x
        },
        ...
      ],
      battle_log: [
        [ 
          { 
            id: x,
            target: x, // no new target if not present
            move: [x, y], // no move if not present
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
      ],
      ...
    }
      
