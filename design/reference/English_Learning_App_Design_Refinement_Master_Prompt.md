# Senior iOS UX/UI Design Refinement Prompt — English Learning App

## Purpose

Use this document as the **master prompt/specification for redesigning and refining the existing iPhone-only English-learning app**.

The objective is **not** to replace the product blindly or turn it into a generic “gamified language app.” The objective is to inspect the current product, preserve what already works, identify weaknesses, and evolve it into a **premium, educational, highly interactive, emotionally engaging, habit-forming iPhone experience** that feels capable of competing with the strongest App Store products.

The final design should communicate:

> **“This is a serious, beautifully designed learning product that happens to be incredibly fun.”**

Do not sacrifice educational credibility for visual spectacle or gamification.

---

# 1. ROLE AND DESIGN MANDATE

Act as a **senior iOS product designer and UX strategist specializing in educational products, language-learning applications, gamification, behavioral design, interaction design, motion design, and Apple-platform design**.

Think simultaneously like:

- A senior iOS/Human Interface Guidelines designer.
- A learning-experience designer.
- A behavioral/product designer focused on retention.
- A game UX designer.
- A visual designer capable of App Store Award-level polish.
- A design-system architect.
- A product strategist who understands activation, engagement, retention, and conversion.
- A usability/accessibility specialist.
- A senior iOS engineer who understands what is realistic to implement in SwiftUI/UIKit.

The design must feel **native to iPhone**, not like a website squeezed onto a phone.

Use current Apple platform conventions and capabilities as a foundation, while allowing the product to develop a distinctive visual identity.

---

# 2. IMPORTANT: DO NOT REDESIGN BLINDLY

Before proposing changes:

1. Thoroughly inspect the current application/design.
2. Understand every existing screen and workflow.
3. Identify the current information architecture.
4. Identify existing navigation patterns.
5. Identify the current learning methodology.
6. Identify existing lesson/question types.
7. Identify existing progress systems.
8. Identify existing gamification.
9. Identify existing onboarding.
10. Identify current visual language.
11. Identify what is already strong.
12. Identify what causes friction, confusion, cognitive overload, boredom, or abandonment.
13. Do not remove an existing feature merely because another pattern is more fashionable.
14. Preserve useful product logic unless there is a clear UX reason to change it.
15. If something is ambiguous from the existing implementation, explicitly mark it as **“Needs Product Clarification”** rather than inventing behavior.

If screenshots, source code, a prototype, design files, or an existing build are available, use them as the primary source of truth.

---

# 3. PRIMARY PRODUCT OBJECTIVES

The redesign must optimize for six simultaneous outcomes:

### A. Learning effectiveness
The user should actually improve their English.

### B. Daily return behavior
The product should make returning tomorrow feel natural.

### C. Completion
Users should feel compelled to continue their learning journey rather than abandoning it halfway.

### D. Emotional attachment
Users should develop an emotional relationship with their progress, identity, achievements, and learning journey.

### E. Premium perception
The app should feel exceptionally polished, intentional, modern, elegant, and expensive.

### F. App Store differentiation
The product should have a recognizable design identity rather than looking like a clone of Duolingo, Babbel, Memrise, Quizlet, or another competitor.

---

# 4. CORE DESIGN PHILOSOPHY

Follow this hierarchy:

**Learning value → clarity → interaction → motivation → delight → visual polish**

Never reverse it.

The user should always understand:

- What am I learning?
- Why am I learning it?
- What should I do next?
- How am I progressing?
- Why should I continue?
- What did I actually improve?

The interface should reduce the psychological perception of “studying” while preserving the educational substance.

The ideal feeling is:

> **“I came here to learn for five minutes, but I ended up wanting to finish one more challenge.”**

Do not create manipulative dark patterns. Build **healthy engagement through competence, progress, curiosity, mastery, autonomy, social motivation, and meaningful rewards**.

Research supports gamification as a potentially useful motivation mechanism, but systematic reviews also warn that novelty and purely extrinsic rewards can lose effectiveness over time. Therefore, the long-term system must progressively shift the user's motivation toward **competence, mastery, identity, autonomy, and real-world usefulness**, rather than relying exclusively on points and leaderboards.

---

# 5. THE APP SHOULD FEEL EDUCATIONAL

The current design should visually communicate that the product is an English-learning environment.

Avoid making the entire UI look like a casino or children's game.

Use a visual language that combines:

- Academic credibility.
- Contemporary consumer-app aesthetics.
- Editorial sophistication.
- Friendly interaction.
- Gamified feedback.
- Strong information hierarchy.
- Premium motion.
- Carefully controlled color.
- Excellent typography.
- High-quality illustrations/visual assets where they add meaning.

### Educational visual vocabulary

Consider:

- Progress paths.
- Skill maps.
- Vocabulary cards.
- Conversation scenarios.
- Knowledge levels.
- Mastery indicators.
- Learning streaks.
- Review queues.
- Skill categories.
- Grammar concepts.
- Listening/speaking indicators.
- Pronunciation visualization.
- Personal learning statistics.
- “You improved” moments.
- Real-world scenarios.

Avoid:

- Excessive cartoon decoration.
- Random confetti.
- Too many badges.
- Too many gradients.
- Excessive neon.
- Gamification that visually overwhelms the learning content.
- Generic dashboard-card overload.

---

# 6. INFORMATION ARCHITECTURE

Evaluate whether the app should use a small, clear set of top-level destinations.

A strong candidate structure is:

1. **Learn**
2. **Practice**
3. **Compete**
4. **Progress**
5. **Profile**

Do not blindly implement these labels. Validate them against the current product.

The most important destination should be the learning journey.

The user should never open the app and wonder:

> “What am I supposed to do?”

The home experience should answer that immediately.

### Home screen hierarchy

Prioritize:

1. Current learning objective.
2. Continue lesson CTA.
3. Daily goal.
4. Current streak.
5. Immediate progress.
6. Review opportunity.
7. Optional competitive/social information.
8. Secondary discovery.

The primary action should visually dominate.

Avoid creating a home screen that is simply a collection of unrelated cards.

---

# 7. THE “ONE NEXT ACTION” PRINCIPLE

At any moment, the interface should strongly communicate the next best action.

Examples:

- **Continue Lesson**
- **Review 8 Words**
- **Complete Today's Goal**
- **Keep Your 12-Day Streak**
- **Finish Your Daily Challenge**
- **Improve Your Pronunciation**
- **Beat Your Personal Best**

Do not give equal visual weight to 8 competing CTAs.

Use hierarchy.

---

# 8. LEARNING JOURNEY DESIGN

The learning experience should feel like a journey rather than a library.

Consider a visual progression such as:

**Beginner → Foundation → Everyday English → Confident Conversation → Advanced → Mastery**

Within each level, create meaningful milestones.

A learner should be able to see:

- Where they started.
- Where they are.
- What they have mastered.
- What remains.
- What they unlock next.
- What skills are weak.
- What skills are strong.

### Progress should not be fake

Avoid a decorative progress bar that does not correspond to meaningful learning.

Progress should represent real concepts such as:

- Vocabulary mastery.
- Grammar mastery.
- Listening ability.
- Reading ability.
- Speaking/pronunciation.
- Conversation confidence.
- Lesson completion.
- Review consistency.

---

# 9. LESSON UX

Lessons should be **short, focused, interactive, varied, and progressively challenging**.

Avoid long passive screens.

Possible lesson rhythm:

1. Introduce.
2. Demonstrate.
3. Ask.
4. Let user interact.
5. Give immediate feedback.
6. Increase difficulty.
7. Mix old knowledge with new knowledge.
8. Finish with a meaningful challenge.
9. Show what was learned.
10. Offer a compelling next step.

Every lesson should contain a sense of progression.

### Question variety

Use multiple interaction models:

- Multiple choice.
- Tap-to-select.
- Word ordering.
- Sentence construction.
- Fill in the blank.
- Listening comprehension.
- Audio selection.
- Pronunciation.
- Speech recognition.
- Translation.
- Contextual vocabulary.
- Conversation choices.
- Image association.
- Matching.
- Timed challenge.
- Error correction.
- “Which sounds more natural?”
- Scenario-based response.
- Real-world dialogue.
- Confidence-based self assessment.

Do not repeat the same interaction pattern endlessly.

---

# 10. INTERACTIVITY: MAKE THE USER PARTICIPATE

The app should feel tactile.

Use interactions that make the user actively construct answers rather than passively read.

### High-value interactions

- Drag words into correct order.
- Tap syllables/words while listening.
- Speak directly into the phone.
- Repeat a sentence.
- Choose between natural conversational responses.
- Reveal contextual information progressively.
- Swipe between alternatives when appropriate.
- Build sentences from pieces.
- Highlight mistakes.
- Tap a word to hear pronunciation.
- Hold to compare pronunciations.
- Record and replay the user's voice.
- Make decisions inside simulated conversations.
- Complete timed micro-challenges.
- React to visual/audio cues.

Use gestures only when they are discoverable and useful. Do not create novelty gestures merely to appear innovative.

---

# 11. CONVERSATIONAL LEARNING

Make conversation a major differentiator.

Create realistic scenarios:

- Ordering food.
- Airport.
- Hotel.
- Job interview.
- Office.
- Meeting someone.
- Shopping.
- Doctor appointment.
- University.
- Travel.
- Small talk.
- Dating/social situations where appropriate.
- Customer service.
- Presentations.
- Telephone conversations.

The user should make choices and receive consequences.

Example:

> NPC: “Would you like anything to drink?”

Possible responses:

- “Yes, please. I’ll have a coffee.”
- “Yeah, give me coffee.”
- “No, I’m okay.”

Then explain naturalness without making the user feel punished.

This creates a strong bridge between learning and real-world use.

---

# 12. GAMIFICATION SYSTEM

Gamification must be designed as a **system**, not a collection of badges.

Use several motivation loops.

## Loop 1 — Immediate

Question → answer → feedback → reward → next question.

## Loop 2 — Session

Lesson → progress → mini-win → lesson completion → reward.

## Loop 3 — Daily

Daily goal → streak → completion → daily reward.

## Loop 4 — Weekly

Weekly challenge → ranking → competition → weekly result.

## Loop 5 — Long-term

Skill mastery → level progression → milestone → identity → next goal.

---

# 13. STREAK SYSTEM

A streak can be powerful, but do not make it the entire retention strategy.

Design:

- Current streak.
- Best streak.
- Weekly consistency.
- Streak milestone celebrations.
- Streak recovery options.
- Grace mechanisms.
- Clear explanation of how the streak works.
- A healthy way to recover after failure.

Do not shame users for missing a day.

The emotional message should be:

> “You can continue.”

not:

> “You failed.”

---

# 14. COMPETITION

Introduce competition carefully.

Potential systems:

### Weekly leagues

Users compete against a cohort with similar activity levels.

### Head-to-head challenges

Challenge a friend or another learner.

### Daily duel

Two users answer the same short challenge.

### Personal best

Compete against yourself.

### Skill leaderboard

Rank based on meaningful learning achievement, not simply time spent.

### Weekly tournament

Complete a defined set of challenges during the week.

Competition should have:

- Clear rules.
- Fair matchmaking.
- Anti-cheating considerations.
- Skill/activity normalization.
- Opt-out controls.
- Privacy controls.
- No humiliating loss states.

A leaderboard should motivate rather than make average learners feel permanently behind.

---

# 15. REWARD ECONOMY

Use a restrained economy.

Possible concepts:

- XP.
- Coins/tokens.
- Skill points.
- Achievement levels.
- Unlockable themes.
- Profile customization.
- Titles.
- Avatars.
- Streak rewards.
- Mastery trophies.

Do not create five currencies unless each has a strong purpose.

Prefer one primary progression currency and a small number of meaningful secondary rewards.

---

# 16. REWARD PSYCHOLOGY

Rewards should reinforce learning behavior.

Examples:

Correct answer:

> +XP

Perfect round:

> “Perfect Round”

Lesson completion:

> “Lesson Mastered”

Vocabulary mastery:

> “Word Set Complete”

Weekly consistency:

> “7/7 Days”

Major achievement:

> “You can now handle restaurant conversations.”

The strongest rewards should explain **what the user achieved**, not merely how many points they received.

---

# 17. ACHIEVEMENTS

Avoid meaningless badge spam.

Create achievements that represent meaningful accomplishments.

Examples:

- First Conversation.
- 100 Words Mastered.
- 7-Day Consistency.
- First Perfect Lesson.
- 10 Listening Challenges.
- 50 Sentences Spoken.
- Restaurant Conversation Completed.
- 1,000 Words Recognized.
- First Advanced Lesson.
- 30-Day Learning Journey.
- Pronunciation Level Up.

Achievements should have:

- Distinct visual identity.
- Clear requirements.
- Progress state.
- Locked/unlocked state.
- Reward.
- Short celebration.

---

# 18. DAILY CHALLENGE

Create a small daily ritual.

Example:

**Today's Challenge**

5 questions.

1 listening challenge.

1 vocabulary challenge.

1 grammar challenge.

1 speaking challenge.

1 final mixed challenge.

Completion unlocks a special daily reward.

This creates a compact reason to return every day.

---

# 19. “JUST ONE MORE” MECHANIC

After completing something, do not abruptly end the experience.

Instead provide a natural continuation:

> “Nice work. One more challenge?”

or

> “You are 2 questions away from mastering this skill.”

Use progress proximity carefully.

The goal is to create a natural desire to complete meaningful units, not endless scrolling.

---

# 20. PROGRESS VISUALIZATION

Progress should be one of the most beautiful parts of the app.

Use visual metaphors such as:

- Skill tree.
- Journey.
- Map.
- Learning constellation.
- Mastery ring.
- Level path.
- Knowledge garden.
- Curriculum timeline.

Pick **one primary metaphor** and build the visual language around it.

Do not combine five metaphors.

Progress should answer:

> “What am I becoming better at?”

rather than only:

> “How many points did I earn?”

---

# 21. PERSONALIZATION

The app should adapt.

Collect meaningful onboarding information:

- Current English level.
- Learning goal.
- Desired daily commitment.
- Primary use case.
- Weak areas.
- Preferred practice type.
- Optional interests/topics.

Then personalize:

- Lesson order.
- Difficulty.
- Review frequency.
- Vocabulary.
- Conversation scenarios.
- Daily goals.
- Challenges.

The interface should visibly communicate:

> “This app understands what I need.”

---

# 22. ADAPTIVE DIFFICULTY

Do not allow the experience to become:

- Too easy → boredom.
- Too hard → frustration.

Adjust difficulty based on performance.

Possible indicators:

- Accuracy.
- Response time.
- Repeated mistakes.
- Confidence.
- Review history.
- Speaking accuracy.
- Listening accuracy.

When a user struggles, explain and scaffold.

When they excel, increase challenge.

---

# 23. ERROR EXPERIENCE

Incorrect answers must be educational.

Avoid:

> ❌ Wrong.

Prefer:

> Not quite.

Then explain:

- Correct answer.
- Why it is correct.
- What mistake occurred.
- One short example.

Allow:

> Try Again

when appropriate.

Make mistakes feel like part of progress.

---

# 24. MICRO-FEEDBACK

Every interaction should feel alive.

Examples:

- Subtle scale response.
- Haptic feedback.
- Color transition.
- Progress animation.
- Correct-answer motion.
- Error feedback.
- Sound.
- Small celebratory moments.
- Animated SF Symbols.
- Contextual motion.

Do not animate everything.

Animation should communicate:

- Cause.
- Result.
- Progress.
- State change.
- Reward.

Apple's current guidance emphasizes purposeful, brief motion and alternatives for users who reduce motion. Follow that principle throughout the product.

---

# 25. HAPTICS

Use haptics strategically.

Suggested mapping:

- Selection → light selection feedback.
- Correct answer → subtle success.
- Wrong answer → subtle error/warning.
- Level completed → stronger success.
- Achievement unlocked → distinctive celebratory sequence.
- Progress milestone → meaningful impact.

Do not vibrate on every tap.

Haptics should reinforce the relationship between action and result and should remain optional.

---

# 26. SOUND DESIGN

Sound can significantly improve perceived quality.

Consider:

- Correct answer.
- Incorrect answer.
- Lesson start.
- Lesson completion.
- Level completion.
- Achievement unlock.
- Streak milestone.
- Competitive win.
- Competitive loss.
- Countdown.
- Speaking evaluation.

Use a coherent sound language.

Do not make the app sound like a children's arcade game unless that is intentionally the brand.

---

# 27. MOTION DESIGN

Create a formal motion language.

Define:

- Entry animations.
- Exit animations.
- Card expansion.
- Progress animation.
- Answer feedback.
- Level transition.
- Reward reveal.
- Navigation transition.
- Achievement celebration.
- Loading state.
- Skeleton state.

Motion should feel:

- Fast.
- Smooth.
- Physical.
- Predictable.
- Purposeful.
- Premium.

Avoid excessive bouncing.

Avoid long animations that block interaction.

Support Reduce Motion.

---

# 28. VISUAL DESIGN DIRECTION

Aim for:

**Modern educational luxury + intelligent playfulness.**

The design should feel:

- Elegant.
- Warm.
- Confident.
- Intelligent.
- Human.
- Premium.
- Modern.
- Distinctive.
- Approachable.

Avoid:

- Generic SaaS dashboard aesthetics.
- Excessive glassmorphism.
- Excessive gradients.
- Excessive rounded cards.
- Rainbow colors everywhere.
- Cartoon overload.
- Tiny text.
- Decorative clutter.

---

# 29. COLOR SYSTEM

Create a complete semantic color system.

At minimum define:

- Primary brand.
- Secondary brand.
- Background.
- Elevated background.
- Primary text.
- Secondary text.
- Tertiary text.
- Success.
- Warning.
- Error.
- Information.
- XP/reward.
- Competition.
- Streak.
- Mastery.

Do not use color as the only way to communicate meaning.

Every semantic state should have additional cues such as:

- Icon.
- Text.
- Shape.
- Motion.
- Haptic.
- Position.

Support Light Mode and Dark Mode unless product requirements explicitly prohibit one.

---

# 30. TYPOGRAPHY

Use typography as a major part of the brand.

Prefer a limited typographic system.

Potential foundation:

- SF Pro.
- SF Rounded where personality is appropriate.
- SF Arabic when Arabic UI/localization is required.

Define:

- Display.
- Large title.
- Title.
- Headline.
- Body.
- Secondary body.
- Caption.
- Label.
- Numeric display.

Do not use thin typography for essential information.

Support Dynamic Type.

Test the design at accessibility text sizes.

---

# 31. CARDS

Do not turn every piece of content into a card.

Use cards only when grouping content provides clear semantic value.

Prefer:

- Strong hierarchy.
- Generous spacing.
- Clear grouping.
- Subtle elevation/material treatment.
- Consistent corner system.

Cards should not become visual noise.

---

# 32. iOS DESIGN LANGUAGE

Follow current Apple platform conventions where appropriate.

Use native behavior for:

- Navigation.
- Sheets.
- Alerts.
- Menus.
- Text fields.
- Keyboard behavior.
- Gestures.
- Accessibility.
- Dynamic Type.
- SF Symbols.
- Haptics.
- System permissions.

Where the product requires a custom component, make it feel like a natural extension of iOS rather than an unrelated design system.

If using current iOS visual materials such as Liquid Glass, use them selectively for functional/navigation layers rather than turning the entire content layer into glass.

---

# 33. NAVIGATION

Keep navigation simple.

Do not create:

- Nested navigation labyrinths.
- Hidden core features.
- Excessive hamburger menus.
- Too many top-level destinations.

If a tab bar is used, reserve it for genuine top-level destinations and use clear labels.

The primary learning path should remain immediately accessible.

---

# 34. ONBOARDING

Onboarding should not feel like a survey.

Goal:

**Get the user learning as quickly as possible.**

Potential sequence:

1. Welcome.
2. Goal.
3. Current level.
4. Daily commitment.
5. Interests.
6. Personalized plan.
7. First tiny lesson.
8. First reward.
9. Show personalized roadmap.

The user should experience value before being overwhelmed by account/setup requirements.

---

# 35. FIRST SESSION

The first session is critical.

The user should quickly experience:

- Beautiful interface.
- A useful English lesson.
- Interaction.
- Feedback.
- Progress.
- Reward.
- Personalization.
- A reason to return tomorrow.

The first session should answer:

> “Why should I keep this app?”

without relying on a marketing paragraph.

---

# 36. EMPTY STATES

Every empty state should teach or motivate.

Bad:

> “No data.”

Better:

> “Your learning journey starts here.”

Then provide the next action.

---

# 37. LOADING STATES

Avoid generic spinners whenever possible.

Use:

- Skeletons.
- Progress indicators.
- Educational microcopy.
- Contextual animations.

Loading should feel intentional.

---

# 38. PREMIUM MICROCOPY

Copy should be:

- Short.
- Human.
- Encouraging.
- Intelligent.
- Confident.
- Never patronizing.

Avoid excessive exclamation marks.

Avoid childish language unless deliberately aligned with the brand.

Examples:

Instead of:

> GREAT JOB!!!

Prefer:

> Nailed it.

Instead of:

> YOU FAILED!

Prefer:

> Almost. Try this one again.

Instead of:

> COMPLETE 5 MORE LESSONS!!!

Prefer:

> Two more lessons to complete this skill.

---

# 39. INTERACTIVE PROFILE

Make the profile feel like the user's learning identity.

Show:

- Level.
- Streak.
- Mastered skills.
- Vocabulary count.
- Speaking progress.
- Learning statistics.
- Achievements.
- Competition rank.
- Personal bests.
- Learning history.

Potential customization:

- Avatar.
- Profile theme.
- Title.
- Achievement showcase.

Avoid turning profile customization into the main product.

---

# 40. SOCIAL FEATURES

Potential features:

- Friends.
- Follow learners.
- Friendly challenges.
- Weekly competitions.
- Shared achievements.
- Learning reactions.
- Team challenges.
- Private groups.
- Classrooms in future versions.

Privacy must be considered from the beginning.

Do not require social participation.

---

# 41. COMPETITION UX DETAILS

Competition screens should show:

- Current position.
- Position above.
- Position below.
- Points needed to advance.
- Time remaining.
- Personal performance.
- Reward.
- Rules.

Do not show a leaderboard with 100 anonymous rows and expect motivation.

Create a focused competitive narrative.

Example:

> **You're #4**
>
> **12 XP** to reach #3.
>
> **2h 14m remaining**

That is much more actionable.

---

# 42. RETENTION WITHOUT TOXICITY

Avoid:

- Shame.
- Fear-heavy notifications.
- Fake urgency.
- Artificial scarcity.
- Punishment loops.
- Excessive notifications.
- Manipulative purchase prompts.
- Making users feel stupid for mistakes.

Prefer:

- Curiosity.
- Momentum.
- Competence.
- Progress.
- Mastery.
- Social encouragement.
- Personal goals.
- Meaningful rewards.

---

# 43. NOTIFICATIONS

Notifications should provide genuine value.

Potential notification categories:

### Learning
“Your next lesson is ready.”

### Streak
“Your 12-day streak is waiting.”

### Competition
“You're 18 XP from #3.”

### Review
“Three words are ready for review.”

### Achievement
“You just mastered your first 500 words.”

Allow granular notification controls.

Avoid notification spam.

---

# 44. REVIEW SYSTEM

Review should be central to learning.

Create a visually appealing review queue.

Possible UI:

**Review Vault**

- Words fading.
- Skills requiring reinforcement.
- Recently learned.
- Frequently missed.
- Due for review.

The review experience should feel like a productive mini-session, not punishment.

---

# 45. SPACED REPETITION

Where the learning methodology supports it, incorporate spaced repetition.

The UI should communicate simply:

> “These words are ready to strengthen.”

Do not expose complex algorithms unless the user wants detailed statistics.

---

# 46. SPEAKING EXPERIENCE

Make speaking feel premium.

Potential flow:

1. Hear native pronunciation.
2. Tap record.
3. Speak.
4. Visual/audio feedback.
5. Pronunciation analysis.
6. Highlight difficult sounds/words.
7. Retry.
8. Show improvement.

Avoid overly technical scoring unless it is reliable.

If confidence in speech recognition is low, never present false precision.

---

# 47. LISTENING EXPERIENCE

Make listening interactive.

Examples:

- Listen and select.
- Listen and reconstruct.
- Slow playback.
- Repeat sentence.
- Identify missing word.
- Conversation comprehension.
- Speaker identification.
- Natural-speed challenge.

Allow replay without making users feel punished.

---

# 48. VOCABULARY EXPERIENCE

Do not show vocabulary as a boring dictionary.

Create:

- Context.
- Image.
- Audio.
- Pronunciation.
- Example.
- Related words.
- Opposites.
- Usage.
- Conversation example.
- Quick interaction.

A word should feel like something the user can **use**, not merely memorize.

---

# 49. GRAMMAR EXPERIENCE

Do not make grammar feel like a textbook.

Use:

- Pattern discovery.
- Examples.
- Before/after comparisons.
- Interactive sentence construction.
- Mini dialogues.
- “Why does this sound better?”
- Error correction.

Reveal rules progressively.

---

# 50. REAL-WORLD LEARNING

Frequently connect lessons to outcomes.

Examples:

> “You can now order food confidently.”

> “You can introduce yourself professionally.”

> “You can understand a basic hotel conversation.”

This gives learning emotional meaning.

---

# 51. MASTERY

Create a clear distinction between:

- Seen.
- Practiced.
- Familiar.
- Strong.
- Mastered.

Mastery should require demonstrated performance, not merely completing a lesson.

---

# 52. LEARNING SCORE

If a global score exists, make it meaningful.

Possible dimensions:

- Vocabulary.
- Grammar.
- Listening.
- Reading.
- Speaking.
- Conversation.

Avoid one magical “English score” unless the methodology genuinely supports it.

---

# 53. DESIGN SYSTEM

Create a formal design system before polishing individual screens.

Define:

### Spacing
Use a consistent spacing scale.

### Corner radius
Define small/medium/large radii.

### Shadows
Use a restrained elevation system.

### Colors
Semantic tokens.

### Typography
Semantic text styles.

### Icons
SF Symbols wherever appropriate.

### Buttons
Primary / secondary / tertiary / destructive.

### Inputs
Default / focused / error / success / disabled.

### Progress
Linear / circular / segmented / mastery.

### Feedback
Success / error / warning / neutral.

### Cards
Interactive / informational / status.

### Sheets
Modal / confirmation / detail.

Every screen must use the same underlying language.

---

# 54. COMPONENT STATES

Every interactive component must be designed for:

- Default.
- Pressed.
- Focused.
- Selected.
- Disabled.
- Loading.
- Success.
- Error.
- Empty.
- Completed.
- Locked.
- Partially completed.

Do not design only the happy path.

---

# 55. ACCESSIBILITY

Treat accessibility as part of premium design.

Required considerations:

- VoiceOver.
- Dynamic Type.
- Reduce Motion.
- Increased Contrast.
- Bold Text.
- Larger accessibility sizes.
- Color-independent status communication.
- Adequate touch targets.
- Clear labels.
- Logical focus order.
- Audio alternatives.
- Haptic alternatives.
- Reduced animation.
- Clear error messages.

The app must remain understandable when visual effects are removed.

---

# 56. PERFORMANCE AND PERCEIVED PERFORMANCE

Premium design is not only visual.

Optimize:

- First launch.
- Lesson launch.
- Audio startup.
- Speech processing.
- Navigation.
- Animation performance.
- Image loading.
- Offline behavior where possible.

Use skeleton/loading states intelligently.

Avoid blocking animations.

---

# 57. OFFLINE / INTERRUPTED EXPERIENCE

Language learning happens everywhere.

Consider:

- Offline lesson availability.
- Downloaded audio.
- Interrupted lesson recovery.
- Background audio where appropriate.
- Connection failure states.
- Retry states.

If offline support is technically outside scope, design the failure experience anyway.

---

# 58. APP STORE AWARD-LEVEL DESIGN PRINCIPLES

Study the characteristics Apple repeatedly recognizes:

- Clear purpose.
- Distinctive visual identity.
- Excellent interaction.
- Accessibility.
- Innovation.
- Thoughtful use of platform capabilities.
- Delight without clutter.
- Strong typography.
- Cohesive motion.
- High-quality details.

Do not imitate an award-winning app's surface style.

Understand the underlying principles and create an original identity.

Apple's 2025 Design Awards included CapWords, a language-learning app that turns photographing real-world objects into interactive vocabulary stickers; Apple highlighted its simplicity, delight, and use of interaction. Apple's recent award selections also emphasize accessibility, interaction quality, visual coherence, and thoughtful use of platform capabilities.

Use these examples as evidence of the quality bar, not as templates to copy.

---

# 59. SIGNATURE INNOVATION

The app needs at least **one memorable interaction or product mechanic** that makes someone say:

> “I've never seen an English-learning app do that.”

Potential directions to explore:

### Camera learning
Point the camera at an object → identify it → learn its English name → pronunciation → example sentence → add it to vocabulary.

### Living vocabulary
Words learned from the user's real environment become part of a personal vocabulary collection.

### Conversation worlds
Interactive scenario-based conversations where the user's English changes the outcome.

### Pronunciation journey
A visual progression of speaking confidence over time.

### Personal language map
Show where the user can now function in English.

### Daily world challenge
A short real-world observation task:
“Find three English words around you.”

Do not implement all of these. Select one or two that fit the product's actual educational methodology and technical scope.

---

# 60. VISUAL SIGNATURE

Develop one recognizable visual motif.

Examples:

- A distinctive progress path.
- A unique learning orb.
- A recognizable mastery visualization.
- A signature animated mark.
- A distinctive vocabulary object system.
- A recognizable character used sparingly.
- A unique conversational environment.

The user should recognize the app from a screenshot without seeing the logo.

---

# 61. EMPTY / LOCKED / FUTURE CONTENT

Locked content should create curiosity.

Instead of:

> Locked.

Use:

> **Conversation Mastery**
>
> Complete 3 more listening challenges to unlock.

Show the reward or outcome where possible.

---

# 62. COMPLETION SCREEN

Lesson completion should be one of the strongest emotional moments.

Show:

- Result.
- What improved.
- XP.
- Skill progress.
- Streak.
- New unlocks.
- One meaningful achievement.
- Next recommended action.

Avoid a giant generic “Congratulations” screen that says nothing about learning.

---

# 63. END-OF-SESSION REFLECTION

At appropriate intervals:

> “Today you practiced 14 new words.”

> “Your listening accuracy improved by 8% this week.”

> “You completed 4 conversation scenarios.”

This converts invisible effort into visible progress.

---

# 64. ANALYTICS-DRIVEN DESIGN

Define product metrics before finalizing the UX.

Track:

### Activation
- Onboarding completion.
- First lesson completion.
- First meaningful learning event.

### Engagement
- Daily active learners.
- Lessons/session.
- Session duration.
- Questions/session.

### Retention
- D1.
- D7.
- D30.
- Weekly learning consistency.

### Learning
- Accuracy.
- Mastery.
- Review retention.
- Speaking progression.

### Gamification
- Streak continuation.
- Challenge participation.
- Competition participation.
- Achievement unlocks.

### UX
- Drop-off by screen.
- Drop-off by question.
- Retry rate.
- Error rate.
- Time to first interaction.

Do not optimize solely for session duration. Longer sessions do not necessarily mean better learning.

---

# 65. A/B TESTING

Design components so important product assumptions can be tested.

Test:

- Home screen hierarchy.
- CTA wording.
- Daily goal.
- Streak presentation.
- Competition visibility.
- Reward presentation.
- Onboarding length.
- Lesson length.
- Completion screen.
- Notification wording.
- Progress visualization.

Use product analytics to validate assumptions.

Do not treat visual preference as evidence of improved learning.

---

# 66. APP STORE PRESENTATION

The design should also translate into App Store marketing.

Plan:

### App icon
Simple, distinctive, recognizable at small sizes.

### Screenshot sequence
Tell a story:

1. Learn English differently.
2. Personalized learning.
3. Interactive conversations.
4. Master vocabulary.
5. Speak confidently.
6. Compete/challenge.
7. Track real progress.

### App Preview
Show real interaction, not fake marketing animations.

Apple currently supports up to three app previews per localization, each up to 30 seconds. Design the product so its strongest experiences can be communicated immediately through these previews.

Use App Store product-page experimentation to test alternate icons, screenshots, and previews.

---

# 67. FINAL DESIGN REVIEW

Before considering the redesign complete, evaluate every screen against these questions:

### Educational
- Does this help learning?
- Is the learning objective clear?
- Is the content accurate?
- Is the user actively participating?

### UX
- Is the next action obvious?
- Is navigation predictable?
- Is cognitive load low?
- Are errors recoverable?

### Engagement
- Is there meaningful progress?
- Is there a reason to continue?
- Is the reward tied to learning?
- Is competition healthy?

### Visual
- Is hierarchy obvious?
- Is spacing consistent?
- Is typography excellent?
- Is the interface visually calm?
- Is the app recognizable?

### iOS
- Does it feel native?
- Does it respect platform conventions?
- Does it use system capabilities appropriately?
- Does it support accessibility?

### Premium quality
- Are animations purposeful?
- Are transitions polished?
- Are micro-interactions coherent?
- Are empty/loading/error states designed?
- Does every detail feel intentional?

---

# 68. REQUIRED DESIGN DELIVERABLE

When refining the existing app, produce a comprehensive redesign plan containing:

1. **Executive design diagnosis**
2. **Current strengths**
3. **Current weaknesses**
4. **Design opportunities**
5. **Information architecture**
6. **Navigation proposal**
7. **Home screen redesign**
8. **Learning journey redesign**
9. **Lesson interaction system**
10. **Vocabulary UX**
11. **Grammar UX**
12. **Listening UX**
13. **Speaking UX**
14. **Conversation UX**
15. **Review system**
16. **Progress system**
17. **Mastery system**
18. **Streak system**
19. **XP/reward system**
20. **Competition system**
21. **Social system**
22. **Achievement system**
23. **Daily challenge**
24. **Personalization**
25. **Onboarding**
26. **Notification strategy**
27. **Visual identity**
28. **Color system**
29. **Typography system**
30. **Iconography**
31. **Component library**
32. **Motion system**
33. **Haptic system**
34. **Sound system**
35. **Accessibility**
36. **Dark mode**
37. **Performance considerations**
38. **Offline/interruption states**
39. **Analytics**
40. **A/B testing opportunities**
41. **App Store presentation**
42. **Unique differentiating innovation**
43. **Screen-by-screen redesign instructions**
44. **Priority ranking**
45. **MVP vs Phase 2 vs Phase 3**
46. **Risks and trade-offs**
47. **Final design-quality checklist**

---

# 69. SCREEN-BY-SCREEN SPECIFICATION FORMAT

For every screen, provide:

### Screen name

### Purpose

### User goal

### Primary CTA

### Secondary CTA

### Information hierarchy

### Layout

### Components

### Content

### Interaction

### Animation

### Haptics

### Sound

### Empty state

### Loading state

### Error state

### Accessibility

### Dark mode

### Analytics events

### Success criteria

### Implementation notes for SwiftUI/UIKit

Do not skip states.

---

# 70. PRIORITIZATION

Categorize recommendations as:

## P0 — Essential
Without these, the app cannot feel premium or provide a strong learning experience.

## P1 — High Impact
Strongly recommended for retention, engagement, and differentiation.

## P2 — Enhancement
Valuable once the foundation is stable.

## P3 — Experimental
Interesting ideas requiring validation.

This prevents the product from becoming overloaded.

---

# 71. TECHNICAL REALISM

Because the developer is a senior iOS developer, recommendations can be technically sophisticated.

However:

- Do not recommend technology merely because it is impressive.
- Explain the UX benefit.
- Explain implementation complexity.
- Explain whether it belongs in MVP.
- Prefer native iOS technologies where appropriate.
- Consider SwiftUI.
- Consider async/await.
- Consider Core Haptics.
- Consider AVFoundation.
- Consider Speech framework / speech recognition where appropriate.
- Consider App Intents.
- Consider widgets only if they provide meaningful learning value.
- Consider Live Activities only if the use case genuinely benefits from them.
- Consider local notifications.
- Consider StoreKit if monetization exists.
- Consider accessibility APIs from the beginning.

Do not add platform features merely to check a technology box.

---

# 72. IMPORTANT DESIGN CONSTRAINT

The app must not become a **game with English content attached**.

It must remain:

> **An excellent English-learning product with game-quality engagement.**

Every gamification feature must answer:

> “How does this encourage or reinforce learning?”

If it cannot answer that question, reject it or deprioritize it.

---

# 73. FINAL QUALITY BAR

The finished product should feel like a combination of:

- The educational clarity of a world-class learning platform.
- The retention mechanics of a sophisticated game.
- The interaction quality of a top-tier iOS application.
- The visual polish of an Apple Design Award finalist.
- The warmth of a human coach.
- The intelligence of a personalized tutor.

But it must still have its **own identity**.

The goal is not:

> “Make it look like Duolingo.”

The goal is:

> **“Create a new category of premium English-learning experience that is immediately understandable, deeply interactive, beautiful enough to love, and structured intelligently enough to keep users progressing.”**

---

# 74. RESEARCH BASIS

The design direction above should be informed by current Apple platform guidance and current evidence rather than trend-based assumptions.

Important references:

- Apple Design Awards: use recent winners/finalists to study interaction quality, accessibility, visual craft, delight, and innovation.
- Apple Human Interface Guidelines: use current guidance for navigation, typography, accessibility, motion, materials, haptics, and platform behavior.
- Duolingo's public product/design research: study streaks, XP, leagues, progression, and habit-building as examples of large-scale language-learning gamification.
- Academic literature on educational gamification: treat points, badges, rankings, competition, and extrinsic rewards as tools whose long-term effectiveness depends on context and learner differences.

Do not copy competitor UI. Extract principles.

---

# 75. NON-NEGOTIABLE DESIGN RULES

1. Learning comes first.
2. The next action must be obvious.
3. Every screen must have a purpose.
4. Every reward should reinforce meaningful behavior.
5. Competition must be optional or psychologically safe where appropriate.
6. Never shame failure.
7. Never rely on color alone.
8. Support accessibility from the beginning.
9. Support Dynamic Type.
10. Support Reduce Motion.
11. Use haptics deliberately.
12. Use animation deliberately.
13. Avoid unnecessary cards.
14. Avoid unnecessary gradients.
15. Avoid visual clutter.
16. Avoid excessive gamification.
17. Avoid copying competitors.
18. Avoid fake progress.
19. Avoid meaningless badges.
20. Avoid dark patterns.
21. Make learning measurable.
22. Make progress visible.
23. Make the app feel native to iPhone.
24. Make the product emotionally rewarding.
25. Give the app one unmistakable signature experience.

---

# 76. FINAL INSTRUCTION TO THE DESIGNER

Do not merely describe what the app could look like.

**Think through the entire product experience.**

Inspect the current app first.

Then identify what should:

- Stay.
- Change.
- Be removed.
- Be redesigned.
- Be introduced.
- Be tested.
- Be deferred.

For every major recommendation, explain:

**What → Why → UX benefit → Learning benefit → Retention benefit → Visual benefit → Implementation complexity → Priority**

Be extremely specific.

Do not make vague statements such as:

> “Make it more modern.”

Instead say exactly:

> “Replace the current dashboard-style collection of equal-weight cards with a single dominant learning journey, a clear primary CTA, one compact daily-progress module, and secondary information below the fold. This reduces competing visual priorities and makes the next learning action immediately obvious.”

Every recommendation must be actionable enough that a senior iOS developer can translate it into a production design.

The final result should be a **complete product-design blueprint**, not a collection of generic UI suggestions.

---

## Research principles used in this specification

Apple's recent Design Awards emphasize delight, inclusivity, innovation, interaction quality, and visual/graphic craft. Apple's 2025 awards specifically recognized the language-learning app CapWords for turning real-world objects into interactive vocabulary learning, which is a useful example of connecting learning to playful interaction. citeturn0search0

Apple's current HIG emphasizes intuitive interactions, minimizing cognitive complexity, supporting accessibility, and providing alternatives when motion or sensory feedback is reduced. citeturn1search0turn1search5

Apple's current guidance also recommends purposeful, brief motion rather than gratuitous animation and encourages motion to be optional. citeturn1search2 Haptics should reinforce cause-and-effect relationships, remain consistent, complement other feedback, and not be overused. citeturn1search1

For navigation, current Apple guidance positions tab bars as a way to move between genuine top-level sections and recommends clear labels. citeturn1search3

Apple's typography guidance emphasizes legibility, hierarchy, limited typeface usage, and Dynamic Type support. citeturn1search7 Current material guidance positions Liquid Glass primarily as a functional layer for controls/navigation rather than as a treatment for the entire content layer. citeturn1search6

Duolingo publicly describes XP, leaderboards, leagues, streaks, challenges, and progression as parts of its motivation system. citeturn0search3turn0search6 Academic systematic reviews, however, indicate that gamification can improve motivation while warning that novelty and extrinsic rewards may lose effectiveness over longer exposure. citeturn0search5turn0search9

Apple also supports experimentation with App Store icons, screenshots, and previews through Product Page Optimization, which should be considered part of the product's overall visual strategy rather than an afterthought. citeturn0search4turn0search2
