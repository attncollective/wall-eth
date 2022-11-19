const { expect } = require("chai");

describe("RobotNFT", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployNFT() {

    const [owner, otherAccount] = await ethers.getSigners()

    const Contract = await ethers.getContractFactory("RobotNFT");
    const contract = await Contract.deploy();
    
    return { contract, owner, otherAccount };
  }

  describe("Tests", function () {
    it("Should set the right interval", async function () {
      const { contract } = await loadFixture(deployCustomInterval);

      expect(await contract.interval()).to.equal(interval);
    });

    it("Upkeep should be needed", async function () {
      const { contract } = await loadFixture(deployCustomInterval);

      let upKeepNeeded = await contract.checkUpkeep();

      expect(upKeepNeeded).to.equal(true);
    });
  });
});
