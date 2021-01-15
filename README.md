# Critical Path

The code written is in PROLOG. The code works well for:

1. criticalPath(<task>, <path>): This function only evaluates is the <path> given is a critical path of <task> or not, that is, this function returns true or false. The critical path that the function calculates includes the <task> as well. For example, the critical path for ‘d’ will be [a, b, c, d].

2. earlyFinish(<task>, <time>): This function will evaluate if the <time> given is the earliest finish time of the <task>. If a variable is passed instead of <time>, the function binds the variable with the earliest finishing time of the <task>.

3. lateStart(<task>, <time>): This function will evaluate if the <time> given is the latest start time of the <task>. If a variable is passed instead of <time>, the function binds the variable with the latest start time of the <task>. 

4. maxSlack(<task>, <time>): This function will evaluate if the <time> given is the maximum slack of the <task>. If a variable is passed instead of <time>, the function binds the variable with the maximum slack of the <task>. 

## Results
For the graph shown below, the results obtained are as follows:

<img src="/assets/graph.png" />

| Node | Critical path | Early finish | Late Start | Max slack |
| --- | --- | --- | --- | --- |
| a(10) | a | 10 | 0 | 0 |
| b(20) | a, b | 30 | 10 | 0 |
| c(20) | a, b, c | 50 | 30 | 0 |
| d(10) | a, b, c, d | 60 | 50 | 0 |
| e(35) | a, e | 45 | 15 | 5 |

