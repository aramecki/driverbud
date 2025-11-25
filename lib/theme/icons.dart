import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mycargenie_2/theme/colors.dart';

// Circle arrow down for dropdowns
HugeIcon arrowDownIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedCircleArrowDown01,
  size: 25,
);

// Circle arrow up for dropdowns
HugeIcon arrowUpIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedCircleArrowUp01,
  size: 25,
);

// Calendar icon
HugeIcon calendarIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedCalendar03,
  size: 25,
);

// Share icon
HugeIcon shareIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedShare08,
  size: 35,
  strokeWidth: 1.5,
);

// Filled Star icon
HugeIcon activeStarIcon = HugeIcon(icon: HugeIcons.strokeRoundedStar, size: 25);

// Only borders star icon
HugeIcon emptyStarIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedStarOff,
  size: 22,
  color: Colors.grey[850],
);

// Garage icon
HugeIcon garageIcon = HugeIcon(icon: HugeIcons.strokeRoundedGarage, size: 30);

// Back icon
HugeIcon backIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedArrowLeft01,
  size: 30,
);

// Settings icon
HugeIcon settingsIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedSettings01,
  size: 30,
);

// Help icon
HugeIcon helpIcon = HugeIcon(icon: HugeIcons.strokeRoundedHelpCircle, size: 30);

// Filter icon
HugeIcon filterIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedFilterMailSquare,
  size: 50,
);

// Image icon
HugeIcon imageIcon({double iconSize = 50}) {
  return HugeIcon(
    icon: HugeIcons.strokeRoundedImage02,
    size: iconSize,
    color: halfAlphaBlack,
  );
}

// Delete icon
HugeIcon deleteIcon({double iconSize = 22}) {
  return HugeIcon(
    icon: HugeIcons.strokeRoundedDelete02,
    size: iconSize,
    color: Colors.deepOrange,
  );
}

// Edit icon
HugeIcon editIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedEdit03,
  size: 22,
  color: Colors.white,
);

HugeIcon searchIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedSearch01,
  size: 30,
  color: Colors.deepOrange,
);
