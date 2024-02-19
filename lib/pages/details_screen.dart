// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flower_app/model/item.dart';
import 'package:flower_app/shared%20widgets/appbar.dart';
import 'package:flower_app/shared%20widgets/colors.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  Item item;
  Details({required this.item, super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isShowMore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(widget.item.imgUrl),
            SizedBox(
              height: 11,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              // SizedBox(
              //   width: 16,
              // ),
              Text(
                "Rs ${widget.item.price}",
                style: TextStyle(fontSize: 18, color: valRed),
              ),
              Text(
                "${widget.item.quantity} on Stock",
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 25, 107, 68)),
              ),
              // SizedBox(
              //   width: 16,
              // ),
            ]),
            SizedBox(
              height: 16,
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              child: Text(
                "Details : ",
                style: TextStyle(fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.item.description,
                maxLines: isShowMore ? null : 3,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.justify,
              ),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    isShowMore = !isShowMore;
                  });
                },
                child: Text(isShowMore ? "Show Less" : "Show More"))
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          widget.item.product,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: valRed,
        actions: [
          ProductsAndPrice(),
        ],
      ),
    );
  }
}
