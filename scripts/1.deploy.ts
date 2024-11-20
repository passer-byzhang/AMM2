import { ethers } from "hardhat";
import {config} from "./config"
async function main() {
    const chainId = await ethers.provider.getNetwork();
    const networkConfig = config[chainId.chainId.toString() as keyof typeof config];
    console.log("Deploying to: ", networkConfig.name + " network...");

    //deploy factory
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy();
    await factory.waitForDeployment();
    const factoryAddress = await factory.getAddress();
    console.log("Factory deployed to: ", factoryAddress);
    
    //deploy Router
    const Router = await ethers.getContractFactory("Router");
    const router = await Router.deploy(factoryAddress,networkConfig.addresses.weth);
    await router.waitForDeployment();
    const routerAddress = await router.getAddress();
    console.log("Router deployed to: ", routerAddress);

    //deploy MasterChef
    const MasterChef = await ethers.getContractFactory("MasterChef");
    const masterChef = await MasterChef.deploy();
    await masterChef.waitForDeployment();
    const masterChefAddress = await masterChef.getAddress();
    console.log("MasterChef deployed to: ", masterChefAddress);

    //deploy reward token
    const RewardToken = await ethers.getContractFactory("RewardToken");
    const rewardToken = await RewardToken.deploy();
    await rewardToken.waitForDeployment();
    const rewardTokenAddress = await rewardToken.getAddress();
    console.log("RewardToken deployed to: ", rewardTokenAddress);



}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});