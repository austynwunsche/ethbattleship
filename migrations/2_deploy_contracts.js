const Game = artifacts.require("./Game.sol")
const GameLibrary = artifacts.require("./GameLibrary.sol")


module.exports = function(deployer) {
  deployer.deploy(GameLibrary)
  deployer.link(GameLibrary, Game)
  deployer.deploy(Game, "0x0504030302",10,30,"0xcc8b06a9154dd1f9eee8c6d05a03127036d45d81")
}
