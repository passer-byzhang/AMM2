# Solidity API

## Router

### factory

```solidity
address factory
```

### WETH

```solidity
address WETH
```

### ensure

```solidity
modifier ensure(uint256 deadline)
```

### constructor

```solidity
constructor(address _factory, address _WETH) public
```

### receive

```solidity
receive() external payable
```

### _addLiquidity

```solidity
function _addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin) internal virtual returns (uint256 amountA, uint256 amountB)
```

### addLiquidity

```solidity
function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external virtual returns (uint256 amountA, uint256 amountB, uint256 liquidity)
```

### addLiquidityETH

```solidity
function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable virtual returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)
```

### removeLiquidity

```solidity
function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) public virtual returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETH

```solidity
function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) public virtual returns (uint256 amountToken, uint256 amountETH)
```

### removeLiquidityWithPermit

```solidity
function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external virtual returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETHWithPermit

```solidity
function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external virtual returns (uint256 amountToken, uint256 amountETH)
```

### removeLiquidityETHSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) public virtual returns (uint256 amountETH)
```

### removeLiquidityETHWithPermitSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external virtual returns (uint256 amountETH)
```

### _swap

```solidity
function _swap(uint256[] amounts, address[] path, address _to) internal virtual
```

### swapExactTokensForTokens

```solidity
function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external virtual returns (uint256[] amounts)
```

### swapTokensForExactTokens

```solidity
function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) external virtual returns (uint256[] amounts)
```

### swapExactETHForTokens

```solidity
function swapExactETHForTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) external payable virtual returns (uint256[] amounts)
```

### swapTokensForExactETH

```solidity
function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) external virtual returns (uint256[] amounts)
```

### swapExactTokensForETH

```solidity
function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external virtual returns (uint256[] amounts)
```

### swapETHForExactTokens

```solidity
function swapETHForExactTokens(uint256 amountOut, address[] path, address to, uint256 deadline) external payable virtual returns (uint256[] amounts)
```

### _swapSupportingFeeOnTransferTokens

```solidity
function _swapSupportingFeeOnTransferTokens(address[] path, address _to) internal virtual
```

### swapExactTokensForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external virtual
```

### swapExactETHForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) external payable virtual
```

### swapExactTokensForETHSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external virtual
```

### quote

```solidity
function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) public pure virtual returns (uint256 amountB)
```

### getAmountOut

```solidity
function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure virtual returns (uint256 amountOut)
```

### getAmountIn

```solidity
function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) public pure virtual returns (uint256 amountIn)
```

### getAmountsOut

```solidity
function getAmountsOut(uint256 amountIn, address[] path) public view virtual returns (uint256[] amounts)
```

### getAmountsIn

```solidity
function getAmountsIn(uint256 amountOut, address[] path) public view virtual returns (uint256[] amounts)
```

## IERC20

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### name

```solidity
function name() external view returns (string)
```

### symbol

```solidity
function symbol() external view returns (string)
```

### decimals

```solidity
function decimals() external view returns (uint8)
```

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### approve

```solidity
function approve(address spender, uint256 value) external returns (bool)
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool)
```

## IFactory

### PairCreated

```solidity
event PairCreated(address token0, address token1, address pair, uint256)
```

### feeTo

```solidity
function feeTo() external view returns (address)
```

### feeToSetter

```solidity
function feeToSetter() external view returns (address)
```

### getPair

```solidity
function getPair(address tokenA, address tokenB) external view returns (address pair)
```

### allPairs

```solidity
function allPairs(uint256) external view returns (address pair)
```

### allPairsLength

```solidity
function allPairsLength() external view returns (uint256)
```

### createPair

```solidity
function createPair(address tokenA, address tokenB) external returns (address pair)
```

### setFeeTo

```solidity
function setFeeTo(address) external
```

### setFeeToSetter

```solidity
function setFeeToSetter(address) external
```

## IPair

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### name

```solidity
function name() external pure returns (string)
```

### symbol

```solidity
function symbol() external pure returns (string)
```

### decimals

```solidity
function decimals() external pure returns (uint8)
```

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### approve

```solidity
function approve(address spender, uint256 value) external returns (bool)
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool)
```

### DOMAIN_SEPARATOR

```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32)
```

### PERMIT_TYPEHASH

```solidity
function PERMIT_TYPEHASH() external pure returns (bytes32)
```

### nonces

```solidity
function nonces(address owner) external view returns (uint256)
```

### permit

```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external
```

### Mint

```solidity
event Mint(address sender, uint256 amount0, uint256 amount1)
```

### Burn

```solidity
event Burn(address sender, uint256 amount0, uint256 amount1, address to)
```

### Swap

```solidity
event Swap(address sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address to)
```

### Sync

```solidity
event Sync(uint112 reserve0, uint112 reserve1)
```

### MINIMUM_LIQUIDITY

```solidity
function MINIMUM_LIQUIDITY() external pure returns (uint256)
```

### factory

```solidity
function factory() external view returns (address)
```

### token0

```solidity
function token0() external view returns (address)
```

### token1

```solidity
function token1() external view returns (address)
```

### getReserves

```solidity
function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)
```

### price0CumulativeLast

```solidity
function price0CumulativeLast() external view returns (uint256)
```

### price1CumulativeLast

```solidity
function price1CumulativeLast() external view returns (uint256)
```

### kLast

```solidity
function kLast() external view returns (uint256)
```

### mint

```solidity
function mint(address to) external returns (uint256 liquidity)
```

### burn

```solidity
function burn(address to) external returns (uint256 amount0, uint256 amount1)
```

### swap

```solidity
function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes data) external
```

### skim

```solidity
function skim(address to) external
```

### sync

```solidity
function sync() external
```

### initialize

```solidity
function initialize(address, address) external
```

## IUniswapV2Router01

### factory

```solidity
function factory() external view returns (address)
```

### WETH

```solidity
function WETH() external view returns (address)
```

### addLiquidity

```solidity
function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity)
```

### addLiquidityETH

```solidity
function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)
```

### removeLiquidity

```solidity
function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETH

```solidity
function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH)
```

### removeLiquidityWithPermit

```solidity
function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETHWithPermit

```solidity
function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH)
```

### swapExactTokensForTokens

```solidity
function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapTokensForExactTokens

```solidity
function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapExactETHForTokens

```solidity
function swapExactETHForTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) external payable returns (uint256[] amounts)
```

### swapTokensForExactETH

```solidity
function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapExactTokensForETH

```solidity
function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapETHForExactTokens

```solidity
function swapETHForExactTokens(uint256 amountOut, address[] path, address to, uint256 deadline) external payable returns (uint256[] amounts)
```

### quote

```solidity
function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB)
```

### getAmountOut

```solidity
function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut)
```

### getAmountIn

```solidity
function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn)
```

### getAmountsOut

```solidity
function getAmountsOut(uint256 amountIn, address[] path) external view returns (uint256[] amounts)
```

### getAmountsIn

```solidity
function getAmountsIn(uint256 amountOut, address[] path) external view returns (uint256[] amounts)
```

## IUniswapV2Router02

### removeLiquidityETHSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH)
```

### removeLiquidityETHWithPermitSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH)
```

### swapExactTokensForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external
```

### swapExactETHForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) external payable
```

### swapExactTokensForETHSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external
```

## IWETH

### deposit

```solidity
function deposit() external payable
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### withdraw

```solidity
function withdraw(uint256) external
```

## SafeMath

### add

```solidity
function add(uint256 x, uint256 y) internal pure returns (uint256 z)
```

### sub

```solidity
function sub(uint256 x, uint256 y) internal pure returns (uint256 z)
```

### mul

```solidity
function mul(uint256 x, uint256 y) internal pure returns (uint256 z)
```

## TransferHelper

### safeApprove

```solidity
function safeApprove(address token, address to, uint256 value) internal
```

### safeTransfer

```solidity
function safeTransfer(address token, address to, uint256 value) internal
```

### safeTransferFrom

```solidity
function safeTransferFrom(address token, address from, address to, uint256 value) internal
```

### safeTransferETH

```solidity
function safeTransferETH(address to, uint256 value) internal
```

## UniswapV2Library

### sortTokens

```solidity
function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1)
```

### pairFor

```solidity
function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair)
```

### getReserves

```solidity
function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint256 reserveA, uint256 reserveB)
```

### quote

```solidity
function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) internal pure returns (uint256 amountB)
```

### getAmountOut

```solidity
function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) internal pure returns (uint256 amountOut)
```

### getAmountIn

```solidity
function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) internal pure returns (uint256 amountIn)
```

### getAmountsOut

```solidity
function getAmountsOut(address factory, uint256 amountIn, address[] path) internal view returns (uint256[] amounts)
```

### getAmountsIn

```solidity
function getAmountsIn(address factory, uint256 amountOut, address[] path) internal view returns (uint256[] amounts)
```

## MockERC20

### constructor

```solidity
constructor(string name, string symbol) public
```

### mint

```solidity
function mint(address to, uint256 amount) public
```

## FeeToken

### feePercentage

```solidity
uint256 feePercentage
```

### constructor

```solidity
constructor(string name, string symbol, uint256 _feePercentage) public
```

### transfer

```solidity
function transfer(address sender, address recipient, uint256 amount) public
```

### mint

```solidity
function mint(address to, uint256 amount) public
```

## WETH

### name

```solidity
string name
```

### symbol

```solidity
string symbol
```

### decimals

```solidity
uint8 decimals
```

### Approval

```solidity
event Approval(address src, address guy, uint256 wad)
```

### Transfer

```solidity
event Transfer(address src, address dst, uint256 wad)
```

### Deposit

```solidity
event Deposit(address dst, uint256 wad)
```

### Withdrawal

```solidity
event Withdrawal(address src, uint256 wad)
```

### balanceOf

```solidity
mapping(address => uint256) balanceOf
```

### allowance

```solidity
mapping(address => mapping(address => uint256)) allowance
```

### receive

```solidity
receive() external payable
```

### deposit

```solidity
function deposit() public payable
```

### withdraw

```solidity
function withdraw(uint256 wad) public
```

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

### approve

```solidity
function approve(address guy, uint256 wad) public returns (bool)
```

### transfer

```solidity
function transfer(address dst, uint256 wad) public returns (bool)
```

### transferFrom

```solidity
function transferFrom(address src, address dst, uint256 wad) public returns (bool)
```

## Factory

### feeTo

```solidity
address feeTo
```

### feeToSetter

```solidity
address feeToSetter
```

### getPair

```solidity
mapping(address => mapping(address => address)) getPair
```

### allPairs

```solidity
address[] allPairs
```

### constructor

```solidity
constructor(address _feeToSetter) public
```

### allPairsLength

```solidity
function allPairsLength() external view returns (uint256)
```

### createPair

```solidity
function createPair(address tokenA, address tokenB) external returns (address pair)
```

### setFeeTo

```solidity
function setFeeTo(address _feeTo) external
```

### setFeeToSetter

```solidity
function setFeeToSetter(address _feeToSetter) external
```

## LPToken

### name

```solidity
string name
```

### symbol

```solidity
string symbol
```

### decimals

```solidity
uint8 decimals
```

### totalSupply

```solidity
uint256 totalSupply
```

### balanceOf

```solidity
mapping(address => uint256) balanceOf
```

### allowance

```solidity
mapping(address => mapping(address => uint256)) allowance
```

### DOMAIN_SEPARATOR

```solidity
bytes32 DOMAIN_SEPARATOR
```

### PERMIT_TYPEHASH

```solidity
bytes32 PERMIT_TYPEHASH
```

### nonces

```solidity
mapping(address => uint256) nonces
```

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### constructor

```solidity
constructor() internal
```

### _mint

```solidity
function _mint(address to, uint256 value) internal
```

### _burn

```solidity
function _burn(address from, uint256 value) internal
```

### approve

```solidity
function approve(address spender, uint256 value) external returns (bool)
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool)
```

### permit

```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external
```

## MasterChef

The (older) MasterChef contract gives out a constant number of SUSHI tokens per block.
It is the only address with minting rights for SUSHI.
The idea for this MasterChef V2 (MCV2) contract is therefore to be the owner of a dummy token
that is deposited into the MasterChef V1 (MCV1) contract.
The allocation point for this pool on MCV1 is the total allocation point for all pools that receive double incentives.

### UserInfo

Info of each MCV2 user.
`amount` LP token amount the user has provided.
`rewardDebt` The amount of SUSHI entitled to the user.

```solidity
struct UserInfo {
  uint256 amount;
  int256 rewardDebt;
}
```

### PoolInfo

Info of each MCV2 pool.
`allocPoint` The amount of allocation points assigned to the pool.
Also known as the amount of SUSHI to distribute per block.

```solidity
struct PoolInfo {
  uint128 accSushiPerShare;
  uint64 lastRewardBlock;
  uint64 allocPoint;
}
```

### SUSHI

```solidity
contract IERC20 SUSHI
```

Address of SUSHI contract.

### poolInfo

```solidity
struct MasterChef.PoolInfo[] poolInfo
```

Info of each MCV2 pool.

### lpToken

```solidity
contract IERC20[] lpToken
```

Address of the LP token for each MCV2 pool.

### userInfo

```solidity
mapping(uint256 => mapping(address => struct MasterChef.UserInfo)) userInfo
```

Info of each user that stakes LP tokens.

### totalAllocPoint

```solidity
uint256 totalAllocPoint
```

_Total allocation points. Must be the sum of all allocation points in all pools._

### AdminRole

```solidity
bytes32 AdminRole
```

### UpdateRole

```solidity
bytes32 UpdateRole
```

### Deposit

```solidity
event Deposit(address user, uint256 pid, uint256 amount, address to)
```

### Withdraw

```solidity
event Withdraw(address user, uint256 pid, uint256 amount, address to)
```

### EmergencyWithdraw

```solidity
event EmergencyWithdraw(address user, uint256 pid, uint256 amount, address to)
```

### Harvest

```solidity
event Harvest(address user, uint256 pid, uint256 amount)
```

### LogPoolAddition

```solidity
event LogPoolAddition(uint256 pid, uint256 allocPoint, contract IERC20 lpToken)
```

### LogSetPool

```solidity
event LogSetPool(uint256 pid, uint256 allocPoint)
```

### LogUpdatePool

```solidity
event LogUpdatePool(uint256 pid, uint64 lastRewardBlock, uint256 lpSupply, uint256 accSushiPerShare)
```

### LogInit

```solidity
event LogInit()
```

### constructor

```solidity
constructor() public
```

### initilize

```solidity
function initilize(address _sushi, address _updateroler) external
```

Deposits a dummy token to `MASTER_CHEF` MCV1. This is required because MCV1 holds the minting rights for SUSHI.
Any balance of transaction sender in `dummyToken` is transferred.
The allocation point for the pool on MCV1 is the total allocation point for all pools that receive double incentives.

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal
```

_Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
{upgradeToAndCall}.

Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.

```solidity
function _authorizeUpgrade(address) internal onlyOwner {}
```_

### poolLength

```solidity
function poolLength() public view returns (uint256 pools)
```

Returns the number of MCV2 pools.

### add

```solidity
function add(uint256 allocPoint, contract IERC20 _lpToken) public
```

Add a new LP to the pool. Can only be called by the owner.
DO NOT add the same LP token more than once. Rewards will be messed up if you do.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| allocPoint | uint256 | AP of the new pool. |
| _lpToken | contract IERC20 | Address of the LP ERC-20 token. |

### set

```solidity
function set(uint256 _pid, uint256 _allocPoint) public
```

Update the given pool's SUSHI allocation point and `IRewarder` contract. Can only be called by the owner.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _pid | uint256 | The index of the pool. See `poolInfo`. |
| _allocPoint | uint256 | New AP of the pool. |

### pendingSushi

```solidity
function pendingSushi(uint256 _pid, address _user) external view returns (uint256 pending)
```

View function to see pending SUSHI on frontend.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _pid | uint256 | The index of the pool. See `poolInfo`. |
| _user | address | Address of user. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| pending | uint256 | SUSHI reward for a given user. |

### massUpdatePools

```solidity
function massUpdatePools(uint256[] pids) external
```

Update reward variables for all pools. Be careful of gas spending!

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| pids | uint256[] | Pool IDs of all to be updated. Make sure to update all active pools. |

### updatePool

```solidity
function updatePool(uint256 pid) public returns (struct MasterChef.PoolInfo pool)
```

Update reward variables of the given pool.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| pid | uint256 | The index of the pool. See `poolInfo`. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| pool | struct MasterChef.PoolInfo | Returns the pool that was updated. |

### deposit

```solidity
function deposit(uint256 pid, uint256 amount, address to) public
```

Deposit LP tokens to MCV2 for SUSHI allocation.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| pid | uint256 | The index of the pool. See `poolInfo`. |
| amount | uint256 | LP token amount to deposit. |
| to | address | The receiver of `amount` deposit benefit. |

### withdraw

```solidity
function withdraw(uint256 pid, uint256 amount, address to) public
```

Withdraw LP tokens from MCV2.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| pid | uint256 | The index of the pool. See `poolInfo`. |
| amount | uint256 | LP token amount to withdraw. |
| to | address | Receiver of the LP tokens. |

### harvest

```solidity
function harvest(uint256 pid, address to) public
```

Harvest proceeds for transaction sender to `to`.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| pid | uint256 | The index of the pool. See `poolInfo`. |
| to | address | Receiver of SUSHI rewards. |

### withdrawAndHarvest

```solidity
function withdrawAndHarvest(uint256 pid, uint256 amount, address to) public
```

Withdraw LP tokens from MCV2 and harvest proceeds for transaction sender to `to`.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| pid | uint256 | The index of the pool. See `poolInfo`. |
| amount | uint256 | LP token amount to withdraw. |
| to | address | Receiver of the LP tokens and SUSHI rewards. |

### emergencyWithdraw

```solidity
function emergencyWithdraw(uint256 pid, address to) public
```

Withdraw without caring about rewards. EMERGENCY ONLY.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| pid | uint256 | The index of the pool. See `poolInfo`. |
| to | address | Receiver of the LP tokens. |

## Pair

### MINIMUM_LIQUIDITY

```solidity
uint256 MINIMUM_LIQUIDITY
```

### factory

```solidity
address factory
```

### token0

```solidity
address token0
```

### token1

```solidity
address token1
```

### price0CumulativeLast

```solidity
uint256 price0CumulativeLast
```

### price1CumulativeLast

```solidity
uint256 price1CumulativeLast
```

### kLast

```solidity
uint256 kLast
```

### lock

```solidity
modifier lock()
```

### getReserves

```solidity
function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast)
```

### Mint

```solidity
event Mint(address sender, uint256 amount0, uint256 amount1)
```

### Burn

```solidity
event Burn(address sender, uint256 amount0, uint256 amount1, address to)
```

### Swap

```solidity
event Swap(address sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address to)
```

### Sync

```solidity
event Sync(uint112 reserve0, uint112 reserve1)
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize(address _token0, address _token1) external
```

### mint

```solidity
function mint(address to) external returns (uint256 liquidity)
```

### burn

```solidity
function burn(address to) external returns (uint256 amount0, uint256 amount1)
```

### swap

```solidity
function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes data) external
```

### skim

```solidity
function skim(address to) external
```

### sync

```solidity
function sync() external
```

## IUniswapV2ERC20

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### name

```solidity
function name() external pure returns (string)
```

### symbol

```solidity
function symbol() external pure returns (string)
```

### decimals

```solidity
function decimals() external pure returns (uint8)
```

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### approve

```solidity
function approve(address spender, uint256 value) external returns (bool)
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool)
```

### DOMAIN_SEPARATOR

```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32)
```

### PERMIT_TYPEHASH

```solidity
function PERMIT_TYPEHASH() external pure returns (bytes32)
```

### nonces

```solidity
function nonces(address owner) external view returns (uint256)
```

### permit

```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external
```

## IUniswapV2Callee

### uniswapV2Call

```solidity
function uniswapV2Call(address sender, uint256 amount0, uint256 amount1, bytes data) external
```

## Math

### min

```solidity
function min(uint256 x, uint256 y) internal pure returns (uint256 z)
```

### sqrt

```solidity
function sqrt(uint256 y) internal pure returns (uint256 z)
```

## SignedSafeMath

### mul

```solidity
function mul(int256 a, int256 b) internal pure returns (int256)
```

_Returns the multiplication of two signed integers, reverting on
overflow.

Counterpart to Solidity's `*` operator.

Requirements:

- Multiplication cannot overflow._

### div

```solidity
function div(int256 a, int256 b) internal pure returns (int256)
```

_Returns the integer division of two signed integers. Reverts on
division by zero. The result is rounded towards zero.

Counterpart to Solidity's `/` operator. Note: this function uses a
`revert` opcode (which leaves remaining gas untouched) while Solidity
uses an invalid opcode to revert (consuming all remaining gas).

Requirements:

- The divisor cannot be zero._

### sub

```solidity
function sub(int256 a, int256 b) internal pure returns (int256)
```

_Returns the subtraction of two signed integers, reverting on
overflow.

Counterpart to Solidity's `-` operator.

Requirements:

- Subtraction cannot overflow._

### add

```solidity
function add(int256 a, int256 b) internal pure returns (int256)
```

_Returns the addition of two signed integers, reverting on
overflow.

Counterpart to Solidity's `+` operator.

Requirements:

- Addition cannot overflow._

### toUInt256

```solidity
function toUInt256(int256 a) internal pure returns (uint256)
```

## UQ112x112

### Q112

```solidity
uint224 Q112
```

### encode

```solidity
function encode(uint112 y) internal pure returns (uint224 z)
```

### uqdiv

```solidity
function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z)
```

## RewardToken

### constructor

```solidity
constructor() public
```

