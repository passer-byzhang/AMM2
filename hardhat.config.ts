import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";
import 'solidity-docgen';

const config: HardhatUserConfig = {
  docgen: {},
  solidity: "0.8.26",
};

export default config;
