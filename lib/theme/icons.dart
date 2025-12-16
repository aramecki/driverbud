import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mycargenie_2/theme/colors.dart';

// Circle arrow down for dropdowns
HugeIcon arrowDownIcon({double iconSize = 25}) {
  return HugeIcon(
    icon: HugeIcons.strokeRoundedCircleArrowDown01,
    size: iconSize,
    color: Colors.white,
  );
}

// Circle arrow up for dropdowns
HugeIcon arrowUpIcon({double iconSize = 25}) {
  return HugeIcon(
    icon: HugeIcons.strokeRoundedCircleArrowUp01,
    size: iconSize,
    color: Colors.white,
  );
}

// Calendar icon
HugeIcon calendarIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedCalendar03,
  size: 25,
);

// Start Calendar icon
HugeIcon startCalendarIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedCalendarAdd02,
  size: 25,
);

// Stop Calendar icon
HugeIcon stopCalendarIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedCalendarRemove02,
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

// Search Icon
HugeIcon searchIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedSearch01,
  size: 30,
  color: Colors.deepOrange,
);

// Circle Check Icon
HugeIcon checkIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedCheckmarkCircle01,
  color: Colors.deepOrange,
  strokeWidth: 2,
  size: 30,
);

// Language Icon
HugeIcon languageIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedLanguageSquare,
  size: 28,
  strokeWidth: 1.5,
);

// Region Icon
HugeIcon regionIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedFlag02,
  size: 28,
  strokeWidth: 1.5,
);

// Currency Icon
HugeIcon currencyIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedMoney01,
  size: 28,
  strokeWidth: 1.5,
);

// Theme Icon
HugeIcon themeIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedColors,
  size: 28,
  strokeWidth: 1.5,
);

// Backup and Restore Icon
HugeIcon backupAndRestoreIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedDownload03,
  size: 28,
  strokeWidth: 1.5,
);

// Feedback Icon
HugeIcon feedbackIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedComment01,
  size: 28,
  strokeWidth: 1.5,
);

// Info Icon
HugeIcon infoIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedAlertSquare,
  size: 28,
  strokeWidth: 1.5,
);

// Insurance Icon
HugeIcon insuranceIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedSafe,
  size: 28,
  strokeWidth: 1.5,
);

// Tax Icon
HugeIcon taxIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedSaleTag01,
  size: 28,
  strokeWidth: 1.5,
);

// Revision Icon
HugeIcon revisionIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedService,
  size: 28,
  strokeWidth: 1.5,
);

// Car Icon
HugeIcon carIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedCar05,
  strokeWidth: 1.5,
  size: 60,
);
