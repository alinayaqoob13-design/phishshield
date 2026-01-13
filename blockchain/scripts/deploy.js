// deploy.js (ESM version)
import hardhat from "hardhat";
const { ethers } = hardhat;

async function main() {
const UrlScanner = await ethers.getContractFactory("UrlScanner");
const urlScanner = await UrlScanner.deploy();
await urlScanner.waitForDeployment();
console.log("Deployed at:", await urlScanner.getAddress());
}

// Run the deployment
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
