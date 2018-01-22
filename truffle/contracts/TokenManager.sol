pragma solidity ^0.4.0;

import './AccountToken.sol';

contract TokenManager {
    function TokenManager(){

    }

    event newTokenEvent(address indexed iaddr, address addr);

    mapping(address => AccountToken) tokenPool;

    function newToken() public returns (address) {
        tokenPool[msg.sender] = new AccountToken();
        newTokenEvent(tokenPool[msg.sender],tokenPool[msg.sender]);
        return tokenPool[msg.sender];
    }

    function transfer() public {
        tokenPool[msg.sender].transferToken();
    }

}