pragma solidity ^0.4.18;

import './GeneralMappingStorage.sol';

contract NamingService{
    GeneralMappingStorage dataStorage;
    address public admin;
    bytes32 schema = "NamingService";
    function NamingService() public {admin = msg.sender;  }
    function () public payable{}

    function ping() public constant returns (bool){
        return true;
    }

    function setStorage (address _address) public returns (bool){
        require(admin == msg.sender);
        dataStorage = GeneralMappingStorage(_address);
        return true;
    }

    function register(bytes32 _name, address _address) public returns (bool){
        require(admin == msg.sender);
        dataStorage.setBytes32ToAddress(schema,_name,_address);
        return true;
    }
    function eliminate(bytes32 _name, address _address) public returns (bool){
        require(admin == msg.sender);
        dataStorage.deleteBytes32ToAddress(schema,_name);
        return true;
    }
    function lookup(bytes32 _name) public returns (address){

        return dataStorage.readBytes32ToAddress(schema,_name);
    }

    function lookupSafe(bytes32 _name) public returns (address){

        address temp;
        temp = dataStorage.readBytes32ToAddress(schema,_name);
        require(temp!= address(0));
        return temp;
    }
}