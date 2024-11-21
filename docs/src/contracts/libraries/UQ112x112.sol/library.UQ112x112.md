# UQ112x112
[Git Source](https://github.com/passer-byzhang/AMM2/blob/35665b73bd26a411359cdea57f5b80d779f9c16b/contracts/libraries/UQ112x112.sol)


## State Variables
### Q112

```solidity
uint224 constant Q112 = 2 ** 112;
```


## Functions
### encode


```solidity
function encode(uint112 y) internal pure returns (uint224 z);
```

### uqdiv


```solidity
function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z);
```

