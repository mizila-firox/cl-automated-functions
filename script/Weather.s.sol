// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Weather} from "src/Weather.sol";
import {IERC20} from "lib/forge-std/src/interfaces/IERC20.sol";

contract WeatherScript is Script {
    IERC20 linkTokenSepolia =
        IERC20(0x779877A7B0D9E8603169DdbD7836e478b4624789);
    address routerAddressSepolia = 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0;
    bytes32 donIdSepolia =
        0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000;
    uint64 subscriptionIdSepolia = 3659;
    uint32 callbackGasLimitSepolia = 300_000;

    function run() external {
        vm.startBroadcast();

        ///////////////////////////////////
        // DEPLOYING
        // Weather weather = new Weather(
        //     address(linkTokenSepolia),
        //     routerAddressSepolia,
        //     subscriptionIdSepolia,
        //     donIdSepolia,
        //     callbackGasLimitSepolia
        // );
        // console.log("Weather contract deployed at: ", address(weather));

        ///////////////////////////////////
        // INTERACTING
        Weather weather = Weather(0xbcCED4E74f3f14a7Be7DB10Bb399d75E538964D1);
        // console.log("owner", weather.owner());

        // weather.setForwarder(0x1abA0fce7dd58D1029Daf38A4F1505dD9Ad51bA4);
        // weather.requestWeather("new-york");

        console.log("lastCity:", weather.lastCity());
        console.log("lastTemperature:", weather.lastTemperature());
    }
}
