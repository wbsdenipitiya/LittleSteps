import 'package:flutter/material.dart';

enum ScenarioNodeAction {
  continueNode,
  choice,
  miniGame,
  end,
}

class StoryNode {
  final String id;
  final String text;
  final String? audioPath;
  final String? imagePath;
  final List<StoryChoice>? choices;
  final ScenarioNodeAction action;

  StoryNode({
    required this.id,
    required this.text,
    this.audioPath,
    this.imagePath,
    this.choices,
    this.action = ScenarioNodeAction.continueNode,
  });
}

class StoryChoice {
  final String text;
  final String nextNodeId;
  final bool isSafeChoice;
  final IconData? icon;

  StoryChoice({
    required this.text,
    required this.nextNodeId,
    this.isSafeChoice = true,
    this.icon,
  });
}

class StoryScenario {
  final String id;
  final String title;
  final String description;
  final List<StoryNode> nodes;
  final String startNodeId;

  StoryScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.nodes,
    required this.startNodeId,
  });
}
