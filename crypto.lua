

--Crypto
local a,b,c,d,e,f,g,h,i,j,k,l,tonumber,type=table.concat,string.byte,string.char,string.rep,string.sub,string.gsub,string.gmatch,string.format,math.floor,math.ceil,math.min,math.max,tonumber,type
local m={}m.AND=bit.band
m.OR=bit.bor
m.XOR=bit.bxor
m.SHL=bit.lshift
m.SHR=bit.rshift
m.NOT=bit.bnot
m.HEX=bit.tohex
m.XOR_BYTE=bit.bxor
m.create_array_of_lanes=function()return{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}end
m.sha2_K_lo,m.sha2_K_hi,m.sha2_H_lo,m.sha2_H_hi,m.sha3_RC_lo,m.sha3_RC_hi={},{},{},{},{},{}m.sha2_H_ext256={[224]={},[256]=m.sha2_H_hi}m.sha2_H_ext512_lo,m.sha2_H_ext512_hi={[384]={},[512]=m.sha2_H_lo},{[384]={},[512]=m.sha2_H_hi}m.K_lo_modulo,m.hi_factor,m.hi_factor_keccak=4294967296,0,0
function m.keccak_feed(n,o,p,q,r,s)local t,u=m.sha3_RC_lo,m.sha3_RC_hi
local v=m.SHR(s,3)for w=q,q+r-1,s do for x=1,v do local y,z,A,B=b(p,w+1,w+4)n[x]=m.XOR(n[x],m.OR(m.SHL(B,24),m.SHL(A,16),m.SHL(z,8),y))w=w+8
y,z,A,B=b(p,w-3,w)o[x]=m.XOR(o[x],m.OR(m.SHL(B,24),m.SHL(A,16),m.SHL(z,8),y))end
for C=1,24 do for x=1,5 do n[25+x]=m.XOR(n[x],n[x+5],n[x+10],n[x+15],n[x+20])end
for x=1,5 do o[25+x]=m.XOR(o[x],o[x+5],o[x+10],o[x+15],o[x+20])end
local D=m.XOR(n[26],m.SHL(n[28],1),m.SHR(o[28],31))local E=m.XOR(o[26],m.SHL(o[28],1),m.SHR(n[28],31))n[2],o[2],n[7],o[7],n[12],o[12],n[17],o[17]=m.XOR(m.SHR(m.XOR(D,n[7]),20),m.SHL(m.XOR(E,o[7]),12)),m.XOR(m.SHR(m.XOR(E,o[7]),20),m.SHL(m.XOR(D,n[7]),12)),m.XOR(m.SHR(m.XOR(D,n[17]),19),m.SHL(m.XOR(E,o[17]),13)),m.XOR(m.SHR(m.XOR(E,o[17]),19),m.SHL(m.XOR(D,n[17]),13)),m.XOR(m.SHL(m.XOR(D,n[2]),1),m.SHR(m.XOR(E,o[2]),31)),m.XOR(m.SHL(m.XOR(E,o[2]),1),m.SHR(m.XOR(D,n[2]),31)),m.XOR(m.SHL(m.XOR(D,n[12]),10),m.SHR(m.XOR(E,o[12]),22)),m.XOR(m.SHL(m.XOR(E,o[12]),10),m.SHR(m.XOR(D,n[12]),22))local F,G=m.XOR(D,n[22]),m.XOR(E,o[22])n[22],o[22]=m.XOR(m.SHL(F,2),m.SHR(G,30)),m.XOR(m.SHL(G,2),m.SHR(F,30))D=m.XOR(n[27],m.SHL(n[29],1),m.SHR(o[29],31))E=m.XOR(o[27],m.SHL(o[29],1),m.SHR(n[29],31))n[3],o[3],n[8],o[8],n[13],o[13],n[23],o[23]=m.XOR(m.SHR(m.XOR(D,n[13]),21),m.SHL(m.XOR(E,o[13]),11)),m.XOR(m.SHR(m.XOR(E,o[13]),21),m.SHL(m.XOR(D,n[13]),11)),m.XOR(m.SHR(m.XOR(D,n[23]),3),m.SHL(m.XOR(E,o[23]),29)),m.XOR(m.SHR(m.XOR(E,o[23]),3),m.SHL(m.XOR(D,n[23]),29)),m.XOR(m.SHL(m.XOR(D,n[8]),6),m.SHR(m.XOR(E,o[8]),26)),m.XOR(m.SHL(m.XOR(E,o[8]),6),m.SHR(m.XOR(D,n[8]),26)),m.XOR(m.SHR(m.XOR(D,n[3]),2),m.SHL(m.XOR(E,o[3]),30)),m.XOR(m.SHR(m.XOR(E,o[3]),2),m.SHL(m.XOR(D,n[3]),30))F,G=m.XOR(D,n[18]),m.XOR(E,o[18])n[18],o[18]=m.XOR(m.SHL(F,15),m.SHR(G,17)),m.XOR(m.SHL(G,15),m.SHR(F,17))D=m.XOR(n[28],m.SHL(n[30],1),m.SHR(o[30],31))E=m.XOR(o[28],m.SHL(o[30],1),m.SHR(n[30],31))n[4],o[4],n[9],o[9],n[19],o[19],n[24],o[24]=m.XOR(m.SHL(m.XOR(D,n[19]),21),m.SHR(m.XOR(E,o[19]),11)),m.XOR(m.SHL(m.XOR(E,o[19]),21),m.SHR(m.XOR(D,n[19]),11)),m.XOR(m.SHL(m.XOR(D,n[4]),28),m.SHR(m.XOR(E,o[4]),4)),m.XOR(m.SHL(m.XOR(E,o[4]),28),m.SHR(m.XOR(D,n[4]),4)),m.XOR(m.SHR(m.XOR(D,n[24]),8),m.SHL(m.XOR(E,o[24]),24)),m.XOR(m.SHR(m.XOR(E,o[24]),8),m.SHL(m.XOR(D,n[24]),24)),m.XOR(m.SHR(m.XOR(D,n[9]),9),m.SHL(m.XOR(E,o[9]),23)),m.XOR(m.SHR(m.XOR(E,o[9]),9),m.SHL(m.XOR(D,n[9]),23))F,G=m.XOR(D,n[14]),m.XOR(E,o[14])n[14],o[14]=m.XOR(m.SHL(F,25),m.SHR(G,7)),m.XOR(m.SHL(G,25),m.SHR(F,7))D=m.XOR(n[29],m.SHL(n[26],1),m.SHR(o[26],31))E=m.XOR(o[29],m.SHL(o[26],1),m.SHR(n[26],31))n[5],o[5],n[15],o[15],n[20],o[20],n[25],o[25]=m.XOR(m.SHL(m.XOR(D,n[25]),14),m.SHR(m.XOR(E,o[25]),18)),m.XOR(m.SHL(m.XOR(E,o[25]),14),m.SHR(m.XOR(D,n[25]),18)),m.XOR(m.SHL(m.XOR(D,n[20]),8),m.SHR(m.XOR(E,o[20]),24)),m.XOR(m.SHL(m.XOR(E,o[20]),8),m.SHR(m.XOR(D,n[20]),24)),m.XOR(m.SHL(m.XOR(D,n[5]),27),m.SHR(m.XOR(E,o[5]),5)),m.XOR(m.SHL(m.XOR(E,o[5]),27),m.SHR(m.XOR(D,n[5]),5)),m.XOR(m.SHR(m.XOR(D,n[15]),25),m.SHL(m.XOR(E,o[15]),7)),m.XOR(m.SHR(m.XOR(E,o[15]),25),m.SHL(m.XOR(D,n[15]),7))F,G=m.XOR(D,n[10]),m.XOR(E,o[10])n[10],o[10]=m.XOR(m.SHL(F,20),m.SHR(G,12)),m.XOR(m.SHL(G,20),m.SHR(F,12))D=m.XOR(n[30],m.SHL(n[27],1),m.SHR(o[27],31))E=m.XOR(o[30],m.SHL(o[27],1),m.SHR(n[27],31))n[6],o[6],n[11],o[11],n[16],o[16],n[21],o[21]=m.XOR(m.SHL(m.XOR(D,n[11]),3),m.SHR(m.XOR(E,o[11]),29)),m.XOR(m.SHL(m.XOR(E,o[11]),3),m.SHR(m.XOR(D,n[11]),29)),m.XOR(m.SHL(m.XOR(D,n[21]),18),m.SHR(m.XOR(E,o[21]),14)),m.XOR(m.SHL(m.XOR(E,o[21]),18),m.SHR(m.XOR(D,n[21]),14)),m.XOR(m.SHR(m.XOR(D,n[6]),28),m.SHL(m.XOR(E,o[6]),4)),m.XOR(m.SHR(m.XOR(E,o[6]),28),m.SHL(m.XOR(D,n[6]),4)),m.XOR(m.SHR(m.XOR(D,n[16]),23),m.SHL(m.XOR(E,o[16]),9)),m.XOR(m.SHR(m.XOR(E,o[16]),23),m.SHL(m.XOR(D,n[16]),9))n[1],o[1]=m.XOR(D,n[1]),m.XOR(E,o[1])n[1],n[2],n[3],n[4],n[5]=m.XOR(n[1],m.AND(m.NOT(n[2]),n[3]),t[C]),m.XOR(n[2],m.AND(m.NOT(n[3]),n[4])),m.XOR(n[3],m.AND(m.NOT(n[4]),n[5])),m.XOR(n[4],m.AND(m.NOT(n[5]),n[1])),m.XOR(n[5],m.AND(m.NOT(n[1]),n[2]))n[6],n[7],n[8],n[9],n[10]=m.XOR(n[9],m.AND(m.NOT(n[10]),n[6])),m.XOR(n[10],m.AND(m.NOT(n[6]),n[7])),m.XOR(n[6],m.AND(m.NOT(n[7]),n[8])),m.XOR(n[7],m.AND(m.NOT(n[8]),n[9])),m.XOR(n[8],m.AND(m.NOT(n[9]),n[10]))n[11],n[12],n[13],n[14],n[15]=m.XOR(n[12],m.AND(m.NOT(n[13]),n[14])),m.XOR(n[13],m.AND(m.NOT(n[14]),n[15])),m.XOR(n[14],m.AND(m.NOT(n[15]),n[11])),m.XOR(n[15],m.AND(m.NOT(n[11]),n[12])),m.XOR(n[11],m.AND(m.NOT(n[12]),n[13]))n[16],n[17],n[18],n[19],n[20]=m.XOR(n[20],m.AND(m.NOT(n[16]),n[17])),m.XOR(n[16],m.AND(m.NOT(n[17]),n[18])),m.XOR(n[17],m.AND(m.NOT(n[18]),n[19])),m.XOR(n[18],m.AND(m.NOT(n[19]),n[20])),m.XOR(n[19],m.AND(m.NOT(n[20]),n[16]))n[21],n[22],n[23],n[24],n[25]=m.XOR(n[23],m.AND(m.NOT(n[24]),n[25])),m.XOR(n[24],m.AND(m.NOT(n[25]),n[21])),m.XOR(n[25],m.AND(m.NOT(n[21]),n[22])),m.XOR(n[21],m.AND(m.NOT(n[22]),n[23])),m.XOR(n[22],m.AND(m.NOT(n[23]),n[24]))o[1],o[2],o[3],o[4],o[5]=m.XOR(o[1],m.AND(m.NOT(o[2]),o[3]),u[C]),m.XOR(o[2],m.AND(m.NOT(o[3]),o[4])),m.XOR(o[3],m.AND(m.NOT(o[4]),o[5])),m.XOR(o[4],m.AND(m.NOT(o[5]),o[1])),m.XOR(o[5],m.AND(m.NOT(o[1]),o[2]))o[6],o[7],o[8],o[9],o[10]=m.XOR(o[9],m.AND(m.NOT(o[10]),o[6])),m.XOR(o[10],m.AND(m.NOT(o[6]),o[7])),m.XOR(o[6],m.AND(m.NOT(o[7]),o[8])),m.XOR(o[7],m.AND(m.NOT(o[8]),o[9])),m.XOR(o[8],m.AND(m.NOT(o[9]),o[10]))o[11],o[12],o[13],o[14],o[15]=m.XOR(o[12],m.AND(m.NOT(o[13]),o[14])),m.XOR(o[13],m.AND(m.NOT(o[14]),o[15])),m.XOR(o[14],m.AND(m.NOT(o[15]),o[11])),m.XOR(o[15],m.AND(m.NOT(o[11]),o[12])),m.XOR(o[11],m.AND(m.NOT(o[12]),o[13]))o[16],o[17],o[18],o[19],o[20]=m.XOR(o[20],m.AND(m.NOT(o[16]),o[17])),m.XOR(o[16],m.AND(m.NOT(o[17]),o[18])),m.XOR(o[17],m.AND(m.NOT(o[18]),o[19])),m.XOR(o[18],m.AND(m.NOT(o[19]),o[20])),m.XOR(o[19],m.AND(m.NOT(o[20]),o[16]))o[21],o[22],o[23],o[24],o[25]=m.XOR(o[23],m.AND(m.NOT(o[24]),o[25])),m.XOR(o[24],m.AND(m.NOT(o[25]),o[21])),m.XOR(o[25],m.AND(m.NOT(o[21]),o[22])),m.XOR(o[21],m.AND(m.NOT(o[22]),o[23])),m.XOR(o[22],m.AND(m.NOT(o[23]),o[24]))end end end
do local H=29
local function I()local J=H%2
H=m.XOR_BYTE((H-J)/2,142*J)return J end
for K=1,24 do local L,M=0
for N=1,6 do M=M and M*M*2 or 1
L=L+I()*M end
local O=I()*M
m.sha3_RC_hi[K],m.sha3_RC_lo[K]=O,L+O*m.hi_factor_keccak end end
m.keccak=function(s,P,Q,R)if type(P)~="number"then print("Argument 'digest_size_in_bytes' must be a number",2)end
local S,n,o="",m.create_array_of_lanes(),m.hi_factor_keccak==0 and m.create_array_of_lanes()local T
local function U(V)if V then if S then local q=0
if S~=""and#S+#V>=s then q=s-#S
m.keccak_feed(n,o,S..e(V,1,q),0,s,s)S=""end
local r=#V-q
local W=r%s
m.keccak_feed(n,o,V,q,r-W,s)S=S..e(V,#V+1-W)return U else print("Adding more chunks is not allowed after receiving the result",2)end else if S then local X=Q and 31 or 6
S=S..(#S+1==s and c(X+128)or c(X)..d("\0",(-2-#S)%s).."\128")m.keccak_feed(n,o,S,0,#S,s)S=nil
local Y=0
local Z=i(s/8)local _={}local function a0(v)if Y>=Z then m.keccak_feed(n,o,"\0\0\0\0\0\0\0\0",0,8,8)Y=0 end
v=i(k(v,Z-Y))if m.hi_factor_keccak~=0 then for x=1,v do _[x]=m.HEX64(n[Y+x-1+m.lanes_index_base])end else for x=1,v do _[x]=m.HEX(o[Y+x])..m.HEX(n[Y+x])end end
Y=Y+v
return f(a(_,"",1,v),"(..)(..)(..)(..)(..)(..)(..)(..)","%8%7%6%5%4%3%2%1"),v*8 end
local a1={}local a2,a3="",0
local function a4(a5)a5=a5 or 1
if a5<=a3 then a3=a3-a5
local a6=a5*2
local T=e(a2,1,a6)a2=e(a2,a6+1)return T end
local a7=0
if a3>0 then a7=1
a1[a7]=a2
a5=a5-a3 end
while a5>=8 do local a8,a9=a0(a5/8)a7=a7+1
a1[a7]=a8
a5=a5-a9 end
if a5>0 then a2,a3=a0(1)a7=a7+1
a1[a7]=a4(a5)else a2,a3="",0 end
return a(a1,"",1,a7)end
if P<0 then T=a4 else T=a4(P)end end
return T end end
if R then return U(R)()else return U end end
m.hex2bin=function(aa)return f(aa,"%x%x",function(ab)return c(tonumber(ab,16))end)end
m.pad_and_xor=function(p,ac,ad)return f(p,".",function(A)return c(m.XOR_BYTE(b(A),ad))end)..d(c(ad),ac-#p)end
m.hmac=function(ae,af,R)local ag=m.block_size_for_HMAC[ae]if not ag then print("Unknown hash function",2)end
if#af>ag then af=m.hex2bin(ae(af))end
local ah=ae()(m.pad_and_xor(af,ag,0x36))local T
local function U(V)if not V then T=T or ae(m.pad_and_xor(af,ag,0x5C)..m.hex2bin(ah()))return T elseif T then print("Adding more chunks is not allowed after receiving the result",2)else ah(V)return U end end
if R then return U(R)()else return U end end
m.sha={sha3_512=function(R)return m.keccak((1600-2*512)/8,512/8,false,R)end,hmac=m.hmac}m.block_size_for_HMAC={[m.sha.sha3_512]=(1600-2*512)/8}

return m