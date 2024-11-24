// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "./libraries/SignedSafeMath.sol";
import "./interfaces/IERC20.sol";
import './libraries/SafeMath.sol';
import './libraries/TransferHelper.sol';
import "hardhat/console.sol";

/// @notice The (older) MasterChef contract gives out a constant number of SUSHI tokens per block.
/// It is the only address with minting rights for SUSHI.
/// The idea for this MasterChef V2 (MCV2) contract is therefore to be the owner of a dummy token
/// that is deposited into the MasterChef V1 (MCV1) contract.
/// The allocation point for this pool on MCV1 is the total allocation point for all pools that receive double incentives.
contract MasterChef is UUPSUpgradeable,OwnableUpgradeable,AccessControlEnumerableUpgradeable {
    using Math for int256;
    using Math for uint128;
    using SafeMath for uint256;
    using SafeMath for uint128;
    using SignedSafeMath for int256;

    /// @notice Info of each MCV2 user.
    /// `amount` LP token amount the user has provided.
    /// `rewardDebt` The amount of SUSHI entitled to the user.
    struct UserInfo {
        uint256 amount;
        int256 rewardDebt;
    }

    /// @notice Info of each MCV2 pool.
    /// `allocPoint` The amount of allocation points assigned to the pool.
    /// Also known as the amount of SUSHI to distribute per block.
    struct PoolInfo {
        uint128 accSushiPerShare;
        uint64 lastRewardBlock;
        uint64 allocPoint;
    }

    /// @notice Address of SUSHI contract.
    IERC20 public SUSHI;

    /// @notice Info of each MCV2 pool.
    PoolInfo[] public poolInfo;
    /// @notice Address of the LP token for each MCV2 pool.
    IERC20[] public lpToken;

    bool public paused = false;


    /// @notice Info of each user that stakes LP tokens.
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;
    /// @dev Total allocation points. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint;

    uint256 private constant SUSHI_PER_BLOCK = 1e20;
    uint256 private constant ACC_SUSHI_PRECISION = 1e12;

    bytes32 public constant AdminRole = keccak256("amm.role.admin");
    bytes32 public constant UpdateRole = keccak256("amm.role.updater");


    event Deposit(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
    event Harvest(address indexed user, uint256 indexed pid, uint256 amount);
    event LogPoolAddition(uint256 indexed pid, uint256 allocPoint, IERC20 indexed lpToken);
    event LogSetPool(uint256 indexed pid, uint256 allocPoint);
    event LogUpdatePool(uint256 indexed pid, uint64 lastRewardBlock, uint256 lpSupply, uint256 accSushiPerShare);
    event LogInit();

    constructor() {
        _disableInitializers();
    }

    modifier notPaused() {
        require(!paused, "MasterChef: paused");
        _;
    }

    /// @notice Deposits a dummy token to `MASTER_CHEF` MCV1. This is required because MCV1 holds the minting rights for SUSHI.
    /// Any balance of transaction sender in `dummyToken` is transferred.
    /// The allocation point for the pool on MCV1 is the total allocation point for all pools that receive double incentives.
    function initilize(address _sushi,address _updateroler) initializer external {
        __Ownable_init(msg.sender);
        _setRoleAdmin(AdminRole, AdminRole);
        _setRoleAdmin(UpdateRole, AdminRole);
        _grantRole(AdminRole, msg.sender);
        _grantRole(UpdateRole, _updateroler);
        SUSHI = IERC20(_sushi);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyRole(UpdateRole) {}


    /// @notice Returns the number of MCV2 pools.
    function poolLength() public view returns (uint256 pools) {
        pools = poolInfo.length;
    }

    /// @notice Add a new LP to the pool. Can only be called by the owner.
    /// DO NOT add the same LP token more than once. Rewards will be messed up if you do.
    /// @param allocPoint AP of the new pool.
    /// @param _lpToken Address of the LP ERC-20 token.
    function add(uint256 allocPoint, IERC20 _lpToken) public onlyOwner {
        uint256 lastRewardBlock = block.number;
        totalAllocPoint = totalAllocPoint + allocPoint;
        lpToken.push(_lpToken);

        poolInfo.push(PoolInfo({
            allocPoint: uint64(allocPoint),
            lastRewardBlock: uint64(lastRewardBlock),
            accSushiPerShare: 0
        }));
        emit LogPoolAddition(lpToken.length - 1, allocPoint, _lpToken);
    }

    /// @notice Update the given pool's SUSHI allocation point and `IRewarder` contract. Can only be called by the owner.
    /// @param _pid The index of the pool. See `poolInfo`.
    /// @param _allocPoint New AP of the pool.
    function set(uint256 _pid, uint256 _allocPoint) public onlyOwner {
        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
        poolInfo[_pid].allocPoint = uint64(_allocPoint);
        emit LogSetPool(_pid, _allocPoint);
    }

    /// @notice View function to see pending SUSHI on frontend.
    /// @param _pid The index of the pool. See `poolInfo`.
    /// @param _user Address of user.
    /// @return pending SUSHI reward for a given user.
    function pendingSushi(uint256 _pid, address _user) external view returns (uint256 pending) {
        PoolInfo memory pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        console.log("pool.accSushiPerShare", pool.accSushiPerShare);
        console.log("pool.lastRewardBlock", pool.lastRewardBlock);
        uint256 accSushiPerShare = pool.accSushiPerShare;
                console.log("user.amount", user.amount);
        console.log("user.rewardDebt", uint256(user.rewardDebt));
        uint256 lpSupply = lpToken[_pid].balanceOf(address(this));
                console.log("lpSupply", lpSupply);
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 blocks = block.number.sub(pool.lastRewardBlock);
            uint256 sushiReward = blocks.mul(SUSHI_PER_BLOCK).mul(pool.allocPoint) / totalAllocPoint;
            accSushiPerShare = accSushiPerShare.add(sushiReward.mul(ACC_SUSHI_PRECISION) / lpSupply);
        }
        console.log("accSushiPerShare", accSushiPerShare);
        console.log("user.amount", user.amount);
        console.log("user.rewardDebt", uint256(user.rewardDebt));
        pending = int256(user.amount.mul(accSushiPerShare) / ACC_SUSHI_PRECISION).sub(user.rewardDebt).toUInt256();
    }

    /// @notice Update reward variables for all pools. Be careful of gas spending!
    /// @param pids Pool IDs of all to be updated. Make sure to update all active pools.
    function massUpdatePools(uint256[] calldata pids) external {
        uint256 len = pids.length;
        for (uint256 i = 0; i < len; ++i) {
            updatePool(pids[i]);
        }
    }

    /// @notice Update reward variables of the given pool.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @return pool Returns the pool that was updated.
    function updatePool(uint256 pid) public returns (PoolInfo memory pool) {
        pool = poolInfo[pid];
        if (block.number > pool.lastRewardBlock) {
            uint256 lpSupply = lpToken[pid].balanceOf(address(this));
            if (lpSupply > 0) {
                uint256 blocks = block.number.sub(pool.lastRewardBlock);
                uint256 sushiReward = blocks.mul(SUSHI_PER_BLOCK).mul(pool.allocPoint) / totalAllocPoint;
                uint128 _acc = uint128(sushiReward.mul(ACC_SUSHI_PRECISION) / lpSupply);
                pool.accSushiPerShare = pool.accSushiPerShare + _acc;
            }
            pool.lastRewardBlock = uint64(block.number);
            poolInfo[pid] = pool;
            emit LogUpdatePool(pid, pool.lastRewardBlock, lpSupply, pool.accSushiPerShare);
        }
    }

    /// @notice Deposit LP tokens to MCV2 for SUSHI allocation.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @param amount LP token amount to deposit.
    /// @param to The receiver of `amount` deposit benefit.
    function deposit(uint256 pid, uint256 amount, address to) public notPaused {
        PoolInfo memory pool = updatePool(pid);
        UserInfo storage user = userInfo[pid][to];

        // Effects
        user.amount = user.amount.add(amount);
        user.rewardDebt = user.rewardDebt.add(int256(amount.mul(pool.accSushiPerShare) / ACC_SUSHI_PRECISION));

        TransferHelper.safeTransferFrom(address(lpToken[pid]),msg.sender, address(this), amount);

        emit Deposit(msg.sender, pid, amount, to);
    }

    /// @notice Withdraw LP tokens from MCV2.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @param amount LP token amount to withdraw.
    /// @param to Receiver of the LP tokens.
    function withdraw(uint256 pid, uint256 amount, address to) public notPaused{
        PoolInfo memory pool = updatePool(pid);
        UserInfo storage user = userInfo[pid][msg.sender];

        // Effects
        user.rewardDebt = user.rewardDebt.sub(int256(amount.mul(pool.accSushiPerShare) / ACC_SUSHI_PRECISION));
        user.amount = user.amount.sub(amount);

        TransferHelper.safeTransfer(address(lpToken[pid]),to, amount);

        emit Withdraw(msg.sender, pid, amount, to);
    }

    /// @notice Harvest proceeds for transaction sender to `to`.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @param to Receiver of SUSHI rewards.
    function harvest(uint256 pid, address to) public {
        PoolInfo memory pool = updatePool(pid);
        UserInfo storage user = userInfo[pid][msg.sender];
        int256 accumulatedSushi = int256(user.amount.mul(pool.accSushiPerShare) / ACC_SUSHI_PRECISION);
        uint256 _pendingSushi = accumulatedSushi.sub(user.rewardDebt).toUInt256();

        // Effects
        user.rewardDebt = accumulatedSushi;

        // Interactions
        if (_pendingSushi != 0) {
            TransferHelper.safeTransfer(address(SUSHI),to, _pendingSushi);
        }
        
        emit Harvest(msg.sender, pid, _pendingSushi);
    }
    
    /// @notice Withdraw LP tokens from MCV2 and harvest proceeds for transaction sender to `to`.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @param amount LP token amount to withdraw.
    /// @param to Receiver of the LP tokens and SUSHI rewards.
    function withdrawAndHarvest(uint256 pid, uint256 amount, address to) public notPaused{
        PoolInfo memory pool = updatePool(pid);
        UserInfo storage user = userInfo[pid][msg.sender];
        int256 accumulatedSushi = int256(user.amount.mul(pool.accSushiPerShare) / ACC_SUSHI_PRECISION);
        uint256 _pendingSushi = accumulatedSushi.sub(user.rewardDebt).toUInt256();

        // Effects
        user.rewardDebt = accumulatedSushi.sub(int256(amount.mul(pool.accSushiPerShare) / ACC_SUSHI_PRECISION));
        user.amount = user.amount.sub(amount);
        
        // Interactions
        TransferHelper.safeTransfer(address(SUSHI),to, _pendingSushi);

        TransferHelper.safeTransfer(address(lpToken[pid]),to, amount);

        emit Withdraw(msg.sender, pid, amount, to);
        emit Harvest(msg.sender, pid, _pendingSushi);
    }


    /// @notice Withdraw without caring about rewards. EMERGENCY ONLY.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @param to Receiver of the LP tokens.
    function emergencyWithdraw(uint256 pid, address to) public {
        UserInfo storage user = userInfo[pid][msg.sender];
        uint256 amount = user.amount;
        user.amount = 0;
        user.rewardDebt = 0;

        // Note: transfer can fail or succeed if `amount` is zero.
        TransferHelper.safeTransfer(address(lpToken[pid]),to, amount);
        emit EmergencyWithdraw(msg.sender, pid, amount, to);
    }

    function setPause(bool _pause) public onlyRole(AdminRole) {
        paused = _pause;
    }
}