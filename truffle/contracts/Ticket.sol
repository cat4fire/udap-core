pragma solidity ^0.4.18;

import './SafeMath.sol';
//import './Org.sol';
import './GeneralStorage.sol';
import './Lib.sol';

//NonFungibleTicket can be used for ticket pool
//MintableToken can be used for organization token
contract Ticket {
    using SafeMath for uint256;
    GeneralStorage gs;
    //   enum Lifecycle{Init,Normal,Locked,Finished,Void}

    address ownerAddress;
    uint256 value;
    Lib.Lifecycle ticketStatus;
    address allowed;
    bytes32 hash;

    function Ticket(address _ownerAddress, uint256 _value, uint256 _ticketStatus, address _allowed, bytes32 _hash) public {
        ownerAddress = _ownerAddress;
        value = _value;
        ticketStatus = Lib.explainLifecycle(_ticketStatus);
        allowed = _allowed;
        hash = _hash;
    }
    function() public payable { }

    function getOwnerAddress() public view returns (address){
        return ownerAddress;
    }

    function setOwnerAddress(address _address) public returns (bool){
        ownerAddress = _address;
        return true;
    }

    function getValue() public view returns (uint256){
        return value;
    }

    function setValue(uint256 _value) public returns (bool){
        value = _value;
        return true;
    }

    function getTicketStatus() public view returns (uint256){
        return Lib.interpretLifecycle(ticketStatus);
    }

    function setTicketStatus(uint256 _value) public returns (bool){
        ticketStatus = Lib.explainLifecycle(_value);
        return true;
    }

    function getAllowed() public view returns (address){
        return allowed;
    }

    function setAllowed(address _address) public returns (bool){
        allowed = _address;
        return true;
    }

    function getHash() public view returns (bytes32){
        return hash;
    }

    function setHash(bytes32 _bytes32) public returns (bool){
        hash = _bytes32;
        return true;
    }
}