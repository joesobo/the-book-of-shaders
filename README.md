# My Book of Shaders - Godot Edition

A playground project for exploring and learning shader development in Godot. This repo serves as a learning resource and a collection of shader implementations, covering both visual shader techniques and code-based shader programming.

---

## Shader Collection

### Visual Effects Shaders
- **Dissolve** - Dissolve/fade effect shader
- **Flash** - Animated color cycling effect with controllable flash speed
- **Hologram** - Holographic display effect
- **Hull Outline** - Object outline/edge highlighting shader
- **UV** - UV coordinate visualization shader for texture debugging
- **Voronoi Water** - Animated water surface with foam layers using Voronoi patterns and flow maps
- **Equation** - Display for mathematical equations impact on brightness

### Color Shaders
- **Color** through **Color10** - A collection of 10 shaders demonstrating how colors interact and influence each other when placed in different contexts, inspired by Josef Albers' Interaction of Color

### Shape Shaders
- **Triangle** - Triangle shape shader using signed distance fields (SDF) with customizable size and colors
- **PietMondrian** - Geometric composition shader inspired by Piet Mondrian's abstract art style, featuring rectangular shapes with independent fill and outline colors
- **Rect** - Rectangle outline shader demonstration
- **Distance** - Distance field visualization shader demonstrating various distance metrics
- **Overlap** - Distance field operations shader with multiple calculation modes (Normal, Min, Max) and drawing modes (Fract, Step, Double Step, Smoothstep)
- **Polygon** - Polar coordinate-based polygon shader for creating regular polygons with adjustable sides
- **Flower** - Polar coordinate flower patterns with 5 different modes (Three, Six, Five, Eighteen, Gear) using trigonometric functions
- **Logo** - Custom logo creation shader using combination of primitive shapes with customizable colors

---

## Shader Library

### Shape Primitives (`shaders/shapes/basic.gdshaderinc`)
A collection of reusable shape functions for building complex shader effects:
- **Rectangles** - Multiple variations including filled, outlined, and positioned rectangles
- **Circles** - Filled circles, blurred circles, and circle outlines with customizable center and radius
- **Triangles** - Triangle shapes using signed distance fields
- **Lines** - Line segment drawing with adjustable thickness for creating custom patterns

### Mathematical Shaping Functions
- **Equations** - Interactive shader demonstrating 33 mathematical shaping functions for easing, tweening, and signal shaping
  - **12 Built-in GLSL functions** - Basic math operations (ceil, floor, fract, mod, sin, etc.)
  - [Polynomial Shaping Functions](https://www.flong.com/archive/texts/code/shapers_poly/index.html)
  - [Exponential Shaping Functions](https://www.flong.com/archive/texts/code/shapers_exp/)
  - [Circular & Elliptical Shaping Functions](https://www.flong.com/archive/texts/code/shapers_circ/)
  - [Bezier and Parametric Shaping Functions](https://www.flong.com/archive/texts/code/shapers_bez/)

### Custom Visual Node Scripts
- **PerlinNoise3DNode** - 3D Perlin noise implementation
- **SimpleNoiseNode** - Basic noise generation
- **VoronoiNode** - Voronoi diagram/cellular noise patterns

---

## Resources

- [Godot Shading Language Documentation](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/index.html)
- [The Book of Shaders](https://thebookofshaders.com/) - Original inspiration
- [Making Effects with Godot Visual Shaders](https://danielilett.com/2024-02-06-tut8-1-godot-shader-intro/)
- [Interaction of Color by Josef Albers](https://www.goodreads.com/book/show/111113.Interaction_of_Color)
- [Patricio Gonzalez Lygia GLSL Shader Library](https://github.com/patriciogonzalezvivo/lygia)
