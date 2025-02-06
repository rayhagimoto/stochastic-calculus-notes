#import "@local/templates:1.0.0" : *

#show : template

#make-title("Stochastic Calculus")

These notes are my attempt at understanding the maths of Black-Scholes options pricing. 
I want to present a derivation that is intuitive to people who have an understanding of undergraduate level calculus.

= Futures and no-arbitrage pricing

#definition[
  A _future_ is a type of contract between two parties to trade an asset (the "underlying") at a fixed time $T$ in the future for a predetermined price $K$ known as the _strike_.
]

Futures can be written for any standardisable asset, like oil, corn, coffee, (not tea -- apparently it's very difficult to standardise this product), and stocks. 
A future can be a way for both parties to reduce uncertainty.
That being said, what is the _fair_ price $K$ for a future?
What does it mean for the price to be fair? 

To work towards answering these questions let's consider how each party can profit from the future. 
Suppose I take the buy-side (also called the _long_ position) of a future in Apple stock struck at $K$ which expires at time $T$.
If at $T$, Apple stock is trading on the market for $S_T > K$ then when I buy stock from the seller of the future (who has a _short_ position) at price $K$, I can immediately go to the stock exchange and sell it to another party at $S_T$, so I profit $S_T - K$. 
On the other hand, if $S_T < K$ then I must still fulfill my side of the future and purchase the stock for $K$. 
If I want to close out the position I have to sell it for its current price for $S_T$, and I incur a loss of $K - S_T$. 

To reiterate, at expiration the net profit for each party is:
- _Long_: $S_T - K$
- _Short_: $K - S_T$

A reasonable guess for the fair value of $K$ is the average value of $S_T$, which requires us to assume a distribution for $S_T$.
However, there is a more powerful argument which allows us to completely circumvent any need to make assumptions about the probability distribution of $S_T$.
Imagine our financial Universe consists of being able to buy/sell futures and borrow/loan money at a risk-free interest rate $r$.
If the stock is worth $S_0$ now, when we go long the future we are effectively taking up a long position in the stock without actually needing to hold it.
We can actually short the stock to get $S_0\$$ now and loan it at the risk free rate so that at time $T$ our cash position is $S_0 e^(r T)$. 
Then if $K < S_0 e^(r T)$ we buy the stock at $K$ and lock in a profit of $S_0 e^(r T) - K$, we then return the stock to close out our initial short position.
In this set of trades we have taken on _no risk_ and made a profit. 
Such a set of actions is known as an arbitrage opportunity.

Now suppose $K > S_0 e^(r T)$. 
From the perspective of the party that is short the future, they could borrow $S_0$ to buy the stock now, so that when the future expires they owe $(S_0 e^(r T) < K)\$$.
Then they lock in a profit of $K - S_0 e^(r T) > 0$.

The price of the future is determined by requiring that neither party can be guaranteed to make a profit. 
This condition squeezes the fair price to precisely $K = S_0 e^(r T)$.
Notice that this doesn't eliminate the ability for either side to profit, it just means that neither party can make a profit with zero risk.


= Ito Calculus

Suppose you're given the stochastic differential equation 
$
  dif X_t = mu_t dif t + sigma_t dif W_t med ,
$ <eq:ito-lemma-derivation-1>
where $W_t$ is a Wiener process and the functions $mu_t$ and $sigma_t$ are deterministic functions of time. 
The mean and variance of $X_t$ are easy to compute:
$
  E[X_t] &= integral_0^t mu_s dif s \
  Var(X_t) &= integral_0^t sigma_s^2 dif s med .
$

And in general the formal solution of the differential equation is 
$
  X_t = integral_0^t mu_s dif s + integral_0^t sigma_s dif B_s med .
$

Now suppose that we have a process $Y_t = f(t, X_t)$, where $f(t, x)$ is some function of $t$ and $x$ like $f(t, x) = t + exp(x)$.
How do we write $d Y_t$? 
We need something like a chain rule for continuous stochastic processes. 
This is what the Ito lemma provides us.
In this section I will sketch the main ideas and provide an intuitive understanding of many of the identities used.

If I had an expression $y = f(t, x)$, where $x = x(t)$ implicitly depends on time, then from multivariable calculus I know I could write 
$
  dif y = (diff f) / (diff t) dif t + (diff f) / (diff x) dif x med ,
$
so a first guess for how to write $dif Y_t$ might look like
$
  dif Y_t = (diff f) / (diff t) dif t + (diff f) / (diff x) dif X_t med .
$
This turns out to be kind of close, but not quite. The reason is that we're not being consistent with which terms we're (implicitly) dropping. 
First, let's agree to keep terms that are $cal(O)(dif t)$. 
Then, noting that $dif W_t$ is like the continuous-time analog of a random walk, its _variance_ (which goes like $(dif W_t)^2$) is expected to be of order $cal(O)(dif t)$, and so $dif W_t ~ cal(O)(dif t^(1 slash 2))$. 
Since $dif X_t$ has one component of order $dif t$, and another component of order $dif W_t$ then when we Taylor expand $f$ we should keep terms up to $(dif W_t)^2$, which motivates us to do an expansion up to second order in $x$. To see this in action, let's write
$
  dif f(t, X_t) = (diff f) / (diff t) dif t + (diff f) / (diff x) dif X_t + 1 / 2 (diff^2 f) / (diff x^2) (dif X_t)^2 med, 
$ <eq:ito-lemma-derivation-2>
where we haven't written cross terms like $dif t dif x$ since those will definitely be greater than order $dif t$ anyway. 
Also note that when I write $diff f slash diff x$ I mean, "take the partial derivative of $f(t,x)$ wrt $x$, then evaluate that expression at $X_t$". 
Upon substituting #eref(<eq:ito-lemma-derivation-1>) into #eref(<eq:ito-lemma-derivation-2>) we obtain

$
  dif f(t, X_t) = (diff f) / (diff t) dif t + (diff f) / (diff x) (mu_t dif t + sigma_t dif W_t) + 1 / 2 (diff^2 f) / (diff x^2) (mu_t dif t + sigma_t dif W_t)^2 med .
$
Now if we expand the term that's second order in $dif X_t$ and drop terms like $(dif t)^2$ and $dif t dif W_t$ (since they are of higher order than $dif t$) then the only surviving term will be $(dif W_t)^2$ and we get
$
  dif f(t, X_t) = (diff f) / (diff t) dif t + (diff f) / (diff x) (mu_t dif t + sigma_t dif W_t) + 1 / 2 (diff^2 f) / (diff x^2) sigma_t^2 (dif W_t)^2 med .
$
Now here's an argument I find pretty neat.
The expectation value of $dif W_t$ is zero and its variance is $dif t$, which is obviously $cal(O)(dif t)$, so the randomness of $dif W_t$ is relevant at order $dif t$. 
What about $(dif W_t)^2$? 
It's expectation value is $dif t$ and it's variance is order $(dif t)^2$, which is _much_ smaller than $dif t$, so the fact that $(dif W_t)^2$ is random is irrelevant at this scale, and we can simply replace it with its expectation value. 
This permits us to write $(dif W_t)^2 -> dif t$ which yields the expression,
#bluebox[
  *Ito Lemma*
  $
    dif f(t, X_t) = [(diff f) / (diff t) + (diff f) / (diff x) mu_t  + 1 / 2 (diff^2 f) / (diff x^2) sigma_t^2] dif t + (diff f) / (diff x) sigma_t dif W_t med .
  $
]

_Example:_

Let $dif X_t = tilde(mu) dif t + sigma W_t$ where $tilde(mu)$ and $sigma$ are constant, and let $S_t = exp(X_t)$. Then, by Ito's lemma we have
$
  dif S_t = [tilde(mu) exp(X_t)  + 1/2 sigma^2 exp(X_t) ] dif t + sigma exp(X_t)  dif W_t med .
$
Since $X_t = ln S_t$ we can equally as well write 
$
  dif S_t = [tilde(mu) S_t  + 1/2 sigma^2 S_t ] dif t + sigma S_t  dif W_t med .
$
Now define $mu equiv tilde(mu) + 1/2 sigma^2$ so that we can simplify this expression to
$
  dif S_t = mu S_t dif t + sigma S_t dif W_t med .
$ <eq:gbm-sde>
Any stochastic process satisfying #eref(<eq:gbm-sde>) is said to follow a _geometric Brownian motion_. It basically says that if $ln S_t$ is a random walk, then $S_t$ satisfies #eref(<eq:gbm-sde>). 

= Towards Black-Scholes

We're now armed with some of the tools needed to construct the Black-Scholes equation.
We know that the requirement of no-arbitrage singles out a particular price which prevents savvy investors from "winning every trade".
We saw how in the binomial tree model this could be achieved for pricing a European call option by constructing a replicating portfolio of cash bond and stock whose weights are updated at each discrete time step.
And now we know of Ito's lemma and of geometric Brownian motion.
It's time to tie these ideas together and write down the Black-Scholes equation.

Denote by $V(t, S_t)$ the value of a European call option at time $t$. We will suppose it expires at $t = T$ and has a strike of $K$. Let's start with some intuitive statements. I wrote $V(t, S_t)$ because it emphasises that $V$ could explicitly depend on $t$. 
But do we expect that it should? 
The answer is yes.
Imagine you have an option which expires 3 months from now versus an option that expires in 3 seconds. 
If both have the same strike, clearly the longer-dated option is worth more because there is _more uncertainty_ at the 3-month time horizon.
Therefore we anticipate that $V(t, S_t)$'s "exposure to time", quantified by $diff V slash diff t$ is nonzero and negative. 

Suppose $S_t$ is a geometric Brownian motion so that $dif S_t = mu S_t dif t + sigma S_t dif W_t$.
 We apply Ito's lemma to $V(t, S_t)$. 
 This gives us
$
  dif V(t, S_t) 
  &= (diff V) / (diff t) dif t + (diff V) / (diff S) dif S_t + 1/2 (diff^2 V) / (diff S^2) (dif S_t)^2 #no-num  \
  &= (diff V) / (diff t) dif t + (diff V) / (diff S) (mu S_t dif t + sigma S_t dif W_t) + 1/2 (diff^2 V) / (diff S^2) (mu S_t dif t + sigma S_t dif W_t)^2 #no-num \ 
  &= [(diff V) / (diff t) + mu S_t (diff V) / (diff S) + 1/2 sigma^2 S_t^2 (diff^2 V) / (diff S^2)] dif t +  sigma S_t (diff V) / (diff S) dif W_t
$ <eq:bs-deriv-1>

Now suppose we have a portfolio consisting of $Delta$ stock and $B$ cash bond. 
Denote its value at time $t$ by $Pi_t$.
$
  Pi_t = Delta S_t + B med .
$ <eq:bs-portfolio>
Suppose that we want to choose $Delta$ and $B$ so that the change in the value after waiting a time interval $dif t$ exactly matches the change in the value of the option over that same infinitesimal period. 
In other words, we're looking for $Delta$ and $B$ such that 
$
  dif Pi_t = dif V(t, S_t) med .
$ <eq:bs-deriv-2>
So long as #eref(<eq:bs-deriv-2>) is satisfied we must have $Pi_t = V(t, S_t)$ for all $t$. Otherwise, 

One one hand, computing the differential of #eref(<eq:bs-deriv-2>) yields
$
  dif Pi_t = Delta dif S_t + r B dif t med .
$
Setting this equal to $dif V(t, S_t)$ which is given by #eref(<eq:bs-deriv-1>) and using the fact that $S_t$ is a geometric Brownian motion, we get 
$
  Delta (mu S_t dif t + sigma S_t dif W_t) + r B dif t equiv [(diff V) / (diff t) + mu S_t (diff V) / (diff S) + 1/2 sigma^2 S_t^2 (diff^2 V) / (diff S^2)] dif t +  sigma S_t (diff V) / (diff S) dif W_t .
$ <eq:bs-deriv-3>
In order to eliminate the randomness from this expression we set

$
  Delta = (diff V) / (diff S) med .
$
#Eref(<eq:bs-deriv-3>) then reduces to
$
   [(diff V) / (diff t) + 1/2 sigma^2 S_t^2 (diff^2 V) / (diff S^2) - r B] dif t = 0 med .
$ <eq:bs-deriv-4>
Solving #eref(<eq:bs-deriv-4>) for $B$ and substituting back into #eref(<eq:bs-portfolio>) we have
$
  Pi_t = (diff V) / (diff S) S_t + 1 / r [(diff V) / (diff t) + 1/2 sigma^2 S_t^2 (diff^2 V) / (diff S^2)] med .
$ <eq:bs-deriv-5>
Moreover, if we impose the boundary condition that at time $T$ the portfolio has the same payoff as the option, that is $Pi_T = "max"(S_T - K, 0)$, then the prescription that $dif Pi_t = dif V(t, S_t)$ enforces $Pi_t = V(t, S_t)$ for all $t$ so we can make the replacement $Pi_t -> V(t, S_t)$ on the lhs of #eref(<eq:bs-deriv-5>) .
\
#bluebox[
  *Black Scholes Equation*  
  $
    r V(t, S_t) = (diff V) / (diff t) + r S_t (diff V) / (diff S) + 1/2 sigma^2 S_t^2 (diff^2 V) / (diff S^2) med .
  $
]



= Brownian motion

#definition[
  _Brownian motion_\
  The process $W = {W_t : t >= 0}$ is a $PP$-Brownian motion if and only if 

  + $W_t$ is continuous, and $W_0 = 0$,
  + the value of $W_t$ is distributed, under $PP$, as a normal random variable $N(0,t)$
  + the increment $W_(s + t) - W_s$ is distributed as a normal $N(0,t)$, under $PP$, and is independent of $cal(F)_s$, the history of what that process did up to time $s$.
]