// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Persons{
    struct Person{
      string name;
      uint256 age;
      address add;
    }
    mapping (address=>Person) public persons;
    function setPerson(uint256 _age, string memory _name) public {
      persons[msg.sender]=Person({
         name:_name,
         age:_age,
         add:msg.sender
      });
    }
    function getPerson() public view returns (string memory,uint256,address){
      Person memory person=persons[msg.sender];
      return (person.name,person.age,person.add);
    }
}