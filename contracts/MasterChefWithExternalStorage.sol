// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "./libraries/SignedSafeMath.sol";
import "./interfaces/IERC20.sol";
import './libraries/SafeMath.sol';
import './libraries/TransferHelper.sol';
import './MasterChefStorage.sol';

/// @notice The (older) MasterChef contract gives out a constant number of SUSHI tokens per block.
/// It is the only address with minting rights for SUSHI.
/// The idea for this MasterChef V2 (MCV2) contract is therefore to be the owner of a dummy token
/// that is deposited into the MasterChef V1 (MCV1) contract.
/// The allocation point for this pool on MCV1 is the total allocation point for all pools that receive double incentives.
contract MasterChefWithExternalStorage is OwnableUpgradeable,AccessControlEnumerableUpgradeable {
    using Math for int256;
    using Math for uint128;
    using SafeMath for uint256;
    using SafeMath for uint128;
    using SignedSafeMath for int256;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
    event Harvest(address indexed user, uint256 indexed pid, uint256 amount);
    event LogPoolAddition(uint256 indexed pid, uint256 allocPoint, IERC20 indexed lpToken);
    event LogSetPool(uint256 indexed pid, uint256 allocPoint);
    event LogUpdatePool(uint256 indexed pid, uint64 lastRewardBlock, uint256 lpSupply, uint256 accSushiPerShare);
    event LogInit();

    MasterChefStorage private _storage;
    constructor(address storageContract) {
        _storage = MasterChefStorage(storageContract);
    }

    /// @notice Deposits a dummy token to `MASTER_CHEF` MCV1. This is required because MCV1 holds the minting rights for SUSHI.
    /// Any balance of transaction sender in `dummyToken` is transferred.
    /// The allocation point for the pool on MCV1 is the total allocation point for all pools that receive double incentives.
    function initilize(address _sushi,address _updateroler) initializer external {
        _storage.setSushi(_sushi);
    }

    /// @notice Add a new LP to the pool. Can only be called by the owner.
    /// DO NOT add the same LP token more than once. Rewards will be messed up if you do.
    /// @param allocPoint AP of the new pool.
    /// @param _lpToken Address of the LP ERC-20 token.
    function add(uint256 allocPoint, IERC20 _lpToken) public onlyOwner {
        uint256 lastRewardBlock = block.number;
        uint256 totalAllocPointBefore = _storage.getTotalAllocPoint();
        _storage.setTotalAllocPoint(totalAllocPointBefore + allocPoint);
        _storage.pushLpToken(address(_lpToken));
        _storage.pushPoolInfo(uint64(allocPoint), uint64(lastRewardBlock), 0);
        emit LogPoolAddition(_storage.getLpTokenLength(), allocPoint, _lpToken);
    }

    /// @notice Update the given pool's SUSHI allocation point and `IRewarder` contract. Can only be called by the owner.
    /// @param _pid The index of the pool. See `poolInfo`.
    /// @param _allocPoint New AP of the pool.
    function set(uint256 _pid, uint256 _allocPoint) public onlyOwner {
        MasterChefStorage.PoolInfo memory poolInfo = _storage.getPoolInfoElement(_pid);
        _storage.setTotalAllocPoint(_storage.getTotalAllocPoint() - poolInfo.allocPoint + _allocPoint);
        _storage.setPoolInfoElement(_pid, poolInfo.accSushiPerShare, poolInfo.lastRewardBlock, uint64(_allocPoint));
        emit LogSetPool(_pid, _allocPoint);
    }

    /// @notice View function to see pending SUSHI on frontend.
    /// @param _pid The index of the pool. See `poolInfo`.
    /// @param _user Address of user.
    /// @return pending SUSHI reward for a given user.
    function pendingSushi(uint256 _pid, address _user) external view returns (uint256 pending) {
        MasterChefStorage.PoolInfo memory pool = _storage.getPoolInfoElement(_pid);
        MasterChefStorage.UserInfo memory user = _storage.getUserInfoElement(_pid, _user);
        uint256 accSushiPerShare = pool.accSushiPerShare;
        uint256 lpSupply = IERC20(_storage.getLpTokenElement(_pid)).balanceOf(address(this));
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 blocks = block.number.sub(pool.lastRewardBlock);
            uint256 sushiReward = blocks.mul(_storage.SUSHI_PER_BLOCK()).mul(pool.allocPoint) / _storage.getTotalAllocPoint();
            accSushiPerShare = accSushiPerShare.add(sushiReward.mul(_storage.ACC_SUSHI_PRECISION()) / lpSupply);
        }
        pending = int256(user.amount.mul(accSushiPerShare) / _storage.ACC_SUSHI_PRECISION()).sub(user.rewardDebt).toUInt256();
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
    function updatePool(uint256 pid) public returns (MasterChefStorage.PoolInfo memory pool) {
        pool = _storage.getPoolInfoElement(pid);
        if (block.number > pool.lastRewardBlock) {
            uint256 lpSupply = IERC20(_storage.getLpTokenElement(pid)).balanceOf(address(this));
            if (lpSupply > 0) {
                uint256 blocks = block.number.sub(pool.lastRewardBlock);
                uint256 sushiReward = blocks.mul(_storage.SUSHI_PER_BLOCK()).mul(pool.allocPoint) / _storage.getTotalAllocPoint();
                uint128 _acc = uint128(sushiReward.mul(_storage.ACC_SUSHI_PRECISION()) / lpSupply);
                pool.accSushiPerShare = pool.accSushiPerShare + _acc;
            }
            pool.lastRewardBlock = uint64(block.number);
            //poolInfo[pid] = pool;
            _storage.setPoolInfoElement(pid, pool.accSushiPerShare, pool.lastRewardBlock, pool.allocPoint);
            emit LogUpdatePool(pid, pool.lastRewardBlock, lpSupply, pool.accSushiPerShare);
        }
    }

    /// @notice Deposit LP tokens to MCV2 for SUSHI allocation.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @param amount LP token amount to deposit.
    /// @param to The receiver of `amount` deposit benefit.
    function deposit(uint256 pid, uint256 amount, address to) public {
        MasterChefStorage.PoolInfo memory pool = updatePool(pid);
        MasterChefStorage.UserInfo memory user = _storage.getUserInfoElement(pid, to);

        // Effects
        user.amount = user.amount.add(amount);
        user.rewardDebt = user.rewardDebt.add(int256(amount.mul(pool.accSushiPerShare) / _storage.ACC_SUSHI_PRECISION()));
        _storage.setUserInfoElement(pid, to, user.amount, user.rewardDebt);

        TransferHelper.safeTransferFrom(_storage.getLpTokenElement(pid),msg.sender, address(this), amount);

        emit Deposit(msg.sender, pid, amount, to);
    }

    /// @notice Withdraw LP tokens from MCV2.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @param amount LP token amount to withdraw.
    /// @param to Receiver of the LP tokens.
    function withdraw(uint256 pid, uint256 amount, address to) public {
        MasterChefStorage.PoolInfo memory pool = updatePool(pid);
        MasterChefStorage.UserInfo memory user = _storage.getUserInfoElement(pid, msg.sender);

        // Effects
        user.rewardDebt = user.rewardDebt.sub(int256(amount.mul(pool.accSushiPerShare) / _storage.ACC_SUSHI_PRECISION()));
        user.amount = user.amount.sub(amount);
        _storage.setUserInfoElement(pid, msg.sender, user.amount, user.rewardDebt);
        TransferHelper.safeTransfer(_storage.getLpTokenElement(pid),to, amount);

        emit Withdraw(msg.sender, pid, amount, to);
    }

    /// @notice Harvest proceeds for transaction sender to `to`.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @param to Receiver of SUSHI rewards.
    function harvest(uint256 pid, address to) public {
        MasterChefStorage.PoolInfo memory pool = updatePool(pid);
        MasterChefStorage.UserInfo memory user = _storage.getUserInfoElement(pid, msg.sender);
        int256 accumulatedSushi = int256(user.amount.mul(pool.accSushiPerShare) / _storage.ACC_SUSHI_PRECISION());
        uint256 _pendingSushi = accumulatedSushi.sub(user.rewardDebt).toUInt256();

        // Effects
        user.rewardDebt = accumulatedSushi;
        _storage.setUserInfoElement(pid, msg.sender, user.amount, user.rewardDebt);

        // Interactions
        if (_pendingSushi != 0) {
            TransferHelper.safeTransfer(_storage.getSushi(),to, _pendingSushi);
        }
        
        emit Harvest(msg.sender, pid, _pendingSushi);
    }
    
    /// @notice Withdraw LP tokens from MCV2 and harvest proceeds for transaction sender to `to`.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @param amount LP token amount to withdraw.
    /// @param to Receiver of the LP tokens and SUSHI rewards.
    function withdrawAndHarvest(uint256 pid, uint256 amount, address to) public {
        MasterChefStorage.PoolInfo memory pool = updatePool(pid);
        MasterChefStorage.UserInfo memory user = _storage.getUserInfoElement(pid, msg.sender);
        int256 accumulatedSushi = int256(user.amount.mul(pool.accSushiPerShare) / _storage.ACC_SUSHI_PRECISION());
        uint256 _pendingSushi = accumulatedSushi.sub(user.rewardDebt).toUInt256();

        // Effects
        user.rewardDebt = accumulatedSushi.sub(int256(amount.mul(pool.accSushiPerShare) / _storage.ACC_SUSHI_PRECISION()));
        user.amount = user.amount.sub(amount);
        _storage.setUserInfoElement(pid, msg.sender, user.amount, user.rewardDebt);
        
        // Interactions
        TransferHelper.safeTransfer(address(_storage.getSushi()),to, _pendingSushi);

        TransferHelper.safeTransfer(_storage.getLpTokenElement(pid),to, amount);

        emit Withdraw(msg.sender, pid, amount, to);
        emit Harvest(msg.sender, pid, _pendingSushi);
    }


    /// @notice Withdraw without caring about rewards. EMERGENCY ONLY.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @param to Receiver of the LP tokens.
    function emergencyWithdraw(uint256 pid, address to) public {
        MasterChefStorage.UserInfo memory user = _storage.getUserInfoElement(pid, msg.sender);
        uint256 amount = user.amount;
        user.amount = 0;
        user.rewardDebt = 0;
        _storage.setUserInfoElement(pid, msg.sender, user.amount, user.rewardDebt);

        // Note: transfer can fail or succeed if `amount` is zero.
        TransferHelper.safeTransfer(address(_storage.getLpTokenElement(pid)),to, amount);
        emit EmergencyWithdraw(msg.sender, pid, amount, to);
    }
}