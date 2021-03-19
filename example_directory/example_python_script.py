### EXAMPLE PYTHON SCRIPT ########################

# -- Modules -------------------------

import numpy as np
import matplotlib
import matplotlib.pyplot as plt

# -- Load data -------------------------

t = np.arange(0.0, 2.0, 0.01)
s = 1 + np.sin(2 * np.pi * t)

# -- Create plot -------------------------

fig, ax = plt.subplots()
ax.plot(t, s)

ax.set(xlabel='time (s)', ylabel='voltage (mV)',
       title='Simple sinusoid plot')
ax.grid()
plt.show()
