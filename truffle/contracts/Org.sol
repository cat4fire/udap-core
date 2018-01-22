pragma solidity ^0.4.18;

import './SafeMath.sol';
import './GeneralStorage.sol';
import './Platform.sol';
import './Activity.sol';

contract Org {
    using SafeMath for uint256;
    uint256 public totalIssuedValue;
    bytes32 public name;
    address public supervisor;
    GeneralStorage public gs;
    Platform public platform;

    function Org(bytes32 _name, address _supervisor, address _gs) public {
        name = _name;
        supervisor = _supervisor;
        gs = GeneralStorage(_gs);
        platform = Platform(msg.sender);
    }
    function() payable public{ }

    // air => totalIssuedValue
    function issue(uint256 _value) public returns(uint256){
        totalIssuedValue=totalIssuedValue.add(_value);
        platform.issue(_value);
        return totalIssuedValue;
    }

    //totalIssuedValue => air
    function voidBack(uint256 _value) public returns(uint256){
        totalIssuedValue=totalIssuedValue.sub(_value);
        platform.voidBack(_value);
        return totalIssuedValue;
    }

    // balances => stakes
    function purchase(address _to, uint256 _amount) public returns (uint256){
        uint256 stake = gs.mapReadAddressToUint(keccak256("Org",name),_to);
        stake=stake.add(_amount);
        gs.mapSetAddressToUint(keccak256("Org",name),_to,stake);
        platform.purchase(_to,_amount);

        return stake;
    }

    // stakes => balances
    function redeem(address _to, uint256 _amount) public returns (uint256){
        uint256 stake = gs.mapReadAddressToUint(keccak256("Org",name),_to);
        stake=stake.sub(_amount);
        gs.mapSetAddressToUint(keccak256("Org",name),_to,stake);
        platform.redeem(_to,_amount);

        return stake;
    }

    //stakes => stakes
    function assign(address _from, address _to, uint256 _amount) public returns (uint256){
        uint256 stake = gs.mapReadAddressToUint(keccak256("Org",name),_from);
        stake=stake.sub(_amount);
        gs.mapSetAddressToUint(keccak256("Org",name),_from,stake);
        stake = gs.mapReadAddressToUint(keccak256("Org",name),_to);
        stake=stake.add(_amount);
        gs.mapSetAddressToUint(keccak256("Org",name),_to,stake);
        platform.assign(_to,_amount);
        return _amount;
    }

    //stakes => stakes balances => balances
    function deal(address _from, address _to, uint256 _amount) public returns (uint256){
        uint256 stake = gs.mapReadAddressToUint(keccak256("Org",name),_from);
        stake=stake.sub(_amount);
        gs.mapSetAddressToUint(keccak256("Org",name),_from,stake);
        stake = gs.mapReadAddressToUint(keccak256("Org",name),_to);
        stake=stake.add(_amount);
        gs.mapSetAddressToUint(keccak256("Org",name),_to,stake);
        platform.assign(_to,_amount);
        return _amount;
    }


    function openActivity(bytes32 _name, address supervise) public returns (address){
        uint256 pointer = gs.counterGet(keccak256("Org"),"pointer");
        address activity = new Activity(_name,supervise,address(gs));
        gs.uniqueMapSetUintToAddress(keccak256("Org","Activity"),pointer,activity);
        return activity;
    }













    /* //======================useless====================
     //whiteList of org
     function addOrgWhite(address _white) public returns (bool){
         require(msg.sender == supervisor);
         guasAddress.createAddress(orgSymbol,_white);
         return true;
     }

     function removeOrgWhite(address _white) public returns(bool){
         require(msg.sender == supervisor);
         guasAddress.deleteAddress(orgSymbol,guasAddress.indexOfAddress(orgSymbol,_white));
         return true;
     }

     function isOrgWhite(address _white) public constant returns(bool){
         uint256 ret = guasAddress.indexOfAddress(orgSymbol,_white);
         if(ret!=uint256(0)){
             return true;
         }
         return false;
     }

     */


}