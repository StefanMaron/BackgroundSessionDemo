  Why Background Sessions Improve Performance

  1. Perceived Performance (User Experience)

  Users don't wait:
  - UI sessions remain responsive - users can continue working immediately
  - Long-running processes (posting, reports, calculations) happen asynchronously
  - No blocking spinners or timeout errors during heavy operations

  From Documentation:
  "It's often desirable to offload AL execution from the UI thread to a background session. Don't let the user wait for
  batches."

  Source: https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-async-overview

  ---
  2. Total Performance (System-wide)

  Better Load Distribution:
  - Background sessions (TaskScheduler/Job Queue) can run on any server in the cluster
  - UI sessions are typically tied to one server
  - Enables horizontal scaling across multiple NST instances

  Optimal Resource Utilization:
  - Heavy jobs scheduled for off-hours reduce peak-time contention
  - Reduces locking and deadlock issues on the database
  - Auto-scaling can add compute nodes based on background queue depth
  - Background sessions distributed across available compute resources

  From Documentation - Comparison Table:

  | Method               | Can Run On                        | Characteristics                         | Load Distribution |
  |----------------------|-----------------------------------|-----------------------------------------|-------------------|
  | Page Background Task | Same server as parent session     | Lightweight, read-only, bound to page   | Limited           |
  | StartSession         | Same server as initiating session | Created immediately, background session | Limited           |
  | TaskScheduler        | ANY server in cluster             | Queued, survives restarts               | Fully distributed |
  | Job Queue            | ANY server in cluster             | Scheduled, recurrence, logging          | Fully distributed |

  Source: https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-async-overview

  ---
  3. How NST Instances Auto-Scale Based on Load

  Real-Time Monitoring:

  Business Central uses Virtual Machine Scale Sets for NST instances with telemetry-driven auto-scaling:

  "One of the key strengths of Business Central online is its ability to provide resource elasticity through real-time,
  data-driven autoscaling and dynamic load distribution to support these needs."

  Source: https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/service-scalability

  How Auto-Scaling Works:

  1. Metrics Collection
    - CPU usage, memory consumption, session counts
    - Background task queue depth
    - Response times and throughput
  2. Threshold Evaluation
    - If load is consistent (not just brief spikes)
    - Metrics exceed configured thresholds
    - Example: Average CPU > 70% over 10-minute period
  3. Scale-Out Action
    - New VM instances automatically created
    - Applications deployed to new instances
    - Load Balancer distributes traffic to new instances
    - Background sessions routed to available capacity
  4. Scale-In Action
    - When load decreases consistently
    - Example: Average CPU < 30% over 10-minute period
    - VM instances removed to optimize costs
    - Sessions redistributed across remaining instances

  From Azure Documentation:
  "If this increased load is consistent, rather than just a brief demand, you can configure autoscale rules to increase the
  number of VM instances in the scale set. When these VM instances are created and your applications are deployed, the scale
  set starts to distribute traffic to them through the load balancer."

  Source: https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview

  Continuous Optimization:
  "The Business Central team is constantly monitoring these metrics and tuning the scaling and balancing algorithms to get
  even better results."

  Source: https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/service-scalability

  Why Background Sessions Matter for Auto-Scaling:
  - TaskScheduler/Job Queue sessions can start on any instance in the cluster
  - New NST instances immediately receive background work from the queue
  - Enables true horizontal scaling across the fleet
  - Load balancer can optimize distribution based on actual capacity

  ---
  4. Performance Impact

  Key Quotes About Performance:

  "Consider running heavy jobs outside working hours. This might decrease locking and deadlock issues both for users and for
  the task or job itself."

  Source: https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/performance/performance-application#run-thi
  ngs-in-the-background

  "Business Central is designed with built-in redundancy, autoscaling, and automatic load-balancing capabilities for its
  compute resources."

  Source: https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/service-overview#business-continuity-and-di
  saster-recovery-bcdr

  ---
  How It All Works Together:

  Without Background Sessions:
  - UI sessions do all the work → single server load → limited scalability
  - Users wait → poor experience
  - Peak load during business hours → resource contention
  - Auto-scaler can't effectively distribute work

  With Background Sessions:
  - Work distributed across cluster → auto-scaler can add NST instances
  - Users continue working → excellent experience
  - Load smoothed over time → better resource efficiency
  - Database scales based on actual workload patterns
  - New NST instances immediately process queued background tasks

  Result: 99.81% of sessions run on compute nodes with ample resources

  Source: https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/service-scalability

  ---
  Simple Answer:
  Background sessions = Better user experience (no waiting) + Better system performance (distributed workload enables
  auto-scaling) + Efficient auto-scaling (new NST instances immediately handle queued work)