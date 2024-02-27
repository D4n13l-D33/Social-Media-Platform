// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./D4n13lNFTFactory.sol";

contract SocialMediaPlatform is Factory{

    struct Users{
        string name;
        uint age;
        address [] postCreated;
        address UserAddress;
    }

    uint groupid;

    struct Group{
        uint groupID;
        string name;
        string description;
        address [] groupPosts;
        address [] groupMembers;
    }

    mapping (address => Users) registeredUsers;

    mapping (address => bool) userRegistrationStatus;

    mapping (uint => Group) groupList;

    mapping (uint => bool) createdGroups;

    mapping (uint => mapping(address => bool)) groupMembers;

    Group [] groups;

    function userRegistriation(string calldata _name, uint _age) external {
        require(userRegistrationStatus[msg.sender] == false, "You have an account already");

        Users storage userReg = registeredUsers[msg.sender];

        userReg.name = _name;
        userReg.age = _age;
        userReg.UserAddress = msg.sender;


    }

    function createGroup(string calldata _groupName, string calldata _description) external {
        require(userRegistrationStatus[msg.sender] == true, "You are not registered");

        Group storage newGroup = groupList[groupid];
        newGroup.name = _groupName;
        newGroup.description = _description;
        newGroup.groupID = groupid;

        groups.push(newGroup);

        createdGroups[groupid] = true;

        groupid += 1;
    }

    function joinGroup (uint _groupID) external {
        require(userRegistrationStatus[msg.sender] == true, "You are not registered");
        require(createdGroups[_groupID]==true, "Invalid Group ID");
        require(groupMembers[_groupID][msg.sender] == false, "Already a member of this group");
        groupMembers[_groupID][msg.sender] = true; 

        groupList[_groupID].groupMembers.push(msg.sender);
    }

    function createNewPost(string calldata _postURI) external {
        require(userRegistrationStatus[msg.sender] == true, "You are not registered");
       address newPost = createPost(_postURI);

       registeredUsers[msg.sender].postCreated.push(newPost);
    }

    function createGroupPost(string calldata _postURI, uint _groupID) external {
        require(userRegistrationStatus[msg.sender] == true, "You are not registered");
        require(createdGroups[_groupID]==true, "Invalid Group ID");
        require(groupMembers[_groupID][msg.sender] == true, "You are not a member of this group");

        address newPost = createPost(_postURI);

        groupList[_groupID].groupPosts.push(newPost);

    }


}