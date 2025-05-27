# <center>Notes on Hungarian Notation</center>

Hungarian Notation simply means prefacing a variable name with a single letter defining that variable's **type**. It was invented by Charles Simonyi at Xerox PARC then Microsoft (he was from Hungary).

VFP has suggested letters for different types. I use most of them but differ in one place, that is: using the **l** for logical. When we say it, as in lOK, we say Ell-Oh-Kay or LOck. But when we read it, it's as One-OK-Kay until we've trained ourselves to see it as Ell, not One. To me that's silly, so I use a b for binary. Then the pronunciation is the same for the variable and word and b can't be mistaken for a number. Examples:
```foxpro
cMyString = "ABC"
bIsOK = .T.
oCust = CREATEOBJECT('Custom')
```
<br>

VFP has also suggested letters defining variable **scope**s as follows:
* g - Public variables
* p - Private variables
* t - Parameter
* l - Local variables

I don't care for them; PUBLIC variables should never be used at all. Within apps, I use special private variables for app-wide usage. Sometimes, I also use private variables for small sections of the app. I'd rather have a letter that distinguishes those two usages.

And, while the **t** for parameters is meant to distinguish values that should not be changed, yet sometimes we purposely pass values that we expect to be changed by the function/method. So, why is **t** so sacred in parameters? To me **t** means time which can be numeric, as in SECONDS(), or character as in TIME().

And yes, there is that **"l"** again. Is that really useful? Or even needed?

Here are the rules I use:
* g - Global (to our app) are PRIVATE variables available to the entire app
* v - PRIVATE variables for a subset of the app
* nothing - Local variables (Almost all variables are local so why repeat the noisy **ell** everywhere? It just gets in the way of code readability.)

So, for example, my string library is created as a global object as follows:
```foxpro
goStr = CREATEOBJECT('KStrings')
```

<font size="2"><center>
by Ken Green - [AdvanceDataSystems.biz](http://AdvanceDataSystems.biz)
</center></font>