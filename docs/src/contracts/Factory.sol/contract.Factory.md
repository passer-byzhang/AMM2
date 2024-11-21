# Factory
[Git Source](https://github.com/passer-byzhang/AMM2/blob/35665b73bd26a411359cdea57f5b80d779f9c16b/contracts/Factory.sol)

**Inherits:**
[IFactory](/contracts/interfaces/IFactory.sol/interface.IFactory.md)


## State Variables
### feeTo

```solidity
address public feeTo;
```


### feeToSetter

```solidity
address public feeToSetter;
```


### getPair

```solidity
mapping(address => mapping(address => address)) public getPair;
```


### allPairs

```solidity
address[] public allPairs;
```


## Functions
### constructor


```solidity
constructor(address _feeToSetter);
```

### allPairsLength


```solidity
function allPairsLength() external view returns (uint256);
```

### createPair


```solidity
function createPair(address tokenA, address tokenB) external returns (address pair);
```

### setFeeTo


```solidity
function setFeeTo(address _feeTo) external;
```

### setFeeToSetter


```solidity
function setFeeToSetter(address _feeToSetter) external;
```

