// EternalStorage.sol
pragma solidity ^0.8.20;

contract ExternalStorage {
    mapping(bytes32 => uint256) private uintStorage;
    mapping(bytes32 => address) private addressStorage;
    mapping(bytes32 => bool) private boolStorage;
    mapping(bytes32 => bytes32) private bytes32Storage;

    function getUint(bytes32 key) public view returns (uint256) {
        return uintStorage[key];
    }

    function setUint(bytes32 key, uint256 value) public {
        uintStorage[key] = value;
    }

    function getAddress(bytes32 key) public view returns (address) {
        return addressStorage[key];
    }

    function setAddress(bytes32 key, address value) public {
        addressStorage[key] = value;
    }

    function getBool(bytes32 key) public view returns (bool) {
        return boolStorage[key];
    }

    function setBool(bytes32 key, bool value) public {
        boolStorage[key] = value;
    }

    function getBytes32(bytes32 key) public view returns (bytes32) {
        return bytes32Storage[key];
    }

    function setBytes32(bytes32 key, bytes32 value) public {
         bytes32Storage[key] = value;
    }
}