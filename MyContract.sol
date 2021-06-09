// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

contract MyContract{
    uint256 public myUint;
    // string public myString='hello world';
    
    function setMyUint(uint s) public {
        myUint=s;
    }
}
