# SFC of IMS nodes - performability abalysis

This repository stores the project work for the Cloud Systems and Advanced Networking course.

The **performance** folder stores:

* single-class analysis with `Jackson` formalism,
* multi-class analysis with `BCMP` formalism.

The **availability** folder stores:

* single-class availability analysis with SHARPE tool,
* multi-class availability analysis with SHARPE tool,
* `sfc_opt.py` which performs the search of the solution minimizing the total cost,
* `suboptimal_solutions.py` which performs the search of the suboptimal solutions,
* `readValuesFromCSVAndEvaluateAvailability.m` which draws the sensitivity analysis' plots,
* the folder `sensitivity` contains the CSV files with the availability measures obtained to perform the sensitivity analysis,
* the folder `solutions` contains the CSV files with the suboptimal solutions found,
* the `+RBD` folder which contains the utility functions for RBDs.
