# ClkDiv — Integer Clock Divider

An integer clock divider I implemented in Verilog, supporting both even and odd division ratios with a 50% duty cycle output.

## About the Design

The module takes a reference clock `i_ref_clk` and produces a divided clock `o_div_clk` such that `fout = fin / n`, where `n` is set by `i_div_ratio`.

- **Even ratios** use a single toggle register (`clk_div`) driven off one posedge counter (`count_positive`).
- **Odd ratios** reuse the same posedge toggle register together with a second toggle register (`clk_odd_div`) clocked on the negedge, OR-ed together to keep the duty cycle balanced — sharing the posedge counter/register between even and odd paths instead of duplicating them.
- The divider is only enabled when `i_clk_en` is high **and** `i_div_ratio` is neither 0 nor 1:
  ```
  enable = i_clk_en && (i_div_ratio != 0) && (i_div_ratio != 1)
  ```
- When disabled, `o_div_clk` passes `i_ref_clk` through directly.

> **Optimization note:** the RTL was refactored to share the toggle register and counter between the even and odd division paths (previously separate: 3 toggle FFs + 5 counters → now: 2 toggle FFs + 2 counters), reducing register count, cell area, and power while keeping the same I/O behavior. Re-checked clean with SpyGlass lint (see `lint_reports/`).

### Ports

| Signal        | Direction | Width | Description                       |
|---------------|-----------|-------|-------------------------------------|
| `i_ref_clk`   | input     | 1     | Reference clock                     |
| `i_rst_n`     | input     | 1     | Active-low asynchronous reset       |
| `i_clk_en`    | input     | 1     | Clock divider enable                |
| `i_div_ratio` | input     | 8     | Division ratio (integer value)      |
| `o_div_clk`   | output    | 1     | Divided output clock                |

## Repository Structure

```
rtl/            → design source file
tb/             → testbench and simulation scripts
lint_reports/   → lint check report
docs/images/    → simulation waveforms
```

## Simulation Results

Verified divided clocks for both even and odd ratios (2, 3, 4, 5, 16, 32):

![Waveforms - even & odd ratios](docs/images/simulation_waveforms_div2to32.png)

Corner cases — `i_div_ratio = 1` and `i_div_ratio = 0` correctly disable the divider and pass `i_ref_clk` through:

![Waveforms - corner cases](docs/images/simulation_waveforms_cornercases.png)

## Tools Used

- Simulation: ModelSim/QuestaSim
