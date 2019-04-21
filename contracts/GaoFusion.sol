pragma solidity ^0.4.25;

import "./GaoFactory.sol";

contract GaoFusion is GaoFactory {
    uint randNonce = 0;
    uint fuseFee = 0.01 ether;

    event Fusion(address owner, uint256 gaoId);


    modifier onlyOwnerOf(uint _gaoId) {
    require(msg.sender == gaoIndexToOwner[_gaoId]);
    _;
    }

    // Create random number base on now, sender address, and an arbitary variable
    function randMod(uint _modulus) internal returns(uint) {
        randNonce = randNonce.add(1);
        return uint8(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
    }

    function _generateDna() private returns (uint8[4]) {
        // Get 4 last number to use for body parts code
        uint8 _rand = uint8(randMod(10000));
        uint8 _head = _rand % 10;
        uint8 _wing = uint8((_rand / 10) % 10);
        uint8 _hands = uint8((_rand / 100) % 10);
        uint8 _legs = uint8((_rand / 1000) % 10);
        uint8[4] memory _dna;
        _dna[0] = _head;
        _dna[1] = _wing;
        _dna[2] = _hands;
        _dna[3] = _legs;
        return _dna;
    }

    function _genarateAbility() internal returns (uint16[3]){
        uint8 _rand = uint8(randMod(1000));
        uint16 _fly = _rand % 10;
        uint16 _swim = uint16((_rand / 10) % 10);
        uint16 _run = uint16((_rand / 100) % 10);
        uint16[3] memory _ability = [uint16(_fly), _swim, _run];
        return _ability;
    }

    function _isReadyToFuse(Gao _gao) internal pure returns (bool) {
        return (!_gao.mature) && (_gao.bonding > 0);
    }

    function isReadyToFuse(uint256 _gaoId) public view returns (bool) {
        require(_gaoId > 0);
        Gao storage gao = gaos[_gaoId];
        return _isReadyToFuse(gao);
    }

    function _fuseGao(Gao _gao) internal {
        _gao.mature = true;
        _gao.dna = _generateDna();
        _gao.ability = _genarateAbility();
    }

    function fuseGao (uint256 _gaoId) external payable {
        require(msg.value == fuseFee);
        require(isReadyToFuse(_gaoId));
        address _owner = gaoIndexToOwner[_gaoId];
        emit Fusion(_owner, _gaoId);
        _fuseGao(gaos[_gaoId]);
    }


}
