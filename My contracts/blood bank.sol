//SPDX-License-Identifier: GPL-3.0
//vishal nakhate

pragma solidity ^0.8.0;

contract bloodBank{
    
    //owner of the contract  is hospital
    address owner;

    constructor(){
        owner= msg.sender;
    }

    //used for defining petient type
    enum patientType{
        Donor,
        Receiver
    }

    //use for storing blood transactions
    struct bloodTransaction{
        patientType patientType;
        uint256 time;
        address from;
        address to;
    }

    //used for storing single patient record
    struct patient{
        uint  aadhar;
        string name;
        uint age;
        string bloodGroup;
        uint contact;
        string homeAddress;
        bloodTransaction[] bT;
    }

    //array is used to store all the patientRecord so it can fetched at once
    patient[] patientRecord;
    
    //mapping is used to map the aadhar card with the index number of array
    // where patient record is stored
    mapping (uint=>uint) patientRecordIndex;

    //used for notifying if function is executed or not 
    event successful(string message);

    //Register a new person
    function newPatient(
        string memory _name, uint _age, string memory _bloodGroup, uint _contact, 
        string memory _homeAddress, uint _aadhar) external {
        //check if the sender is owner or not
        require(msg.sender == owner, "only hospital admin can register new patient");
        //get the length of array
        uint index= patientRecord.length;

        //insert records 
        patientRecord.push();
        patientRecord[index].name= _name;
        patientRecord[index].age= _age;
        patientRecord[index].bloodGroup= _bloodGroup; 
        patientRecord[index].contact= _contact; 
        patientRecord[index].homeAddress= _homeAddress; 
        patientRecord[index].aadhar= _aadhar;

        //store the array index in the map against the user aadhar number
        patientRecordIndex[_aadhar] = index;

        emit successful ("patient information added successfully");
        }

        //function to get specific user data
        function getPatientRecord(uint _aadhar) external view returns (patient memory){
        uint index= patientRecordIndex[_aadhar];
        return patientRecord[index];
        }

        //function to get all the records
        function getAllRecord() external view returns(patient[] memory ){
            return patientRecord;
        }
    

        //function store blood transaction
        function bloodTxn(uint256 _aadhar, patientType _type, address _from, address _to) external{
            //check if sender is hospital or not
            require(msg.sender==owner, "only hospital can update the patient blood transaction data");
        
        //get at which index the patient registration detials are saved
        uint index = patientRecordIndex[_aadhar];

        //insert blood transaction in the record
        bloodTransaction memory txnObject= bloodTransaction({
            patientType: _type, 
            time:block.timestamp, 
            from: _from, 
            to: _to
        });

        patientRecord[index].bT.push(txnObject);

        emit successful("patient blood transaction data is updated successfully");
        
        }

}