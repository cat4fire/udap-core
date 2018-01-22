pragma solidity ^0.4.18;

import './SafeMath.sol';


contract Random {
    using SafeMath for uint256;

    function Random() public payable{}
    function () public payable{}
    mapping(bytes32 => mapping(bytes32 => bool)) collision;
    bytes32 last;

    /*
     *  Entropy sources
    *  - now
    *  - block.hash(..) * 256 (ish)
    *  - tx.origin
    *  - msg.sender
    *  - block.gaslimit
    *  - msg.gas
    *  - tx.gasprice
    */

    function random() public returns (bytes32){
        bytes32 r = keccak256(now,
            block.blockhash(block.number),
            msg.sender,
            block.gaslimit,
            msg.gas,
            last);
        last = r;
        return r;
    }

    function randomSafe(bytes32 _schema) public returns (bytes32){
        for(uint256 i = 0; i <10; i++){
            bytes32 r = keccak256(now,
                block.blockhash(block.number),
                msg.sender,
                block.gaslimit,
                msg.gas,
                last);
            if(collision[_schema][r] == false){
                collision[_schema][r] = true;
                last = r;
                return r;
            }

        }
        revert();
    }
}