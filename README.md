# ETH Battleship
Battleship on the Ethereum blockchain

Demo (Rinkeby, Ropsten): [https://eth-battleship/](https://eth-battleship.github.io/)

This is my implementation of the game Battleship on the Ethereum blockchain.
It is to be played by 2 players (i.e. 2 accounts) with as many people as you want watching the game progress.


### Game guide

Rules: [https://en.wikipedia.org/wiki/Battleship_(game)](https://en.wikipedia.org/wiki/Battleship_(game))

This is a 2-player game. You cannot play against yourself (i.e. the same ETH address is not permitted to play against itself). Even if you can't play a game you can observe it and/or see it's final outcome.

The smart contract is flexible enough to allow for any configuration of ship
lengths, max. no. of rounds and any size board (<= 16 max size), but for demo sake and to
save time the board size is fixed at 10x10, max. rounds at 30, and the ships are
the same as the default for the traditional game.
