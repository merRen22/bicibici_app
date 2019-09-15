import 'package:flutter/material.dart';

class UtilityWidget {
  static Widget sliverloadingIndicator(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            height: (MediaQuery.of(context).size).height,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.purple),
                strokeWidth: 5.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget containerloadingIndicator(BuildContext context) {
    return Container(
            height: (MediaQuery.of(context).size).height,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.purple),
                strokeWidth: 5.0,
              ),
            ),
    );
  }
}
