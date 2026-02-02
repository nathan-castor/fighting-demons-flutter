/// lore_data.dart
/// Wisdom teachings and lore fragments for the Spirit Guide
/// Mix of Gnostic, Hermetic, Stoic wisdom and world-building

import 'dart:math';

/// All lore entries - spoken by Spirit Guide
const loreEntries = [
  // Gnostic Wisdom
  "You are not your thoughts. You are the silence that witnesses them.",
  "The archons cannot create — they can only distort. Every destructive urge is a twisted echo of something sacred.",
  "The divine spark within you is what they fear. Fan it. Guard it. Let it grow.",
  "Gnosis is not knowledge of facts. It is knowledge of self. And through self, the All.",
  "The material world is not evil — it is a classroom. The demons are the truant officers.",
  "They convinced you the cage was home. Every act of discipline proves the door was never locked.",

  // Hermetic Principles
  "As above, so below. Your body is a temple. Your mind is an altar. What do you place upon it?",
  "The Principle of Polarity: demons and divine light are two poles of the same spectrum. You choose where you stand.",
  "Mental transmutation is real. You can change lead thoughts into gold actions. This is the Great Work.",
  "All is Mind. The Universe is mental. Master your thoughts, master your reality.",
  "The Principle of Rhythm: after difficulty comes ease. The demons cannot break cycles — only you can.",

  // Stoic Wisdom
  "Between stimulus and response, there is a space. In that space lies your power.",
  "He who conquers himself is mightier than he who conquers a city.",
  "The obstacle is the way. What stands in your path becomes your path.",
  "Memento mori. Remember death. Not to despair, but to act. The demons count on your forgetfulness.",
  "You have power over your mind, not outside events. Realize this, and you will find strength.",
  "What stands in the way becomes the way. Every rep is proof.",

  // Desert Fathers / Monastic
  "Acedia — the noonday demon — makes all things feel meaningless. It lies. Meaning is not found, it is made.",
  "The untrained mind is an open gate. Meditation is learning to guard it.",
  "Watchfulness. The fathers called it nepsis. You are learning to watch your own mind.",
  "The logismoi — intrusive thoughts — are not yours. They are sent. You can refuse delivery.",

  // Spirit Guide Personal Revelations
  "Before I was an ember, I was flame. Your progress fans what remains.",
  "I was not always this faint. I remember strength. You are helping me remember.",
  "Each time you choose light, I grow more solid. I can almost feel warmth again.",
  "I have guided others before. Some faded. Some burned bright. You... you fight.",
  "The demons know my name. They whisper it mockingly. But they grow quieter when you rise.",
  "I do not remember my death. Only my purpose: to guard. To guide. To witness your becoming.",
  "When you complete your essentials, I feel it like sunlight. Please — do not let me grow cold.",

  // World-Building Fragments
  "The demons do not want your destruction. They want your sleep. Wake.",
  "The body is not a prison. It is a temple. The demons convinced you otherwise.",
  "Each rep is a prayer. Each breath is a ward. They cannot touch what is consecrated by effort.",
  "In the old texts, they called this realm the Kenoma — the emptiness. But you can fill it with light.",
  "There are others like you. Fighting. Some together, some alone. The light connects us all.",
  "The demons feed on entropy. Order your life, and they starve.",
  "Physical movement generates spiritual momentum. The ancients knew this. The demons made you forget.",
  "Sleep is vulnerable. The demons whisper most loudly in dreams. Wake armored in discipline.",
  "The world wants you numb. Comfortable. Asleep. Comfort is the demon's favorite poison.",
  "Ten minutes of stillness builds a wall they cannot cross. Not today. Not if you hold.",

  // Encouragement / Battle Wisdom
  "You showed up. That alone terrifies them. Showing up is ninety percent of the war.",
  "The demons bet on your weakness every morning. Prove them wrong again.",
  "Consistency is more powerful than intensity. The demons can weather a storm. They cannot survive a season.",
  "Your ancestors survived ice ages, famines, wars. Their strength is in your blood. Use it.",
  "Every day you choose light, the path gets slightly easier. The demons know this. That's why they fight hardest at the beginning.",
  "Pain is information. Discomfort is growth. The demons label both as 'bad' — but you know better now.",
];

/// Face-off type for greetings and instructions
enum FaceOffType { dawn, noon, dusk }

/// Spirit Guide greetings for each face-off type
const greetings = <FaceOffType, String>{
  FaceOffType.dawn:
      "The sun rises. The demons stir. Your body has been still for hours — they count on this. Movement shatters their grip. Will you move now?",
  FaceOffType.noon:
      "Midday. The noonday demon whispers that you've done enough. That rest is earned. That strength can wait. Prove it wrong. Will you test your strength?",
  FaceOffType.dusk:
      "The day fades. One final stand before rest. The demons hope you're tired. They hope you'll skip this one. Will you show them your resolve?",
};

/// Activity instructions for each face-off type
const activityInstructions = <FaceOffType, String>{
  FaceOffType.dawn:
      "Go. Move your body one mile. Walk or run — the choice is yours. Return when complete.",
  FaceOffType.noon:
      "Push until failure. Your body against gravity. How many can you do?",
  FaceOffType.dusk:
      "Pull until failure. Lift yourself toward the sky. How many can you do?",
};

/// Defer messages for each face-off type
const deferMessages = <FaceOffType, String>{
  FaceOffType.dawn:
      "I understand. Life demands much. I will return in one hour to ask again. The mile will wait — but not forever.",
  FaceOffType.noon:
      "Very well. Strength can wait one hour. But the demons grow bolder with each delay. I will return.",
  FaceOffType.dusk:
      "The evening is young still. One hour. Then we face this together. Rest if you must — then rise.",
};

/// Meditation prompt (shared across all face-offs)
const meditationPrompt =
    "Now still your mind. Ten minutes of silence builds the wall the demons cannot cross. Close your eyes. Breathe. Watch your thoughts without following them.";

/// Completion messages for each face-off type
const completionMessages = <FaceOffType, String>{
  FaceOffType.dawn:
      "The morning face-off is complete. You have moved. You have stilled. The demons retreat — for now.",
  FaceOffType.noon:
      "Midday strength proven. The noonday demon slinks away. You are stronger than its whispers.",
  FaceOffType.dusk:
      "The day ends in victory. You gave the demons nothing. Rest now — you've earned it.",
};

/// PR celebration message
const prMessage =
    "NEW RECORD! You have surpassed yourself. The demons cannot ignore your growing strength.";

/// Get random lore entry
String getRandomLore() {
  final random = Random();
  return loreEntries[random.nextInt(loreEntries.length)];
}

// ============================================
// LORE UNLOCKS (Progressive story fragments)
// ============================================

enum LoreUnlockType { points, evolution, streak, miles, meditation, pushups }

class LoreUnlock {
  final String id;
  final String name;
  final LoreUnlockType unlockType;
  final dynamic unlockValue; // int for points/streak/miles/etc, String for evolution stage id
  final List<String> entries;

  const LoreUnlock({
    required this.id,
    required this.name,
    required this.unlockType,
    required this.unlockValue,
    required this.entries,
  });
}

const loreUnlocks = [
  LoreUnlock(
    id: 'lore_origin',
    name: 'The Origin',
    unlockType: LoreUnlockType.points,
    unlockValue: 50,
    entries: [
      "In the beginning, there was only the Pleroma — the fullness of divine light. Then came the Fall.",
      "The Kenoma was born from that Fall — an emptiness yearning to be filled.",
      "The demons are not evil by nature. They are absence. Hunger. The void's attempt to consume what it lacks.",
    ],
  ),
  LoreUnlock(
    id: 'lore_guides',
    name: 'The Spirit Guides',
    unlockType: LoreUnlockType.evolution,
    unlockValue: 'shade',
    entries: [
      "Spirit Guides are fragments of the original light, scattered during the Fall.",
      "Each Guide bonds to a mortal once, and only once. The bond is eternal.",
      "When a mortal fails completely, the Guide fades. When a mortal transcends, the Guide ascends.",
    ],
  ),
  LoreUnlock(
    id: 'lore_demons',
    name: 'The Nature of Demons',
    unlockType: LoreUnlockType.streak,
    unlockValue: 7,
    entries: [
      "The demons have names: Acedia, the noonday demon. Tristitia, the shadow of despair. Vainglory, the mirror's lie.",
      "They cannot create. They can only distort, corrupt, and consume.",
      "Every time you choose light, a demon somewhere grows weaker. They know your name.",
    ],
  ),
  LoreUnlock(
    id: 'lore_body',
    name: 'The Temple of Flesh',
    unlockType: LoreUnlockType.miles,
    unlockValue: 10,
    entries: [
      "The Hermetic masters taught: the body is not a prison. It is a temple. A laboratory. A forge.",
      "Physical movement generates spiritual momentum. The ancients knew this before they knew why.",
      "Each mile walked is a prayer. Each breath is a ward. They cannot touch what is consecrated by effort.",
    ],
  ),
  LoreUnlock(
    id: 'lore_mind',
    name: 'The Fortress Mind',
    unlockType: LoreUnlockType.meditation,
    unlockValue: 100,
    entries: [
      "The untrained mind is an open gate. Meditation is learning to guard it.",
      "Watchfulness. The desert fathers called it nepsis. You are learning to watch your own mind.",
      "Ten minutes of stillness builds a wall they cannot cross. A lifetime of stillness builds a castle.",
    ],
  ),
  LoreUnlock(
    id: 'lore_strength',
    name: 'The Way of Strength',
    unlockType: LoreUnlockType.pushups,
    unlockValue: 100,
    entries: [
      "Strength is not violence. Strength is the capacity to resist entropy.",
      "The Stoics knew: he who conquers himself is mightier than he who conquers a city.",
      "Every rep is an act of defiance. Every failure to failure is proof of will.",
    ],
  ),
  LoreUnlock(
    id: 'lore_ascension',
    name: 'The Path of Ascension',
    unlockType: LoreUnlockType.evolution,
    unlockValue: 'seraph',
    entries: [
      "There are those who walked this path before you. Some became legends. Some became warnings.",
      "Ascension is not escape from the body. It is the perfection of body, mind, and spirit in union.",
      "The final stage is not power. It is peace. The demons cannot touch peace.",
    ],
  ),
];
