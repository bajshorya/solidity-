// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract BajCoin{
    address public owner;
    uint public totalSupply;
    mapping (address => uint) public  balances;
    constructor(){
        owner=msg.sender;
    }
    function mint (uint amount) public {
        require(owner==msg.sender);
        balances[owner]+=amount;
        totalSupply+=amount;
    }
    function mintTo (uint amount , address to ) public {
        require(owner==msg.sender);
        balances[to]+=amount;
        totalSupply+=amount;
    }
    function transfer(uint amount, address to) public {
        uint existingBalance=balances[msg.sender];
        require(existingBalance>=amount);
        balances[msg.sender]-=amount;
        balances[to]+=amount;
    }
}