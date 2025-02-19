#import "@local/templates:1.0.0" : *

= Black-Scholes

== Derivation

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
So long as #eref(<eq:bs-deriv-2>) is satisfied we must have $Pi_t = V(t, S_t)$ for all $t$. 

Otherwise, if $Pi_t != V(t, S_t)$, then there would exist an opportunity to construct a risk-free profit.
Specifically, if $Pi_t > V(t, S_t)$, one could sell the portfolio and buy the option, locking in a risk-free gain.
Conversely, if $Pi_t < V(t, S_t)$, one could sell the option and buy the replicating portfolio, again guaranteeing a profit without risk.
Such arbitrage opportunities cannot persist in an efficient market, meaning that the equality
$
  Pi_t = V(t, S_t)
$
must hold at all times.


On one hand, computing the differential of #eref(<eq:bs-deriv-2>) yields
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
  $ <eq:bs>
]

Assuming the "initial" condition $V(T, S_T) = max(S_T - K, 0)$ one obtains the solution

#bluebox[
  $
    V(S, K, t, sigma, r) = S Phi(d_+) - K e^(-r t) Phi(d_-)
  $
  where
  $
    d_(plus.minus) = (ln(S / K) + (r plus.minus sigma^2 / 2) t) / (sigma sqrt(t))
  $ <eq:d-plus-minus>
  and $Phi$ is the standard normal CDF $Phi(x) = integral_(-infinity)^x 1 / sqrt(2 pi) e^(-s^2/2) thin dif s$.
]

== Puts and put-call parity

_Note:_ In this section I will change some notation. I will denote the value of a call option by $C$ and the value of a put option by $P$.
These should be interpreted as functions of time even if I don't explicitly write the argument, since they dependend on the time to expiration.

You can do something similar for puts to get a formula for the value of the put. 
An easier way is to recognise that if you have a portfolio which is long a call and short a put, its payoff is $max(S_T - K, 0) - max(K - S_T, 0) = S_T - K$. 
When the time to expiration is $T$ we can easily construct another portfolio with same payoff by holding one stock and borrowing $K e^(-r T)$ dollars. 
By the requirement of no-arbitrage we therefore must have,
$
  C - P = S - K e^(-r T) med .
$

This important identity is known as Put-Call parity. 
Since it's important I'll highlight it one more time.

#bluebox[
  *Put-call parity*
  $
    C - P = S - K e^(- r T)
  $ <eq:put-call-parity>

  This formula holds not just at expiration but at all times.
  It is enforced by the requirement of no-arbitrage.
]

== Approximations and other useful identities

#bluebox[
  *ATF/ATM approximation*

  $
    C approx 0.4 S sigma sqrt(T)
  $
]


== Connection with heat equation

Under the change of variables
$
  tau = T - t, quad u = V e^(r tau) #no-num \
  x = ln(S / K) + (r - sigma^2/2) tau #no-num 
$
#eref(<eq:bs>) becomes the heat equation
$
  (diff u) / (diff tau) = 1/2 sigma^2 (diff^2 u) / (diff x^2) med 
$
with the initial condition $u(x, 0) = K (e^x - 1) thin bb(1)_(x > 0)$.
Since the Green's function for the heat equation is a Gaussian, the general solution for this initial condition involves convolving the end state with a Gaussian.
From this perspective, we can think of the solution to the Black-Scholes equation as taking the payoff function and smoothing it with a Gaussian whose width depends on the time to expiration ($tau$) and the volatility $sigma$.
This intuition will be useful later when we discuss option risks.

= Brownian motion

#definition[
  _Brownian motion_\
  The process $W = {W_t : t >= 0}$ is a $PP$-Brownian motion if and only if 

  + $W_t$ is continuous, and $W_0 = 0$,
  + the value of $W_t$ is distributed, under $PP$, as a normal random variable $N(0,t)$
  + the increment $W_(s + t) - W_s$ is distributed as a normal $N(0,t)$, under $PP$, and is independent of $cal(F)_s$, the history of what that process did up to time $s$.
]