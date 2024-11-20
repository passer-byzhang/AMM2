import { ethers } from "hardhat";
import {config} from "./config"
async function main() {
    const chainId = await ethers.provider.getNetwork();
    const networkConfig = config[chainId.chainId.toString() as keyof typeof config];
    console.log("Upgrading MasterChef on:", networkConfig.name + " network...");

    //deploy MasterChef
    const MasterChef = await ethers.getContractFactory("MasterChef");
    const masterChef = await MasterChef.deploy();
    await masterChef.waitForDeployment();
    const masterChefAddress = await masterChef.getAddress();
    console.log("New MasterChef deployed to:", masterChefAddress);

    const MasterChefProxy = await ethers.getContractAt("MasterChef", networkConfig.addresses.masterChef);
    await MasterChefProxy.upgradeToAndCall(masterChefAddress,"0x");
    console.log("MasterChef upgraded");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});