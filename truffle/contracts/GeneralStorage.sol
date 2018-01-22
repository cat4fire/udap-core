pragma solidity ^0.4.18;

import './SafeMath.sol';

contract GeneralStorage{
    using SafeMath for uint256;
    //======================================================================List

    //value is unique, key is managered automatically, it's more like set
    //address
    //======================== index   => content
    mapping(bytes32 => mapping(uint256 => address)) listAddressPayload;
    mapping(bytes32 => uint256) listAddressCounter; //starts from 1, 0 means there is no content
    mapping(bytes32 => mapping(address => uint256)) listAddressPointer;

    function listCreateAddress(bytes32 _schema, address _address) public returns(bool){
        require(listAddressPointer[_schema][_address]==0);
        listAddressCounter[_schema] = listAddressCounter[_schema].incr();
        listAddressPayload[_schema][listAddressCounter[_schema]] = _address;
        listAddressPointer[_schema][_address] = listAddressCounter[_schema];
        return true;
    }

    function listReadAddress(bytes32 _schema, uint256 _index) public constant returns(address){
        return listAddressPayload[_schema][_index];
    }

    function listUpdateAddress(bytes32 _schema, uint256 _index, address _address) public returns (bool){
        require(listAddressPointer[_schema][_address]==0);
        require(_index <= listAddressCounter[_schema]);
        delete listAddressPointer[_schema][listAddressPayload[_schema][_index]];
        listAddressPayload[_schema][_index] = _address;
        listAddressPointer[_schema][_address] = _index;
        return true;
    }

    function listDeleteAddress(bytes32 _schema, uint256 _index) public returns (bool){
        require(listAddressCounter[_schema]>0);
        require(_index <= listAddressCounter[_schema]);
        //    require(listAddressPayload[_schema][_index]!=address(0));

        address temp = listAddressPayload[_schema][_index];
        listAddressPointer[_schema][listAddressPayload[_schema][listAddressCounter[_schema]]] = _index;
        delete listAddressPointer[_schema][temp];

        listAddressPayload[_schema][_index] = listAddressPayload[_schema][listAddressCounter[_schema]];
        delete listAddressPayload[_schema][listAddressCounter[_schema]];

        listAddressCounter[_schema] = listAddressCounter[_schema].decr();
        return true;
    }

    function listCountAddress(bytes32 _schema) public constant returns (uint256){
        return listAddressCounter[_schema];
    }

    function listIndexOfAddress(bytes32 _schema, address _address) public constant returns (uint256){
        return listAddressPointer[_schema][_address];
    }


    //unique map address, key is unique and arbitary, value is unique,
    //key should not be 0 cause 0 cann't tell it's null or iterally zero
    function uniqueMapCreateUintToAddress(bytes32 _schema,uint256 _uint_k, address _address) public returns(bool){
        require(listAddressPointer[_schema][_address]==uint256(0));
        listAddressPayload[_schema][_uint_k] = _address;
        listAddressPointer[_schema][_address] = _uint_k;
        listAddressCounter[_schema] = listAddressCounter[_schema].incr();
        return true;
    }

    function uniqueMapSetUintToAddress(bytes32 _schema,uint256 _uint_k, address _address) public returns(bool){
        bool _new = false;
        if(listAddressPointer[_schema][_address]==uint256(0)){
            _new = true;
        }
        listAddressPayload[_schema][_uint_k] = _address;
        listAddressPointer[_schema][_address] = _uint_k;
        if(_new){
            listAddressCounter[_schema] = listAddressCounter[_schema].incr();
        }
        return true;
    }

    function uniqueMapUpdateUintToAddress(bytes32 _schema,uint256 _uint_k, address _address) public returns(bool){
        require(listAddressPointer[_schema][_address]!=uint256(0));
        listAddressPayload[_schema][_uint_k] = _address;
        listAddressPointer[_schema][_address] = _uint_k;
        return true;
    }

    function uniqueMapReadUintToAddress(bytes32 _schema,uint256 _uint_k) public constant returns(address){
        return listAddressPayload[_schema][_uint_k];
    }

    function uniqueMapDeleteUintToAddress(bytes32 _schema,uint256 _uint_k) public returns(bool){
        if(uniqueMapReadUintToAddress(_schema, _uint_k) ==address(0)){
            return true;
        }
        else{
            delete listAddressPointer[_schema][uniqueMapReadUintToAddress(_schema, _uint_k)];
            delete listAddressPayload[_schema][_uint_k];
            listAddressCounter[_schema] = listAddressCounter[_schema].decr();
        }
    }

    function uniqueMapIndexOfUintToAddress(bytes32 _schema, address _address) public constant returns(uint256){
        return listAddressPointer[_schema][_address];
    }



    //uint256
    //======================== index   => content
    mapping(bytes32 => mapping(uint256 => uint256)) listUintPayload;
    mapping(bytes32 => uint256) listUintCounter; //starts from 1, 0 means there is no content
    mapping(bytes32 => mapping(uint256 => uint256)) listUintPointer;

    function listCreateUint(bytes32 _schema, uint256 _uint256) public returns(bool){
        require(listUintPointer[_schema][_uint256]==0);
        listUintCounter[_schema] = listUintCounter[_schema].incr();
        listUintPayload[_schema][listUintCounter[_schema]] = _uint256;
        listUintPointer[_schema][_uint256] = listUintCounter[_schema];
        return true;
    }

    function listReadUint(bytes32 _schema, uint256 _index) public constant returns(uint256){
        return listUintPayload[_schema][_index];
    }

    function listUpdateUint(bytes32 _schema, uint256 _index, uint256 _uint256) public returns (bool){
        require(listUintPointer[_schema][_uint256]==0);
        require(_index <= listUintCounter[_schema]);
        delete listUintPointer[_schema][listUintPayload[_schema][_index]];
        listUintPayload[_schema][_index] = _uint256;
        listUintPointer[_schema][_uint256] = _index;
        return true;
    }

    function listDeleteUint(bytes32 _schema, uint256 _index) public returns (bool){
        require(listUintCounter[_schema]>0);
        require(_index <= listUintCounter[_schema]);

        uint256 temp = listUintPayload[_schema][_index];
        listUintPointer[_schema][listUintPayload[_schema][listUintCounter[_schema]]] = _index;
        delete listUintPointer[_schema][temp];

        listUintPayload[_schema][_index] = listUintPayload[_schema][listUintCounter[_schema]];
        delete listUintPayload[_schema][listUintCounter[_schema]];

        listUintCounter[_schema] = listUintCounter[_schema].decr();
        return true;
    }

    function listCountUint(bytes32 _schema) public constant returns (uint256){
        return listUintCounter[_schema];
    }

    function listIndexOfUint(bytes32 _schema, uint256 _uint256) public constant returns (uint256){
        return listUintPointer[_schema][_uint256];
    }

    function listContainsUint(bytes32 _schema, uint256 _uint256) public constant returns (bool){
        if(listUintPointer[_schema][_uint256]!=uint256(0)){
            return true;
        }
        return false;
    }
    //bytes32
    //======================== index   => content
    mapping(bytes32 => mapping(uint256 => bytes32)) listBytes32Payload;
    mapping(bytes32 => uint256) listBytes32Counter; //starts from 1, 0 means there is no content
    mapping(bytes32 => mapping(bytes32 => uint256)) listBytes32Point;

    function listCreateBytes32(bytes32 _schema, bytes32 _bytes32) public returns(bool){
        require(listBytes32Point[_schema][_bytes32]==0);
        listBytes32Counter[_schema] = listBytes32Counter[_schema].incr();
        listBytes32Payload[_schema][listBytes32Counter[_schema]] = _bytes32;
        listBytes32Point[_schema][_bytes32] = listBytes32Counter[_schema];
        return true;
    }

    function listReadBytes32(bytes32 _schema, uint256 _index) public constant returns(bytes32){
        return listBytes32Payload[_schema][_index];
    }

    function listUpdateBytes32(bytes32 _schema, uint256 _index, bytes32 _bytes32) public returns (bool){
        require(listBytes32Point[_schema][_bytes32]==0);
        require(_index <= listBytes32Counter[_schema]);
        delete listBytes32Point[_schema][listBytes32Payload[_schema][_index]];
        listBytes32Payload[_schema][_index] = _bytes32;
        listBytes32Point[_schema][_bytes32] = _index;
        return true;
    }

    function listDeleteBytes32(bytes32 _schema, uint256 _index) public returns (bool){
        require(listBytes32Counter[_schema]>0);
        require(_index <= listBytes32Counter[_schema]);

        bytes32 temp = listBytes32Payload[_schema][_index];
        listBytes32Point[_schema][listBytes32Payload[_schema][listBytes32Counter[_schema]]] = _index;
        delete listBytes32Point[_schema][temp];

        listBytes32Payload[_schema][_index] = listBytes32Payload[_schema][listBytes32Counter[_schema]];
        delete listBytes32Payload[_schema][listBytes32Counter[_schema]];

        listBytes32Counter[_schema] = listBytes32Counter[_schema].decr();
        return true;
    }

    function listCountBytes32(bytes32 _schema) public constant returns (uint256){
        return listBytes32Counter[_schema];
    }

    function listIndexOfBytes32(bytes32 _schema, bytes32 _bytes32) public constant returns (uint256){
        return listBytes32Point[_schema][_bytes32];
    }

    function listValidateBytes32(bytes32 _schema, uint256 _index) public constant returns(bool){
        if(_index <= listBytes32Counter[_schema]){
            return true;
        }
        return false;
    }

    //======================================================================List


    //======================================================================Map
    //bytes32 => address
    mapping(bytes32 => mapping(bytes32 => address)) mapBytes32ToAddress;

    function mapCreateBytes32ToAddress(bytes32 _schema, bytes32 _bytes32, address _address) public returns (bool){
        require(mapBytes32ToAddress[_schema][_bytes32]==address(0));
        mapBytes32ToAddress[_schema][_bytes32] = _address;
        return true;
    }

    function mapReadBytes32ToAddress(bytes32 _schema, bytes32 _bytes32) public constant returns (address ){
        return mapBytes32ToAddress[_schema][_bytes32];
    }

    function mapUpdateBytes32ToAddress(bytes32 _schema, bytes32 _bytes32, address _address) public returns (bool){
        require(mapBytes32ToAddress[_schema][_bytes32]!=address(0));
        mapBytes32ToAddress[_schema][_bytes32] = _address;
        return true;
    }
    function mapSetBytes32ToAddress(bytes32 _schema, bytes32 _bytes32, address _address) public returns (bool){
        mapBytes32ToAddress[_schema][_bytes32] = _address;
        return true;
    }

    function mapDeleteBytes32ToAddress(bytes32 _schema, bytes32 _bytes32) public returns (bool){
        require(mapBytes32ToAddress[_schema][_bytes32]!=address(0));
        delete mapBytes32ToAddress[_schema][_bytes32];
        return true;
    }

    //address => uint256
    mapping(bytes32 => mapping(address => uint256)) mapAddressToUint;

    function mapCreateAddressToUint(bytes32 _schema, address _address, uint256 _uint) public returns (bool){
        require(mapAddressToUint[_schema][_address]==uint256(0));
        mapAddressToUint[_schema][_address] = _uint;
        return true;
    }

    function mapReadAddressToUint(bytes32 _schema, address _address) public constant returns (uint256 ){
        return mapAddressToUint[_schema][_address];
    }

    function mapUpdateAddressToUint(bytes32 _schema, address _address, uint256 _uint) public returns (bool){
        require(mapAddressToUint[_schema][_address]!=uint256(0));
        mapAddressToUint[_schema][_address] = _uint;
        return true;
    }

    function mapSetAddressToUint(bytes32 _schema, address _address, uint256 _uint) public returns (bool){
        //    require(mapAddressToUint[_schema][_address]!=uint256(0));
        mapAddressToUint[_schema][_address] = _uint;
        return true;
    }

    function mapDeleteAddressToUint(bytes32 _schema, address _address) public returns (bool){
        require(mapAddressToUint[_schema][_address]!=uint256(0));
        delete mapAddressToUint[_schema][_address];
        return true;
    }


    //bytes32 => uint256
    mapping(bytes32 => mapping(bytes32 => uint256)) mapBytes32ToUint;

    function mapCreateBytes32ToUint(bytes32 _schema, bytes32 _bytes32, uint256 _uint) public returns (bool){
        require(mapBytes32ToUint[_schema][_bytes32]==uint256(0));
        mapBytes32ToUint[_schema][_bytes32] = _uint;
        return true;
    }

    function mapReadBytes32ToUint(bytes32 _schema, bytes32 _bytes32) public constant returns (uint256 ){
        return mapBytes32ToUint[_schema][_bytes32];
    }

    function mapUpdateBytes32ToUint(bytes32 _schema, bytes32 _bytes32, uint256 _uint) public returns (bool){
        require(mapBytes32ToUint[_schema][_bytes32]!=uint256(0));
        mapBytes32ToUint[_schema][_bytes32] = _uint;
        return true;
    }

    function mapSetBytes32ToUint(bytes32 _schema, bytes32 _bytes32, uint256 _uint) public returns (bool){
        //    require(mapBytes32ToUint[_schema][_address]!=uint256(0));
        mapBytes32ToUint[_schema][_bytes32] = _uint;
        return true;
    }

    function mapDeleteBytes32ToUint(bytes32 _schema, bytes32 _bytes32) public returns (bool){
        require(mapBytes32ToUint[_schema][_bytes32]!=uint256(0));
        delete mapBytes32ToUint[_schema][_bytes32];
        return true;
    }


    //special counter

    function counterNow(bytes32 _schema, bytes32 _name) public constant returns(uint256){
        return mapBytes32ToUint[_schema][_name];
    }

    function counterGet(bytes32 _schema, bytes32 _name) public returns(uint256){
        mapBytes32ToUint[_schema][_name]=mapBytes32ToUint[_schema][_name].incr();
        return mapBytes32ToUint[_schema][_name];
    }

    //bytes32 => bool
    mapping(bytes32 => mapping(bytes32 => bool)) mapBytes32ToBool;

    function mapCreateBytes32ToBool(bytes32 _schema, bytes32 _bytes32, bool _bool) public returns (bool){
        require(mapBytes32ToBool[_schema][_bytes32]==false);
        mapBytes32ToBool[_schema][_bytes32] = _bool;
        return true;
    }

    function mapReadBytes32ToBool(bytes32 _schema, bytes32 _bytes32) public constant returns (bool){
        return mapBytes32ToBool[_schema][_bytes32];
    }

    function mapUpdateBytes32ToBool(bytes32 _schema, bytes32 _bytes32, bool _bool) public returns (bool){
        require(mapBytes32ToBool[_schema][_bytes32]!=false);
        mapBytes32ToBool[_schema][_bytes32] = _bool;
        return true;
    }

    function mapSetBytes32ToBool(bytes32 _schema, bytes32 _bytes32, bool _bool) public returns (bool){
        //    require(mapBytes32ToBool[_schema][_address]!=bool(0));
        mapBytes32ToBool[_schema][_bytes32] = _bool;
        return true;
    }

    function mapDeleteBytes32ToBool(bytes32 _schema, bytes32 _bytes32) public returns (bool){
        require(mapBytes32ToBool[_schema][_bytes32]!=false);
        delete mapBytes32ToBool[_schema][_bytes32];
        return true;
    }


    //bytes32 => bytes32
    mapping(bytes32 => mapping(bytes32 => bytes32)) mapBytes32ToBytes32;

    function mapCreateBytes32Tobytes32(bytes32 _schema, bytes32 _bytes32_k, bytes32 _bytes32_v) public returns (bool){
        require(mapBytes32ToBytes32[_schema][_bytes32_k]==bytes32(0));
        mapBytes32ToBytes32[_schema][_bytes32_k] = _bytes32_v;
        return true;
    }

    function mapReadBytes32Tobytes32(bytes32 _schema, bytes32 _bytes32_k) public constant returns (bytes32 ){
        return mapBytes32ToBytes32[_schema][_bytes32_k];
    }

    function mapUpdateBytes32Tobytes32(bytes32 _schema, bytes32 _bytes32_k, bytes32 _bytes32_v) public returns (bool){
        require(mapBytes32ToBytes32[_schema][_bytes32_k]!=bytes32(0));
        mapBytes32ToBytes32[_schema][_bytes32_k] = _bytes32_v;
        return true;
    }

    function mapSetBytes32Tobytes32(bytes32 _schema, bytes32 _bytes32_k, bytes32 _bytes32_v) public returns (bool){
        mapBytes32ToBytes32[_schema][_bytes32_k] = _bytes32_v;
        return true;
    }

    function mapDeleteBytes32Tobytes32(bytes32 _schema, bytes32 _bytes32_k) public returns (bool){
        require(mapBytes32ToBytes32[_schema][_bytes32_k]!=bytes32(0));
        delete mapBytes32ToBytes32[_schema][_bytes32_k];
        return true;
    }

    //uint256 => bytes32
    mapping(bytes32 => mapping(uint256 => bytes32)) mapUintToBytes32;

    function mapCreateUintToBytes32(bytes32 _schema, uint256 _uint, bytes32 _bytes32) public returns (bool){
        require(mapUintToBytes32[_schema][_uint]==bytes32(0));
        mapUintToBytes32[_schema][_uint] = _bytes32;
        return true;
    }

    function mapReadUintToBytes32(bytes32 _schema, uint256 _uint) public constant returns (bytes32 ){
        return mapUintToBytes32[_schema][_uint];
    }

    function mapUpdateUintToBytes32(bytes32 _schema, uint256 _uint, bytes32 _bytes32) public returns (bool){
        require(mapUintToBytes32[_schema][_uint]!=bytes32(0));
        mapUintToBytes32[_schema][_uint] = _bytes32;
        return true;
    }

    function mapSetUintToBytes32(bytes32 _schema, uint256 _uint, bytes32 _bytes32) public returns (bool){
        mapUintToBytes32[_schema][_uint] = _bytes32;
        return true;
    }

    function mapDeleteUintToBytes32(bytes32 _schema, uint256 _uint) public returns (bool){
        require(mapUintToBytes32[_schema][_uint]!=bytes32(0));
        delete mapUintToBytes32[_schema][_uint];
        return true;
    }

    //uint256 => bool
    mapping(bytes32 => mapping(uint256 => bool)) mapUintToBool;

    function mapCreateUintToBool(bytes32 _schema, uint256 _uint, bool _bool) public returns (bool){
        require(mapUintToBool[_schema][_uint]==false);
        mapUintToBool[_schema][_uint] = _bool;
        return true;
    }

    function mapReadUintToBool(bytes32 _schema, uint256 _uint) public constant returns (bool ){
        return mapUintToBool[_schema][_uint];
    }

    function mapUpdateUintToBool(bytes32 _schema, uint256 _uint, bool _bool) public returns (bool){
        require(mapUintToBool[_schema][_uint]!=false);
        mapUintToBool[_schema][_uint] = _bool;
        return true;
    }

    function mapSetUintToBool(bytes32 _schema, uint256 _uint, bool _bool) public returns (bool){
        mapUintToBool[_schema][_uint] = _bool;
        return true;
    }

    function mapDeleteUintToBool(bytes32 _schema, uint256 _uint) public returns (bool){
        require(mapUintToBool[_schema][_uint]!=false);
        delete mapUintToBool[_schema][_uint];
        return true;
    }

    //uint256 => uint256
    mapping(bytes32 => mapping(uint256 => uint256)) mapUintToUint;

    function mapCreateUintToUint(bytes32 _schema, uint256 _uint_k, uint256 _uint_v) public returns (bool){
        require(mapUintToUint[_schema][_uint_k]==uint256(0));
        mapUintToUint[_schema][_uint_k] = _uint_v;
        return true;
    }

    function mapReadUintToUint(bytes32 _schema, uint256 _uint_k) public constant returns (uint256 ){
        return mapUintToUint[_schema][_uint_k];
    }

    function mapUpdateUintToUint(bytes32 _schema, uint256 _uint_k, uint256 _uint_v) public returns (bool){
        require(mapUintToUint[_schema][_uint_k]!=uint256(0));
        mapUintToUint[_schema][_uint_k] = _uint_v;
        return true;
    }

    function mapSetUintToUint(bytes32 _schema, uint256 _uint_k, uint256 _uint_v) public returns (bool){
        mapUintToUint[_schema][_uint_k] = _uint_v;
        return true;
    }

    function mapDeleteUintToUint(bytes32 _schema, uint256 _uint_k) public returns (bool){
        require(mapUintToUint[_schema][_uint_k]!=uint256(0));
        delete mapUintToUint[_schema][_uint_k];
        return true;
    }

    //uint256 => address
    mapping(bytes32 => mapping(uint256 => address)) mapUintToAddress;

    function mapCreateUintToAddress(bytes32 _schema, uint256 _uint_k, address _address) public returns (bool){
        require(mapUintToAddress[_schema][_uint_k]==address(0));
        mapUintToAddress[_schema][_uint_k] = _address;
        return true;
    }

    function mapReadUintToAddress(bytes32 _schema, uint256 _uint_k) public constant returns (address ){
        return mapUintToAddress[_schema][_uint_k];
    }

    function mapUpdateUintToAddress(bytes32 _schema, uint256 _uint_k, address _address) public returns (bool){
        require(mapUintToAddress[_schema][_uint_k]!=address(0));
        mapUintToAddress[_schema][_uint_k] = _address;
        return true;
    }

    function mapSetUintToAddress(bytes32 _schema, uint256 _uint_k, address _address) public returns (bool){
        mapUintToAddress[_schema][_uint_k] = _address;
        return true;
    }

    function mapDeleteUintToAddress(bytes32 _schema, uint256 _uint_k) public returns (bool){
        require(mapUintToAddress[_schema][_uint_k]!=address(0));
        delete mapUintToAddress[_schema][_uint_k];
        return true;
    }

    //======================================================================Map

}