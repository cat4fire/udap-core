pragma solidity ^0.4.18;

import './SafeMath.sol';


contract STLStorage {
    using SafeMath for uint256;

    function STLStorage() public payable{}
    function () public payable{}

    // uint256 => bytes32
    mapping(bytes32 => mapping(uint256 => bytes32)) mapUintToBytes32;

    function mapUintToBytes32Set(bytes32 _schema, uint256 _key, bytes32 _value) public returns (bool){
        mapUintToBytes32[_schema][_key] = _value;
        return true;
    }

    function mapUintToBytes32Get(bytes32 _schema, uint256 _key) public view returns (bytes32){
        return mapUintToBytes32[_schema][_key];
    }

    function mapUintToBytes32Det(bytes32 _schema, uint256 _key) public returns (bool){
        delete mapUintToBytes32[_schema][_key];
        return true;
    }

    // bytes32 => uint256
    mapping(bytes32 => mapping(bytes32 => uint256)) mapBytes32ToUint;

    function mapBytes32ToUintSet(bytes32 _schema, bytes32 _key, uint256 _value) public returns (bool){
        mapBytes32ToUint[_schema][_key] = _value;
        return true;
    }

    function mapBytes32ToUintGet(bytes32 _schema, bytes32 _key) public view returns (uint256){
        return mapBytes32ToUint[_schema][_key];
    }

    function mapBytes32ToUintDet(bytes32 _schema, bytes32 _key) public returns (bool){
        delete mapBytes32ToUint[_schema][_key];
        return true;
    }

    //special increasing counter
    //starts from 1, 0 meanings none
    function getCounter(bytes32 _schema, bytes32 _key) public returns (uint256){
        mapBytes32ToUint[_schema][_key] = mapBytes32ToUint[_schema][_key].incr();
        return mapBytes32ToUint[_schema][_key];
    }

    function nowCounter(bytes32 _schema, bytes32 _key) public view returns (uint256){
        return mapBytes32ToUint[_schema][_key];
    }

    function setCounter(bytes32 _schema, bytes32 _key, uint256 _value) public returns (bool){
        mapBytes32ToUint[_schema][_key] = _value;
        return true;
    }
    //special increasing counter

    // bytes32 => bytes32
    mapping(bytes32 => mapping(bytes32 => bytes32)) mapBytes32ToBytes32;

    function mapBytes32ToBytes32Set(bytes32 _schema, bytes32 _key, bytes32 _value) public returns (bool){
        mapBytes32ToBytes32[_schema][_key] = _value;
        return true;
    }

    function mapBytes32ToBytes32Get(bytes32 _schema, bytes32 _key) public view returns (bytes32){
        return mapBytes32ToBytes32[_schema][_key];
    }

    function mapBytes32ToBytes32Det(bytes32 _schema, bytes32 _key) public returns (bool){
        delete mapBytes32ToBytes32[_schema][_key];
        return true;
    }
}