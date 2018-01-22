pragma solidity ^0.4.18;

import "./GeneralStorage.sol";

library SQL {
    // keccak256("meta","tableName") list, stores all table's names
    // keccak256("meta",_tableId) "tablePropertyXXX" => XXX map,stores all table's properties
    // keccak256("meta",_tableId,"columnName") list, stores all tables' columns' name
    // keccak256("meta",_tableId,_columnId) "columnPropertyXXX" => XXX map,stores all column's properties
    // keccak256("meta",_tableId,_columnId,"data") map:id => data OR uniqueMap id => data, the data of number Id
    // keccak256("meta",_tableId,_columnId,"point") _point => data ,insure auto increase
    // keccak256("meta",_tableId,"internalId") list, contains exist internalId.
    // keccak256("meta",_tableId,"internalId") "point" => last internalId, insure that point is autoIncrease

    //Column Types:
    enum ColumnType{EMPTY,BYTES32,UINT256,ADDRESS,BOOL,/*add more enum here, */LAST}

    function explainColumnTypeIndex(uint256 _value) internal constant returns (ColumnType) {
        require(_value < uint256(ColumnType.LAST) );
        return ColumnType(_value);
    }

    function validateColumnType(uint256 _value) internal constant returns (bool) {
        if(_value < uint256(ColumnType.LAST)){
            return true;
        }
        return false;
    }

    function interpretColumnType(ColumnType ct) internal constant returns (uint256){
        return uint256(ct);
    }

    //=================================table=================================
    function createTable(GeneralStorage _gs, bytes32 _tableName) public returns (bool){
        require(_gs.listCreateBytes32(keccak256("meta","tableName"),_tableName));
        uint tableId = _gs.listIndexOfBytes32(keccak256("meta","tableName"),_tableName);
        _gs.mapCreateBytes32ToUint(keccak256("meta",_tableId,"internalId"),"point",0);

        createColumn(_gs,tableId,"deleted",4,false,true,false);
        return true;
    }
    function isTable(GeneralStorage _gs, bytes32 _tableName) public constant returns (bool){
        uint256 ret = getTableId(_gs,_tableName);
        if(ret==0){
            return false;
        }else{
            return true;
        }
    }

    function isTable(GeneralStorage _gs, uint256 _tableId) public constant returns (bool){

        return _gs.listValidateBytes32(keccak256("meta","tableName"),_tableId);
    }

    function getTableId(GeneralStorage _gs, bytes32 _tableName) public constant returns (uint256){
        return _gs.listIndexOfBytes32(keccak256("meta","tableName"),_tableName);

    }

    function updateTable(GeneralStorage _gs, bytes32 _tableNameOld, bytes32 _tableNameNew) public returns (bool){
        require(isTable(_gs,_tableNameOld));
        require(_gs.listUpdateBytes32(keccak256("meta","tableName"),_gs.listIndexOfBytes32(keccak256("meta","table"),_tableNameOld),_tableNameNew));
        return true;
    }

    //=================================table=================================

    //=================================column=================================

    function createColumn(GeneralStorage _gs, uint256 _tableId, bytes32 columnName, uint256 _columnType, bool _unique, bool _notNull, bool _autoIncrease) public returns (bool){
        require(isTable(_gs,_tableId));
        require(_gs.listCreateBytes32(keccak256("meta",_tableId,"columnName"),columnName));
        require(validateColumnType(_columnType));
        if(_autoIncrease = true){
            //to do
        }
        uint256 columnId = getColumnId(_gs, _tableId, columnName);

        _gs.mapCreateBytes32ToUint(keccak256("meta",_tableId,columnId),"columnPropertyType",_columnType);
        _gs.mapCreateBytes32ToBool(keccak256("meta",_tableId,columnId),"columnPropertyNotNull",_notNull);
        _gs.mapCreateBytes32ToBool(keccak256("meta",_tableId,columnId),"columnPropertyAutoIncrease",_autoIncrease);
        _gs.mapCreateBytes32ToBool(keccak256("meta",_tableId,columnId),"columnPropertyUnique",_unique);
        return true;
    }

    function isColumn(GeneralStorage _gs, bytes32 _tableName, bytes32 columnName) public constant returns(bool){
        uint256 ret = _gs.listIndexOfBytes32(keccak256("meta",_tableName,"columnName"), columnName);
        if(ret==0){
            return false;
        }else{
            return true;
        }
    }

    function getColumnId(GeneralStorage _gs, uint256 _tableId, bytes32 columnName) public constant returns(uint256){
        return _gs.listIndexOfBytes32(keccak256("meta",_tableId,"columnName"), columnName);
    }

    function getColumnName(GeneralStorage _gs, uint256 _tableId, uint256 columnId)public constant returns(bytes32){
        return _gs.listReadBytes32(keccak256("meta",_tableId,"columnName"), columnId);
    }


    //=================================column=================================

    //=================================data=================================

    function createRecord(GeneralStorage _gs, uint256 _tableId ) public returns(uint256){
        uint256 point = _gs.mapReadBytes32ToUint(keccak256("meta",_tableId,"internalId"),"point");
        point=point.incr();
        _gs.mapSetBytes32ToUint(keccak256("meta",_tableId,"internalId"),"point",point);
        _gs.listCreateUint(keccak256("meta",_tableId,"internalId"),point);
        return point;
    }

    function setRecord(GeneralStorage _gs, uint256 _tableId, uint256 _internalId, data) public returns(uint256){

    }

    function deleteRecord(GeneralStorage _gs, uint256 _tableId, uint256 _internalId) public returns (bool){
        require(_gs.listContainsUint(keccak256("meta",_tableId,"internalId"),_internalId));
        //delete all data refered by this _internalId;
        //todo
        //delete this _internalId
        _gs.listDeleteUint(keccak256("meta",_tableId,"internalId"),_gs.listIndexOfUint(keccak256("meta",_tableId,"internalId"),_internalId));
        return true;
    }


    //=================================data=================================
}