# MockERC20
[Git Source](https://github.com/passer-byzhang/AMM2/blob/35665b73bd26a411359cdea57f5b80d779f9c16b/contracts/mock/MockERC20.sol)

**Inherits:**
ERC20Permit


## Functions
### constructor


```solidity
constructor(string memory name, string memory symbol) ERC20Permit(name) ERC20(name, symbol);
```

### mint


```solidity
function mint(address to, uint256 amount) public;
```

