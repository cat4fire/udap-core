pragma solidity ^0.4.18;

import './MintableToken.sol';
import './NonFungibleTicket.sol';
import './SafeMath.sol';
import './GeneralUniqueArrayStorage.sol';
import './GeneralMappingStorage.sol';
import './NamingService.sol';

contract OrgToken is MintableToken{
    using SafeMath for uint256;
    //   mapping(bytes32 => NonFungibleTicket) ticketAddress;
    //    mapping(address => uint256) ownerStakeValue;//refer to owner's whole ticket stake fortune
    uint256 totalIssuedValue;
    NamingService ns;
    GeneralUniqueArrayStorage guasAddress;
    GeneralMappingStorage gmsAddress;
    address supervisor;
    bytes32 orgSymbol;

    bytes32 TICKET_ADDRESS;
    bytes32 OWNER_STAKE_VALUE; //用户名下已购买的票总共的价值,不分ticket
    bytes32 ISSUED_STAKE_VALUE;//发行的票总共的价值,不分ticket


    function OrgToken(bytes32 _orgSymbol, address _ns) public {

        require(NamingService(_ns).ping());
        ns = NamingService(_ns);

        address temp = ns.lookupSafe("GeneralUniqueArrayStorage");
        guasAddress = GeneralUniqueArrayStorage(temp);

        temp = ns.lookupSafe("GeneralMappingStorage");
        gmsAddress =  GeneralMappingStorage(temp);

        totalIssuedValue = 0;
        supervisor=msg.sender;
        orgSymbol = _orgSymbol;
        TICKET_ADDRESS = keccak256(_orgSymbol,"ticketAddress");
        OWNER_STAKE_VALUE = keccak256(_orgSymbol,"ownerStakeValue");
        ISSUED_STAKE_VALUE = keccak256(_orgSymbol,"issuedStakeValue");
    }
    function() payable { }
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

    function getIssuedStakeValue(bytes32 _ticketSymbol) public constant returns (uint256){
        return gmsAddress.readBytes32ToUint(ISSUED_STAKE_VALUE, _ticketSymbol);
    }

    function getOwnerStakeValue(address _owner) public constant returns (uint256){
        return gmsAddress.readAddressToUint(OWNER_STAKE_VALUE, _owner);
    }

    function issueTicketPool(bytes32 _ticketSymbol) public returns (address){
        address temp= new NonFungibleTicket(_ticketSymbol);
        gmsAddress.createBytes32ToAddress(TICKET_ADDRESS,_ticketSymbol,temp);
        return temp;
    }

    function ticketPool(bytes32 _ticketSymbol) public constant returns(address){
        return gmsAddress.readBytes32ToAddress(TICKET_ADDRESS,_ticketSymbol);
    }

    //发行新票
    function issue (bytes32 _ticketSymbol, uint256 _value) public returns(bool){
        uint256 temp = gmsAddress.readBytes32ToUint(ISSUED_STAKE_VALUE, _ticketSymbol);
        temp = temp.add(_value);
        gmsAddress.setBytes32ToUint(ISSUED_STAKE_VALUE, _ticketSymbol, temp);
        return true;
    }

    //作废票子
    function melt (bytes32 _ticketSymbol, uint256 _value) public returns(bool){
        uint256 temp = gmsAddress.readBytes32ToUint(ISSUED_STAKE_VALUE, _ticketSymbol);
        temp = temp.sub(_value);
        gmsAddress.setBytes32ToUint(ISSUED_STAKE_VALUE, _ticketSymbol, temp);
        return true;
    }
    //售出新票
    function purchase (address _to, uint256 _value) public returns(bool){
        uint256 temp = gmsAddress.readAddressToUint(OWNER_STAKE_VALUE, _to);
        temp = temp.add(_value);
        gmsAddress.setAddressToUint(OWNER_STAKE_VALUE, _to, temp);
        balances[_to] =balances[_to].sub(_value);
        return true;
    }
    //回收新票
    function redeem (address _to, uint256 _value) public returns(bool){
        uint256 temp = gmsAddress.readAddressToUint(OWNER_STAKE_VALUE, _to);
        temp = temp.sub(_value);
        gmsAddress.setAddressToUint(OWNER_STAKE_VALUE, _to, temp);
        balances[_to] = balances[_to].add(_value);
        return true;
    }

    //转票
    function exchange( address _from, address _to, uint256 _value) public returns(bool){
        uint256 temp = gmsAddress.readAddressToUint(OWNER_STAKE_VALUE, _from);
        temp = temp.sub(_value);
        gmsAddress.setAddressToUint(OWNER_STAKE_VALUE, _to, temp);
        balances[_from] =balances[_from].add(_value);

        temp = gmsAddress.readAddressToUint(OWNER_STAKE_VALUE, _to);
        temp = temp.add(_value);
        gmsAddress.setAddressToUint(OWNER_STAKE_VALUE, _to, temp);
        balances[_to] =balances[_to].add(_value);

        return true;
    }

}