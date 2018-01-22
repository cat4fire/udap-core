pragma solidity ^0.4.18;

import './SafeMath.sol';
import './Org.sol';
import './GeneralStorage.sol';
import './Platform.sol';
import './Ticket.sol';

contract Activity {
    using SafeMath for uint256;

    Org organization;
    Platform platform;
    bytes32 name;
    address supervisor;
    address voidHold;
    GeneralStorage gs;

    function Activity(bytes32 _name, address _supervisor, address _gs) public {
        gs = GeneralStorage(_gs);
        organization = Org(msg.sender);
        //    platform = organization.getPlatform();
        supervisor = _supervisor;
        name = _name;
        voidHold = address(0x16bd98edbb26b6ac07a9641d0810ffb7684e2cf0);
    }
    function() public payable { }


    /*mapping(bytes32 => address) ticketOwnerAddress;
    mapping(bytes32 => uint256) ticketValue;
    mapping(bytes32 => Lifecycle) ticketStatus;
    mapping(address => uint256) ownerBalance;//用户持有票的总价值 发行者发行了多少价值的票 验票者验了多少价值的票 作废了多少价值的票
    mapping(bytes32 => address) ticketAllowed;// the v_value is the _spender， just allow one to one trade
    mapping(bytes32 => bytes32) ticketHash;

    gs.mapSetBytes32ToAddress(keccak256("Activity","ticketOwnerAddress"),ticket,address);
    gs.mapSetBytes32ToUint(keccak256("Activity","ticketValue"),ticket,uint);
    gs.mapSetBytes32ToUint(keccak256("Activity","ticketStatus"),ticket,uint);
    gs.mapSetAddressToUint(keccak256("Activity","ownerBalance"),address,uint);//用户持有票的总价值 发行者发行了多少价值的票 验票者验了多少价值的票 作废了多少价值的票
    gs.mapSetBytes32ToAddress(keccak256("Activity","ticketAllowed"),ticket,address);
    gs.mapSetBytes32Tobytes32(keccak256("Activity","ticketHash"),ticket,ticketHash);*/


    //  gs.mapSetAddressToUint(keccak256("Activity","ownerBalance"),address,uint);//用户持有票的总价值 发行者发行了多少价值的票 验票者验了多少价值的票 作废了多少价值的票

    event e_mint(address _sender, uint256 _value , bytes32 _ticket, bytes32 _tHast);
    //制造新票 sender = mint
    function mint(uint256 _value , bytes32 _ticket, bytes32 _tHast)  public returns (bool) {

        Ticket TicketAddress = new Ticket(msg.sender,_value,Lib.interpretLifecycle(Lib.Lifecycle.Init),address(0),_tHast);
        gs.mapSetBytes32ToAddress(keccak256("Activity","Ticket"),_ticket,TicketAddress);
        uint256 ownerBalance = gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"),msg.sender);
        ownerBalance = ownerBalance.add(_value);
        gs.mapUpdateAddressToUint(keccak256("Activity","ownerBalance"),msg.sender,ownerBalance);

        /*ticketOwnerAddress[_ticket]=msg.sender;
        ticketHash[_ticket] = _tHast;
        ticketValue[_ticket]=_value;
        ownerBalance[msg.sender]=ownerBalance[msg.sender].add(_value);//该Minter发行了多少新票
        ticketAllowed[_ticket] = address(0);
        ticketStatus[_ticket] = Lifecycle.Init;*/

        organization.issue(_value);

        e_mint(msg.sender,_value,_ticket,_tHast);
        return true;
    }

    event e_voidIt(address _sender, bytes32 _ticket);
    //作废 sender = mint
    function voidIt (bytes32 _ticket) public returns (bool){
        //    require(ticketStatus[_ticket]==Lifecycle.Init);

        Ticket TicketAddress = Ticket(gs.mapReadBytes32ToAddress(keccak256("Activity","Ticket"),_ticket));
        require(Lib.explainLifecycle(TicketAddress.getTicketStatus())==Lib.Lifecycle.Init);
        TicketAddress.setOwnerAddress(voidHold);
        TicketAddress.setAllowed(address(0));
        TicketAddress.setTicketStatus(Lib.interpretLifecycle(Lib.Lifecycle.Void));
        uint256 ownerBalance = gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"),voidHold);
        ownerBalance = ownerBalance.add(TicketAddress.getValue());
        gs.mapUpdateAddressToUint(keccak256("Activity","ownerBalance"),voidHold,ownerBalance);

        /*ticketOwnerAddress[_ticket]=voidHold;
        ownerBalance[voidHold] = ownerBalance[voidHold].add(ticketValue[_ticket]);//作废了新票
        delete ticketAllowed[_ticket];
        ticketStatus[_ticket]=Lifecycle.Void;*/

        organization.voidBack(TicketAddress.getValue());

        e_voidIt(msg.sender, _ticket);
        return true;
    }

    event e_sell(address _sender, bytes32 _ticket, address _to);
    //出售新票sender = seller
    function sell(bytes32 _ticket, address _to) public returns (bool) {
        //    require(ticketStatus[_ticket] == Lifecycle.Init);
        Ticket TicketAddress = Ticket(gs.mapReadBytes32ToAddress(keccak256("Activity","Ticket"),_ticket));
        require(Lib.explainLifecycle(TicketAddress.getTicketStatus())==Lib.Lifecycle.Init);

        TicketAddress.setOwnerAddress(_to);
        uint256 ownerBalance = gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"), _to);
        ownerBalance = ownerBalance.add(TicketAddress.getValue());//持票人所持所有票总价值增加
        gs.mapUpdateAddressToUint(keccak256("Activity","ownerBalance"), _to,ownerBalance);
        TicketAddress.setAllowed(address(0));
        TicketAddress.setTicketStatus(Lib.interpretLifecycle(Lib.Lifecycle.Normal));
        ownerBalance = gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"), msg.sender);
        ownerBalance = ownerBalance.add(TicketAddress.getValue());//售票员售票总价值
        gs.mapUpdateAddressToUint(keccak256("Activity","ownerBalance"), msg.sender,ownerBalance);

        /*ticketOwnerAddress[_ticket]=_to;
        ownerBalance[_to]=ownerBalance[_to].add(ticketValue[_ticket]);
        ticketAllowed[_ticket] = address(0);
        ticketStatus[_ticket] = Lifecycle.Normal;*/

        organization.purchase(_to,TicketAddress.getValue());

        e_sell(msg.sender, _ticket, _to);
        return true;
    }

    event e_reclaim(address _sender, bytes32 _ticket);
    //回收sender = reclaim
    function reclaim(bytes32 _ticket) public returns(bool){
        //    require(ticketStatus[_ticket]==Lifecycle.Normal);

        Ticket TicketAddress = Ticket(gs.mapReadBytes32ToAddress(keccak256("Activity","Ticket"),_ticket));
        require(Lib.explainLifecycle(TicketAddress.getTicketStatus())==Lib.Lifecycle.Normal);
        uint256 ownerBalance = gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"), TicketAddress.getOwnerAddress());
        ownerBalance = ownerBalance.sub(TicketAddress.getValue());//持票人所持所有票总价值减少
        gs.mapUpdateAddressToUint(keccak256("Activity","ownerBalance"), TicketAddress.getOwnerAddress(), ownerBalance);
        organization.redeem(TicketAddress.getOwnerAddress(),TicketAddress.getValue());
        TicketAddress.setAllowed(address(0));
        TicketAddress.setTicketStatus(Lib.interpretLifecycle(Lib.Lifecycle.Init));
        TicketAddress.setOwnerAddress(msg.sender);
        ownerBalance = gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"), msg.sender);
        ownerBalance = ownerBalance.add(TicketAddress.getValue());//退票员退票的总价值
        gs.mapUpdateAddressToUint(keccak256("Activity","ownerBalance"), msg.sender, TicketAddress.getValue());


        /*ownerBalance[ticketOwnerAddress[_ticket]]=ownerBalance[ticketOwnerAddress[_ticket]].sub(ticketValue[_ticket]);
        organization.redeem(ticketOwnerAddress[_ticket],ticketValue[_ticket]);
        ticketOwnerAddress[_ticket]=msg.sender;
        delete ticketAllowed[_ticket];
        ticketStatus[_ticket]=Lifecycle.Init;*/

        e_reclaim(msg.sender, _ticket);
        return true;

    }

    event e_checkIn(address _sender, bytes32 _ticket);
    //检票入场 sender =taker
    function checkIn(bytes32 _ticket) public returns (bool){
        //    require(ticketStatus[_ticket]==Lifecycle.Normal);

        Ticket TicketAddress = Ticket(gs.mapReadBytes32ToAddress(keccak256("Activity","Ticket"),_ticket));
        require(Lib.explainLifecycle(TicketAddress.getTicketStatus())==Lib.Lifecycle.Normal);
        uint256 ownerBalance = gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"), msg.sender);
        ownerBalance = ownerBalance.add(TicketAddress.getValue());//检票员检票的总价值
        gs.mapUpdateAddressToUint(keccak256("Activity","ownerBalance"), msg.sender, ownerBalance);
        //    TicketAddress.setOwnerAddress(msg.sender);
        TicketAddress.setTicketStatus(Lib.interpretLifecycle(Lib.Lifecycle.Finished));

        /*ticketOwnerAddress[_ticket]=msg.sender;
        ownerBalance[msg.sender]=ownerBalance[msg.sender].add(ticketValue[_ticket]);//检票员检票的总价值
        ticketStatus[_ticket]=Lifecycle.Finished;*/

        e_checkIn(msg.sender, _ticket);
        return true;
    }

    event e_halfTime(address _sender, bytes32 _ticket, bool _in);
    //中场迁出 sender =taker (take-out)
    function halfTimeCheckOut(bytes32 _ticket) public returns (bool) {
        //    require(ticketStatus[_ticket]==Lifecycle.Finished);

        Ticket TicketAddress = Ticket(gs.mapReadBytes32ToAddress(keccak256("Activity","Ticket"),_ticket));
        require(Lib.explainLifecycle(TicketAddress.getTicketStatus())==Lib.Lifecycle.Finished);
        TicketAddress.setTicketStatus(Lib.interpretLifecycle(Lib.Lifecycle.Locked));

        //    ticketStatus[_ticket]=Lifecycle.Locked;
        e_halfTime(msg.sender,_ticket,false);
        return true;
    }

    //中场迁入 sender =taker (take-in)
    function halfTimeCheckIn(bytes32 _ticket) public returns (bool) {
        //    require(ticketStatus[_ticket]==Lifecycle.Locked);

        Ticket TicketAddress = Ticket(gs.mapReadBytes32ToAddress(keccak256("Activity","Ticket"),_ticket));
        require(Lib.explainLifecycle(TicketAddress.getTicketStatus())==Lib.Lifecycle.Locked);
        TicketAddress.setTicketStatus(Lib.interpretLifecycle(Lib.Lifecycle.Finished));

        //    ticketStatus[_ticket]=Lifecycle.Finished;
        e_halfTime(msg.sender,_ticket,true);
        return true;
    }

    event e_assign(address _sender, address _from, address _to, bytes32 _ticket);
    //转让(赠票) sender = system
    function assign(address _from, address _to, bytes32 _ticket) public returns (bool) {
        /*require(ticketStatus[_ticket] ==Lifecycle.Normal);
        require(_to != address(0));
        require(_from != address(0));
        require(ticketOwnerAddress[_ticket] == _from);
        require(ticketAllowed[_ticket] == _to);*/
        require(_to != address(0));
        require(_from != address(0));
        Ticket TicketAddress = Ticket(gs.mapReadBytes32ToAddress(keccak256("Activity","Ticket"),_ticket));
        require(Lib.explainLifecycle(TicketAddress.getTicketStatus())==Lib.Lifecycle.Normal);
        require(TicketAddress.getOwnerAddress()==_from);

        uint256 ownerBalance = gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"), _from);
        ownerBalance = ownerBalance.sub(TicketAddress.getValue());
        gs.mapUpdateAddressToUint(keccak256("Activity","ownerBalance"), _from, ownerBalance);
        ownerBalance = gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"), _to);
        ownerBalance = ownerBalance.add(TicketAddress.getValue());
        gs.mapUpdateAddressToUint(keccak256("Activity","ownerBalance"), _to, ownerBalance);
        TicketAddress.setAllowed(address(0));
        TicketAddress.setOwnerAddress(_to);

        /*ownerBalance[_from]=ownerBalance[_from].sub(ticketValue[_ticket]);
        ownerBalance[_to]=ownerBalance[_to].add(ticketValue[_ticket]);
        ticketOwnerAddress[_ticket] = _to;
        delete ticketAllowed[_ticket];*/

        organization.assign(_from,_to,TicketAddress.getValue());

        e_assign(msg.sender,_from,_to,_ticket);
        return true;
    }

    event e_deal(address _sender, address _from, address _to, bytes32 _ticket);
    //交易 sender = system
    function deal(address _from, address _to, bytes32 _ticket) public returns (bool) {
        /*require(ticketStatus[_ticket] ==Lifecycle.Normal);
        require(_to != address(0));
        require(_from != address(0));
        require(ticketOwnerAddress[_ticket] == _from);
        require(ticketAllowed[_ticket] == _to);*/
        require(_to != address(0));
        require(_from != address(0));
        Ticket TicketAddress = Ticket(gs.mapReadBytes32ToAddress(keccak256("Activity","Ticket"),_ticket));
        require(Lib.explainLifecycle(TicketAddress.getTicketStatus())==Lib.Lifecycle.Normal);
        require(TicketAddress.getOwnerAddress()==_from);

        uint256 ownerBalance = gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"), _from);
        ownerBalance = ownerBalance.sub(TicketAddress.getValue());
        gs.mapUpdateAddressToUint(keccak256("Activity","ownerBalance"), _from, ownerBalance);
        ownerBalance = gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"), _to);
        ownerBalance = ownerBalance.add(TicketAddress.getValue());
        gs.mapUpdateAddressToUint(keccak256("Activity","ownerBalance"), _to, ownerBalance);
        TicketAddress.setAllowed(address(0));
        TicketAddress.setOwnerAddress(_to);

        /*ownerBalance[_from]=ownerBalance[_from].sub(ticketValue[_ticket]);
        ownerBalance[_to]=ownerBalance[_to].add(ticketValue[_ticket]);
        ticketOwnerAddress[_ticket] = _to;
        delete ticketAllowed[_ticket];*/

        organization.deal(_from,_to,TicketAddress.getValue());

        e_deal(msg.sender,_from,_to,_ticket);
        return true;
    }



    event e_approve(address _sender,address _spender, bytes32 _ticket);
    //sender = owner
    function approve(address _spender, bytes32 _ticket) public returns (bool) {
        /*require(_spender != address(0));
        require(ticketOwnerAddress[_ticket] == msg.sender);
        require(ticketStatus[_ticket] == Lifecycle.Normal);*/

        require(_spender != address(0));
        Ticket TicketAddress = Ticket(gs.mapReadBytes32ToAddress(keccak256("Activity","Ticket"),_ticket));
        require(Lib.explainLifecycle(TicketAddress.getTicketStatus())==Lib.Lifecycle.Normal);
        require(TicketAddress.getOwnerAddress()==msg.sender);

        TicketAddress.setAllowed(_spender);
        /*ticketAllowed[_ticket]=_spender;*/

        e_approve(msg.sender,_spender,_ticket);
        return true;
    }

    function allowance(bytes32 _ticket, address _spender) public constant returns (bool) {
        Ticket TicketAddress = Ticket(gs.mapReadBytes32ToAddress(keccak256("Activity","Ticket"),_ticket));
        if(TicketAddress.getAllowed() == _spender){
            return true;
        }
        return false;
    }

    function stakeOf(address _owner) public constant returns (uint256) {
        return gs.mapReadAddressToUint(keccak256("Activity","ownerBalance"), _owner);
    }













    /*

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
*/
}