// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract gasslessAndSearch{

    function containsKeyword(string memory _str, string memory _keyword) internal pure returns (bool) {
        bytes memory strBytes = bytes(_str);
        bytes memory keywordBytes = bytes(_keyword);

        uint256 keywordLength = keywordBytes.length;
        if (keywordLength == 0) {
            return false;
        }

        for (uint256 i = 0; i <= strBytes.length - keywordLength; i++) {
            bool found = true;
            for (uint256 j = 0; j < keywordLength; j++) {
                if (strBytes[i + j] != keywordBytes[j]) {
                    found = false;
                    break;
                }
            }
            if (found) {
                return true;
            }
        }
        return false;
    }

     mapping(address => uint256) public nonces;
    event GaslessTransaction(address indexed user, uint256 indexed nonce);

    function gaslessTransaction(uint256 _nonce, bytes memory _signature) public {
        require(_nonce == nonces[msg.sender] + 1, "Invalid nonce");
        bytes32 messageHash = keccak256(abi.encodePacked(msg.sender, _nonce));
        address recoveredAddress = recoverSigner(messageHash, _signature);
        require(recoveredAddress == msg.sender, "Invalid signature");
        nonces[msg.sender]++;
        emit GaslessTransaction(msg.sender, _nonce);
    }

    function recoverSigner(bytes32 _messageHash, bytes memory _signature) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }
        if (v < 27) {
            v += 27;
        }
        return ecrecover(_messageHash, v, r, s);
    }

}

