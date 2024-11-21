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

contract RouterLiqudityTest is Test {
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
        (uint256 amountA, uint256 amountB, uint256 liquidity) = router
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
        // Check results
        assert(amountA >= amountAMin);
        assert(amountB >= amountBMin);
        assert(liquidity > 0);
    }

    function testAddLiquidityInsufficient() public {
        uint256 amountADesired = 1000;
        uint256 amountBDesired = 1000;
        uint256 amountAMin = 900;
        uint256 amountBMin = 900;
        uint256 deadline = block.timestamp + 15;
        tokenA.mint(address(this), amountADesired);
        tokenB.mint(address(this), amountBDesired);
        tokenA.approve(address(router), amountADesired);
        tokenB.approve(address(router), amountBDesired);
        vm.expectRevert(bytes("UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED"));
        // Add liquidity
        router.addLiquidity(
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

    function testAddLiquidityETH() public {
        uint256 amountADesired = 1000 ether;
        uint256 amountETHDesired = 1000 ether;
        uint256 amountAMin = 900 ether;
        uint256 amountETHMin = 900 ether;
        uint256 deadline = block.timestamp + 15;
        tokenA.mint(address(this), amountADesired);
        tokenA.approve(address(router), amountADesired);
        vm.deal(address(this), amountETHDesired);
        // Add liquidity
        (uint256 amountA, uint256 amountETH, uint256 liquidity) = router
            .addLiquidityETH{value: 1000 ether}(
            address(tokenA),
            amountADesired,
            amountAMin,
            amountETHMin,
            address(this),
            deadline
        );
        // Check results
        assert(amountA >= amountAMin);
        assert(amountETH >= amountETHMin);
        assert(liquidity > 0);
    }

    function testRemoveLiquidity() public {
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
        (uint256 amountA, uint256 amountB, uint256 liquidity) = router
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
        IERC20(pair2).approve(address(router), liquidity);
        // Remove liquidity
        (uint256 amountAOut, uint256 amountBOut) = router
            .removeLiquidity(
                address(tokenA),
                address(tokenB),
                liquidity,
                amountAMin,
                amountBMin,
                address(this),
                deadline
            );
        // Check results
        assert(amountAOut >= amountAMin);
        assert(amountBOut >= amountBMin);
    }

    function testRemoveLiquidityPermit() public {
        vm.startBroadcast(alice);
        uint256 amountADesired = 1000 ether;
        uint256 amountBDesired = 1000 ether;
        uint256 amountAMin = 900 ether;
        uint256 amountBMin = 900 ether;
        uint256 deadline = block.timestamp + 15;
        tokenA.mint(alice, amountADesired);
        tokenB.mint(alice, amountBDesired);
        tokenA.approve(address(router), amountADesired);
        tokenB.approve(address(router), amountBDesired);

        // Add liquidity
        (uint256 amountA, uint256 amountB, uint256 liquidity) = router
            .addLiquidity(
                address(tokenA),
                address(tokenB),
                amountADesired,
                amountBDesired,
                amountAMin,
                amountBMin,
                alice,
                deadline
            );
        // Generate permit signature
        (uint8 v, bytes32 r, bytes32 s) = _signPermit(
            pair2,
            alice,
            address(router),
            liquidity,
            deadline
        );

        // Remove liquidity with permit
        router.removeLiquidityWithPermit(
            address(tokenA),
            address(tokenB),
            liquidity,
            amountAMin,
            amountBMin,
            alice,
            deadline,
            false, // approveMax
            v,
            r,
            s
        );

        // Check results
        uint256 balanceA = tokenA.balanceOf(alice);
        uint256 balanceB = tokenB.balanceOf(alice);
        assert(balanceA >= amountAMin);
        assert(balanceB >= amountBMin);
        vm.stopBroadcast(); 

    }


  function _signPermit(
        address token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline
    ) internal view returns (uint8 v, bytes32 r, bytes32 s) {
        bytes32 structHash = keccak256(
            abi.encode(
                keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                owner,
                spender,
                value,
                IERC20Permit(token).nonces(owner),
                deadline
            )
        );

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                IERC20Permit(token).DOMAIN_SEPARATOR(),
                structHash
            )
        );
        uint256 key = users[owner];
        (v, r, s) = vm.sign(key, digest);
    }

}
