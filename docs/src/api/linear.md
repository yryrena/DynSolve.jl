# Linearization and Perturbation

## `linearize(model::Model, ss::Dict; order=1)`

Performs **symbolic linearization** (or higher-order expansion) around a steady state.

```julia
lin = linearize(model, ss; order=1)
```

### Returns

A dictionary containing matrices or Jacobians such as:

```julia
Dict(:A => [0.9], :B => [0.1])
```

### Method

- compute Jacobians of the model equations with respect to variables and shocks 
- substitute steady-state values 
- return coefficient matrices for the state-space representation:
$$
x_{t+1} = A x_t + B \varepsilon_t
$$



## Higher-Order Perturbations

Future releases will include:

- 2nd and 3rd order perturbation methods.
- Automatic symbolic differentiation for nonlinear terms.

------

## Example

```julia
lin = linearize(model, ss)
display(lin[:A])
```
 