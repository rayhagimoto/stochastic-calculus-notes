#import "@local/templates:1.0.0" : *

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