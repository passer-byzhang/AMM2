// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ExternalStorage} from './ExternalStorage.sol';

contract MasterChefStorage is ExternalStorage {
    /// @notice Info of each MCV2 user.
    /// `amount` LP token amount the user has provided.
    /// `rewardDebt` The amount of SUSHI entitled to the user.
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "MasterChefStorage: FORBIDDEN");
        _;
    }

    function transferOwnership(address _owner) public onlyOwner {
        owner = _owner;
    }

    constructor() {
        owner = msg.sender;
    }


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
    address public SUSHI;

    function getSushi() public view returns (address) {
        return getAddress(keccak256("sushi"));
    }

    function setSushi(address _sushi) public onlyOwner{
        setAddress(keccak256("sushi"), _sushi);
    }

    /// @notice Info of each MCV2 pool.
    PoolInfo[] public poolInfo;
    function getPoolInfoLength() public view returns (uint256) {
        return getUint(keccak256("poolInfo.length"));
    }

    function setPoolInfoLength(uint256 _length) public onlyOwner {
        setUint(keccak256("poolInfo.length"), _length);
    }


    function getPoolInfoElement(uint256 _pid) public view returns (PoolInfo memory pool) {
        pool.accSushiPerShare = uint128(getUint(keccak256(abi.encodePacked("poolInfo",_pid, "accSushiPerShare"))));
        pool.lastRewardBlock = uint64(getUint(keccak256(abi.encodePacked("poolInfo",_pid, "lastRewardBlock"))));
        pool.allocPoint = uint64(getUint(keccak256(abi.encodePacked("poolInfo",_pid, "allocPoint"))));
    }

    function setPoolInfoElement(uint256 _pid, uint128 _accSushiPerShare, uint64 _lastRewardBlock, uint64 _allocPoint) public onlyOwner{
        setUint(keccak256(abi.encodePacked("poolInfo",_pid, "accSushiPerShare")), _accSushiPerShare);
        setUint(keccak256(abi.encodePacked("poolInfo",_pid, "lastRewardBlock")), _lastRewardBlock);
        setUint(keccak256(abi.encodePacked("poolInfo",_pid, "allocPoint")), _allocPoint);
    }

    function pushPoolInfo(uint128 _accSushiPerShare, uint64 _lastRewardBlock, uint64 _allocPoint) public onlyOwner {
        uint256 length = getUint(keccak256("poolInfo.length"));
        setPoolInfoElement(length, _accSushiPerShare, _lastRewardBlock, _allocPoint);
        setUint(keccak256("poolInfo.length"), length + 1);
    }

    /// @notice Address of the LP token for each MCV2 pool.
    address[] public lpToken;

    function getLpTokenLength() public view returns (uint256) {
        return getUint(keccak256("lpToken.length"));
    }

    function setLpTokenLength(uint256 _length) public onlyOwner {
        setUint(keccak256("lpToken.length"), _length);
    }

    function getLpTokenElement(uint256 index) public  view returns (address) {
        return getAddress(keccak256(abi.encodePacked("lpToken",index)));
    }
    function setLpTokenElement(uint256 index, address _lpToken) public onlyOwner {
        setAddress(keccak256(abi.encodePacked("lpToken",index )), _lpToken);
    }

    function pushLpToken(address _lpToken) public onlyOwner {
        uint256 length = getUint(keccak256("lpToken.length"));
        setLpTokenElement(length, _lpToken);
        setUint(keccak256("lpToken.length"), length + 1);
    }

    /// @notice Info of each user that stakes LP tokens.
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;
    function getUserInfoElement(uint256 _pid, address _user) public  view returns (UserInfo memory userInfo) {
        userInfo.amount = getUint(keccak256(abi.encodePacked("userInfo",_pid, _user,"amount")));
        userInfo.rewardDebt = int256(getUint(keccak256(abi.encodePacked("userInfo",_pid, _user,"rewardDebt"))));
    }

    function setUserInfoElement(uint256 _pid, address _user, uint256 _amount, int256 _rewardDebt) public onlyOwner {
        setUint(keccak256(abi.encodePacked("userInfo",_pid, _user,"amount")), _amount);
        setUint(keccak256(abi.encodePacked("userInfo",_pid, _user,"rewardDebt")), uint256(_rewardDebt));
    }

    /// @dev Total allocation points. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint;
    function getTotalAllocPoint() public view returns (uint256) {
        return getUint(keccak256("totalAllocPoint"));
    }
    function setTotalAllocPoint(uint256 _totalAllocPoint) public onlyOwner {
        setUint(keccak256("totalAllocPoint"), _totalAllocPoint);
    }

    uint256 public constant SUSHI_PER_BLOCK = 1e20;
    uint256 public constant ACC_SUSHI_PRECISION = 1e12;

    bytes32 public constant AdminRole = keccak256("amm.role.admin");
    bytes32 public constant UpdateRole = keccak256("amm.role.updater");
}