pragma solidity ^0.4.18;

import './SafeMath.sol';
import './STL.sol';
import './STLStorage.sol';
import './Random.sol';

contract STLTest {

    using SafeMath for uint256;
    using STL for STL.List;

    Random random;
    STLStorage stlStorage;
    /*    function STLTest(Random _r, STLStorage _s) public payable{
            random = _r;
            stlStorage = _s;
        }*/
    function STLTest() public payable{
        random = new Random() ;
        stlStorage = new STLStorage();
    }

    STL.List list;

    function test1() public returns (bytes32,uint256) {
        list = STL.initList("myname","arrayList",random,stlStorage);
        list.add("a");
        list.add("b");
        list.remove();
        bytes32 ret = list.get(0);
        uint256 length = list.getLength();
        return (ret,length);
    }
    function test2() public returns (bytes32,uint256) {
        list = STL.initList("yourname","linkedList",random,stlStorage);
        list.add("a");
        list.add("b");
        list.remove();
        bytes32 ret = list.get(0);
        uint256 length = list.getLength();
        return (ret,length);
    }
}