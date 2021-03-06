#optimization for determining the IC triangle size
#ref: https://www.cvxpy.org/examples/basic/linear_program.html
#Import packages.
import cvxpy as cp
import numpy as np
import math 

L = 3;
N = 5;
e_sym=1;
e_th = math.factorial(N-1);
i_sym = math.factorial(N-1);
lsta = [1,3];

for i in range(3,N+1):
  lsta.append(math.factorial(i));

x  = 1*np.ones((10,10));
P_0 = np.ones((4,1));
P_1 = np.ones((4,1));
delta_1 = np.ones((4,1));
x_0 = x[:,[0]];
x_1 = x[:,[1]];

Pk = np.ones((10,10));
deltak = np.ones((10,10));

print(P_k);

print(x_0[:,0]);

print(Pk[:,0]*(deltak[:,0])@(xk[:,0]));

print('star1: ',sum(sum((Pk[[2,3],:]*deltak[[2,3],:])*x[[2,3],:])));

print((x[0]))

print('star2',np.sum(x))

# Generate a random non-trivial linear program.
np.random.seed(1)

# Define and solve the CVXPY problem.
n_sym = cp.Variable(1)
e_sic = cp.Variable((n,1),"e_sic");
p_signal = cp.Variable((1),"p_signal");
p_interference  = cp.Variable((1),"p_interference");
N_0  = cp.Variable(1)
xk = cp.Variable((n,n), "xk",boolean=True)
#deltak =cp.Variable((n,n),"deltak", boolean=True)
prob = cp.Problem(cp.Maximize(n_sym),
                 [sum(cp.sum(xk))==n_sym,
                 cp.multiply(Pk[:,0],(xk[:,0]))==p_signal,
                 cp.multiply(Pk[:,1],deltak[:,1])@xk[:,1]>=p_interference,
                 ])
prob.solve()

print("A solution nsym is",n_sym.value)

print("A solution x",x)

if (n_sym.value != None and math.ceil(n_sym.value) in lsta):
  # Print result.
  print("\nThe optimal value is", prob.value)
  print("A solution nsym is",math.ceil(n_sym.value))
