##tc1#########

a=8
b=1
c="s"
d="t"

s=a+b
t=c+d
#error
v=a+c
#error
w=b+d

##tc2########
str1="hello"
str2="world"

a=str1
b=str1+str2
c=str1+str2+"everybody"
#warning
b=45
#error
d=b+c+"str1"
c="hi"+"str2"
#error
e=c+5+7+14

##tc3########
#list program
l1=[]
l2=[]

l1.append(23)
l2.append("two")
#warning
l3=l1+l2
#warning
l1.append("45")
l2.append("four")
l4=[]
l4.append(2)
#error
l5=l1*l4



##tc4######
#if-else
aa=231
bb=543
cc="str1"

if aa>bb:
    s1=aa+bb+334+123
    #error
    s2=bb+cc+435
else:
    #warning
    bb="str2"+"345"
    #error
    dd=aa+"str3"+bb

xx="w1"
#warning
if aa==xx:
    #error
    mm=xx+3+34+21
	
xx = "st1"+"st2"  


##tc5#######
#long expression

var1=123+345+543+768+546+100
var2="s1"+"s2"+"s3"+"s4"+"s5"
var3=4356+342+9001
var4="str1"+"str2"+"str3"
#error
var5=var2+var2+var3+var4
var6=var1+var2+234+23+4
var7=var1+var3*var6
var8=var2+var4+"342"
#error
var9=var6+var8+"234"
#warning
var1=var8
var2=var1
#warning
var4=var3

##tc6##########
#harder

v11=13
v22=26
v33=77
v44="123s"

a11=v11+v22*v33+12+34
#error
a22=v22+v23+"s2"+4+5+"23"
#error
a33=21*43*50+77+v11+v44
a44=v22+v33*763+13
#error
a55=a11*a44+v44+23+v11
#warning
a44="s3"+v44+"s4"+"s5"


###tc7##############
a1 = 420
b1 = 910
c1 = 445
d1 = "str"

if a1>b1:
    x1=45+90+1
else:
    x1=100*45
#warning
x1="am"+"34"
y1=d1+x1+b1+123
#warning/error
if y1<c1:
    b1="pm"+"23"
else:
    f1=x1+"tomorrow"+"never"+"dies"
	#error
    g1=a1+x1
#error
w1 = f1 * d1 + 56
#error
y1 = f1 + d1 + 15



####tc8####
list1=[]
list2=[]
list3=[]

list1.append(23)
list2.append("s1")
list3.append(100)

list4=list1+list3
#warning
list5=list1+list2
list6=list1+list3+list4
list7=[]
list7.append("s2")
#warning
list8=list6+list7+list1+list2
#error
list9=list2*list7
#warning
list10=list5+list6+list2


##tc9#######
www = 4
#error
zzz = www + "s"
#commenting a line
mmm = "trs" + "str"
kkk = "2"
#warning
www = kkk
zzz = www
zz = 123+345
ww = "123"+"345"
#error
ww = 1+2+3+4+5+"6"
mmm = "okay"
#error
kkk = mmm + 2







##tc10##
variable11=23456
variable22=90000
variable33="string33"
variable44="string44"

if variable33==variable44:
	variable11 = variable11 + variable22
	#error
	variable1 = 5632+"2345"
else:
	#error
	variable33 = variable33 + 123
	variable2 = "1234"
	
#error
variable2 = 123+variable2
variable44 = variable2
#warning
variable33 = 456+324
#error/warning
if variable33 > variable11:
	variable1 = 123
	#error
	variable11 = variable11 + "23445" + 132324 + 34342


###bonus1####
#function

def f(a,b,c):
    return a + b + c

f(2,3,4)
w=f("so","did","we")
#error
e=f(1,2,"you")
p = f(5,34,7)

def g(x,y):
    l1 = []
    l2 = []
    l1.append(x)
    l2.append(y)
    return l1+l2

g(2,3)
#warning
q=g(1,"s1")
m = g("to","you")
#warning
p = "var"
#warning
m = 45



#####bonus 2#####
def f1(a,b,c):
    return a+b+c

c = "lmnop"
yz=23
#warning
c=f1(3,4,yz)
#error
e=f1("3",3,2)

def f2(k1,k2):
    return k1 *k2

p1=2
p2=3
g1=f2(p1,p2)
#warning
p1="34"
#error
g2=f2(p1,"bye")
