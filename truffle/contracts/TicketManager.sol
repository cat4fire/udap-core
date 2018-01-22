pragma solidity ^0.4.0;


contract TicketManager {
    function TicketManger(){

    }

    uint64 public totalSupply;

    mapping(address => bytes) public ticketPool;

    function newTicket(bytes b) public {
        ticketPool[msg.sender] = b;
    }

    function getTicket() public returns (bytes ret){
        ret = ticketPool[msg.sender];
    }

}