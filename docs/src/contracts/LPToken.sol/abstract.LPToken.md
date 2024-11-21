# LPToken
[Git Source](https://github.com/passer-byzhang/AMM2/blob/35665b73bd26a411359cdea57f5b80d779f9c16b/contracts/LPToken.sol)


## State Variables
### name

```solidity
string public constant name = "Uniswap V2";
```


### symbol

```solidity
string public constant symbol = "UNI-V2";
```


### decimals

```solidity
uint8 public constant decimals = 18;
```


### totalSupply

```solidity
uint256 public totalSupply;
```


### balanceOf

```solidity
mapping(address => uint256) public balanceOf;
```


### allowance

```solidity
mapping(address => mapping(address => uint256)) public allowance;
```


### DOMAIN_SEPARATOR

```solidity
bytes32 public DOMAIN_SEPARATOR;
```


### PERMIT_TYPEHASH

```solidity
bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
```


### nonces

```solidity
mapping(address => uint256) public nonces;
```


## Functions
### constructor


```solidity
constructor();
```

### _mint


```solidity
function _mint(address to, uint256 value) internal;
```

### _burn


```solidity
function _burn(address from, uint256 value) internal;
```

### _approve


```solidity
function _approve(address owner, address spender, uint256 value) private;
```

### _transfer


```solidity
function _transfer(address from, address to, uint256 value) private;
```

### approve


```solidity
function approve(address spender, uint256 value) external returns (bool);
```

### transfer


```solidity
function transfer(address to, uint256 value) external returns (bool);
```

### transferFrom


```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool);
```

### permit


```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
    external;
```

## Events
### Approval

```solidity
event Approval(address indexed owner, address indexed spender, uint256 value);
```

### Transfer

```solidity
event Transfer(address indexed from, address indexed to, uint256 value);
```

