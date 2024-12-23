// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Will{
    uint startTime;
    uint tenYears;
    uint public lastVisited;
    address owner;

    address payable recepient;
    uint private amount;

    constructor(address payable  _recepient) {
       tenYears=10;
       startTime=block.timestamp;
       lastVisited=block.timestamp;
       owner=msg.sender;
       recepient=_recepient; 
    }
    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }
    modifier onlyRecepient(){
        require(msg.sender==recepient);
        _;
    }
    function deposit() public payable onlyOwner{
        lastVisited=block.timestamp;
    }
    function ping() public onlyOwner{
        lastVisited=block.timestamp;
    }
    function claim()external onlyRecepient{
        require(lastVisited < block.timestamp-tenYears);
        payable(recepient).transfer(address(this).balance);    
    }   
}
