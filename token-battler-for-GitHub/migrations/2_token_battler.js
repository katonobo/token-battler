var TokenBattlerToken = artifacts.require("./TokenBattlerToken.sol");

  module.exports = function(deployer) {
  deployer.deploy(TokenBattlerToken, "TokenBattlerToken", "TBT");
};
