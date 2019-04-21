var Adoption = artifacts.require("../contracts/GaoOwnership.sol");
module.exports = function(deployer) {
  deployer.deploy(Adoption);
};
