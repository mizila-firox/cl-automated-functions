// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {FunctionsClient} from "lib/chainlink/contracts/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "lib/chainlink/contracts/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";
import {IRouterClient} from "lib/chainlink/contracts/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {IERC20} from "lib/forge-std/src/interfaces/IERC20.sol";

import {OwnerIsCreator} from "lib/chainlink/contracts/src/v0.8/shared/access/OwnerIsCreator.sol";

contract Weather is FunctionsClient, OwnerIsCreator {
    using FunctionsRequest for FunctionsRequest.Request;

    /*//////////////////////////////////////////////////////////////
                            GLOBAL VARIABLES
    //////////////////////////////////////////////////////////////*/

    // FUNCTIONS
    IERC20 linkToken; // sepolia  0x779877a7b0d9e8603169ddbd7836e478b4624789
    IRouterClient router; // seoplia 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0
    bytes32 donId; // sepolia 0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000
    uint64 subscriptionId; // sepolia 3659
    uint32 callbackGasLimit = 300_000;

    string public lastCity;
    bytes32 public lastRequestId;
    bytes public lastResponse;
    bytes public lastError;
    string public lastTemperature;

    string public source =
        "const city = args[0];"
        "const apiResponse = await Functions.makeHttpRequest({"
        "url: `https://wttr.in/${city}?format=3`,"
        "responseType: 'text'"
        "});"
        "if (apiResponse.error) {"
        "throw Error('Request failed');"
        "}"
        "const { data } = apiResponse;"
        "return Functions.encodeString(data);";

    // AUTOMATION
    address public forwarderAddress;

    constructor(
        address linkTokenAddress,
        address _router,
        uint64 _subscriptionId,
        bytes32 _donId,
        uint32 _callbackGasLimit
    ) FunctionsClient(_router) {
        linkToken = IERC20(linkTokenAddress);
        router = IRouterClient(_router);
        subscriptionId = _subscriptionId;
        donId = _donId;
        callbackGasLimit = _callbackGasLimit;
        linkToken.approve(address(router), type(uint256).max);
    }

    /*//////////////////////////////////////////////////////////////
                          CHAINLINK FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function requestWeather(
        string memory _city
    ) external onlyForwarder returns (bytes32 requestId) {
        string[] memory args = new string[](1);
        args[0] = _city;

        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(source);
        if (args.length > 0) req.setArgs(args);

        lastCity = _city;

        requestId = _sendRequest(
            req.encodeCBOR(),
            subscriptionId,
            callbackGasLimit,
            donId
        );
    }

    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (lastRequestId != requestId) {
            revert("non matching requestIds"); // Check if request IDs match
        }
        lastError = err;

        // Update the contract's state variables with the response and any errors
        lastResponse = response;
        lastTemperature = string(response);
    }

    /*//////////////////////////////////////////////////////////////
                          CHAINLINK AUTOMATION
    //////////////////////////////////////////////////////////////*/

    function setForwarder(address _forwarderAddress) external onlyOwner {
        forwarderAddress = _forwarderAddress;
    }

    modifier onlyForwarder() {
        require(
            msg.sender == forwarderAddress,
            "Only the forwarder can call this function"
        );
        _;
    }
}
