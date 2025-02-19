#import "@local/templates:1.0.0" : *

= The Greeks

In the Black-Scholes model the value of the option is exposed to numerous factors, not just the stock price.
These are quantified by the _option Greeks_ $Delta$, $Gamma$, $cal(V)$, $Theta$, $rho$.

#bluebox[
  *The Greeks*
  $
    Delta &equiv (diff V) / (diff S) \
    Gamma &equiv (diff^2 V) / (diff S^2) = (diff Delta) / (diff S) \
    cal(V) &equiv (diff V) / (diff sigma) \
    Theta &equiv (diff V) / (diff T) \
    rho &equiv (diff V) / (diff r) 
  $
]

== Approximations for the Greeks

Below are some approximations for the values of the Greeks using the Black-Scholes formula. 
I use $Phi$ to denote the standard normal CDF and $phi$ to denote its PDF.
$d_+$ and $d_-$ are defined in #eref(<eq:d-plus-minus>)

#set align(center)
#table(
  columns:3,
  rows:6,
  [Greek], [Call Option], [Put Option],
  [Delta], [$Phi(d_+)$], [$Phi(d_+) - 1$],
  [Gamma], [$phi(d_+) slash S sigma sqrt(T)$], [Same],
  [Vega], [$S sqrt(T) phi(d_+)$], [Same],
  [Rho], [$K T e^(-r T) Phi(d_-)$], [$-K T e^(-r T) Phi(-d_-)$],
  [Theta], [< 0], [< 0 (can be > 0)],
)
#set align(left)

_Delta_

$Delta ~ Phi(d_+) approx (1/2 + 0.4 thin d_+)$
First, $-1 < Delta < 1$.
An in-the-money call is long the stock.
The deeper in the money, the closer $Delta -> 1$.
At the money ($K = S$) or at the forward ($K = S e^(r t)$), $Delta approx 0.5$.

_Gamma_

Same for puts and calls:
$Gamma ~ phi(d_+) / (S sigma sqrt(T))$.
 At-the-money: $Gamma ~ 0.4 / (S sigma sqrt(T))$.
Here I'll write about calls, but the same logic works for puts.
First of all, remember that we can think of the function $C(S_t, t)$ like a smoothed out version of the option payoff $max(S_T - K, 0)$.
So you can imagine taking the hockey stick function and convolving it with a Gaussian to get a smoothed out profile. 
As you get closer to expiration, you get closer to the hockey stick curve. 
At $S = K$ this function has effectively $+infinity$ convexity ($Gamma -> infinity$). This helps explain the presence of the $1 / sqrt(T)$ in the formula.

#figure(
  image("figs/gamma-versus-DTE.png", width:70%),
  caption: [
    Call option price assuming $K = 100$, $r = 0.05$, $sigma = 0.1$ versus spot for different DTEs shown in the legend. 
    The legend also shows the $Gamma$ evaluated at the strike. It shows that $Gamma$ decreases with $sqrt(T)$.
  ]
)




== Trader terminology

Motivating questions:
+ Suppose you're long one call with expiration at $T_1$ and short another call in the same underlying and the same strike but expiration at $T_2 > T_1$. Is your position 
  + long $rho$?
  + long $cal(V)$?
  + long the underlying?
