// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DocumentTracker {

    enum ConfidentialityLevel {
        PUBLIC,
        SECRET,
        TOPSECRET
    }

    struct Data {
        string Title;
        MetaData data;
        ConfidentialityLevel level;
    }
    struct MetaData {
        bytes32 MetaDataHash;
        string Name;
        string[] Owner;
        string Type;
        string Size;
        string LastModifiedDate;
    }



    //Assuming the bytes32 mentioned here is unique
    mapping(string => Data) public documentMapping;

    function upload(string memory  _identifier,Data memory _data) public returns(string memory){
        // //TO make sure an existing data is not over written 
        // require(!(documentMapping[_identifier]),"Document with the same document id exists");
        // bytes32 _hash = _data.data.MetaDataHash;
        // //makeing sure the hash of the metadata is equal to the provided hash
        // bytes32 newHash = keccak256(abi.encodePacked(_data.Title,_data.data.Name,_data.data.Type,_data.data.Size,_data.data.LastModifiedDate,_data.level));
        // require(newHash == _data.data.MetaDataHash,"The provided hash is not equal to the hash the metadata");
        //Updating the storage 
        documentMapping[_identifier] = _data;

        return(_identifier);
    }

    function transferOwnerShip(string memory _identifier,string[] memory _newOwner) public returns(string memory){
        Data memory currentData = documentMapping[_identifier];
        currentData.data.Owner = _newOwner;
        documentMapping[_identifier] = currentData;
        return(_identifier);


    }

    function retrieveData(string memory _identifier) public view  returns(Data memory){
        return(documentMapping[_identifier]);
    }
}
