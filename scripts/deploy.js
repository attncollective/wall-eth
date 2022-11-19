// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  // Deploy NFT
  await deployNFT();
}

async function deployNFT (oracleAddress="0x0F7C4A8D7e911E6A6d0b3aAAB6a833601ccE65cC") {
  const oracleAddress = "0x0F7C4A8D7e911E6A6d0b3aAAB6a833601ccE65cC";

  const Lock = await hre.ethers.getContractFactory("RobotNFT");
  const lock = await Lock.deploy(oracleAddress);

  await lock.deployed();

  console.log(
    `Contract deployed to ${lock.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
