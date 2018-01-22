pragma solidity ^0.4.18;

import './SafeMath.sol';
import './OrgToken.sol';

//NonFungibleTicket can be used for ticket pool
//MintableToken can be used for organization token
contract NonFungibleTicket {
    using SafeMath for uint256;

    function NonFungibleTicket(bytes32 _ticketSymbol) public {

        organization = OrgToken(msg.sender);
        supervisor = msg.sender;
        ticketSymbol = _ticketSymbol;
    }
    function() payable { }
    uint256 public version;

    OrgToken organization;
    bytes32 ticketSymbol;
    address supervisor;
    address voidHold;

    enum Lifecycle{Init,Normal,Locked,Finished,Void}


    //  mapping(address => uint256[]) ownerTokenID;
    mapping(bytes32 => address) ticketOwnerAddress;
    mapping(bytes32 => uint256) ticketValue;
    mapping(bytes32 => Lifecycle) ticketStatus;
    mapping(address => uint256) ownerBalance;//用户持有票的总价值 发行者发行了多少价值的票 验票者验了多少价值的票 作废了多少价值的票
    mapping(bytes32 => address) ticketAllowed;// the v_value is the _spender， just allow one to one trade
    mapping(bytes32 => bytes32) ticketHash;

    mapping(bytes32 => address) mintWhiteList;
    mapping(address => uint256) mintReverseWhiteList;
    uint256 mintWhiteListIndex;

    mapping(bytes32 => address) ticketTakerWhiteList;
    mapping(address => uint256) ticketTakerReverseWhiteList;
    uint256 ticketTakerWhiteListIndex;

    mapping(bytes32 => address) sellerWhiteList;
    mapping(address => uint256) sellerReverseWhiteList;
    uint256 sellerWhiteListIndex;

    event e_mint(address _sender, uint256 _value , bytes32 _ticket, bytes32 _tHast);
    //制造新票 sender = mint
    function mint(uint256 _value , bytes32 _ticket, bytes32 _tHast)  public returns (bool) {
        require(isMintWhiteList(msg.sender));
        ticketOwnerAddress[_ticket]=msg.sender;
        ticketHash[_ticket] = _tHast;
        ticketValue[_ticket]=_value;
        ownerBalance[msg.sender]=ownerBalance[msg.sender].add(_value);//该Minter发行了多少新票
        ticketAllowed[_ticket] = address(0);
        ticketStatus[_ticket] = Lifecycle.Init;

        organization.issue(ticketSymbol,_value);

        e_mint(msg.sender,_value,_ticket,_tHast);
        return true;
    }

    event e_voidIt(address _sender, bytes32 _ticket);
    //作废 sender = mint
    function voidIt (bytes32 _ticket) public returns (bool){
        require(isMintWhiteList(msg.sender));
        require(ticketStatus[_ticket]==Lifecycle.Init);

        ticketOwnerAddress[_ticket]=voidHold;
        ownerBalance[voidHold] = ownerBalance[voidHold].add(ticketValue[_ticket]);//作废了新票
        delete ticketAllowed[_ticket];
        ticketStatus[_ticket]=Lifecycle.Void;

        organization.melt(ticketSymbol,ticketValue[_ticket]);

        e_voidIt(msg.sender, _ticket);
        return true;
    }

    event e_sell(address _sender, bytes32 _ticket, address _to);
    //出售新票sender = seller
    function sell(bytes32 _ticket, address _to) public returns (bool) {
        require(isSellerWhiteList(msg.sender));
        require(ticketStatus[_ticket] == Lifecycle.Init);

        ticketOwnerAddress[_ticket]=_to;
        ownerBalance[_to]=ownerBalance[_to].add(ticketValue[_ticket]);
        ticketAllowed[_ticket] = address(0);
        ticketStatus[_ticket] = Lifecycle.Normal;

        organization.purchase(_to,ticketValue[_ticket]);

        e_sell(msg.sender, _ticket, _to);
        return true;
    }

    event e_reclaim(address _sender, bytes32 _ticket);
    //回收sender = mint
    function reclaim(bytes32 _ticket) public returns(bool){
        require(isMintWhiteList(msg.sender));
        require(ticketStatus[_ticket]==Lifecycle.Normal);

        ownerBalance[ticketOwnerAddress[_ticket]]=ownerBalance[ticketOwnerAddress[_ticket]].sub(ticketValue[_ticket]);

        organization.redeem(ticketOwnerAddress[_ticket],ticketValue[_ticket]);

        ticketOwnerAddress[_ticket]=msg.sender;
        delete ticketAllowed[_ticket];
        ticketStatus[_ticket]=Lifecycle.Init;

        e_reclaim(msg.sender, _ticket);
        return true;

    }

    event e_checkIn(address _sender, bytes32 _ticket);
    //检票入场 sender =taker
    function checkIn(bytes32 _ticket) public returns (bool){
        require(isTicketTakerWhiteList(msg.sender));
        require(ticketStatus[_ticket]==Lifecycle.Normal);

        ticketOwnerAddress[_ticket]=msg.sender;
        ownerBalance[msg.sender]=ownerBalance[msg.sender].add(ticketValue[_ticket]);//检票员检票的总价值
        ticketStatus[_ticket]=Lifecycle.Finished;

        e_checkIn(msg.sender, _ticket);
        return true;
    }

    event e_halfTime(address _sender, bytes32 _ticket, bool _in);
    //中场迁出 sender =taker
    function halfTimeCheckOut(bytes32 _ticket) public returns (bool) {
        require(isTicketTakerWhiteList(msg.sender));
        require(ticketStatus[_ticket]==Lifecycle.Finished);

        ticketStatus[_ticket]=Lifecycle.Locked;
        e_halfTime(msg.sender,_ticket,false);
        return true;
    }

    //中场迁入 sender =taker
    function halfTimeCheckIn(bytes32 _ticket) public returns (bool) {
        require(isTicketTakerWhiteList(msg.sender));
        require(ticketStatus[_ticket]==Lifecycle.Locked);

        ticketStatus[_ticket]=Lifecycle.Finished;
        e_halfTime(msg.sender,_ticket,true);
        return true;
    }

    event e_transfer(address _sender, address _from, address _to, bytes32 _ticket);
    //转票 sender = system
    function transferFrom(address _from, address _to, bytes32 _ticket) public returns (bool) {
        require(isMintWhiteList(msg.sender));
        require(ticketStatus[_ticket] ==Lifecycle.Normal);

        require(_to != address(0));
        require(_from != address(0));
        require(ticketOwnerAddress[_ticket] == _from);
        require(ticketAllowed[_ticket] == _to);

        ownerBalance[_from]=ownerBalance[_from].sub(ticketValue[_ticket]);
        ownerBalance[_to]=ownerBalance[_to].add(ticketValue[_ticket]);
        ticketOwnerAddress[_ticket] = _to;
        delete ticketAllowed[_ticket];
        organization.exchange(_from,_to,ticketValue[_ticket]);
        e_transfer(msg.sender,_from,_to,_ticket);
        return true;
    }

    event e_approve(address _sender,address _spender, bytes32 _ticket);
    //sender = owner
    function approve(address _spender, bytes32 _ticket) public returns (bool) {
        require(_spender != address(0));
        require(ticketOwnerAddress[_ticket] == msg.sender);
        require(ticketStatus[_ticket] == Lifecycle.Normal);

        ticketAllowed[_ticket]=_spender;

        e_approve(msg.sender,_spender,_ticket);
        return true;
    }

    function allowance(bytes32 _ticket, address _spender) public constant returns (bool) {
        if(ticketAllowed[_ticket] == _spender){
            return true;
        }
        return false;
    }

    function balanceOf(address _owner) public constant returns (uint256) {
        return ownerBalance[_owner];
    }



    function addMintWhiteList(address _white) public returns (bool){
        if(isMintWhiteList(_white) == true){
            return true;
        }
        mintWhiteListIndex=mintWhiteListIndex.add(uint256(1));
        mintWhiteList[keccak256(ticketSymbol,"mintWhiteList",mintWhiteListIndex)] = _white;
        mintReverseWhiteList[_white] = mintWhiteListIndex;
        return true;
    }

    function removeMintWhiteList(address _white) public returns(bool){
        if(isMintWhiteList(_white) == false){
            return true;
        }
        delete mintWhiteList[keccak256(ticketSymbol,"mintWhiteList",mintReverseWhiteList[_white])];
        delete mintReverseWhiteList[_white];
        mintWhiteListIndex=mintWhiteListIndex.sub(uint256(1));
        return true;
    }

    function isMintWhiteList(address _white) public constant returns(bool){
        uint256 ret = mintReverseWhiteList[_white];
        if(ret!=uint256(0)){
            return true;
        }
        return false;
    }

    function addSellerWhiteList(address _white) public returns (bool){
        if(isSellerWhiteList(_white) == true){
            return true;
        }
        sellerWhiteListIndex=sellerWhiteListIndex.add(uint256(1));
        sellerWhiteList[keccak256(ticketSymbol,"sellerWhiteList",sellerWhiteListIndex)] = _white;
        sellerReverseWhiteList[_white] = sellerWhiteListIndex;
        return true;
    }

    function removeSellerWhiteList(address _white) public returns(bool){
        if(isSellerWhiteList(_white) == false){
            return true;
        }
        delete sellerWhiteList[keccak256(ticketSymbol,"sellerWhiteList",sellerReverseWhiteList[_white])];
        delete sellerReverseWhiteList[_white];
        sellerWhiteListIndex=sellerWhiteListIndex.sub(uint256(1));
        return true;
    }

    function isSellerWhiteList(address _white) public constant returns(bool){
        uint256 ret = sellerReverseWhiteList[_white];
        if(ret!=uint256(0)){
            return true;
        }
        return false;
    }

    function addTicketTakerWhiteList(address _white) public returns (bool){
        if(isTicketTakerWhiteList(_white) == true){
            return true;
        }
        ticketTakerWhiteListIndex=ticketTakerWhiteListIndex.add(uint256(1));
        ticketTakerWhiteList[keccak256(ticketSymbol,"ticketTakerWhiteList",ticketTakerWhiteListIndex)] = _white;
        ticketTakerReverseWhiteList[_white] = ticketTakerWhiteListIndex;
        return true;
    }

    function removeTicketTakerWhiteList(address _white) public returns(bool){
        if(isTicketTakerWhiteList(_white) == false){
            return true;
        }
        delete ticketTakerWhiteList[keccak256(ticketSymbol,"ticketTakerWhiteList",ticketTakerReverseWhiteList[_white])];
        delete ticketTakerReverseWhiteList[_white];
        ticketTakerWhiteListIndex=ticketTakerWhiteListIndex.sub(uint256(1));
        return true;
    }

    function isTicketTakerWhiteList(address _white) public constant returns(bool){
        uint256 ret = ticketTakerReverseWhiteList[_white];
        if(ret!=uint256(0)){
            return true;
        }
        return false;
    }

}
