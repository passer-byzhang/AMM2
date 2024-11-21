// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "../lib/forge-std/src/Test.sol";
import {Factory} from "../contracts/Factory.sol";
import {Pair} from "../contracts/Pair.sol";
import {Router} from "../contracts/Router.sol";
import {IERC20} from "../contracts/interfaces/IERC20.sol";
import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {WETH} from "../contracts/mock/WETH.sol";
import {MockERC20} from "../contracts/mock/MockERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "hardhat/console.sol";

contract RouterSwapTest is Test {
        WETH public weth;
    Factory public factory;
    Router public router;
    MockERC20 public tokenA;
    MockERC20 public tokenB;
    address public pair1;
    address public pair2;
    mapping(address => uint256) public users;
    address public alice;

    function setUp() public {
        // Deploy the contract
        weth = new WETH();
        factory = new Factory(address(this));
        router = new Router(address(factory), address(weth));
        tokenA = new MockERC20("TokenA", "A");
        tokenB = new MockERC20("TokenB", "B");
        pair1 = factory.createPair(address(tokenA), address(weth));
        pair2 = factory.createPair(address(tokenA), address(tokenB));
        (address user,uint256 key) = makeAddrAndKey("alice");
        alice = user;
        users[alice] = key;
    }


    function testSwapExactTokensForTokens() public {
        addLiquidity();
        uint256 amountIn = 100 ether;
        uint256 amountOutMin = 0;
        uint256 deadline = block.timestamp + 15;
        tokenA.mint(alice, amountIn);
        vm.startBroadcast(alice);
        tokenA.approve(address(router), amountIn);
        address[] memory path = new address[](2);
        path[0] = address(tokenA);
        path[1] = address(tokenB);
        router.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            alice,
            deadline
        );
        vm.stopBroadcast();
        assert(tokenB.balanceOf(alice) > 0);
        assert(tokenA.balanceOf(alice) == 0);

    }

    function addLiquidity() public {
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
         router
            .addLiquidity(
                address(tokenA),
                address(tokenB),
                amountADesired,
                amountBDesired,
                amountAMin,
                amountBMin,
                address(this),
                deadline
            );
    }


}