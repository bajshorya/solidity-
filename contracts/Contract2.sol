// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
interface IStorage{
    function getNum() external  view returns (uint);
    function add() external  ;

}
contract Contract2{
    constructor(){

    }
    function proxyAdd() public {
        IStorage(0xD4Fc541236927E2EAf8F27606bD7309C1Fc2cbee).add();
    }
    function proxyGet() public  view returns(uint){
        uint value = IStorage(0xD4Fc541236927E2EAf8F27606bD7309C1Fc2cbee).getNum();
        return value;
    }
}