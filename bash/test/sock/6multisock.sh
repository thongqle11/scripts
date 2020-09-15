#!/bin/bash
INT=p4p1_1
SET1=fe80::20e:1eff:fec4:aab4%p4p1_1-fe80::20e:1eff:fec4:112a
SET2=fe80::20e:1eff:fec4:aab6%p4p1_2-fe80::20e:1eff:fec4:112b
SET3=fe80::20e:1eff:fec4:aab8%p4p1_3-fe80::20e:1eff:fec4:112c
SET4=fe80::20e:1eff:fec4:aaba%p4p1_4-fe80::20e:1eff:fec4:112d
SET5=fe80::20e:1eff:fec4:aab5%p4p2_1-fe80::20e:1eff:fed2:49c
SET6=fe80::20e:1eff:fec4:aab7%p4p2_2-fe80::20e:1eff:fed2:49d
SET7=fe80::20e:1eff:fec4:aab9%p4p2_3-fe80::20e:1eff:fed2:49e
SET8=fe80::20e:1eff:fec4:aabb%p4p2_4-fe80::20e:1eff:fed2:49f
sock -f$SET1,$SET2,$SET3,$SET4,$SET5,$SET6,$SET7,$SET8 -Y1 -M0 $*
