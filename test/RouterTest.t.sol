// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "../lib/forge-std/src/Test.sol";
import {Factory} from "../contracts/Factory.sol";
import {Pair} from "../contracts/Pair.sol";
import {Router} from "../contracts/Router.sol";

import {WETH} from "../contracts/mock/WETH.sol";
import {MockERC20} from "../contracts/mock/MockERC20.sol";
import "hardhat/console.sol";

contract RouterTest is Test {
    WETH public weth;
    Factory public factory;
    Router public router;
    MockERC20 public tokenA;
    MockERC20 public tokenB;
    address public pair1;
    address public pair2;

    function setUp() public {
        // Deploy the contract
        weth = new WETH();
        factory = new Factory(address(this));
        router = new Router(address(factory), address(weth));
         tokenA = new MockERC20("TokenA","A");
         tokenB = new MockERC20("TokenB","B");
        pair1 = factory.createPair(address(tokenA), address(weth));
        pair2 = factory.createPair(address(tokenA), address(tokenB));
    }

    function testAddLiquidity() public {
        uint256 amountADesired = 1000 ether;
        uint256 amountBDesired = 1000 ether;
        uint256 amountAMin = 900 ether;
        uint256 amountBMin = 900 ether;
        uint256 deadline = block.timestamp + 15;
        tokenA.mint(address(this), amountADesired);
        tokenB.mint(address(this), amountBDesired);
        tokenA.approve(address(router), amountADesired);
        tokenB.approve(address(router), amountBDesired);

        // Add liquidity
        (uint256 amountA, uint256 amountB, uint256 liquidity) = router.addLiquidity(
            address(tokenA),
            address(tokenB),
            amountADesired,
            amountBDesired,
            amountAMin,
            amountBMin,
            address(this),
            deadline
        );

        // Check results
        assert(amountA >= amountAMin);
        assert(amountB >= amountBMin);
        assert(liquidity > 0);

    }


}