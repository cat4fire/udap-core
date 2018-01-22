pragma solidity ^0.4.18;

import './SafeMath.sol';

library Lib {
    using SafeMath for uint256;

    enum Lifecycle{EMPTY,Init,Normal,Locked,Finished,Void,/*add more enum here, */LAST}
    enum ColumnType{EMPTY,BYTES32,UINT256,ADDRESS,BOOL,/*add more enum here, */LAST}

    function explainColumnType(uint256 _value) internal pure returns (ColumnType) {
        require(_value < uint256(ColumnType.LAST) );
        return ColumnType(_value);
    }

    function interpretColumnType(ColumnType ct) internal pure returns (uint256){
        return uint256(ct);
    }

    function validateColumnType(uint256 _value) internal pure returns (bool) {
        if(_value < uint256(ColumnType.LAST)){
            return true;
        }
        return false;
    }



    function explainLifecycle(uint256 _value) internal pure returns (Lifecycle) {
        require(_value < uint256(Lifecycle.LAST) );
        return Lifecycle(_value);
    }

    function interpretLifecycle(Lifecycle l) internal pure returns (uint256){
        return uint256(l);
    }

    function validateLifecycle(uint256 _value) internal pure returns (bool) {
        if(_value < uint256(Lifecycle.LAST)){
            return true;
        }
        return false;
    }
}


