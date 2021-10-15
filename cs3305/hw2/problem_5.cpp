
/*
    File: problem_5.cpp
    Author: Noah Gardner
    Date: 3/1/2020
    Description: 
        The purpose of this file is to implement project 9 page 434 in the text
*/

#include <cstdlib>
#include <iostream>
#include <random>
#include <chrono>

using namespace std;

class plane
{
    public:
        plane(){};
        bool landing;
        int elapsed = 0;
};
class node
{
    public:
        node(plane input)
        {
            this->data = input;
            next = NULL;
        };

        plane data;
        node* next;
};
class runway
{
    public:
        runway(int ltime, int ttime, int new_ltime, int new_ttime, int max_ltime, int time);
        void output();
        void tail_insert(node *input);
        void elapsed_time();
        void step();
        void simulate();

        void landing_arrival();
        double landing_arrival_sample();
        void takeoff_arrival();
        double takeoff_arrival_sample();
        double takeoff_departure_sample();
        void remove_plane(node *input);

        node* head_ptr;
        default_random_engine generator;
        
        // inputs
        int landing_time;
        int takeoff_time;
        int new_landing_time;
        int new_takeoff_time;
        int max_landing_time;
        int total_time;

        // outputs
        int takeoff_planes = 0;
        int landed_planes = 0;
        int crashed_planes = 0;
        double total_takeoff_time = 0; // total takeoff time for calculating the average
        double total_landing_time = 0; // total landing time for calculating the average

        // timers
        double elapsed = 0;
        double time_since_takeoff = 0;
        double time_since_landing = 0;
};

runway::runway(int ltime, int ttime, int new_ltime, int new_ttime, int max_ltime, int time)
{
    head_ptr = NULL;
    landing_time = ltime;
    takeoff_time = ttime;
    new_landing_time = new_ltime;
    new_takeoff_time = new_ttime;
    max_landing_time = max_ltime;
    total_time = time;
}

void runway::output()
{
    cout << "Number of airplanes that took off: " << takeoff_planes << "\n";
    cout << "Number of airplanes that landed: " << landed_planes << "\n";
    cout << "Number of airplanes that crashed: " << crashed_planes << "\n";
    cout << "Average takeoff time: " << total_takeoff_time/takeoff_planes << "\n";
    cout << "Average landing time: " << total_landing_time/landed_planes << "\n";
}

void runway::tail_insert(node *input)
{
    node *temp = head_ptr;
    node *prev = NULL;

    // find the last pointer to insert at the tail
    while (temp != NULL)
    {
        prev = temp;
        temp = temp->next;
    }

    input->next = temp;
    if (head_ptr != NULL)
    {
        prev->next = input;
    }
    else
    {
        head_ptr = input; // this may be the first plane to join the queue
    }
}

// increment the elapsed time of each plane in the queue
void runway::elapsed_time()
{
    node *temp = head_ptr;
    while (temp != NULL)
    {
        // all existing planes have waited for 1 time step
        temp->data.elapsed++;
        temp = temp->next;
    }
}

void runway::takeoff_arrival()
{
    // see if a new takeoff will join the queue
    if (time_since_takeoff > takeoff_arrival_sample())
    {
        time_since_takeoff = 0;
        node *p = new node(plane());
        p->data.landing = false; // takeoff plane
        tail_insert(p);
    }
    else
    {
        time_since_takeoff++;
    }
}

void runway::landing_arrival()
{
    // see if a new landing will join the queue
    if (time_since_landing > landing_arrival_sample())
    {
        time_since_landing = 0;
        node *p = new node(plane());
        p->data.landing = true; // landing plane
        tail_insert(p);
    }
    else
    {
        time_since_landing++;
    }
}

void runway::remove_plane(node *input)
{
    // record data from the landing plane
    if (input->data.landing == true)
    {
        // plane crashed, so record it
        if (input->data.elapsed > max_landing_time)
        {
            crashed_planes++;
        }
        // otherwise plane meets requirements to land
        else
        {
            landed_planes++;
        }
        total_landing_time += input->data.elapsed;
    }
    // record data from the takeoff plane
    else
    {
        takeoff_planes++;
        total_takeoff_time += input->data.elapsed;
    }

    // the new plane is last in the queue, so replace it with the tail pointer (null)
    if (input->next == NULL)
    {
        input = input->next;
    }
    // otherwise, remove the plane from the queue
    else
    {
        node *temp = input->next;
        input->data = input->next->data;
        input->next = temp->next;
    }
}

void runway::step()
{
    node *temp = head_ptr;

    // find the first landing plane in the queue and check the conditions
    while (temp != NULL)
    {
        // plane is landing, check conditions
        if (temp->data.landing == true)
        {
            // enough time has elapsed, so remove the plane from the queue
            if (temp->data.elapsed > landing_time)
            {
                remove_plane(temp);
                return;
            }
            // not enough time has elapsed, so return
            // no plane can take off while a plane is waiting to land
            else
            {
                return;
            }
        }
        temp = temp->next;
    }

    // find first takeoff plane since there are no planes trying to land
    temp = head_ptr;
    while (temp != NULL)
    {
        if (temp->data.landing == false && temp->data.elapsed > takeoff_time)
        {   
            // takeoff planes have a probability for depature to simulate delays
            if (takeoff_departure_sample() > 0.5)
            {
                remove_plane(temp);
                return;
            }
        }
        temp = temp->next;
    }
}

void runway::simulate()
{
    for (int i=total_time; i>0; --i)
    {
        elapsed_time();
        step();
        takeoff_arrival();
        landing_arrival();
    }
    output();
}

double runway::landing_arrival_sample()
{
    normal_distribution<double> dist(new_landing_time, 1);
    return dist(generator);
}

double runway::takeoff_arrival_sample()
{
    normal_distribution<double> dist(new_takeoff_time, 1);
    return dist(generator);
}

double runway::takeoff_departure_sample()
{
    normal_distribution<double> dist(0, 1);
    return dist(generator);
}

int main()
{
    int time_to_land = 5;
    int time_to_takeoff = 5;
    int time_new_landing_plane = 10;
    int time_new_takeoff_plane = 5;
    int time_max_landing = 7;
    int time_to_simulate = 5000;

    runway r(time_to_land, time_to_takeoff, time_new_landing_plane, time_new_takeoff_plane, time_max_landing, time_to_simulate);
    r.simulate();

    return 0;
}