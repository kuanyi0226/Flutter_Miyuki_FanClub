import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:project5_miyuki/class/Song.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project5_miyuki/materials/colors.dart';
import 'package:provider/provider.dart';

class RatingCard extends StatefulWidget {
  List ratingList;
  final String songName;

  RatingCard({required this.ratingList, required this.songName});

  @override
  _RatingCardState createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  double _averageScore = 0.0;
  int _ratingCount = 0;

  bool _isCountdownActive = false;
  int _countdownSeconds = 10;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _calculateRatingData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _countdownTimer!.cancel();
  }

  void _calculateRatingData() {
    double totalScore = 0.0;
    int count = widget.ratingList.length;

    for (var entry in widget.ratingList) {
      // Extract rating from the string
      double? score;
      final regex = RegExp(
          r'\[?(\d+(\.\d+)?)\]?'); // Regex to match numbers with optional brackets
      final match = regex.firstMatch(entry);
      if (match != null) {
        score = double.tryParse(match.group(1) ?? '');
      }

      if (score != null) {
        totalScore += score;
      }
    }

    setState(() {
      _averageScore = count > 0 ? totalScore / count : 0.0;
      _ratingCount = count;
    });
  }

  void _addRating() async {
    //check cool-down
    if (_isCountdownActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please wait $_countdownSeconds seconds.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    double selectedRating = Song.readRating(widget.ratingList);
    String snackBarString = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.rate),
          content: RatingBar.builder(
            initialRating: selectedRating,
            minRating: 0,
            maxRating: 5,
            itemSize: 40.0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              selectedRating = rating;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (kIsWeb ||
                    Provider.of<InternetConnectionStatus>(context,
                            listen: false) ==
                        InternetConnectionStatus.connected) {
                  //Update ratings
                  widget.ratingList =
                      await Song.updateRatings(widget.songName, selectedRating);
                  setState(() {
                    _calculateRatingData();
                  });
                  snackBarString = AppLocalizations.of(context)!.rated;
                  _startCountdown();
                } else {
                  snackBarString = AppLocalizations.of(context)!.no_wifi;
                }
                Navigator.of(context).pop();
                var snackBar = SnackBar(content: Text(snackBarString));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }

  void _startCountdown() {
    setState(() {
      _isCountdownActive = true;
      _countdownSeconds = 10;
    });

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countdownSeconds--;
      });

      if (_countdownSeconds == 0) {
        timer.cancel();
        setState(() {
          _isCountdownActive = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Average Score
                  Text(
                    _averageScore.toStringAsFixed(1),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // Rating Bar
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: _averageScore,
                        itemCount: 5,
                        itemSize: 20.0,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                      //Rate amount
                      Text(
                        '  ($_ratingCount)',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  //Rated before
                  Song.inRatingList(widget.ratingList)
                      ? Text(' (${AppLocalizations.of(context)!.rated})',
                          style: TextStyle(fontSize: 12))
                      : Container(),
                ],
              ),
              SizedBox(height: 16),
              // Add Rating Button
              OutlinedButton(
                onPressed: _addRating,
                child: Text(AppLocalizations.of(context)!.rate,
                    style: TextStyle(color: theme_pink)),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  side: BorderSide(width: 2.0, color: theme_pink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
