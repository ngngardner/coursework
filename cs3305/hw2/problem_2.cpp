
/*
    File: problem_2.cpp
    Author: Noah Gardner
    Date: 3/1/2020
    Description: 
        The purpose of this file is to implement project 6 page 351 in the text
*/

#include <iostream>
#include <cstdlib>
#include <complex>

using namespace std;

template<class T>
class polynomial
{
    public:
        polynomial();
        polynomial(T);
        polynomial(polynomial<T>& source);

        void update_coeff(T source,int c);
        void assign_coeff(T source, int c);
        void clear();
        T coefficient(int c);
        int highest_degree(int c);
        T next_term(int c);
        T evaluate(double x);

        T operator()(double x);

        polynomial& operator=(const polynomial& source);
        polynomial& operator=(std::complex<T> source);

        polynomial& operator+(const polynomial<T>& source);
        polynomial& operator-(const polynomial<T>& source);
        polynomial& operator*(const polynomial<T>& source);
        void output_poly();
    private:
        T *data;
        int degree;
};

template<class T>
polynomial<T>::polynomial()
{
    degree = 0;
    data = new T[1];
    
    T x(0);
    data[0] = x;
}

template<class T>
polynomial<T>::polynomial(T input)
{
    degree = 0;
    data = new T[1];
    data[0] = input;
}

template<class T>
polynomial<T>& polynomial<T>::operator=(const polynomial<T>& source)
{
    this->data = source.data;
    this->degree = source.degree;

    return *this;
}

template<class T>
polynomial<T>& polynomial<T>::operator=(std::complex<T> source)
{
    this->data = new T(source);
    for (int i=1; i<= this->degree; i++)
    {
        this->data[i] = new T(0);
    }
    return *this;
}

template<class T>
void polynomial<T>::update_coeff(T source,int c)
{
    if (c > degree)
    {
        T *temp = new T[c+1];
        for (int i=0; i<=degree; i++)
        {
            temp[i] = data[i];
        }
        data = temp;
        degree = c;
    }

    T temp = T(data[c]);
    temp += source;
    data[c] = temp;
}

template<class T>
void polynomial<T>::assign_coeff(T source, int c)
{
    if (c > degree)
    {
        T *temp = new T[c+1];
        for (int i=0; i<=degree; i++)
        {
            temp[i] = data[i];
        }
        data = temp;
        degree = c;
    }
    data[c] = T(source);
}

template<class T>
void polynomial<T>::clear()
{
    for (int i=0; i<=degree; i++)
    {
        data[i] = new T(0);
    }
}

template<class T>
T polynomial<T>::coefficient(int c)
{
    return data[c];
}

template<class T>
int polynomial<T>::highest_degree(int c)
{
    return degree;
}

template<class T>
T polynomial<T>::next_term(int c)
{
    for (int i=c-1; i>=0; i--)
    {
        if (data[i] != new T(0))
            return data[i];
    }
    return T(0);
}

template<class T>
T polynomial<T>::evaluate(double x)
{
    T ans(0);
    for (int i=0; i<=degree; i++)
    {
        ans += data[i] * pow(x,i);
    }
    return ans;
}

template<class T>
T polynomial<T>::operator()(double x)
{
    return evaluate(x);
}

template<class T>
polynomial<T>& polynomial<T>::operator+(const polynomial<T>& source)
{
    polynomial<T>* res;
    res->degree = degree > source.degree ? degree : source.degree;
    res->data = new T[res->degree + 1];
    for (int i=0; i<=res->degree; i++)
    {
        T temp(0);
        res->data[i] = temp;
    }

    for (int i=degree; i>=0; i--)
    {
        res->update_coeff(data[i], i);
    }

    for (int i=source.degree; i>=0; i--)
    {
        res->update_coeff(source.data[i], i);
    }

    return *res;
}

template<class T>
polynomial<T>& polynomial<T>::operator-(const polynomial<T>& source)
{
    polynomial<T>* res;
    res->degree = degree > source.degree ? degree : source.degree;
    res->data = new T[res->degree + 1];
    for (int i=0; i<=res->degree; i++)
    {
        if (i<=degree && i<= source.degree)
        {
            res->assign_coeff((data[i] - source.data[i]), i);
        }
        else if (i<=degree)
        {
            res->assign_coeff(data[i], i);
        }       
        else
        {
            T temp(-source.data[i]);
            res->assign_coeff(temp, i);
        }
    }

    return *res;
}

template<class T>
polynomial<T>& polynomial<T>::operator*(const polynomial<T>& source)
{
    polynomial<T>* res;
    res->degree = degree + source.degree;
    res->data = new T[res->degree + 1];
    for (int i=0; i<=res->degree; i++)
    {
        T temp(0);
        res->data[i] = temp;
    }

    for (int i=0; i<=degree; i++)
    {
        for (int j=0; j<=source.degree; j++)
        {
            T temp = data[i]*source.data[j];
            res->data[i+j] += temp;
        }
    }
    return *res;
}

template<class T>
void polynomial<T>::output_poly()
{
    for (int i=degree; i>=0; i--)
    {
        if (data[i] != std::complex<T>(0,0))
        {
            cout << "(" << data[i].real() << " + " << data[i].imag() << "i)*x^"<<i;
            if (i>0)
                cout<<" + ";
        }
    }
    cout << "\n";
}

int main()
{
    polynomial<std::complex<double>> object(std::complex<double>(1,1));

    object.assign_coeff(std::complex<double>(3,3),3);
    object.update_coeff(std::complex<double>(-1,-2),3);
    cout<<"The first polynomial is ...\n";
    object.output_poly();
    cout<<endl;

    polynomial<std::complex<double>> object2(std::complex<double>(4,4));
    object2.assign_coeff(std::complex<double>(3,3),1);
    object2.assign_coeff(std::complex<double>(2,2),2);
    object2.assign_coeff(std::complex<double>(1,1),3);
    cout<<"The second polynomial is ...\n";
    object2.output_poly();
    cout<<endl;

    cout<<"After adding ..\n";
    polynomial<std::complex<double>> object3;
    object3 = object + object2;
    object3.output_poly();
    cout<<endl;

    cout<<"After subtracting ...\n";
    polynomial<std::complex<double>> object4;
    object4 = object - object2;
    object4.output_poly();
    cout<<endl;

    cout<<"After multiplying ...\n";
    polynomial<std::complex<double>> object5;
    object5 = object * object2;
    object5.output_poly();
    cout<<endl;

    std::complex<double>temp = object.evaluate(1);
    cout<<"The first polynomial at x = 0: "<<temp<<endl;
    
    return 0;
}