#!/bin/bash

matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath(pwd)); test_OLDTW($1,$2,$3,$4,$5,$6,$7);quit;"
