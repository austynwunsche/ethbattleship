# ETH Battleship -- ConsenSys Dev Program 2018
## Battleship on the Ethereum blockchain
  
Battleship on the Ethereum blockchain, it is to be played by 2 players (i.e. 2 accounts) with as many people as you want watching the game.

### Development Test
* Download / Clone Repository
* Install [Metamask](https://metamask.io/) and connect to Ropsten or Rinkeby testnets
* Enjoy

Install the descrepecies you will need. 
```
yarn
```

Install Truffle
```
npm install truffle -g
```
Run your local private test RPC with [Ganache](https://truffleframework.com/ganache)

```
truffle develop
```
Prepare and deploy the contracts with [Truffle](https://truffleframework.com/truffle)
```
truffle migrate --reset
```
Run the dApp [locally](http://localhost:3000/):
```
yarn start
```
```
npm start
```

Test smart contracts with Remix or
```
truffle test
```

### Game guide

Rules: [https://en.wikipedia.org/wiki/Battleship_(game)](https://en.wikipedia.org/wiki/Battleship_(game))
