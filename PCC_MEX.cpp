/***********************************************************************/
/************************* DISCLAIMER **********************************/
/***********************************************************************/
/** This UCR Suite software is copyright protected � 2012 by          **/
/** Thanawin Rakthanmanon, Bilson Campana, Abdullah Mueen,            **/
/** Gustavo Batista and Eamonn Keogh.                                 **/
/**                                                                   **/
/** Unless stated otherwise, all software is provided free of charge. **/
/** As well, all software is provided on an "as is" basis without     **/
/** warranty of any kind, express or implied. Under no circumstances  **/
/** and under no legal theory, whether in tort, contract,or otherwise,**/
/** shall Thanawin Rakthanmanon, Bilson Campana, Abdullah Mueen,      **/
/** Gustavo Batista, or Eamonn Keogh be liable to you or to any other **/
/** person for any indirect, special, incidental, or consequential    **/
/** damages of any character including, without limitation, damages   **/
/** for loss of goodwill, work stoppage, computer failure or          **/
/** malfunction, or for any and all other damages or losses.          **/
/**                                                                   **/
/** If you do not agree with these terms, then you you are advised to **/
/** not use this software.                                            **/
/***********************************************************************/
/***********************************************************************/


#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <iostream>
#include "mex.h"

#define INF 1e20       //Pseudo Infitinte number for this code

using namespace std;

/// Data structure for sorting the query.
typedef struct Index
    {   double value;
        int    index;
    } Index;


/// Comparison function for sorting the query.
/// The query will be sorted by absolute z-normalization value, |z_norm(Q[i])| from high to low.
int comp(const void *a, const void* b)
{   Index* x = (Index*)a;
    Index* y = (Index*)b;
    return abs(y->value) - abs(x->value);
}


/// Main function for calculating PCC distance between the query, Q, and current data, T.
/// Note that Q is already sorted by absolute z-normalization value, |z_norm(Q[i])|
/// This is the only difference between this and ED method
//double distance(const double * const Q, const double * const T , const int& j , const int& m , const double& mean , const double& std , const int* const order, const double& bsf)
double distance(double * Q, double * T , const int& j , const int& m , const double& mean , const double& std , int* order, const double& bsf)
{
    int i;
    double sum = 0;
    for ( i = 0 ; i < m ; i++ )
    {
        double x = (T[(order[i]+j)]-mean)/std;
        sum += x*Q[i];
    }
    return sum;
}


/// If serious error happens, terminate the program.
void error(int id)
{
    if(id==1)
        printf("ERROR : Memory can't be allocated!!!\n\n");
    else if ( id == 2 )
        printf("ERROR : File not Found!!!\n\n");
    else if ( id == 3 )
        printf("ERROR : Can't create Output File!!!\n\n");
    else if ( id == 4 )
    {
        printf("ERROR: Invalid Number of Arguments!!!\n");
        printf("Command Usage:   UCR_ED.exe  data_file  query_file   m   \n");
        printf("For example  :   UCR_ED.exe  data.txt   query.txt   128  \n");
    }
    exit(1);
}


class mystream : public std::streambuf
{
protected:
virtual std::streamsize xsputn(const char *s, std::streamsize n) { mexPrintf("%.*s", n, s); return n; }
virtual int overflow(int c=EOF) { if (c != EOF) { mexPrintf("%.1s", &c); } return 1; }
};
class scoped_redirect_cout
{
public:
  scoped_redirect_cout() { old_buf = std::cout.rdbuf(); std::cout.rdbuf(&mout); }
  ~scoped_redirect_cout() { std::cout.rdbuf(old_buf); }
private:
  mystream mout;
  std::streambuf *old_buf;
};


void cpp_pcc(char *Data_File, char *Query_File, int m, double *y, double *s )
{
    FILE *fp;              // the input file pointer
    FILE *qp;              // the query file pointer

    double *Q;             // query array
    double *T;             // array of current data
    int *order;            // ordering of query by |z(q_i)|
    double bsf;            // best-so-far
    long long loc = 0;     // answer: location of the best-so-far match

    double d;
    long long i , j ;
    double ex , ex2 , mean, std;

    double t1,t2;

    t1 = clock();

    bsf = -INF;
    i = 0;
    j = 0;
    ex = ex2 = 0;

    fp = fopen(Data_File,"r");
    if( fp == NULL )
        exit(2);

    qp = fopen(Query_File,"r");
    if( qp == NULL )
        exit(2);


    /// Array for keeping the query data
    Q = (double *)malloc(sizeof(double)*m);
    if( Q == NULL )
        error(1);

    /// Read the query data from input file and calculate its statistic such as mean, std
    while(fscanf(qp,"%lf",&d) != EOF && i < m)
    {
        ex += d;
        ex2 += d*d;
        Q[i] = d;
        i++;
    }
    mean = ex/m;
    std = ex2/m;
    std = sqrt(std-mean*mean);
    fclose(qp);

    /// Do z_normalixation on query data
    for( i = 0 ; i < m ; i++ )
         Q[i] = (Q[i] - mean)/std;

    /// Sort the query data
    order = (int *)malloc(sizeof(int)*m);
    if( order == NULL )
        error(1);
    Index *Q_tmp = (Index *)malloc(sizeof(Index)*m);
    if( Q_tmp == NULL )
        error(1);
    for( i = 0 ; i < m ; i++ )
    {
        Q_tmp[i].value = Q[i];
        Q_tmp[i].index = i;
    }
    qsort(Q_tmp, m, sizeof(Index),comp);
    for( i=0; i<m; i++)
    {   Q[i] = Q_tmp[i].value;
        order[i] = Q_tmp[i].index;
    }
    free(Q_tmp);



    /// Array for keeping the current data; Twice the size for removing modulo (circulation) in distance calculation
    T = (double *)malloc(sizeof(double)*2*m);
    if( T == NULL )
        error(1);

    double dist = 0;
    i = 0;
    j = 0;
    ex = ex2 = 0;

    /// Read data file, one value at a time
    while(fscanf(fp,"%lf",&d) != EOF )
    {
        ex += d;
        ex2 += d*d;
        T[i%m] = d;
        T[(i%m)+m] = d;

        /// If there is enough data in T, the ED distance can be calculated
        if( i >= m-1 )
        {

            /// the current starting location of T
            j = (i+1)%m;

            /// Z_norm(T[i]) will be calculated on the fly
            mean = ex/m;
            std = ex2/m;
            std = sqrt(std-mean*mean);

            /// Calculate ED distance
            dist = distance(Q,T,j,m,mean,std,order,bsf);
            if( dist > bsf )
            {
                bsf = dist;
                loc = i-m+1;
            }
            ex -= T[j];
            ex2 -= T[j]*T[j];
        }
        i++;
    }
    fclose(fp);
    t2 = clock();

   /* cout << "Location : " << loc << endl;
    cout << "Distance : " << sqrt(bsf) << endl;
    cout << "Data Scanned : " << i << endl;
    */
    /*
    cout << "Total Execution Time : " << (t2-t1)/CLOCKS_PER_SEC << " sec" << endl;
    */
	*y = loc;
    *s = bsf/(m-1);
}



/* The gateway function that replaces the "main".
 *plhs[] - the array of output values
 *prhs[] - the array of input values*/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{  
    /// output location
    double *y;
    /// output score
    double *s;
    
    int M;
	int buflen0, status0;
    int buflen1, status1;

	char *input_buf0, *output_buf0;
	char *input_buf1, *output_buf1;


    /* Check for proper number of arguments. */
    if (nrhs != 3) {
        mexErrMsgTxt("Three inputs required.");
	} 
    else if (nlhs > 2) {
        mexErrMsgTxt("Too many output arguments");
    }
    
    M = mxGetScalar(prhs[2]);
    
      /* Get the length of the input string. */
    buflen0 = (mxGetM(prhs[0]) * mxGetN(prhs[0])) + 1;
    /* Allocate memory for input and output strings. */
	input_buf0 =(char *) mxCalloc(buflen0, sizeof(char));

    /* Copy the string data from prhs[0] into a C string 
    * input_buf. */
   	status0 = mxGetString(prhs[0], input_buf0, buflen0);
  
          /* Get the length of the input string. */
    buflen1 = (mxGetM(prhs[1]) * mxGetN(prhs[1])) + 1;
    /* Allocate memory for input and output strings. */
	input_buf1 =(char *) mxCalloc(buflen1, sizeof(char));

    /* Copy the string data from prhs[0] into a C string 
    * input_buf. */
   	status1 = mxGetString(prhs[1], input_buf1, buflen1);
    
    
    /*mexPrintf("Number of inputs:  %d\n", nrhs);
    mexPrintf("Number of outputs: %d\n", nlhs);
	mexPrintf("M: %d\n", M);
    mexPrintf("Data_File: %s\n", input_buf0);
    mexPrintf("Query_File: %s\n", input_buf1);
	*/
    
	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	y = mxGetPr(plhs[0]);
    
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
	s = mxGetPr(plhs[1]);

    
    cpp_pcc(input_buf0, input_buf1, M, y,s);
    

}

