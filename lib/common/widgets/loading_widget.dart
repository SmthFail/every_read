import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                CircularProgressIndicator(),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Loading",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Spacer(),
              ],
            ),
          );
        }));
  }
}