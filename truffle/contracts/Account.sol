pragma solidity ^0.4.0;

import './AccountToken.sol';
import './TicketManger.sol';
import './TokenManager.sol';

contract Account {
    function Account(){

    }

    mapping(address => bytes) accountName;
    mapping(address => TicketManger[]) ticketPool;
    mapping(address => TokenManager) token;

    function newAccount() public returns(bool ret){
        return true;
    }

    function transferToken(address spender, uint256 value) public {
    }

    function newTicket() public returns(bool ret){

        return true;
    }

}