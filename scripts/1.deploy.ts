import { ethers } from "hardhat";
import {config} from "./config"

async function main() {
    const chainId = await ethers.provider.getNetwork();
    const networkConfig = config[chainId.chainId.toString() as keyof typeof config];
    console.log("Deploying to: ", networkConfig.name + " network...");
    const [admin] = await ethers.getSigners();

    //deploy factory
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy(admin.address);
    await factory.waitForDeployment();
    const factoryAddress = await factory.getAddress();
    console.log("Factory deployed to: ", factoryAddress);
    
    //deploy Router
    const Router = await ethers.getContractFactory("Router");
    const router = await Router.deploy(factoryAddress,networkConfig.addresses.weth);
    await router.waitForDeployment();
    const routerAddress = await router.getAddress();
    console.log("Router deployed to: ", routerAddress);



    //deploy reward token
    const RewardToken = await ethers.getContractFactory("RewardToken");
    const rewardToken = await RewardToken.deploy();
    await rewardToken.waitForDeployment();
    console.log("RewardToken deployed to: ", rewardToken.target);

    //deploy MasterChef
    const MasterChefImpl = await ethers.getContractFactory("MasterChef");
    const masterChefImpl = await MasterChefImpl.deploy();
    await masterChefImpl.waitForDeployment();
    const initData = masterChefImpl.interface.encodeFunctionData("initilize", [
        rewardToken.target,
        admin.address,
      ]);
    const MasterChef = await ethers.deployContract("ERC1967Proxy", [masterChefImpl.target, initData]);
    await MasterChef.waitForDeployment();
    console.log("MasterChef deployed to: ", MasterChef.target);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});