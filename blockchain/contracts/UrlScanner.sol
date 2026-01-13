// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UrlScanner {
    event UrlSubmitted(string url);

    function submitUrl(string memory url) public {
        emit UrlSubmitted(url);
    }
}
