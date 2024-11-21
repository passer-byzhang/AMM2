# Pair
[Git Source](https://github.com/passer-byzhang/AMM2/blob/35665b73bd26a411359cdea57f5b80d779f9c16b/contracts/Pair.sol)

**Inherits:**
[LPToken](/contracts/LPToken.sol/abstract.LPToken.md)


## State Variables
### MINIMUM_LIQUIDITY

```solidity
uint256 public constant MINIMUM_LIQUIDITY = 10 ** 3;
```


### SELECTOR

```solidity
bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
```


### factory

```solidity
address public factory;
```


### token0

```solidity
address public token0;
```


### token1

```solidity
address public token1;
```


### reserve0

```solidity
uint112 private reserve0;
```


### reserve1

```solidity
uint112 private reserve1;
```


### blockTimestampLast

```solidity
uint32 private blockTimestampLast;
```


### price0CumulativeLast

```solidity
uint256 public price0CumulativeLast;
```


### price1CumulativeLast

```solidity
uint256 public price1CumulativeLast;
```


### kLast

```solidity
uint256 public kLast;
```


### unlocked

```solidity
uint256 private unlocked = 1;
```


## Functions
### lock


```solidity
modifier lock();
```

### getReserves


```solidity
function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
```

### _safeTransfer


```solidity
function _safeTransfer(address token, address to, uint256 value) private;
```

### constructor


```solidity
constructor() public;
```

### initialize


```solidity
function initialize(address _token0, address _token1) external;
```

### _update


```solidity
function _update(uint256 balance0, uint256 balance1, uint112 _reserve0, uint112 _reserve1) private;
```

### _mintFee


```solidity
function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn);
```

### mint


```solidity
function mint(address to) external lock returns (uint256 liquidity);
```

### burn


```solidity
function burn(address to) external lock returns (uint256 amount0, uint256 amount1);
```

### swap


```solidity
function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external lock;
```

### skim


```solidity
function skim(address to) external lock;
```

### sync


```solidity
function sync() external lock;
```

## Events
### Mint

```solidity
event Mint(address indexed sender, uint256 amount0, uint256 amount1);
```

### Burn

```solidity
event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
```

### Swap

```solidity
event Swap(
    address indexed sender,
    uint256 amount0In,
    uint256 amount1In,
    uint256 amount0Out,
    uint256 amount1Out,
    address indexed to
);
```

### Sync

```solidity
event Sync(uint112 reserve0, uint112 reserve1);
```

