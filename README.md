# upward_radar
upward radar project


Processing workflow:

1. upsample in `matlab` using `FFTinterp.m`
2. perform matched filtering by calling Keith's `C` code from `matlab` using `match_filter_master.m`. This file calls the `C` code on all files within a folder
3. use `peak_averager.m` to calculate mean and standard deviation of all peaks within chirp