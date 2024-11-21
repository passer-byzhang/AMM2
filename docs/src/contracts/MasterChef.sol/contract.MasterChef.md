# MasterChef
[Git Source](https://github.com/passer-byzhang/AMM2/blob/35665b73bd26a411359cdea57f5b80d779f9c16b/contracts/MasterChef.sol)

**Inherits:**
UUPSUpgradeable, OwnableUpgradeable, AccessControlEnumerableUpgradeable

The (older) MasterChef contract gives out a constant number of SUSHI tokens per block.
It is the only address with minting rights for SUSHI.
The idea for this MasterChef V2 (MCV2) contract is therefore to be the owner of a dummy token
that is deposited into the MasterChef V1 (MCV1) contract.
The allocation point for this pool on MCV1 is the total allocation point for all pools that receive double incentives.


## State Variables
### SUSHI
Address of SUSHI contract.


```solidity
IERC20 public SUSHI;
```


### poolInfo
Info of each MCV2 pool.


```solidity
PoolInfo[] public poolInfo;
```


### lpToken
Address of the LP token for each MCV2 pool.


```solidity
IERC20[] public lpToken;
```


### userInfo
Info of each user that stakes LP tokens.


```solidity
mapping(uint256 => mapping(address => UserInfo)) public userInfo;
```


### totalAllocPoint
*Total allocation points. Must be the sum of all allocation points in all pools.*


```solidity
uint256 public totalAllocPoint;
```


### SUSHI_PER_BLOCK

```solidity
uint256 private constant SUSHI_PER_BLOCK = 1e20;
```


### ACC_SUSHI_PRECISION

```solidity
uint256 private constant ACC_SUSHI_PRECISION = 1e12;
```


### AdminRole

```solidity
bytes32 public constant AdminRole = keccak256("amm.role.admin");
```


### UpdateRole

```solidity
bytes32 public constant UpdateRole = keccak256("amm.role.updater");
```


## Functions
### constructor


```solidity
constructor();
```

### initilize

Deposits a dummy token to `MASTER_CHEF` MCV1. This is required because MCV1 holds the minting rights for SUSHI.
Any balance of transaction sender in `dummyToken` is transferred.
The allocation point for the pool on MCV1 is the total allocation point for all pools that receive double incentives.


```solidity
function initilize(address _sushi, address _updateroler) external initializer;
```

### _authorizeUpgrade


```solidity
function _authorizeUpgrade(address newImplementation) internal override onlyRole(UpdateRole);
```

### poolLength

Returns the number of MCV2 pools.


```solidity
function poolLength() public view returns (uint256 pools);
```

### add

Add a new LP to the pool. Can only be called by the owner.
DO NOT add the same LP token more than once. Rewards will be messed up if you do.


```solidity
function add(uint256 allocPoint, IERC20 _lpToken) public onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`allocPoint`|`uint256`|AP of the new pool.|
|`_lpToken`|`IERC20`|Address of the LP ERC-20 token.|


### set

Update the given pool's SUSHI allocation point and `IRewarder` contract. Can only be called by the owner.


```solidity
function set(uint256 _pid, uint256 _allocPoint) public onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_pid`|`uint256`|The index of the pool. See `poolInfo`.|
|`_allocPoint`|`uint256`|New AP of the pool.|


### pendingSushi

View function to see pending SUSHI on frontend.


```solidity
function pendingSushi(uint256 _pid, address _user) external view returns (uint256 pending);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_pid`|`uint256`|The index of the pool. See `poolInfo`.|
|`_user`|`address`|Address of user.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`pending`|`uint256`|SUSHI reward for a given user.|


### massUpdatePools

Update reward variables for all pools. Be careful of gas spending!


```solidity
function massUpdatePools(uint256[] calldata pids) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`pids`|`uint256[]`|Pool IDs of all to be updated. Make sure to update all active pools.|


### updatePool

Update reward variables of the given pool.


```solidity
function updatePool(uint256 pid) public returns (PoolInfo memory pool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`pid`|`uint256`|The index of the pool. See `poolInfo`.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`pool`|`PoolInfo`|Returns the pool that was updated.|


### deposit

Deposit LP tokens to MCV2 for SUSHI allocation.


```solidity
function deposit(uint256 pid, uint256 amount, address to) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`pid`|`uint256`|The index of the pool. See `poolInfo`.|
|`amount`|`uint256`|LP token amount to deposit.|
|`to`|`address`|The receiver of `amount` deposit benefit.|


### withdraw

Withdraw LP tokens from MCV2.


```solidity
function withdraw(uint256 pid, uint256 amount, address to) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`pid`|`uint256`|The index of the pool. See `poolInfo`.|
|`amount`|`uint256`|LP token amount to withdraw.|
|`to`|`address`|Receiver of the LP tokens.|


### harvest

Harvest proceeds for transaction sender to `to`.


```solidity
function harvest(uint256 pid, address to) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`pid`|`uint256`|The index of the pool. See `poolInfo`.|
|`to`|`address`|Receiver of SUSHI rewards.|


### withdrawAndHarvest

Withdraw LP tokens from MCV2 and harvest proceeds for transaction sender to `to`.


```solidity
function withdrawAndHarvest(uint256 pid, uint256 amount, address to) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`pid`|`uint256`|The index of the pool. See `poolInfo`.|
|`amount`|`uint256`|LP token amount to withdraw.|
|`to`|`address`|Receiver of the LP tokens and SUSHI rewards.|


### emergencyWithdraw

Withdraw without caring about rewards. EMERGENCY ONLY.


```solidity
function emergencyWithdraw(uint256 pid, address to) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`pid`|`uint256`|The index of the pool. See `poolInfo`.|
|`to`|`address`|Receiver of the LP tokens.|


## Events
### Deposit

```solidity
event Deposit(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
```

### Withdraw

```solidity
event Withdraw(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
```

### EmergencyWithdraw

```solidity
event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
```

### Harvest

```solidity
event Harvest(address indexed user, uint256 indexed pid, uint256 amount);
```

### LogPoolAddition

```solidity
event LogPoolAddition(uint256 indexed pid, uint256 allocPoint, IERC20 indexed lpToken);
```

### LogSetPool

```solidity
event LogSetPool(uint256 indexed pid, uint256 allocPoint);
```

### LogUpdatePool

```solidity
event LogUpdatePool(uint256 indexed pid, uint64 lastRewardBlock, uint256 lpSupply, uint256 accSushiPerShare);
```

### LogInit

```solidity
event LogInit();
```

## Structs
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

