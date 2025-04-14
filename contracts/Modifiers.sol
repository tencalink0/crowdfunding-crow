//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Modifiers {
    modifier onlyCreator(address _creator) {
        require(msg.sender == _creator, "Unauthorised access");
        _;
    }

    modifier beforeDeadline(uint32 _deadline) {
        require(block.timestamp < _deadline, "The deadline has passed");
        _;
    }

    modifier afterDeadline(uint32 _deadline) {
        require(block.timestamp > _deadline, "The deadline has not yet been reached");
        _;
    }
}