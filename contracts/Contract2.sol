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
        IStorage(0x4a9C121080f6D9250Fc0143f41B595fD172E31bf).add();
    }
    function proxyGet() public  view returns(uint){
        uint value = IStorage(0x4a9C121080f6D9250Fc0143f41B595fD172E31bf).getNum();
        return value;
    }
}