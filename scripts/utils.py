from typing import Union, List, Tuple, Optional
import colorsys

# Try to import matplotlib, use default color if not available
try:
    import matplotlib.pyplot as plt
    DEFAULT_COLOR = plt.rcParams["axes.prop_cycle"].by_key()["color"][0]
except ImportError:
    DEFAULT_COLOR = "#377eb8"

def parse_color(
    color: Union[str, Tuple, List], kind: Optional[str] = None
) -> Tuple[float, float, float, float]:
    """
    Parse color input into RGBA format (0-1 range).
    
    Args:
        color: Color input in various formats
        kind: Force specific color format interpretation ('HEX', 'RGB', 'RGBA', 'HSV', 'HSL')
    
    Returns:
        Tuple of (r, g, b, a) values in 0-1 range
    """
    if isinstance(color, (tuple, list)):
        if len(color) == 3:
            r, g, b = color
            a = 1.0
        elif len(color) == 4:
            r, g, b, a = color
        else:
            raise ValueError("Tuple/List color must have 3 or 4 components")
            
        if kind == "HSV":
            r, g, b = colorsys.hsv_to_rgb(r, g, b)
        elif kind == "HSL":
            r, g, b = colorsys.hls_to_rgb(r, g, b)
            
        return (r, g, b, a)
    
    if isinstance(color, str):
        # Remove '#' if present and convert to lowercase
        color = color.strip("#").lower()
        
        # Handle matplotlib style references
        if color.startswith("c"):
            try:
                color = plt.rcParams["axes.prop_cycle"].by_key()["color"][int(color[1:])]
                color = color.strip("#").lower()
            except:
                raise ValueError(f"Invalid matplotlib color reference: {color}")
        
        # Parse HEX format
        if kind in (None, "HEX"):
            if len(color) == 6:
                r = int(color[0:2], 16) / 255
                g = int(color[2:4], 16) / 255
                b = int(color[4:6], 16) / 255
                return (r, g, b, 1.0)
            elif len(color) == 8:
                r = int(color[0:2], 16) / 255
                g = int(color[2:4], 16) / 255
                b = int(color[4:6], 16) / 255
                a = int(color[6:8], 16) / 255
                return (r, g, b, a)
    
    raise ValueError(f"Invalid color format: {color}")

def set_lightness(
    color: Union[str, Tuple, List],
    lightness: float,
    opacity: Optional[float] = None,
    kind: Optional[str] = None,
) -> str:
    """
    Adjust the lightness and optionally opacity of a color.
    
    Args:
        color: Input color in various formats
        lightness: Target lightness value (0-1)
        opacity: Optional opacity value (0-1)
        kind: Force specific color format interpretation
    
    Returns:
        HEX color string with adjusted lightness/opacity
    """
    if lightness < 0 or lightness > 1:
        raise ValueError("Lightness must be between 0 and 1")
    
    if opacity is not None and (opacity < 0 or opacity > 1):
        raise ValueError("Opacity must be between 0 and 1")
    
    # Parse input color to RGBA
    r, g, b, a = parse_color(color, kind)
    
    # Convert to HSL
    h, l, s = colorsys.rgb_to_hls(r, g, b)
    
    # Adjust lightness
    r, g, b = colorsys.hls_to_rgb(h, lightness, s)
    
    # Apply opacity if specified
    if opacity is not None:
        a = opacity
    
    # Convert back to HEX
    hex_color = "#{:02x}{:02x}{:02x}".format(
        int(r * 255), int(g * 255), int(b * 255)
    )
    if a < 1:
        hex_color += "{:02x}".format(int(a * 255))
    
    return hex_color

def color_gradient(
    min_lightness: float = 0.1,
    max_lightness: float = 0.7,
    steps: int = 5,
    color: Union[str, Tuple, List] = DEFAULT_COLOR,
    kind: Optional[str] = None,
) -> List[str]:
    """
    Create a gradient of colors with varying lightness.
    
    Args:
        min_lightness: Minimum lightness value (0-1)
        max_lightness: Maximum lightness value (0-1)
        steps: Number of colors in gradient
        color: Base color to create gradient from
        kind: Force specific color format interpretation
    
    Returns:
        List of HEX color strings
    """
    if steps < 2:
        raise ValueError("Steps must be at least 2")
    
    if min_lightness < 0 or min_lightness > 1 or max_lightness < 0 or max_lightness > 1:
        raise ValueError("Lightness values must be between 0 and 1")
    
    lightness_values = [
        min_lightness + (max_lightness - min_lightness) * i / (steps - 1)
        for i in range(steps)
    ]
    
    return [set_lightness(color, l, kind=kind) for l in lightness_values]
