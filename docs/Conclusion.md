Conclusion

  The Key Takeaways

  1. Perception Matters

  User experience often matters more than raw performance. If users can keep working, the system feels fast—even if processing continues in the background.

Choose Your Battles

  - ✅ Do: Write performant code from the start
  - ✅ Do: Optimize critical paths
  - ⚠️ Consider: Is spending days optimizing for 1 second worth it?
  - 🎯 Remember: Sometimes serial processing is faster than parallel!

  3. Use the Right Tool

  | When to Use              | Tool                 |
  |--------------------------|----------------------|
  | Page calculations        | Page Background Task |
  | Quick async tasks        | StartSession         |
  | One-time scheduled tasks | TaskScheduler        |
  | Recurring operations     | Job Queue            |

  4. Enable Auto-Scaling

  TaskScheduler & Job Queue run on ANY NST → enables true horizontal scaling in BC Online

  5. The Real Win

  "The user doesn't know it's slow if it's run in background"

  From 2-minute waits & frustrated users → "This system is super-fast!"