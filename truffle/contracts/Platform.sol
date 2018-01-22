pragma solidity ^0.4.18;


import './SafeMath.sol';
import './Org.sol';
import './ERC20Token.sol';
import './GeneralStorage.sol';

contract Platform is ERC20Token{

    //all caller is the real caller, no system agents

    GeneralStorage public gs;

    mapping (address => uint256) stakes;
    uint256 allOrgIssuedValue;

    function Platform(address _gs) public{
        gs = GeneralStorage(_gs);
    }
    function() payable public{ }

    // real money => balances
    function charge(address _to, uint256 _amount) public returns (bool){
        //whitelist
        mint(_to,_amount);
        return true;
    }

    // balances => real money
    function withdraw(address _to, uint256 _amount) public returns (bool){
        //whitelist
        melt(_to,_amount);
        return true;
    }

    // balances => balances
    function exchange(address _to, uint256 _amount) public returns (bool){
        //whitelist
        balances[msg.sender]=balances[msg.sender].sub(_amount);
        balances[_to]=balances[_to].add(_amount);
        return true;
    }

    // balances => stakes
    function purchase(address _to, uint256 _amount) public returns (bool){
        //whitelist
        balances[_to]=balances[_to].sub(_amount);
        stakes[_to]=balances[_to].add(_amount);
        return true;
    }

    // stakes => balances
    function redeem(address _to, uint256 _amount) public returns (bool){
        //whitelist
        balances[_to]=balances[_to].add(_amount);
        stakes[_to]=balances[_to].sub(_amount);
        return true;
    }

    //stakes => stakes
    function assign(address _to, uint256 _amount) public returns (bool){
        //whitelist
        stakes[msg.sender]=stakes[msg.sender].sub(_amount);
        stakes[_to]=balances[_to].add(_amount);
        return true;
    }

    //stakes => stakes balances => balances
    function deal(address _from, address _to, uint256 _amount) public returns (bool){
        //whitelist
        balances[_from]=balances[_from].add(_amount);
        stakes[_from]=balances[_from].sub(_amount);
        balances[_to]=balances[_to].sub(_amount);
        stakes[_to]=balances[_to].add(_amount);
        return true;
    }

    // air => allOrgIssuedValue
    function issue(uint256 _value) public returns(uint256){
        allOrgIssuedValue=allOrgIssuedValue.add(_value);
        return allOrgIssuedValue;
    }

    //allOrgIssuedValue => air
    function voidBack(uint256 _value) public returns(uint256){
        allOrgIssuedValue=allOrgIssuedValue.sub(_value);
        return allOrgIssuedValue;
    }






    event e_openOrg(address _org, uint256 _pointer);
    function openOrg(bytes32 _name, address supervise) public returns (uint256){
        uint256 pointer = gs.counterGet(keccak256("Platform"),"pointer");
        address org = new Org(_name,supervise,address(gs));
        gs.uniqueMapSetUintToAddress(keccak256("Platform","Org"),pointer,org);
        e_openOrg(org,pointer);
        return pointer;
    }

    function getOrgIndex(address _address) public view returns (uint256){
        uint256 pointer = gs.uniqueMapIndexOfUintToAddress(keccak256("Platform","Org"),_address);
        return pointer;
    }

    function getOrgAddress(uint256 _uint256) public view returns (address){
        address _address = gs.uniqueMapReadUintToAddress(keccak256("Platform","Org"),_uint256);
        return _address;
    }
}