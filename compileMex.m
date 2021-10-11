cd collector
mex getRaster.c
cd ../

cd prediction/predVariationalSubFunctions/CCode
%mex optQCC.c
mex optQCC.c COMPFLAGS="\$COMPFLAGS -march=native -Wall -fopenmp" CXXFLAGS="\$CXXFLAGS -fopenmp"
mex calcFuncValsC.c COMPFLAGS="\$COMPFLAGS -march=native -Wall -fopenmp" CXXFLAGS="\$CXXFLAGS -fopenmp"
mex calcCondQB.c COMPFLAGS="\$COMPFLAGS -march=native -Wall -fopenmp" CXXFLAGS="\$CXXFLAGS -fopenmp"
mex calcMuAB2.c COMPFLAGS="\$COMPFLAGS -march=native -Wall -fopenmp" CXXFLAGS="\$CXXFLAGS -fopenmp"
cd ../../../

cd training
mex cglasso.c
mex getCondTransMatrixC.c

cd ../
cd prediction/helperFunctions
mex -DMX_COMPAT_32 sumProductSparseC.c COMPFLAGS="\$COMPFLAGS -march=native -Wall -fopenmp" CXXFLAGS="\$CXXFLAGS -fopenmp" 
%mex sumProductSparseC.c
cd ../../
