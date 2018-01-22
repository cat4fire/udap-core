pragma solidity ^0.4.0;

import './StandardToken.sol';

contract AccountToken is StandardToken {
    bytes b;
    event newAccountTokenEvent(address indexed iaddr, address addr);
    function AccountToken(){
        newAccountTokenEvent(msg.sender,msg.sender);
        b='test';
    }

    event transferTokenEvent(address indexed iaddr, address addr);
    function transferToken() public returns (bool){
        transferTokenEvent(msg.sender,msg.sender);
        return true;
    }
}