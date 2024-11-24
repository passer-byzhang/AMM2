// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "../lib/forge-std/src/Test.sol";
import {MockERC20} from "../contracts/mock/MockERC20.sol";
import {RewardToken} from "../contracts/mock/RewardToken.sol";
import {MasterChefWithExternalStorage} from "../contracts/MasterChefWithExternalStorage.sol";
import {MasterChefStorage} from '../contracts/MasterChefStorage.sol';
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../contracts/interfaces/IERC20.sol";
import "hardhat/console.sol";

contract MasterChefWithExternalStorageTest is Test {
    RewardToken public rewardToken;
    MockERC20 public lpToken1;
    MockERC20 public lpToken2;
    MockERC20 public lpToken3;
    MasterChefWithExternalStorage public masterChef;
    MasterChefStorage public masterChefStorage;

    address public alice;
    address public bob;
    address public carol;

    function setUp() public {
        // Deploy the contract
        lpToken1 = new MockERC20("LPToken1", "LP1");
        lpToken2 = new MockERC20("LPToken2", "LP2");
        lpToken3 = new MockERC20("LPToken3", "LP3");
        rewardToken = new RewardToken();
        masterChef = new MasterChefWithExternalStorage();
        masterChefStorage = new MasterChefStorage();
        // Deploy the MasterChef implementation
        MasterChefWithExternalStorage masterChefImplementation = new MasterChefWithExternalStorage();
        // Deploy the proxy and initialize the MasterChef contract
        ERC1967Proxy proxy = new ERC1967Proxy(
            address(masterChefImplementation),
            abi.encodeWithSelector(MasterChefWithExternalStorage.initilize.selector, address(masterChefStorage))
        );
        // Cast the proxy to the MasterChef type
        masterChef = MasterChefWithExternalStorage(address(proxy));
        alice = address(1);
        bob = address(2);
        carol = address(3);

        rewardToken.mint(address(masterChef), 1e70);
        masterChefStorage.transferOwnership(address(masterChef));
        masterChef.setRewardToken(address(rewardToken));
    }

    function testAddPool() public {
        masterChef.add(200, IERC20(address(lpToken1)));
        masterChef.add(200, IERC20(address(lpToken2)));
        masterChef.add(100, IERC20(address(lpToken3)));
        assertEq(masterChefStorage.getPoolInfoLength(), 3);
    }

    function testSetPool()public {
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(OwnableUpgradeable.OwnableUnauthorizedAccount.selector,alice));
        masterChef.add(200, IERC20(address(lpToken1)));
        masterChef.add(200, IERC20(address(lpToken1)));
        masterChef.add(200, IERC20(address(lpToken2)));
        masterChef.add(100, IERC20(address(lpToken3)));
        masterChef.set(0,100);
        masterChef.set(1,100);
        masterChef.set(2,50);
        MasterChefStorage.PoolInfo memory poolInfo = masterChefStorage.getPoolInfoElement(0);
        assertEq(poolInfo.allocPoint, 100);
        poolInfo = masterChefStorage.getPoolInfoElement(1);
        assertEq(poolInfo.allocPoint, 100);
        poolInfo = masterChefStorage.getPoolInfoElement(2);
        assertEq(poolInfo.allocPoint, 50);
    }

    function testDeposit() public {
        masterChef.add(200, IERC20(address(lpToken1)));
        masterChef.add(200, IERC20(address(lpToken2)));
        masterChef.add(100, IERC20(address(lpToken3)));
        lpToken1.mint(address(this), 1000 ether);
        lpToken1.approve(address(masterChef), 1000 ether);
        masterChef.deposit(0, 1000 ether, address(this));
        assertEq(lpToken1.balanceOf(address(masterChef)), 1000 ether);
        MasterChefStorage.UserInfo memory userInfo =  masterChefStorage.getUserInfoElement(0, address(this));
        assertEq(userInfo.amount, 1000 ether);
        lpToken2.mint(address(this), 1000 ether);
        lpToken2.approve(address(masterChef), 1000 ether);
        masterChef.deposit(1, 1000 ether, address(this));
        assertEq(lpToken2.balanceOf(address(masterChef)), 1000 ether);
        userInfo =  masterChefStorage.getUserInfoElement(1, address(this));
        assertEq(userInfo.amount, 1000 ether);
    }

    function testHarvest() public {
        masterChef.add(200, IERC20(address(lpToken1)));
        masterChef.add(100, IERC20(address(lpToken2)));
        masterChef.add(100, IERC20(address(lpToken3)));
        MasterChefStorage.PoolInfo memory poolInfo = masterChefStorage.getPoolInfoElement(0);
        poolInfo = masterChefStorage.getPoolInfoElement(1);
        poolInfo = masterChefStorage.getPoolInfoElement(2);

        vm.startBroadcast(alice);
        lpToken1.mint(alice, 1000 ether);
        lpToken1.approve(address(masterChef), 1000 ether);
        masterChef.deposit(0, 1000 ether, alice);
        lpToken2.mint(alice, 1000 ether);
        lpToken2.approve(address(masterChef), 1000 ether);
        masterChef.deposit(1, 1000 ether, alice);
        vm.stopBroadcast();
        vm.startBroadcast(bob);
        lpToken2.mint(bob, 1000 ether);
        lpToken2.approve(address(masterChef), 1000 ether);
        masterChef.deposit(1, 1000 ether, bob);
        vm.stopBroadcast();

        uint256 blockNumber = block.number;
        vm.roll(blockNumber + 10);
        assertEq(1e21/2, masterChef.pendingSushi(0, alice));
        assertEq(1e21/4/2, masterChef.pendingSushi(1, bob));
        assertEq(1e21/4/2, masterChef.pendingSushi(1, alice));

        vm.startBroadcast(alice);
        masterChef.harvest(0, alice);
        assertEq(rewardToken.balanceOf(alice), 1e21/2);
        masterChef.harvest(1, alice);
        assertEq(rewardToken.balanceOf(alice), 1e21/2 + 1e21/4/2);
        vm.stopBroadcast();
        vm.startBroadcast(bob);
        masterChef.harvest(1, bob);
        assertEq(rewardToken.balanceOf(bob), 1e21/4/2);
        vm.stopBroadcast();
    }

    function testWithdraw() public {
        masterChef.add(200, IERC20(address(lpToken1)));
        masterChef.add(200, IERC20(address(lpToken2)));
        masterChef.add(100, IERC20(address(lpToken3)));
        lpToken1.mint(address(this), 1000 ether);
        lpToken1.approve(address(masterChef), 1000 ether);
        assertEq(lpToken1.balanceOf(address(this)), 1000 ether);
        masterChef.deposit(0, 1000 ether, address(this));
        MasterChefStorage.UserInfo memory userInfo =  masterChefStorage.getUserInfoElement(0, address(this));
        assertEq(userInfo.amount, 1000 ether);
        assertEq(lpToken1.balanceOf(address(this)),0 );
        masterChef.withdraw(0, 1000 ether, address(this));
        assertEq(lpToken1.balanceOf(address(this)), 1000 ether);
        userInfo =  masterChefStorage.getUserInfoElement(0, address(this));
        assertEq(userInfo.amount, 0);
    }

    function testWithdrawAndHarvest() public {
        masterChef.add(200, IERC20(address(lpToken1)));
        masterChef.add(200, IERC20(address(lpToken2)));
        masterChef.add(100, IERC20(address(lpToken3)));
        lpToken1.mint(address(this), 1000 ether);
        lpToken1.approve(address(masterChef), 1000 ether);
        assertEq(lpToken1.balanceOf(address(this)), 1000 ether);
        masterChef.deposit(0, 1000 ether, address(this));
        MasterChefStorage.UserInfo memory userInfo =  masterChefStorage.getUserInfoElement(0, address(this));
        assertEq(userInfo.amount, 1000 ether);
        assertEq(lpToken1.balanceOf(address(this)),0 );
        uint256 blockNumber = block.number;
        vm.roll(blockNumber + 10);
        assertEq(4e20, masterChef.pendingSushi(0, address(this)));
        masterChef.withdraw(0, 1000 ether, address(this));
        assertEq(lpToken1.balanceOf(address(this)), 1000 ether);
        userInfo =  masterChefStorage.getUserInfoElement(0, address(this));
        assertEq(userInfo.amount, 0);
    }



}