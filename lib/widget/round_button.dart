import 'package:flutter/material.dart';

// ignore: camel_case_types
class roundbuttom extends StatelessWidget {
  String button;
  bool loading;
  VoidCallback ontap;
  roundbuttom(
      {super.key,
      required this.button,
      required this.ontap,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Center(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: loading == true
                ? CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Colors.white,
                  )
                : Text(
                    button,
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
