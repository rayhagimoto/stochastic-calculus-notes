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
  image("figs/call_vs_spot.png"),
  caption: [
    Call option price assuming $K = 100$, $r = 0.05$, $sigma = 0.1$ versus spot for different DTEs shown in the legend. 
    The legend also shows the $Gamma$ evaluated at the strike. It shows that $Gamma$ decreases with $sqrt(T)$.
  ]
) <fig:call-vs-stock-price-DTE>

_Rho_

*Calls:*
$K T e^(-r T) Phi(d_-)$. For small $r$, and ATM, this is approximately $0.5 thin K T (1 - r T)$. 
Therefore longer dated calls (larger $T$), increase in value more when interest rates increase. 
Why? 
If you think of a call as a leveraged position in a stock, then imagine if the stock is worth \$100 right now. 
If the call costs \$10 then you can buy the call and effectively free up \$90 to invest at the risk-free rate, which is good for you.
Another way to look at it is that options are kind of like a delayed purchase with a fixed price of $\$K$ (which you are not obligated to exercise). 
If you have $\$K e^(-r T)$ dollars today, then you can afford to exercise the option at expiration.
The higher $r$ is, the less cash you need to have now to do this, which makes the call more attractive.
Therefore _calls gain value when interest rates increase_.

*Puts:*
$P = K T e^(-r T) Phi(-d_2)$  
For small $r$, and at-the-money (ATM), this is approximately  
$P approx 0.5 K T (1 - r T)$.  
Since the last term $-r T$ reduces the value of the put, we see that _puts lose value when interest rates increase_.
Why?  
Unlike calls, a put option behaves more like a prepaid insurance policy against a stock decline. If you want to short a stock, one alternative is simply borrowing and selling the stock today, which costs nothing upfront and gives you cash in hand that you can invest at the risk-free rate.

However, buying a put requires _paying upfront_, which means you have _less money to invest elsewhere_. When interest rates rise, this opportunity cost becomes larger, making puts _less attractive_.
Another way to see this:  
- A put option gives you the right to _sell at a fixed price \( K \) in the future_.  
- If interest rates are high, the present value of receiving \( K \) in the future _decreases_.  
- This makes the put less valuable today because the strike price effectively "shrinks" in real terms as rates rise.  


== Option portfolios

#set enum(numbering: "1a.")

+ Suppose you're long one ATM call with expiration at $T_1$ and short another ATM call in the same underlying and the same strike but expiration at $T_2 > T_1$. Is your position 
  + long $rho$?
  + long $cal(V)$?
  + long the underlying?

Since calls increase in value with $r$ the long call is long Rho and the short call is short Rho.
However, the effect of interest is greater when there is more time to expiration so the portfolio is net short Rho.
Something similar can be said for $cal(V)$. 
The position is net short $cal(V)$.
Delta is a bit tricky but we can figure it out in a few ways. 
First of all, we can approximate $Delta approx Phi(d_1) ~ (r/sigma + sigma) sqrt(T)$ (where I've ignored a term that decays like $1 slash sqrt(T)$ as well as constant terms, because I only care about the dominant scaling with $T$). 
This suggests that $Delta$ will generally grow with time to expiration.
So the position is short the stock.
Another way to see this is to look at the slopes of the curves in @fig:call-vs-stock-price-DTE. 
As DTE gets smaller the change in slope becomes more dramatic and asymptotes to $Delta = 0.5$ for very small $T$.