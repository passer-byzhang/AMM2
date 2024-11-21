# SignedSafeMath
[Git Source](https://github.com/passer-byzhang/AMM2/blob/35665b73bd26a411359cdea57f5b80d779f9c16b/contracts/libraries/SignedSafeMath.sol)


## State Variables
### _INT256_MIN

```solidity
int256 private constant _INT256_MIN = -2 ** 255;
```


## Functions
### mul

*Returns the multiplication of two signed integers, reverting on
overflow.
Counterpart to Solidity's `*` operator.
Requirements:
- Multiplication cannot overflow.*


```solidity
function mul(int256 a, int256 b) internal pure returns (int256);
```

### div

*Returns the integer division of two signed integers. Reverts on
division by zero. The result is rounded towards zero.
Counterpart to Solidity's `/` operator. Note: this function uses a
`revert` opcode (which leaves remaining gas untouched) while Solidity
uses an invalid opcode to revert (consuming all remaining gas).
Requirements:
- The divisor cannot be zero.*


```solidity
function div(int256 a, int256 b) internal pure returns (int256);
```

### sub

*Returns the subtraction of two signed integers, reverting on
overflow.
Counterpart to Solidity's `-` operator.
Requirements:
- Subtraction cannot overflow.*


```solidity
function sub(int256 a, int256 b) internal pure returns (int256);
```

### add

*Returns the addition of two signed integers, reverting on
overflow.
Counterpart to Solidity's `+` operator.
Requirements:
- Addition cannot overflow.*


```solidity
function add(int256 a, int256 b) internal pure returns (int256);
```

### toUInt256


```solidity
function toUInt256(int256 a) internal pure returns (uint256);
```

