# FeeToken
[Git Source](https://github.com/passer-byzhang/AMM2/blob/35665b73bd26a411359cdea57f5b80d779f9c16b/contracts/mock/MockFeeERC20.sol)

**Inherits:**
ERC20


## State Variables
### feePercentage

```solidity
uint256 public feePercentage;
```


## Functions
### constructor


```solidity
constructor(string memory name, string memory symbol, uint256 _feePercentage) ERC20(name, symbol);
```

### transfer


```solidity
function transfer(address sender, address recipient, uint256 amount) public;
```

### mint


```solidity
function mint(address to, uint256 amount) public;
```

