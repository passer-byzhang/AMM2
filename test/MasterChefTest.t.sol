// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "../lib/forge-std/src/Test.sol";
import {MockERC20} from "../contracts/mock/MockERC20.sol";
import {RewardToken} from "../contracts/mock/RewardToken.sol";
import {MasterChef} from "../contracts/MasterChef.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../contracts/interfaces/IERC20.sol";
import "hardhat/console.sol";

contract MasterChefTest is Test {
    RewardToken public rewardToken;
    MockERC20 public lpToken1;
    MockERC20 public lpToken2;
    MockERC20 public lpToken3;
    MasterChef public masterChef;

    function setUp() public {
        // Deploy the contract
        lpToken1 = new MockERC20("LPToken1", "LP1");
        lpToken2 = new MockERC20("LPToken2", "LP2");
        lpToken3 = new MockERC20("LPToken3", "LP3");
        rewardToken = new RewardToken();
        masterChef = new MasterChef();

        // Deploy the MasterChef implementation
        MasterChef masterChefImplementation = new MasterChef();

        // Deploy the proxy and initialize the MasterChef contract
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(masterChefImplementation),
            abi.encodeWithSelector(MasterChef.initilize.selector, rewardToken, address(this))
        );

        // Cast the proxy to the MasterChef type
        masterChef = MasterChef(address(proxy));
    }

    function testAddPool() public {
        masterChef.add(200, IERC20(address(lpToken1)));
        masterChef.add(200, IERC20(address(lpToken2)));
        masterChef.add(100, IERC20(address(lpToken3)));
        assertEq(masterChef.poolLength(), 3);
    }
}