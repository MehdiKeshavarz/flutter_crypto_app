import 'package:flutter/material.dart';
class SliderWidget extends StatefulWidget {
   var controller;
   SliderWidget({Key? key,required this.controller,}) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {

  var image = [
   'images/a1.png',
   'images/a2.png',
   'images/a3.png',
   'images/a4.png',
  ];


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.controller,
      children: [
        myPages(image[0]),
        myPages(image[1]),
        myPages(image[2]),
        myPages(image[3]),
      ],
    );
  }

  Widget myPages(String image){
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Image(image: AssetImage(image),fit: BoxFit.fill,));
  }
}
