import itertools
import simpy
import numpy as np

SIM_TIME = 60*60*1  # Simulation time in seconds

LAMBDA1 = 5. / 60.  # person arrival time per second
MU2 = .75 * 60  # boarding pass check time in seconds

UA = .5 * 60  # lower personal check time in seconds
UB = 1. * 60  # upper personal check time in seconds

wait_times = {}

def person(name, env, bp_queue, pc_queue):
    """A person arrives at the airport."""
    
    with bp_queue.request() as req:
        # Request one of boarding pass lines
        yield req

        # The boarding pass check process takes some (exp) time
        yield env.timeout(np.random.exponential(scale=MU2))

    with pc_queue.request() as req2:
        #request one of the personal check queues
        yield req2
        
        # The boarding pass check process takes some (uniform) time
        yield env.timeout(np.random.uniform(low=UA, high=UB))

    wait_times[name].append(env.now)
    
    print('%s finished airport queues in %.2f seconds.' % (name,
            env.now - wait_times[name][0]))
                                                          
def person_generator(env, bp_queue, pc_queue):
    """Generate people that arrive at the airport."""
    for i in itertools.count():
        yield env.timeout(np.random.poisson(lam=LAMBDA1))
        name = 'Person %d' % i
        wait_times[name] = [env.now]
        env.process(person(name, env, bp_queue, pc_queue))

# Create environment and start processes
env = simpy.Environment()
boarding_pass_queue = simpy.Resource(env, 5)
personal_check_queue = simpy.Resource(env, 5)
env.process(person_generator(env, boarding_pass_queue, personal_check_queue))
env.run(until=SIM_TIME)

#print wait_times
#meantime = np.mean([x[1]-x[0] for x in wait_times.values()])
#print('mean wait time is %.2f seconds' % meantime)
