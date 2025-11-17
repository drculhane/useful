import arkouda as ak ; import numpy as np
import sys

from arkouda.comm_diagnostics \
    import (start_comm_diagnostics, stop_comm_diagnostics, print_comm_diagnostics_table, reset_comm_diagnostics)

ak.connect()

if len(sys.argv) > 1 :
    iseed = int(sys.argv[1])
else :
    iseed = 1701
np.random.seed(iseed)
nleft = np.random.randint(-10,10,(11,11,11,250))
nright = np.random.randint(-10,10,(11,11,250,11))
nprod = np.matmul(nleft,nright)

print ("\n\nTesting 4D matrix multiplication: non-distributed, then distributed.")
print()
pleft = ak.array(nleft) ; pright = ak.array(nright)
start_comm_diagnostics()
pprod1 = ak.matmul(pleft, pright)
stop_comm_diagnostics()
print_comm_diagnostics_table()

print()
reset_comm_diagnostics()
start_comm_diagnostics()
pprod2 = ak.distmatmulmultidim(pleft,pright)
stop_comm_diagnostics()
print_comm_diagnostics_table()

n1 = pprod1.to_ndarray() ;

n2 = pprod2.to_ndarray()

print()
print ((nprod==n1).all())
print ((nprod==n2).all())

ak.shutdown()
