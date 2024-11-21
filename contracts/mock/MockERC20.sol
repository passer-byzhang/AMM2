pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MockERC20 is ERC20Permit {
    constructor(string memory name,string memory symbol) ERC20Permit(name) ERC20(name, symbol) {
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}