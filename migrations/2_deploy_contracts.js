const Profiles = artifacts.require("Profiles");
const Recipes = artifacts.require("Recipes");

module.exports = function(deployer) {
  deployer.deploy(Profiles);
  deployer.deploy(Recipes);
};
