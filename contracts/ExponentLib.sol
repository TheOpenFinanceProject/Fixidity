pragma solidity ^0.5.0;

import "./FixidityLib.sol";
import "./LogarithmLib.sol";

library ExponentLib {

    function fixedExp10() public pure returns(int256) {
        return 22026465794806716516957900645;
    }

    /**
     * @notice Not fully tested anymore.
     */
    function powerE(int256 x) 
        public 
        pure 
        returns (int256) 
    {
        assert(x < 172 * FixidityLib.fixed1());
        int256 r = FixidityLib.fixed1();
        while(x >= 10 * FixidityLib.fixed1()) {
            x -= 10 * FixidityLib.fixed1();
            r = FixidityLib.multiply(r, fixedExp10());
        }
        if(x == FixidityLib.fixed1()) {
            return FixidityLib.multiply(r, LogarithmLib.fixedE());
        } else if(x == 0) {
            return r;
        }
        int256 tr = 100 * FixidityLib.fixed1();
        int256 d = tr;
        for(uint8 i = 1; i <= 2 * FixidityLib.digits(); i++) {
            d = (d * x) / (FixidityLib.fixed1() * i);
            tr += d;
        }
        return trunc_digits(FixidityLib.multiply(tr, r), 2);
    }

    function powerAny(int256 a, int256 b) 
        public 
        pure 
        returns (int256) 
    {
        return powerE(FixidityLib.multiply(LogarithmLib.ln(a), b));
    }

    function rootAny(int256 a, int256 b) 
        public 
        pure 
        returns (int256) 
    {
        return powerAny(a, FixidityLib.reciprocal(b));
    }

    function rootN(int256 a, uint8 n) 
        public 
        pure 
        returns (int256) 
    {
        return powerE(FixidityLib.divide(LogarithmLib.ln(a), FixidityLib.fixed1() * n));
    }

    function round_off(int256 v, uint8 digits) 
        public 
        pure 
        returns (int256) 
    {
        int256 t = int256(uint256(10) ** uint256(digits));
        int8 sign = 1;
        if(v < 0) {
            sign = -1;
            v = 0 - v;
        }
        if(v % t >= t / 2) v = v + t - v % t;
        return v * sign;
    }

    function trunc_digits(int256 v, uint8 digits) 
        public 
        pure 
        returns (int256) 
    {
        if(digits <= 0) return v;
        return round_off(v, digits) / FixidityLib.fixed1();
    }
}
