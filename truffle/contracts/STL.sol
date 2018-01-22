pragma solidity ^0.4.18;

import './SafeMath.sol';
import './Random.sol';
import './STLStorage.sol';
import './Random.sol';

library STL {
    using SafeMath for uint256;

    struct List{
        bytes32 l_name;
        bytes32 l_guid;//id is 32-bit random unique numer;
        //    uint256 type;//0 for unknow, 1 for uint256, 2 for bytes32 .3 for.....
        bytes32 l_mode;// ARRAYLIST, LINKEDLIST
        uint256 l_length;
        Random l_random;
        STLStorage l_storage;
    }

    bytes32 constant public ARRAYLIST = "arrayList";
    bytes32 constant public LINKEDLIST = "linkedList";

    bytes32 constant NAME = keccak256("name");
    //   bytes32 constant GUID = keccak256("guid");
    bytes32 constant MODE = keccak256("mode");
    bytes32 constant LENGTH = keccak256("length");

    /*    bytes32 constant DATA = "data";

        bytes32 constant COUNTER = keccak256("counter");
        bytes32 constant INDEX = keccak256("index");*/

    //array-list
    //map struct ->    guid  =>    LENGTH => length     MODE => mode     i(index) => data
    //linked-list
    //map struct ->    guid  =>    LENGTH => length     MODE => mode     i(uid)+data => data
    //map struct ->    guid  =>    LENGTH => length     MODE => mode     i(uid)+prev-uid => prev-uid
    //map struct ->    guid  =>    LENGTH => length     MODE => mode     i(uid)+next-uid => next-uid

    function initList(bytes32 _name, bytes32 _mode, Random _random, STLStorage _storage) internal returns (List){
        require(keccak256(_mode) == keccak256(ARRAYLIST) || keccak256(_mode) == keccak256(LINKEDLIST));
        bytes32 guid =  _random.random();
        populateList(_name,_mode,guid,_storage);
        List memory ret = List(_name, guid, _mode, 0, _random, _storage);
        return ret;
    }

    function populateList(bytes32 _name, bytes32 _mode, bytes32 _guid, STLStorage _storage) internal returns (bool){
        _storage.mapBytes32ToBytes32Set(_guid,NAME, _name);
        _storage.mapBytes32ToBytes32Set(_guid,MODE, _mode);
        _storage.mapBytes32ToUintSet(_guid,LENGTH, 0);
        if(keccak256(_mode) == keccak256 (LINKEDLIST)){
            _storage.mapBytes32ToBytes32Set(_guid,keccak256("start","data"), bytes32(0));
            _storage.mapBytes32ToBytes32Set(_guid,keccak256("start","prev-uid"), bytes32(0));
            _storage.mapBytes32ToBytes32Set(_guid,keccak256("start","next-uid"), bytes32("end"));
            _storage.mapBytes32ToBytes32Set(_guid,keccak256("end","data"), bytes32(0));
            _storage.mapBytes32ToBytes32Set(_guid,keccak256("end","prev-uid"), bytes32("start"));
            _storage.mapBytes32ToBytes32Set(_guid,keccak256("end","next-uid"), bytes32(0));
        }
        return true;
    }

    function getLength(List storage _self) public view returns (uint256){
        STLStorage _storage = _self.l_storage;
        /*uint256 l = _storage.mapBytes32ToUintGet(_self.l_guid,LENGTH);
        require(l == _self.l_length);*/
        return _storage.mapBytes32ToUintGet(_self.l_guid,LENGTH);//as same as l_length, to make double assurance
        //    return _self.l_length//to save gas
    }

    function setLength(List storage _self, uint256 _length) internal returns (bool){
        STLStorage _storage = _self.l_storage;
        _storage.mapBytes32ToUintSet(_self.l_guid,LENGTH, _length);
        _self.l_length = _length;
        return true;
    }

    function incrLength(List storage _self) public returns (uint256){
        STLStorage _storage = _self.l_storage;
        uint256 l = _storage.mapBytes32ToUintGet(_self.l_guid,LENGTH);
        l = l.incr();
        _storage.mapBytes32ToUintSet(_self.l_guid,LENGTH, l);
        _self.l_length = l;
        return l;
    }

    function decrLength(List storage _self) public returns (uint256){
        STLStorage _storage = _self.l_storage;
        uint256 l = _storage.mapBytes32ToUintGet(_self.l_guid,LENGTH);
        l = l.decr();
        _storage.mapBytes32ToUintSet(_self.l_guid,LENGTH, l);
        _self.l_length = l;
        return l;
    }

    function isArrayList(List storage _self) public view returns (bool){
        STLStorage _storage = _self.l_storage;
        bytes32 m = _storage.mapBytes32ToBytes32Get(_self.l_guid,MODE);
        if(keccak256(m) == keccak256 (ARRAYLIST)){
            return true;
        }
        return false;
    }

    function isLinkedList(List storage _self) public view returns (bool){
        STLStorage _storage = _self.l_storage;
        bytes32 m = _storage.mapBytes32ToBytes32Get(_self.l_guid,MODE);
        if(keccak256(m) == keccak256 (LINKEDLIST)){
            return true;
        }
        return false;
    }


    //interface function

    //queue-style
    //add = append one to the end of list(queue)
    function add(List storage _self, bytes32 _value) public returns (uint256){
        return abstract_insert(_self, getLength(_self), _value);
    }

    //queue-style
    //remove = remove the first element of list(queue) and return it
    function remove(List storage _self) public returns (bytes32){
        return abstract_delete(_self, 0);
    }

    //queue-style
    //peek = just get the firt element of list(queue)
    function peek(List storage _self) public view returns (bytes32){
        return get(_self, 0);
    }

    //non-style
    //insert = insert the provided value into the position, which means all subsequent elements will be moved backforwards
    //return new length
    function insert(List storage _self, uint256 _index, bytes32 _value) public returns (uint256){
        return abstract_insert(_self, _index, _value);
    }

    //non-style
    //set = set the index number element to provided value
    function set(List storage _self, uint256 _index, bytes32 _value) public returns (bytes32){
        return abstract_set(_self, _index, _value);
    }

    function get(List storage _self, uint256 _index) public view returns (bytes32){
        return abstract_get(_self, _index);
    }


    function abstract_insert(List storage _self, uint256 _index, bytes32 _value) internal returns (uint256){
        if(isArrayList(_self)){
            return arrayList_insert(_self, _index, _value);
        }
        if(isLinkedList(_self)){
            return linkedList_insert(_self, _index, _value);
        }
    }

    function abstract_delete(List storage _self, uint256 _index) internal returns (bytes32){
        if(isArrayList(_self)){
            return arrayList_delete(_self, _index);
        }
        if(isLinkedList(_self)){
            return linkedList_delete(_self, _index);
        }
    }

    function abstract_set(List storage _self, uint256 _index, bytes32 _value) internal returns (bytes32){
        if(isArrayList(_self)){
            return arrayList_set(_self, _index, _value);
        }
        if(isLinkedList(_self)){
            return linkedList_set(_self, _index, _value);
        }
    }

    function abstract_get(List storage _self, uint256 _index) internal view returns (bytes32){
        if(isArrayList(_self)){
            return arrayList_get(_self, _index);
        }
        if(isLinkedList(_self)){
            return linkedList_get(_self, _index);
        }
    }

    //part 1 : array list
    //index starts from 0,

    // index can be any position of list AND the last+1 (which means append)
    function arrayList_insert(List storage _self, uint256 _index, bytes32 _value) internal returns (uint256){
        uint256 l = getLength(_self);
        require(_index <= l);
        STLStorage _storage = _self.l_storage;
        for(uint256 i = l; i > _index; i = i.decr()){
            _storage.mapUintToBytes32Set(_self.l_guid,i, _storage.mapUintToBytes32Get(_self.l_guid, i.decr()));
        }
        _storage.mapUintToBytes32Set(_self.l_guid,_index, _value);
        incrLength(_self);
        return getLength(_self);
    }

    //index can be any position of list
    function arrayList_delete(List storage _self, uint256 _index) internal returns (bytes32){
        uint256 l = getLength(_self);
        require(_index < l);
        STLStorage _storage = _self.l_storage;
        bytes32 ret =  _storage.mapUintToBytes32Get(_self.l_guid,_index);
        for(uint256 i = _index; i < l.decr(); i = i.incr()){
            _storage.mapUintToBytes32Set(_self.l_guid,i, _storage.mapUintToBytes32Get(_self.l_guid, i.incr()));
        }
        _storage.mapUintToBytes32Set(_self.l_guid, getLength(_self).decr(), bytes32(0));
        decrLength(_self);
        return ret;
    }

    //index can be any position of list, return orginal value which is being replaced by provided value
    function arrayList_set(List storage _self, uint256 _index, bytes32 _value) internal returns (bytes32){
        uint256 l = getLength(_self);
        require(_index < l);
        STLStorage _storage = _self.l_storage;
        bytes32 ret =  _storage.mapUintToBytes32Get(_self.l_guid,_index);
        _storage.mapUintToBytes32Set(_self.l_guid,_index,_value);
        return ret;
    }

    function arrayList_get(List storage _self, uint256 _index) internal view returns (bytes32){
        uint256 l = getLength(_self);
        require(_index < l);
        STLStorage _storage = _self.l_storage;
        bytes32 ret = _storage.mapUintToBytes32Get(_self.l_guid, _index);
        return ret;
    }

    //part 2 linked list
    //index starts from 0,
    //addition node whose uid is "start" represents start node, so does "end"
    //start => 1 => 2 => .... => 4 => end

    // index can be any position of list AND the last+1 (which means append)
    function linkedList_insert(List storage _self, uint256 _index, bytes32 _value) internal returns (uint256){
        uint256 l = getLength(_self);
        require(_index <= l);
        STLStorage _storage = _self.l_storage;
        bytes32 _uid;
        bytes32 data;
        bytes32 prev_uid;
        bytes32 next_uid;
        (_uid, data, prev_uid, next_uid) = linkedList_find(_self,_index);
        bytes32 new_uid =  _self.l_random.random();

        _storage.mapBytes32ToBytes32Set(_self.l_guid,keccak256(new_uid,"data"),_value);
        _storage.mapBytes32ToBytes32Set(_self.l_guid,keccak256(new_uid,"prev-uid"),prev_uid);
        _storage.mapBytes32ToBytes32Set(_self.l_guid,keccak256(new_uid,"next-uid"),_uid);

        _storage.mapBytes32ToBytes32Set(_self.l_guid,keccak256(_uid,"prev-uid"),new_uid);

        incrLength(_self);
        return getLength(_self);
    }

    //index can be any position of list
    function linkedList_delete(List storage _self, uint256 _index) internal returns (bytes32){
        uint256 l = getLength(_self);
        require(_index <= l);
        STLStorage _storage = _self.l_storage;
        bytes32 _uid;
        bytes32 data;
        bytes32 prev_uid;
        bytes32 next_uid;
        (_uid, data, prev_uid, next_uid) = linkedList_find(_self,_index);

        _storage.mapBytes32ToBytes32Set(_self.l_guid,keccak256(prev_uid,"next-uid"),next_uid);
        _storage.mapBytes32ToBytes32Set(_self.l_guid,keccak256(next_uid,"prev-uid"),prev_uid);


        _storage.mapBytes32ToBytes32Det(_self.l_guid,keccak256(_uid,"data"));
        _storage.mapBytes32ToBytes32Det(_self.l_guid,keccak256(_uid,"next-uid"));
        _storage.mapBytes32ToBytes32Det(_self.l_guid,keccak256(_uid,"prev-uid"));

        decrLength(_self);
        return data;
    }

    //index can be any position of list, return orginal value which is being replaced by provided value
    function linkedList_set(List storage _self, uint256 _index, bytes32 _value) internal returns (bytes32){
        uint256 l = getLength(_self);
        require(_index <= l);
        STLStorage _storage = _self.l_storage;
        bytes32 _uid;
        bytes32 data;
        bytes32 prev_uid;
        bytes32 next_uid;
        (_uid, data, prev_uid, next_uid) = linkedList_find(_self,_index);
        _storage.mapBytes32ToBytes32Set(_self.l_guid,keccak256(_uid,"data"),_value);
        return data;
    }

    function linkedList_get(List storage _self, uint256 _index) internal view returns (bytes32){
        uint256 l = getLength(_self);
        require(_index <= l);
        bytes32 _uid;
        bytes32 data;
        bytes32 prev_uid;
        bytes32 next_uid;
        (_uid, data, prev_uid, next_uid) = linkedList_find(_self,_index);
        return data;
    }


    function linkedList_find(List storage _self, uint256 _index) internal view returns(bytes32 _uid, bytes32 _data, bytes32 _prev_uid ,bytes32 _next_uid){
        uint256 l = getLength(_self);
        require(_index < l);
        bytes32 next_uid = "start";
        STLStorage _storage = _self.l_storage;
        for(uint256 i = 0;i <= _index; i = i.incr()){
            next_uid = _storage.mapBytes32ToBytes32Get(_self.l_guid,keccak256(next_uid,"next-uid"));
        }
        _uid = next_uid;
        _data = _storage.mapBytes32ToBytes32Get(_self.l_guid,keccak256(next_uid,"data"));
        _prev_uid = _storage.mapBytes32ToBytes32Get(_self.l_guid,keccak256(next_uid,"prev-uid"));
        _next_uid = _storage.mapBytes32ToBytes32Get(_self.l_guid,keccak256(next_uid,"next-uid"));
    }
}