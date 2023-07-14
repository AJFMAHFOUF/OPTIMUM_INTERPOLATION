import numpy as np
import matplotlib.pyplot as plt
L = 1000
N = 6
x=np.arange(0,N*(L+1),2)
x1 = x/L
y1 = np.exp(-0.5*x1**2)
y2 = (1.0 + x1)*np.exp(-x1) 
L2 = 1.5*L
y3 = 0.5*(np.exp(-x1) + (1 + 2*x1)*np.exp(-2*x1)) #np.exp(-0.5*(x/L2)**2)
plt.plot(x1,y1,linewidth=3,color='red',label='C=exp[-0.5*(r/L)^2]')
plt.plot(x1,y2,linewidth=3,color='blue',label='C=(1+r/L)*exp(-r/L)')
plt.plot(x1,y3,linewidth=3,color='green',label='MESAN')
plt.title ('Modèles de corrélations horizontales')
plt.xlabel('Longueur normalisée (r/L)')
plt.ylabel('Correlation (C)')
plt.xlim(0,N)
plt.legend(loc='best')
plt.savefig('../PLOTS/correl3.png')
plt.show()
