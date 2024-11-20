import { ethers } from "hardhat";
import {config} from "./config"

async function main() {
    const chainId = await ethers.provider.getNetwork();
    const networkConfig = config[chainId.chainId.toString() as keyof typeof config];
    console.log("Initing in ", networkConfig.name + " network...");

    //init masterchef
    const [admin] = await ethers.getSigners();
    const MasterChef = await ethers.getContractAt("MasterChef", networkConfig.addresses.masterChef);
    await MasterChef.initilize(networkConfig.addresses.rewardToken,admin.address);
    console.log("MasterChef inited");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
})