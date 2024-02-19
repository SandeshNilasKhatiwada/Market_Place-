import 'package:flutter/material.dart';

const decorationTextField = InputDecoration(
  //to delete borders ( bottom border )
  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
  // on click border color
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
    color: Colors.grey,
  )),
  // fill with grey default color
  filled: true,
  contentPadding: EdgeInsets.all(8),
);
