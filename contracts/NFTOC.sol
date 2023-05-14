// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);
        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)
            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)
                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
                )
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
                )
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
                )
                out := shl(224, out)
                mstore(resultPtr, out)
                resultPtr := add(resultPtr, 4)
            }
            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }
            mstore(result, encodedLen)
        }
        return string(result);
    }
}

contract NFTOC is ERC721, Ownable {
    using Strings for uint256;

    // =================================
    // Storage
    // =================================

    uint256 public constant maxSupply = 5;
    uint256 public numMinted;

    bool public saleIsActive;

    // =================================
    // Metadata
    // =================================

    function generateHTMLandSVG()
        internal
        pure
        returns (string memory Html, string memory Svg)
    {
        Html = '<!DOCTYPE html> <html lang="en"> <head> <meta charset="UTF-8"> <meta http-equiv="X-UA-Compatible" content="IE=edge"> <meta name="viewport" content="width=device-width, initial-scale=1.0"> <title>Document</title> <style> body { overflow:hidden; height:100vh; width:100vw; background:#1d1e22; --c1: #1d1e22; --c2: #444857; background-image: -webkit-linear-gradient(top, var(--c1), var(--c2)); background-image: -moz-linear-gradient(top, var(--c1), var(--c2))); background-image: -o-linear-gradient(top, var(--c1), var(--c2))); background-image: -ms-linear-gradient(top, var(--c1), var(--c2))); background-image: linear-gradient(top, var(--c1), var(--c2))); } </style> </head> <body> <svg id="hs" width="400" height="400" xmlns="http://www.w3.org/2000/svg"> <defs> <filter id="glow"> <fegaussianblur class="blur" result="coloredBlur" stddeviation="8"></fegaussianblur> <femerge> <femergenode in="coloredBlur"></femergenode> <femergenode in="coloredBlur"></femergenode> <femergenode in="coloredBlur"></femergenode> <femergenode in="SourceGraphic"></femergenode> </femerge> </filter> <filter id="filter-broken" filterUnits="objectBoundingBox" x="0" y="0" width="100%" height="100%" color-interpolation-filters="sRGB"> <feImage preserveAspectRatio="xMidYMid meet" xlink:href="data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 800"%3E%3Crect width="70%25" height="70%25" fill="white"/%3E%3Ccircle cx="50%25" cy="50%25" r="500" %0Afill="none" stroke="black" stroke-width="950" stroke-dasharray="200"/%3E%3C/svg%3E" result="lense"/> <feDisplacementMap scale="10" xChannelSelector="B" yChannelSelector="G" in2="lense" in="SourceGraphic" result="glass-effect"/> <feMerge> <feMergeNode in="SourceGraphic"/> <feMergeNode in="glass-effect"/> </feMerge> </filter> </defs> <style type="text/css"> <![CDATA[ #svg_8{transform-origin:center;} svg { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); filter: url("#filter-broken"); /* url("#glow"); */ } #svg_12 { url("#glow"); mix-blend-mode:multiply; transform-origin:center; } .path { animation:  animation1 3s ease-in-out 1s infinite alternate; fill-opacity: .25; } .p_0{ animation:  animation2 3s ease-in-out .5s infinite alternate; } @keyframes animation1 { from {transform: perspective(400px) rotateX(20deg);} to {transform: perspective(400px) rotateX(-20deg);} from {transform: perspective(400px) rotateY(20deg);} to {transform: perspective(400px) rotateY(-20deg);} from {stroke-width: 1;} to {stroke-width: 9;} } @keyframes animation2 { from {transform: perspective(400px) rotateX(20deg);} to {transform: perspective(400px) rotateX(-20deg);} from {transform: perspective(400px) rotateY(20deg);} to {transform: perspective(400px) rotateY(-20deg);} from {stroke-width: 1;} to {stroke-width: 2;} from {stroke-opacity: .4;} to {stroke-opacity: 1;} } ]]> </style> <g> <g fill="#1a1b1f" id="svg_8"> <path class="p_0" stroke-width="1.5" stroke="#000000" id="svg_6" d="m302.47663,282.55895c-11.5319,-4.19342 -12.58025,5.76595 -33.28525,-1.57253l-40.62373,-14.67696l40.62373,-14.67696c20.705,-7.60057 21.75335,2.62089 33.28525,-1.57253c4.71759,-1.57253 7.60057,-7.86266 5.76595,-12.58025c-1.57253,-4.71759 -2.88297,-4.19342 -4.45551,-8.91101c-1.57253,-4.71759 -0.52418,-4.97968 -2.09671,-9.69728c-1.57253,-4.71759 -7.86266,-7.60057 -12.58025,-5.76595c-11.5319,4.19342 -5.76595,12.58025 -26.47095,20.18082l-62.63917,22.27753l-62.63917,-22.80171c-20.705,-7.60057 -15.20114,-15.9874 -26.47095,-20.18082c-4.71759,-1.57253 -11.00772,1.31044 -12.58025,5.76595c-1.57253,4.71759 -0.52418,4.97968 -2.09671,9.69728c-1.57253,4.71759 -2.88297,4.19342 -4.45551,8.91101c-1.57253,4.71759 1.31044,11.00772 5.76595,12.58025c11.5319,4.19342 12.58025,-5.76595 33.28525,1.57253l40.62373,14.67696l-40.62373,14.67696c-20.705,7.60057 -21.75335,-2.62089 -33.28525,1.57253c-4.71759,1.57253 -7.60057,7.86266 -5.76595,12.58025c1.57253,4.71759 2.88297,4.19342 4.45551,8.91101c1.57253,4.71759 0.52418,4.97968 2.09671,9.69728c1.57253,4.71759 7.86266,7.60057 12.58025,5.76595c11.5319,-4.19342 5.76595,-12.58025 26.47095,-20.18082l62.63917,-22.27753l62.63917,22.80171c20.705,7.60057 15.20114,15.9874 26.47095,20.18082c4.71759,1.57253 11.00772,-1.31044 12.58025,-5.76595c1.57253,-4.71759 0.52418,-4.97968 2.09671,-9.69728c1.57253,-4.71759 2.88297,-4.19342 4.45551,-8.91101c1.83462,-4.71759 -1.04835,-11.00772 -5.76595,-12.58025z" fill="null"/> <path class="p_0" stroke-width="1.5" stroke="#000000" id="svg_7" d="m200,57.68695c-34.85778,0 -62.90126,28.04348 -62.90126,62.90126l0,55.0386c0,5.76595 3.40715,13.62861 7.60057,17.55993l18.60829,17.29785c4.19342,3.93133 8.91101,11.26981 10.22145,16.24949s7.33848,9.1731 13.10443,9.1731l26.20886,0c5.76595,0 11.79399,-4.19342 13.10443,-9.1731s6.02804,-12.31816 10.22145,-16.24949l18.60829,-17.29785c4.19342,-3.93133 7.60057,-11.79399 7.60057,-17.55993l0,-55.0386c0.52418,-34.85778 -27.5193,-62.90126 -62.37708,-62.90126zm-30.14019,128.4234c-10.22145,0 -17.03576,-8.38683 -17.03576,-17.03576c0,-8.64892 8.12475,-14.41487 18.3462,-14.41487s18.3462,5.50386 18.3462,14.41487c0,8.64892 -9.69728,17.03576 -19.65664,17.03576zm30.14019,23.58797c-5.24177,0 -7.86266,-2.62089 -7.86266,-7.86266s5.24177,-15.72531 7.86266,-15.72531s7.86266,10.48354 7.86266,15.72531s-2.62089,7.86266 -7.86266,7.86266zm30.14019,-23.58797c-10.22145,0 -19.65664,-8.38683 -19.65664,-17.03576c0,-8.64892 8.12475,-14.41487 18.3462,-14.41487s18.3462,5.50386 18.3462,14.41487c0,8.64892 -6.8143,17.03576 -17.03576,17.03576z" fill="null"/> <path id="svg_12" class="path" d="m88.5,80.45313l272.5,79.54688l-231,189l-41.5,-268.54688z" stroke-opacity="null" stroke-width="1.5" stroke="#000000" fill="none"/> <path id="svg_13" class="path" d="m88.5,80.45313l272.5,79.54688l-231, 189l-41.5, -268.54688z" stroke-opacity="null" stroke-width=".3" stroke="#e29e29" fill="none" transform="rotate(45)"/> </g> </g> <animateMotion dur="5s" repeatCount="indefinite" rotate="auto-reverse"> <mpath href="#svg_13"/> </animateMotion> </svg> <script> function randomValues() { var timeline = anime.timeline({ duration: function() { return anime.random(0, 270); }, delay: [45, 250], direction: "alternate", easing: "easeInOutQuint", autoplay: true, loop:true, }); timeline.add({ targets: ["feDisplacementMap"], scale:[5 , 30] }); timeline.add({ targets: ["#svg_8"], fill: ["#150485","#590995", "#c62a88", "#03c4a1"], scale: [.5, 1.05], complete: randomValues }); }; randomValues(); var stroke_anim1 = anime({ targets: ["#svg_12"], strokeDashoffset: [anime.setDashoffset, 0], points: [ { value: [ "88.5,80.45313l272.5,79.54688l-231,189l-41.5,-268.54688z", "207.5,185.45313l156.5,-26.45313l,190l-44.5,-268.54687z"] }, ], fill: ["#150485", "#590995", "#c62a88", "#03c4a1"], stroke: ["#f1e7b6", "#fe346e", "#40008","#00bdaa"], easing: "easeOutQuad", duration: 2000, autoplay:true, loop: true, }); var stroke_anim2 = anime({ targets: [".p_0"], strokeDashoffset: [anime.setDashoffset, 0], points: [ { value: [ "88.5,80.45313l272.5,79.54688l-231,189l-41.5,-268.54688z", "207.5,185.45313l156.5,-26.45313l,190l-44.5,-268.54687z"] }, ], stroke: ["#f1e7b6", "#fe346e", "#400082", "#00bdaa"], easing: "easeOutQuad", delay:1000, duration: 2000, autoplay:true, loop: true, }); var rotate_stroke_anime = anime({ targets: ["#svg_13 path" ], easing: ["easeOutInCirc"], strokeDashoffset:  [10, 0], duration: 1000, opacity:.5, skewY:100, skewX:100, autoplay:true, direction:"normal", loop: true, stroke:[.3, 1], }); </script> </body> </html>';
        Svg = '<svg xmlns="http://www.w3.org/2000/svg" width="350" height="350"> <rect x="125" y="125" width="100" height="100" style="fill:rgb(0,0,0)" /> </svg>';
    }

    function toString(bytes memory data) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2 + i * 2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3 + i * 2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }

    function htmlToImageURI(
        string memory html
    ) internal pure returns (string memory) {
        string memory baseURL = "data:text/html;base64,";
        string memory htmlBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(html)))
        );
        return string(abi.encodePacked(baseURL, htmlBase64Encoded));
    }

    function svgToImageURI(
        string memory svg
    ) internal pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        requireNFTExists(tokenId);
        (string memory html, string memory svg) = generateHTMLandSVG();

        string memory imageURIhtml = htmlToImageURI(html);
        string memory imageURIsvg = svgToImageURI(svg);

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "NFTBNB | ",
                                uint2str(tokenId),
                                "",
                                '", "description":"", "attributes":"", "image":"',
                                imageURIsvg,
                                '", "animation_url":"',
                                imageURIhtml,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function uint2str(
        uint _i
    ) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    // =================================
    // Mint
    // =================================

    function mint() public payable {
        require(saleIsActive, "Sale must be active to mint");
        require(numMinted < maxSupply, "All NFTs are minted");

        numMinted += 1;
        _safeMint(_msgSender(), numMinted);
    }

    // =================================
    // Owner functions
    // =================================

    function setSaleStatus(bool state) public onlyOwner {
        saleIsActive = state;
    }

    // =================================
    // Function to check if token exists
    // =================================

    function requireNFTExists(uint256 tokenId) internal view {
        require(_exists(tokenId), "NFT does not exist");
    }

    // =================================
    // Constructor
    // =================================

    constructor() ERC721("NFTBNB", "NFTBNB") {}
}
