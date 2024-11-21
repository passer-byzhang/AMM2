// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "../lib/forge-std/src/Test.sol";
import {Factory} from "../contracts/Factory.sol";
import {Pair} from "../contracts/Pair.sol";
import {UniswapV2Library} from "../contracts/libraries/UniswapV2Library.sol";
import "hardhat/console.sol";
contract FactoryTest is Test {
    Factory public factory;

    function setUp() public {
        // Deploy the contract
        factory = new Factory(address(this));
    }

    function testCreatePair() public {
        // Create a pair
        factory.createPair(address(1), address(2));
        // Check the pair
        assertEq(factory.allPairsLength(), 1);

        vm.expectRevert(bytes("IDENTICAL_ADDRESSES"));
        factory.createPair(address(0), address(0));

        vm.expectRevert(bytes("ZERO_ADDRESS"));
        factory.createPair(address(0), address(1));

        vm.expectRevert(bytes("PAIR_EXISTS"));
        factory.createPair(address(1), address(2));

    }

    function testInitcode() public {
        address addr = factory.createPair(address(1), address(2));
        bytes memory bytecode = type(Pair).creationCode;
        bytes32 salt = keccak256(bytecode);
        console.logBytes32(salt);
        address addr_ = UniswapV2Library.pairFor(address(factory), address(1), address(2));
        assertEq(addr, addr_);
    }


    function testSetFeeTo() public {
        factory.setFeeTo(address(1));
        assertEq(factory.feeTo(), address(1));
    }

}