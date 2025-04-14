//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract CrowdFunding {
    struct Campaign {
        address creator;
        uint goal;
        uint pledged;
        uint32 deadline;
        bool claimed;
        mapping(address => uint) contributions;
    }

    // campaign id -> campaign 
    mapping(uint => Campaign) public campaigns;

    
}