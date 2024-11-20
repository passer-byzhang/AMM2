import { ethers } from "hardhat";
async function getCreationCode(){
    const UniswapV2Pair = await ethers.getContractFactory("Pair");
    const creationCode = UniswapV2Pair.bytecode;
    //console.log(JSON.stringify(creationCode));
    const initcode = ethers.keccak256(creationCode);
    console.log(initcode);
}

getCreationCode();