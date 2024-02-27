// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./D4n13lNFTFactory.sol";
import "./gaslessandSearch.sol";

error YOU_ARE_NOT_REGISTERED();
error INVALID_POSTID();
error INVALID_GORUPID();
error YOU_ALREADY_HAVE_ACCOUNT();
error ALREADY_A_MEMBER();
error NOT_A_MEMBER();
error ALREADY_LIKED();

contract SocialMediaPlatform is Factory, gasslessAndSearch{


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

    uint postid;

    struct post{
        address post;
        string uri;
        string [] comments;
        uint likes;
        
    }

    mapping (address => Users) registeredUsers;

    mapping (address => bool) userRegistrationStatus;

    mapping (uint => Group) groupList;

    mapping (uint => bool) createdGroups;

    mapping (uint => mapping(address => bool)) groupMembers;

    mapping(uint => post) PostLists;

    mapping(uint => mapping(address => bool)) likedPost;

    Group [] groups;

    // event userRegistered(address user, string name);
    // event GroupCreated (string _groupname, uint groupid);
    // event JoinedGroup (string _name, address user, string GroupName, uint groupid);
    // event createdPost (address user, uint postid);
    // event CreatedGroupPost (uint groupid, address user, uint postid);
    // event LIkedPost(address who, uint _postID);
    // event Commented(address user, uint postid);

    function userRegistriation(string calldata _name, uint _age) external {
        if(userRegistrationStatus[msg.sender] != false){
            revert YOU_ALREADY_HAVE_ACCOUNT();
        }


        Users storage userReg = registeredUsers[msg.sender];

        userReg.name = _name;
        userReg.age = _age;
        userReg.UserAddress = msg.sender;

        userRegistrationStatus[msg.sender] = true;

        // emit userRegistered(msg.sender, _name);
    }

    function createGroup(string memory _groupName, string memory _description) external {

       onlyRegisteredUsers();

        groupid = groupid + 1;

        Group storage newGroup = groupList[groupid];
        newGroup.name = _groupName;
        newGroup.description = _description;
        newGroup.groupID = groupid;

        groups.push(newGroup);

        createdGroups[groupid] = true;

        groupMembers[groupid][msg.sender] = true;

        // emit GroupCreated(_groupName, groupid);

        
    }

    function joinGroup (uint _groupID) external {
        onlyRegisteredUsers();

        if(createdGroups[_groupID]!= true){
            revert INVALID_GORUPID();
        }

        if(groupMembers[_groupID][msg.sender] != false){
            revert ALREADY_A_MEMBER();
        }
        
        groupMembers[_groupID][msg.sender] = true; 

        groupList[_groupID].groupMembers.push(msg.sender);

        // string memory _name = registeredUsers[msg.sender].name;
        // string memory GroupName = groupList[_groupID].name;

        // emit JoinedGroup(_name, msg.sender, GroupName, _groupID);
    }

    function createNewPost(string calldata _postURI) external {
        onlyRegisteredUsers();
       
       address newPost = createPost(_postURI);

       registeredUsers[msg.sender].postCreated.push(newPost);
       
       postid = postid + 1;

        PostLists[postid].post = newPost;

        PostLists[postid].uri = _postURI;

        // emit createdPost(msg.sender, postid);


    }

    function createGroupPost(string calldata _postURI, uint _groupID) external {
       onlyRegisteredUsers();
       onlyGroupMembers(_groupID);

        if(createdGroups[_groupID]!= true){
            revert INVALID_GORUPID();
        }
        
        
        address newPost = createPost(_postURI);

        groupList[_groupID].groupPosts.push(newPost);

        postid = postid + 1;

        PostLists[postid].post = newPost;
        PostLists[postid].uri = _postURI;

        // emit CreatedGroupPost(_groupID, msg.sender, postid);

    }

    function likePost(uint _postID) external {
        onlyRegisteredUsers();
        
        if(_postID == 0){
            revert INVALID_POSTID();
        }
        if(_postID > postid){
            revert INVALID_POSTID();
        }

        if(likedPost[_postID][msg.sender]!=false){
            revert ALREADY_LIKED();
        }

        

        likedPost[_postID][msg.sender] == true;

        PostLists[_postID].likes++;

        // emit LIkedPost(msg.sender, _postID);
    }

    function comment (uint _postid, string memory _comment) external {
        onlyRegisteredUsers();
        if(_postid == 0){
            revert INVALID_POSTID();
        }
        if(_postid>postid){
            revert INVALID_POSTID();
        }

        
        PostLists[_postid].comments.push(_comment);

        // emit Commented(msg.sender, _postid);

    }

    function getGroups() external view returns (Group [] memory){
        onlyRegisteredUsers();
        return groups;
    }

    function getAllPosts() external view returns(address [] memory){
        onlyRegisteredUsers();
        return Posts;
    }

    function getGroupPosts(uint _groupid) external view returns(address [] memory){
        onlyRegisteredUsers();
        onlyGroupMembers(_groupid);

        if(createdGroups[_groupid]!= true){
            revert INVALID_GORUPID();
        }
        

        
        return groupList[_groupid].groupPosts;
    }

    function getComment(uint _postid) external view returns (string [] memory){
        onlyRegisteredUsers();

        return PostLists[_postid].comments;
    }

    function onlyRegisteredUsers()private view {

        if(userRegistrationStatus[msg.sender]==false){
            revert YOU_ARE_NOT_REGISTERED();
        }
    }

    function onlyGroupMembers(uint _groupid) private view {
        if(groupMembers[_groupid][msg.sender]!=true){
            revert NOT_A_MEMBER();
        }
    }

     

    function searchPosts(string memory _keyword) public view returns (uint256[] memory) {
        uint256[] memory result = new uint256[](postid);
        uint256 count = 0;

        for (uint256 i = 1; i <= postid; i++) {
            if (bytes(PostLists[i].uri).length > 0 && containsKeyword(PostLists[i].uri, _keyword)) {
                result[count] = i;
                count++;
            }
        }

        uint256[] memory finalResult = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            finalResult[i] = result[i];
        }

        return finalResult;
    }
}