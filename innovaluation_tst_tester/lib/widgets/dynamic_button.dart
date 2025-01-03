import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/user_state.dart';
import '../screens/questionnaire_screen.dart';
import 'camera_service.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:innovaluation_tst_tester/widgets/roc_components.dart';
import '../providers/dialog_provider.dart';

class DynamicProgressButton extends StatefulWidget {
  final String userId;

  DynamicProgressButton({Key? key, required this.userId}) : super(key: key);

  @override
  _DynamicProgressButtonState createState() => _DynamicProgressButtonState();
}

class _DynamicProgressButtonState extends State<DynamicProgressButton> {
  UserState? userState;

  @override
  void initState() {
    super.initState();
  }

@override
Widget build(BuildContext context) {
  return StreamBuilder<UserState>(
    stream: userStateStream(widget.userId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData) {
        return Text('No user state available');
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<DialogManager>(context, listen: false).showDialogIfNeeded(snapshot.data!, context);
        });
        return _displayUserState(snapshot.data!);
      }
    },
  );
}

  void _faceVerifyPressed() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ROCEnrollWebViewer()));
  }

  // Check if the follow-up photo is locked
  bool _isPhotoLocked(UserState userState) {
    return userState.initialPhotoTaken &&
        !userState.canTakeFollowUpPhoto() &&
        !userState.followUpPhotoTaken;
  }

  void _completeQuestionnaire() {
    // navigate to the questionnaire screen
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => QuestionnaireScreen()));
  }

  void _takePhoto() async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(),
      ),
    );
  }

  Stream<UserState> userStateStream(String userId) {
    // listen to the  document for the given userId and map changes to UserState
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => UserState.fromFirestore(snapshot));
  }

  Widget _displayUserState(UserState userState) {
    // Check if the dialog should be shown and display it
    //_shouldShowDialog(userState);

    if (!userState.questionnaireCompleted) {
      return buildStateButton(
          context: context,
          text: 'Complete Questionnaire',
          fontSize: 20,
          iconPath: "assets/images/clipboard2.svg",
          color: const Color.fromARGB(255, 188, 188, 188),
          hasProgressBar: false,
          userState: userState,
          onPressed: _completeQuestionnaire,
          tooltipMessage: "Complete the questionnaire to proceed.");
    } else if (!userState.faceVerified) {
      return buildStateButton(
          context: context,
          text: 'Verify Face',
          iconPath: "assets/images/face.svg",
          color: Color(0xFF2E1C56),
          hasProgressBar: false,
          userState: userState,
          onPressed: _faceVerifyPressed,
          tooltipMessage: "Verify your face to proceed.");
    } else if (!userState.initialPhotoTaken) {
      //_isDialogShown = false;
      return buildStateButton(
          context: context,
          text: 'Take Initial Photo',
          iconPath: "assets/images/camera.svg",
          color: Color(0xFF2E1C56),
          hasProgressBar: false,
          userState: userState,
          tooltipMessage: "Take a photo of your injection site once administered",
          onPressed: _takePhoto);
    } else if (_isPhotoLocked(userState) &&
        !userState.hasFollowUpPhotoDeadlinePassed()) {
      return buildStateButton(
          context: context,
          text: 'Photo Locked',
          color: Color(0xFF949494),
          hasProgressBar: true,
          userState: userState,
          onPressed: null);
    } else if (userState.canTakeFollowUpPhoto()) {
      return buildStateButton(
          context: context,
          text: 'Take Follow-up Photo',
          fontSize: 20,
          iconPath: "assets/images/camera.svg",
          color: Color(0xFF2E1C56),
          hasProgressBar: true,
          userState: userState,
          onPressed: _takePhoto);
    } else if (userState.initialPhotoTaken && userState.followUpPhotoTaken) {
      return buildStateButton(
          context: context,
          text: 'All tasks completed',
          tooltipMessage: "Please await your diagnosis. Thank you for your cooperation.",
          iconPath: "assets/images/clipboard2.svg",
          color: Color(0xFF949494),
          hasProgressBar: false,
          userState: userState,
          onPressed: null);
      // user misses window
    } else if (userState.hasFollowUpPhotoDeadlinePassed()) {
      return buildStateButton(
          context: context,
          text: 'Missed Window',
          color: Color(0xFF949494),
          hasProgressBar: false,
          userState: userState,
          tooltipMessage: "Please contact your healthcare provider.",
          onPressed: null);
    } else {
      return Text('Unknown state');
    }
  }
}

Widget buildStateButton({
  required BuildContext context,
  required String text,
  String? iconPath,
  required Color color,
  VoidCallback? onPressed,
  required bool hasProgressBar,
  required UserState userState,
  String? tooltipMessage,
  double? fontSize,
}) {
  // Function to darken color
  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDarkened =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDarkened.toColor();
  }

  // Define button style with custom disabled and enabled background colors
  final buttonStyle = ButtonStyle(
    // Background color changes when button is pressed
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          // Darken the button color when pressed
          return darken(color, 0.1);
        }
        // Default color
        return color;
      },
    ),
    // Apply shape and padding to match the custom layout
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    padding: MaterialStateProperty.all(EdgeInsets.zero),
    // Maintain shadow on elevation
    elevation: MaterialStateProperty.all(4),
    shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.25)),
  );

  return Container(
    height: 120,
    width: 400,
    margin: EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      // Add boxShadow property to Container
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.30), // Shadow color with opacity
          spreadRadius: 0,
          blurRadius: 4,
          offset: Offset(0, 4), // Vertical shadow position
        ),
      ],
      borderRadius: BorderRadius.circular(20), // Match button's border radius
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: Row(
        children: [
          // First 3/4 of the button for text and progress bar
          Expanded(
            flex: 3, // Takes 3/4 of the space
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      text,
                      style: TextStyle(
                          fontSize: fontSize ?? 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // Only show progress bar if hasProgressBar is true, pushed lower
                  if (hasProgressBar)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: CountdownProgressBar(userState: userState),
                    ),
                  if (!hasProgressBar)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 8.0),
                      child: Text(
                        tooltipMessage ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Last 1/4 of the button for the SVGs
          Expanded(
            flex: 1, // Takes 1/4 of the space
            child: Container(
              // Center the SVGs within this container
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center the icons horizontally
                children: [
                  if (iconPath != null)
                  SvgPicture.asset(iconPath,
                      height: 30, width: 30, color: Colors.white), // First SVG
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0), // Space between the icons
                    child: SvgPicture.asset('assets/images/arrow.svg',
                        height: 18, width: 18), // Second SVG
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

String formatDuration(Duration d) =>
    d.toString().split('.').first.padLeft(8, "0");

class CountdownProgressBar extends StatefulWidget {
  final UserState userState;

  const CountdownProgressBar({Key? key, required this.userState})
      : super(key: key);

  @override
  _CountdownProgressBarState createState() => _CountdownProgressBarState();
}

class _CountdownProgressBarState extends State<CountdownProgressBar> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildProgressBar(widget.userState);
  }

  Widget _buildProgressBar(UserState userState) {
    Duration? remainingDuration;
    final int totalDurationSeconds;
    bool hasProgressBar = false;

    // Determine the countdown type and set the remaining duration
    if (userState.initialPhotoTaken && !userState.canTakeFollowUpPhoto()) {
      remainingDuration = userState.getLockedCountdownDuration();
      totalDurationSeconds = 48 * 3600; // Total duration for locked countdown
      hasProgressBar = true;
    } else {
      remainingDuration = userState.getFollowUpPhotoCountdownDuration();
      totalDurationSeconds =
          24 * 3600; // Total duration for follow-up countdown
    }

    if (remainingDuration != null && remainingDuration.inSeconds > 0) {
      final remainingSeconds = remainingDuration.inSeconds;
      double progress = hasProgressBar
          ? 1 - remainingSeconds / totalDurationSeconds
          : remainingSeconds / totalDurationSeconds;

      String remainingTimeText =
          "${remainingDuration.inHours}h ${(remainingDuration.inMinutes % 60)}m";

      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: SizedBox(
          height: 24, // Height of the progress bar
          width: double.infinity, // Ensure it takes the full width available
          child: Stack(
            children: [
              // Background color
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 228, 228, 228), // Base color for the unfilled part
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              // Gradient progress
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress, // Dynamic progress
                  child: Container(
                    height: double.infinity, // Fill the height
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0x99CF49FF), Color(0xABB50AAD)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              // Timer text
              // Timer text with shadow and padding
            Container(
              padding: EdgeInsets.only(left: 20), // Add padding to the left
              alignment: Alignment.centerLeft, // Align text to the left
              child: Text(
                remainingTimeText,
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 14, // Adjust the font size as needed
                  shadows: [
                    Shadow( // Shadow for the text
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  return Container(); // Return an empty container if there's no progress to show
}
}

// TODO
// language support
// more push notifications. Questionnaire reminder, photo reminder, missed window