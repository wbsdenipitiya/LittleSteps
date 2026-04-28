import '../models/story_scenario.dart';
import 'package:flutter/material.dart';

final strangerDangerScenario = StoryScenario(
  id: 'stranger_danger_park',
  title: 'A New Friend at the Park?',
  description: 'Learn how to stay safe when meeting someone new.',
  startNodeId: 'start',
  nodes: [
    StoryNode(
      id: 'start',
      text: 'You are playing with your ball at the park. It is a sunny day!',
      action: ScenarioNodeAction.continueNode,
      choices: [
        StoryChoice(text: 'Next', nextNodeId: 'stranger_appears'),
      ],
    ),
    StoryNode(
      id: 'stranger_appears',
      text: 'A person you don\'t know comes and says, "Hi! I have some yummy candy in my car. Do you want to come and see?"',
      action: ScenarioNodeAction.choice,
      choices: [
        StoryChoice(
          text: 'Go with them for candy',
          nextNodeId: 'danger_choice',
          isSafeChoice: false,
          icon: Icons.volunteer_activism_rounded,
        ),
        StoryChoice(
          text: 'Say "No" and run to Mommy/Daddy',
          nextNodeId: 'safe_choice',
          isSafeChoice: true,
          icon: Icons.family_restroom,
        ),
      ],
    ),
    StoryNode(
      id: 'safe_choice',
      text: 'Great job! You stayed safe. Always check with your grown-ups first!',
      action: ScenarioNodeAction.end,
    ),
    StoryNode(
      id: 'danger_choice',
      text: 'Wait! We never go with someone we don\'t know. Let\'s try again.',
      action: ScenarioNodeAction.continueNode,
      choices: [
        StoryChoice(text: 'Try Again', nextNodeId: 'stranger_appears'),
      ],
    ),
  ],
);
