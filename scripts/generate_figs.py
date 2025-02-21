import numpy as np
from scipy.stats import norm
import matplotlib.pyplot as plt
from pathlib import Path
from utils import color_gradient
plt.rcParams['backend'] = "Cairo"
if 'axion' in plt.style.available:
    plt.style.use('axion')

OUT_PATH = Path("../src/figs/")

def call_option_price(S, K, sigma, r, T):
    root_T = T ** 0.5
    sigma_root_T = sigma * root_T
    d1 = np.log(S / K) / sigma_root_T + (r / sigma) * root_T + sigma_root_T
    d2 = d1 - sigma_root_T
    call = S * norm.cdf(d1) - K * np.exp(-r * T) * norm.cdf(d2)
    return call

def gamma(S, K, sigma, r, T):
    root_T = T ** 0.5
    sigma_root_T = sigma * root_T

    if S * sigma_root_T < 1e-9:
      return float("inf")
    d1 = np.log(S / K) / sigma_root_T + (r / sigma) * root_T + sigma_root_T
    g = norm.pdf(d1) / (S * sigma_root_T)
    return g


def plot_call_vs_spot():
    # Constants
    K = 100
    sigma = 0.1
    r = 0.05

    # Spot price
    x = np.linspace(80, 120, 1000)

    # Color gradient for the plot
    colors = color_gradient(color="#377eb8", min_lightness=0.2, max_lightness=0.7, steps=3)[::-1]

    # Create figure
    fig, ax = plt.subplots(figsize=(5, 3))
    
    # Text positions (you might need to adjust these)
    y0 = 24.2
    dy = 1.9
    text_x = [92 for _ in range(3)]  # X coordinates for text
    text_y = [y0 - i*dy for i in range(3)]      # Y coordinates for text
    
    for i, color in zip(range(3), colors):
        T = [1, 0.5, 0.0][i]
        labels = ["1 year", "6 months", "0 months"][i]
        value = [call_option_price(_x, K, sigma, r, T) for _x in x]
        ax.plot(x, value, label=labels, color=color)
        
        # Add Gamma text near the lines
        gamma_value = gamma(K, K, sigma, r, T)
        kwargs = dict(horizontalalignment='left', verticalalignment='center', fontsize=9)
        if gamma_value < float("inf"):
            ax.text(text_x[i], text_y[i], f"$\\Gamma = {gamma_value:.2f}$", 
                    color=color, **kwargs)
        else:
            ax.text(text_x[i], text_y[i], f"$\\Gamma = \\infty$", color=color, **kwargs)

    # Add vertical line at strike price
    ax.axvline(K, color='black', linestyle='--', label='Strike Price ($K$)')

    ax.set_xlabel('$S$')
    ax.set_ylabel('$C(S)$')
    ax.legend(frameon=False)
    plt.savefig(OUT_PATH / 'call_vs_spot.png', bbox_inches='tight', format="png")
    plt.close()



if __name__ == '__main__':
    plot_call_vs_spot()