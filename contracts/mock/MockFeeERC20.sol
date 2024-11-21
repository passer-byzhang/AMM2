// FeeToken.sol
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FeeToken is ERC20 {
    uint256 public feePercentage;

    constructor(string memory name, string memory symbol, uint256 _feePercentage) ERC20(name, symbol) {
        feePercentage = _feePercentage;
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function transfer(address sender, address recipient, uint256 amount) public {
        uint256 fee = (amount * feePercentage) / 100;
        uint256 amountAfterFee = amount - fee;
        super._transfer(sender, recipient, amountAfterFee);
        if (fee > 0) {
            super._transfer(sender, address(this), fee);
        }
    }
}