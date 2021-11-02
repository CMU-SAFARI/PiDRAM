
/*============================================================================

This Chisel source file is part of a pre-release version of the HardFloat IEEE
Floating-Point Arithmetic Package, by John R. Hauser (with some contributions
from Yunsup Lee and Andrew Waterman, mainly concerning testing).

Copyright 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017 The Regents of the
University of California.  All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

package hardfloat

import Chisel._

object rawFloatFromIN
{
    def apply(signedIn: Bool, in: Bits): RawFloat =
    {
        val expWidth = log2Up(in.getWidth)
//*** CHANGE THIS; CAN BE VERY LARGE:
        val extIntWidth = 1<<expWidth

        val sign = signedIn && in(in.getWidth - 1)
        val absIn = Mux(sign, -in.asUInt, in.asUInt)
        val extAbsIn = Cat(UInt(0, extIntWidth), absIn)(extIntWidth - 1, 0)
        val adjustedNormDist = countLeadingZeros(extAbsIn)
        val sig =
            (extAbsIn<<adjustedNormDist)(
                extIntWidth - 1, extIntWidth - in.getWidth)

        val out = Wire(new RawFloat(expWidth, in.getWidth))
        out.isNaN  := Bool(false)
        out.isInf  := Bool(false)
        out.isZero := ! sig(in.getWidth - 1)
        out.sign   := sign
        out.sExp   := Cat(UInt(1, 1), ~adjustedNormDist(expWidth - 1, 0)).zext
        out.sig    := sig
        out
    }
}

