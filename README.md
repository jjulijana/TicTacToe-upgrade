# TicTacToe-upgrade
Strategies to enhance the second player's chances in tic-tac-toe - Playstudio's GameMath workshop

On this workshop, we used a very simple game - an auto-play version of Tic-Tac-Toe.
Throughout the day, we analyzed, optimized, and improved the game using the LUA programming language.

Install LUA and ZeroBrane
   LUA: http://www.lua.org/download.html
   Used IDE (and debugger) ZeroBrane: https://studio.zerobrane.com/

(for better understanding (trying yourself or debaging) change in code: INTERACTIVE = true    PRINT_DEB = true)

Problem: The distribution of wins between the first and second player is not equal, the first player has much higher chances.

Info from random 100000 games:
X rate is: 58.522%
O rate is: 28.623%
- rate is: 12.855%
Games usually ends at: 9th, 7th, 8th turn (respectively).

What do we want: We want to increase chances for second player, but simultaneously not to increase number of tie-ended matches.

Idea: 
1. Delete random tile from board. There doesn't necessarily have to be a piece on the tile.
   Results weren't any better, X has same chances but we have more ties.
2. Include X sensitive bombs on random tiles. 
   If 1st player stands on it, it explodes: bomb disappears and so do X (this tile remains empty).
   If 2nd playes stand on a bomb: nothing unusual happens, O is placed on a tile.
Therefore, although X always play first, now there is a chance that some of his moves could be "dealdly" and he could lose adventage.

Results from random 100000 games:
X rate is: 45.728%
O rate is: 44.737%
- rate is: 9.535%
5turn rate is: 9.656%
6turn rate is: 8.918%
7turn rate is: 19.276%
8turn rate is: 16.153%
9turn rate is: 16.798%
10turn rate is: 15.973%
11turn rate is: 12.483%

