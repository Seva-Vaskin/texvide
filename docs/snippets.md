# LaTeX Snippets Guide

> Inspired by [gillescastel/latex-snippets](https://github.com/gillescastel/latex-snippets)

This guide covers the most useful snippets available in TexVIDE for LaTeX document creation.

## Basic Structure

### Document Template
```latex
template<Tab>
```
Creates a basic LaTeX document structure with common packages:
- UTF-8 encoding
- AMS Math support
- Figure support
- Basic document structure

### Environments
```latex
beg<Tab>
```
Creates a begin/end environment structure:
```latex
\begin{name}
    
\end{name}
```

## Math Mode

### Inline Math
```latex
mk<Tab>
```
Creates inline math mode: `$...$`

### Display Math
```latex
dm<Tab>
```
Creates display math mode:
```latex
\[
    
.\]
```

### Align Environment
```latex
ali<Tab>
```
Creates align environment:
```latex
\begin{align*}
    
.\end{align*}
```

## Fractions

### Quick Fraction
```latex
//
```
In math mode, creates a fraction: `\frac{}{}`

### Smart Fraction
```latex
1/2
```
Automatically creates: `\frac{1}{2}`

Also works with expressions:
```latex
(x+y)/2
```
Becomes: `\frac{x+y}{2}`

## Subscripts and Superscripts

### Auto Subscripts
```latex
x1
```
Automatically becomes: `x_1`

```latex
x12
```
Automatically becomes: `x_{12}`

### Powers
```latex
sr
```
In math mode, adds square: `^2`

```latex
cb
```
In math mode, adds cube: `^3`

```latex
td
```
In math mode, adds general power: `^{}`

## Common Structures

### Matrices
```latex
pmat<Tab>
```
Creates parenthesis matrix:
```latex
\begin{pmatrix}  \end{pmatrix}
```

```latex
bmat<Tab>
```
Creates bracket matrix:
```latex
\begin{bmatrix}  \end{bmatrix}
```

### Lists
```latex
enum<Tab>
```
Creates enumerated list:
```latex
\begin{enumerate}
    \item 
\end{enumerate}
```

```latex
item<Tab>
```
Creates bulleted list:
```latex
\begin{itemize}
    \item 
\end{itemize}
```

## Math Operators and Symbols

### Common Operators
- `sum` → `\sum_{n=1}^{\infty}`
- `lim` → `\lim_{n \to \infty}`
- `prod` → `\prod_{n=1}^{\infty}`
- `part` → `\frac{\partial V}{\partial x}`

### Symbols
- `ooo` → `\infty`
- `>=` → `\ge`
- `<=` → `\le`
- `!=` → `\neq`
- `->` → `\to`
- `!>` → `\mapsto`

### Sets
- `NN` → `\N` (Natural numbers)
- `RR` → `\R` (Real numbers)
- `QQ` → `\Q` (Rational numbers)
- `ZZ` → `\Z` (Integers)
- `inn` → `\in`
- `notin` → `\not\in`

## Advanced Features

### Auto-Expanding Functions
Mathematical functions automatically expand:
- `sin` → `\sin`
- `cos` → `\cos`
- `log` → `\log`
- `exp` → `\exp`

### Smart Brackets
```latex
lr(<Tab>
```
Creates `\left( \right)`

Similar snippets:
- `lr[` for square brackets
- `lr{` for curly braces
- `lr|` for absolute value

### Integrals
```latex
dint<Tab>
```
Creates definite integral:
```latex
\int_{-\infty}^{\infty}
```

## Figures and Tables

### Figure Environment
```latex
fig<Tab>
```
Creates complete figure environment:
```latex
\begin{figure}[htpb]
    \centering
    \includegraphics[width=0.8\textwidth]{name}
    \caption{caption}
    \label{fig:name}
\end{figure}
```

### Table Environment
```latex
table<Tab>
```
Creates complete table environment:
```latex
\begin{table}[htpb]
    \centering
    \caption{caption}
    \label{tab:label}
    \begin{tabular}{c}
    
    \end{tabular}
\end{table}
```

## Tips

1. Most snippets work in math mode only when appropriate
2. Many snippets are context-aware and will behave differently based on where you use them
3. The `<Tab>` key is used to trigger snippets and move between placeholder positions
4. Visual selections can be wrapped in environments or commands using many of these snippets

## Advanced Math Features

### Cases Environment
```latex
case<Tab>
```
Creates cases environment:
```latex
\begin{cases}
    
\end{cases}
```

### Column Vector
```latex
cvec<Tab>
```
Creates a column vector:
```latex
\begin{pmatrix} x_1\\ \vdots\\ x_n \end{pmatrix}
```

### Big Function Definition
```latex
bigfun<Tab>
```
Creates a function definition with domain and codomain:
```latex
\begin{align*}
    f: X &\longrightarrow Y \\
    x &\longmapsto f(x) = 
.\end{align*}
```

