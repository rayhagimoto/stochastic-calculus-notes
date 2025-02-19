#import "@local/templates:1.0.0" : *

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