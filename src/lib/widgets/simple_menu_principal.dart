import 'package:flutter/material.dart';

class Choice {
  const Choice(
      {required this.title,
      required this.icon,
      required this.color,
      required this.highlightColor,
      required this.onPressed});
  final String title;
  final IconData icon;
  final Function onPressed;
  final Color color;
  final Color highlightColor;
}

class SimpleMenuItem extends StatefulWidget {
  const SimpleMenuItem(
      {Key? key, required this.choice, required this.iconSize, this.textStyle})
      : super(key: key);
  final Choice choice;
  final double iconSize;
  final TextStyle? textStyle;

  @override
  State<SimpleMenuItem> createState() => _SimpleMenuItemState();
}

class _SimpleMenuItemState extends State<SimpleMenuItem> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.choice.color;
  }

  @override
  Widget build(BuildContext context) {
    //final TextStyle? textStyle = Theme.of(context).textTheme.displaySmall;
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _currentColor = widget.choice.highlightColor;
        });
      },
      onExit: (event) {
        setState(() {
          _currentColor = widget.choice.color;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.choice.onPressed();
        },
        child: Card(
          elevation: 1,
          color: _currentColor,
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Icon(widget.choice.icon,
                          size: widget.iconSize,
                          color: widget.textStyle!.color)),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(widget.choice.title,
                        textAlign: TextAlign.center, style: widget.textStyle),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SimpleMenuPrincipal extends StatelessWidget {
  SimpleMenuPrincipal(
      {Key? key,
      required this.choices,
      this.maxPerRow,
      // required this.color,
      // required this.highlightColor,
      required this.iconSize,
      this.textStyle})
      : super(key: key);
  final List<Choice> choices;
  // final Color color;
  // final Color highlightColor;

  late int? maxPerRow;
  final double iconSize;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: maxPerRow ?? 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 8.0,
        children: List.generate(
          choices.length,
          (index) {
            return Center(
              child: SimpleMenuItem(
                choice: choices[index],
                // color: choices[index].color,
                // highlightColor: choices[index].highlightColor,
                iconSize: iconSize,
                textStyle: textStyle,
              ),
            );
          },
        ));
  }
}
