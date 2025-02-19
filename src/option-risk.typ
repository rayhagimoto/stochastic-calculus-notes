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

The formula for $Delta$ is a bit complicated, so for now let's just write down some intuition. 
First, $-1 < Delta < 1$.
An in-the-money call is long the stock.
The deeper in the money, the closer $Delta -> 1$.
At the money ($K = S$) or at the forward ($K = S e^(r t)$), $Delta approx 0.5$.

For both puts and calls, $Gamma approx 1 / (S sigma sqrt(T))$.
For now we'll just talk about calls, but similar ideas can be applied to puts. 
First of all, remember that we can think of the function $C(S_t, t)$ like a smoothed out version of the option payoff $max(S_T - K, 0)$.
So you can imagine taking the hockey stick function and convolving it with a Gaussian to get a smoothed out profile. 
As you get closer to expiration, you get closer to the hockey stick curve. 
At $S = K$ this function has effectively $+infinity$ convexity ($Gamma -> infinity$). This helps explain the presence of the $1 / sqrt(T)$ in the formula.

#figure(
  image("figs/gamma-versus-DTE.png", width:70%),
  caption: [
    Call option price assuming $K = 100$, $r = 0.05$, $sigma = 0.1$ versus spot for different DTEs shown in the legend. 
    The legend also shows the $Gamma$ evaluated at the strike. It shows that 
  ]
)

== Trader terminology

Motivating questions:
+ Suppose you're long one call with expiration at $T_1$ and short another call in the same underlying and the same strike but expiration at $T_2 > T_1$. Is your position 
  + long $rho$?
  + long $cal(V)$?
  + long the underlying?
