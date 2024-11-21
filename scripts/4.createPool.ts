import { ethers } from "hardhat";
import {config} from "./config"

export async function createPool(token0:string,token1:string,fee:number) {
    const chainId = await ethers.provider.getNetwork();
    const networkConfig = config[chainId.chainId.toString() as keyof typeof config];
    console.log("Creating pool on:", networkConfig.name + " network...");

    const Factory = await ethers.getContractAt("Factory", networkConfig.addresses.factory);
    const poolAddress = await Factory.createPair(token0,token1);
    console.log("Pool created: "+poolAddress);
}

createPool("","",(0.3*10000)).catch((error) => {
    console.error(error);
    process.exitCode = 1;
}); //token0, token1, fee