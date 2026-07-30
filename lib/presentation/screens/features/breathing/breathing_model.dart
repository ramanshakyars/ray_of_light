import 'package:flutter/material.dart';

class BreathingModel {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final String duration;
  final IconData icon;
  final int inhale;
  final int hold1;
  final int exhale;
  final int hold2;
  final String audioAsset;
  final String description;

  const BreathingModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.duration,
    required this.icon,
    required this.inhale,
    required this.hold1,
    required this.exhale,
    required this.hold2,
    required this.audioAsset,
    required this.description,
  });

  /// Distinct breathing techniques mapped to assets MP3 files
  static const List<BreathingModel> defaultExercises = [
    BreathingModel(
      id: "box_breathing",
      title: "Box Breathing",
      subtitle: "Sama Vritti • Equalize & Focus",
      tag: "CALM & FOCUS",
      duration: "4 min",
      icon: Icons.crop_square_rounded,
      inhale: 4,
      hold1: 4,
      exhale: 4,
      hold2: 4,
      audioAsset: "freesound_community-meditation-bowls-23651.mp3",
      description: "Equal 4-part rhythm used by Navy SEALs to reset the nervous system and sharpen mental focus.",
    ),
    BreathingModel(
      id: "478_relax",
      title: "4-7-8 Relaxation",
      subtitle: "Pranayama • Deep Sleep & Anxiety",
      tag: "DEEP SLEEP",
      duration: "5 min",
      icon: Icons.nightlight_round,
      inhale: 4,
      hold1: 7,
      exhale: 8,
      hold2: 0,
      audioAsset: "soul_frequencies-ambient-meditation-music-498455.mp3",
      description: "Natural tranquilizer for the nervous system. Calms anxiety and prepares your mind for deep sleep.",
    ),
    BreathingModel(
      id: "coherent_flow",
      title: "Coherent Flow",
      subtitle: "Resonant • HRV & Emotional Balance",
      tag: "BALANCE & HRV",
      duration: "6 min",
      icon: Icons.waves_rounded,
      inhale: 5,
      hold1: 0,
      exhale: 5,
      hold2: 0,
      audioAsset: "lucadialessandro-angelical-pad-143276.mp3",
      description: "5-second smooth wave that aligns your heart rate variability with respiratory rhythm.",
    ),
    BreathingModel(
      id: "solar_energizer",
      title: "Solar Energizer",
      subtitle: "Kapalabhati • Morning Boost",
      tag: "ENERGY BOOST",
      duration: "3 min",
      icon: Icons.wb_sunny_rounded,
      inhale: 2,
      hold1: 1,
      exhale: 2,
      hold2: 1,
      audioAsset: "samuelfjohanns-uplifting-pad-texture-113842.mp3",
      description: "Rapid energizing rhythm to stimulate oxygen flow, boost morning alertness, and clear brain fog.",
    ),
    BreathingModel(
      id: "711_vagus",
      title: "7-11 Deep Calm",
      subtitle: "Vagus Reset • Maximum Relaxation",
      tag: "DEEP CALM",
      duration: "8 min",
      icon: Icons.spa_rounded,
      inhale: 7,
      hold1: 0,
      exhale: 11,
      hold2: 0,
      audioAsset: "gigidelaromusic-pure-meditation-tone-450975.mp3",
      description: "Extended exhale triggers parasympathetic nervous system for instant relief from acute stress.",
    ),
  ];
}
