// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DocumentTracker {

    enum ConfidentialityLevel {
        PUBLIC,
        SECRET,
        TOPSECRET
    }

    struct Data {
        MetaData data;
        mapping(address=>bool) owners;
        uint256 _initialised;
    }
    struct MetaData {
        string Title;
        bytes32 MetaDataHash;
        string Name;
        string Type;
        string Size;
        string LastModifiedDate;
        ConfidentialityLevel level;

    }



    //Assuming the bytes32 mentioned here is unique
    mapping(string => Data) public documentMapping;

    event OwnerShipTransfer(address _oldOwner,address _newOwner);

    event Upload(string _identifier);

    function upload(string memory  _identifier,MetaData memory _metaData) public returns(string memory){
        require(documentMapping[_identifier]._initialised!=1,"document with this id already exist");
        // //TO make sure an existing data is not over written 
        // require(!(documentMapping[_identifier]),"Document with the same document id exists");
        // bytes32 _hash = _data.data.MetaDataHash;
        // //makeing sure the hash of the metadata is equal to the provided hash
        // bytes32 newHash = keccak256(abi.encodePacked(_data.Title,_data.data.Name,_data.data.Type,_data.data.Size,_data.data.LastModifiedDate,_data.level));
        // require(newHash == _data.data.MetaDataHash,"The provided hash is not equal to the hash the metadata");
        //Updating the storage 
        documentMapping[_identifier].data = _metaData;
        documentMapping[_identifier].owners[msg.sender] = true;
        documentMapping[_identifier]._initialised = 1;
        emit Upload(_identifier);
        return(_identifier);
    }

    function addNewOwner(string memory _identifier,address ownerAddress) public {
        require(documentMapping[_identifier].owners[msg.sender],"You are not a owner of this file");
        documentMapping[_identifier].owners[ownerAddress] = true;
        //if the ownership transfer from 0 address to a new address then it is ownerAddress
        emit OwnerShipTransfer(address(0),ownerAddress);


    }

    function transferOwnerShip(string memory _identifier,address newOwner) public {
        require(documentMapping[_identifier].owners[msg.sender], " You are not the owner of this id");
        //changing current ownership to false 
        documentMapping[_identifier].owners[msg.sender] = false;
        documentMapping[_identifier].owners[newOwner] = true;
        emit OwnerShipTransfer(msg.sender,newOwner);
    }

    function retrieveData(string memory _identifier) public view  returns(MetaData memory){

        require(documentMapping[_identifier].owners[msg.sender], " You are not the owner of this id");

        return(documentMapping[_identifier].data);
    }
}
