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
    uint32 callbackGasLimitSepolia = 300000;

    // FUJI
    IERC20 linkTokenFuji = IERC20(0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846);
    address routerAddressFuji = 0xA9d587a00A31A52Ed70D6026794a8FC5E2F5dCb0;
    bytes32 donIdFuji =
        0x66756e2d6176616c616e6368652d66756a692d31000000000000000000000000;
    uint64 subscriptionIdFuji = 13614;
    uint32 callbackGasLimitFuji = 300000;

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

        // Weather weatherFuji = new Weather(
        //     address(linkTokenFuji),
        //     routerAddressFuji,
        //     subscriptionIdFuji,
        //     donIdFuji,
        //     callbackGasLimitFuji
        // );

        // console.log("Weather contract deployed at: ", address(weatherFuji));

        ///////////////////////////////////
        // INTERACTING
        // Weather weather = Weather(0x7e9c4ced372d16181EbE79C6f1d3feED234F0Bf0);
        // console.log("owner", weather.owner());

        // weather.setForwarder(0x1abA0fce7dd58D1029Daf38A4F1505dD9Ad51bA4);
        // weather.requestWeather("new_york");

        // console.log("lastCity:", weather.lastCity());
        // console.log("lastTemperature:", weather.lastTemperature());

        Weather weatherFuji = Weather(
            0x49Ba880eb225830057239840b678BCc6e00AA999
        );

        // weatherFuji.setForwarder(0xC2a1171419bac1eA3e2a18f7479f50B86013a812);
        // weatherFuji.requestWeather("new-york");

        console.log("sender", weatherFuji.addressWhoCalledThis_msgSender());
        console.log("origin", weatherFuji.addressWhoCalledThis_txOrigin());

        console.log("lastCity:", weatherFuji.lastCity());
        console.log("lastTemperature:", weatherFuji.lastTemperature());
    }
}
