pragma solidity ^0.4.18;

import './SafeMath.sol';

contract GeneralUniqueArrayStorage{
    using SafeMath for uint256;

    //address

    function GeneralUniqueArrayStorage (){

    }

    mapping(bytes32 => mapping(uint256 => address)) addressPayLoad;
    mapping(bytes32 => uint256) addressCounter; //starts from 1, 0 means there is no content
    mapping(bytes32 => mapping(address => uint256)) addressR;

    function createAddress(bytes32 _schema, address _address) public returns(bool){
        require(addressR[_schema][_address]==0);
        addressCounter[_schema] = addressCounter[_schema].incr();
        addressPayLoad[_schema][addressCounter[_schema]] = _address;
        addressR[_schema][_address] = addressCounter[_schema];
        return true;
    }

    function readAddress(bytes32 _schema, uint256 _index) public constant returns(address){
        return addressPayLoad[_schema][_index];
    }

    function updateAddress(bytes32 _schema, uint256 _index, address _address) public returns (bool){
        require(addressR[_schema][_address]==0);
        require(_index <= addressCounter[_schema]);
        delete addressR[_schema][addressPayLoad[_schema][_index]];
        addressPayLoad[_schema][_index] = _address;
        addressR[_schema][_address] = _index;
        return true;
    }

    function deleteAddress(bytes32 _schema, uint256 _index) public returns (bool){
        require(addressCounter[_schema]>0);
        require(_index <= addressCounter[_schema]);

        address temp = addressPayLoad[_schema][_index];
        addressR[_schema][addressPayLoad[_schema][addressCounter[_schema]]] = _index;
        delete addressR[_schema][temp];

        addressPayLoad[_schema][_index] = addressPayLoad[_schema][addressCounter[_schema]];
        delete addressPayLoad[_schema][addressCounter[_schema]];

        addressCounter[_schema] = addressCounter[_schema].decr();
        return true;
    }

    function countAddress(bytes32 _schema) public constant returns (uint256){
        return addressCounter[_schema];
    }

    function indexOfAddress(bytes32 _schema, address _address) public constant returns (uint256){
        return addressR[_schema][_address];
    }

    //uint256
    //======================== index   => content
    mapping(bytes32 => mapping(uint256 => uint256)) uintPayLoad;
    mapping(bytes32 => uint256) uintCounter; //starts from 1, 0 means there is no content
    mapping(bytes32 => mapping(uint256 => uint256)) uintR;

    function createUint(bytes32 _schema, uint256 _uint256) public returns(bool){
        require(uintR[_schema][_uint256]==0);
        uintCounter[_schema] = uintCounter[_schema].incr();
        uintPayLoad[_schema][uintCounter[_schema]] = _uint256;
        uintR[_schema][_uint256] = uintCounter[_schema];
        return true;
    }

    function readUint(bytes32 _schema, uint256 _index) public constant returns(uint256){
        return uintPayLoad[_schema][_index];
    }

    function updateUint(bytes32 _schema, uint256 _index, uint256 _uint256) public returns (bool){
        require(uintR[_schema][_uint256]==0);
        require(_index <= uintCounter[_schema]);
        delete uintR[_schema][uintPayLoad[_schema][_index]];
        uintPayLoad[_schema][_index] = _uint256;
        uintR[_schema][_uint256] = _index;
        return true;
    }

    function deleteUint(bytes32 _schema, uint256 _index) public returns (bool){
        require(uintCounter[_schema]>0);
        require(_index <= uintCounter[_schema]);

        uint256 temp = uintPayLoad[_schema][_index];
        uintR[_schema][uintPayLoad[_schema][uintCounter[_schema]]] = _index;
        delete uintR[_schema][temp];

        uintPayLoad[_schema][_index] = uintPayLoad[_schema][uintCounter[_schema]];
        delete uintPayLoad[_schema][uintCounter[_schema]];

        uintCounter[_schema] = uintCounter[_schema].decr();
        return true;
    }

    function countUint(bytes32 _schema) public constant returns (uint256){
        return uintCounter[_schema];
    }

    function indexOfUint(bytes32 _schema, uint256 _uint256) public constant returns (uint256){
        return uintR[_schema][_uint256];
    }

    //bytes32
    //======================== index   => content
    mapping(bytes32 => mapping(uint256 => bytes32)) bytes32PayLoad;
    mapping(bytes32 => uint256) bytes32Counter; //starts from 1, 0 means there is no content
    mapping(bytes32 => mapping(bytes32 => uint256)) bytes32R;

    function createBytes32(bytes32 _schema, bytes32 _bytes32) public returns(bool){
        require(bytes32R[_schema][_bytes32]==0);
        bytes32Counter[_schema] = bytes32Counter[_schema].incr();
        bytes32PayLoad[_schema][bytes32Counter[_schema]] = _bytes32;
        bytes32R[_schema][_bytes32] = bytes32Counter[_schema];
        return true;
    }

    function readBytes32(bytes32 _schema, uint256 _index) public constant returns(bytes32){
        return bytes32PayLoad[_schema][_index];
    }

    function updateBytes32(bytes32 _schema, uint256 _index, bytes32 _bytes32) public returns (bool){
        require(bytes32R[_schema][_bytes32]==0);
        require(_index <= bytes32Counter[_schema]);
        delete bytes32R[_schema][bytes32PayLoad[_schema][_index]];
        bytes32PayLoad[_schema][_index] = _bytes32;
        bytes32R[_schema][_bytes32] = _index;
        return true;
    }

    function deleteBytes32(bytes32 _schema, uint256 _index) public returns (bool){
        require(bytes32Counter[_schema]>0);
        require(_index <= bytes32Counter[_schema]);

        bytes32 temp = bytes32PayLoad[_schema][_index];
        bytes32R[_schema][bytes32PayLoad[_schema][bytes32Counter[_schema]]] = _index;
        delete bytes32R[_schema][temp];

        bytes32PayLoad[_schema][_index] = bytes32PayLoad[_schema][bytes32Counter[_schema]];
        delete bytes32PayLoad[_schema][bytes32Counter[_schema]];

        bytes32Counter[_schema] = bytes32Counter[_schema].decr();
        return true;
    }

    function countBytes32(bytes32 _schema) public constant returns (uint256){
        return bytes32Counter[_schema];
    }

    function indexOfBytes32(bytes32 _schema, bytes32 _bytes32) public constant returns (uint256){
        return bytes32R[_schema][_bytes32];
    }
}