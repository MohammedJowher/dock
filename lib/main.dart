import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(child: Dock()),
      ),
    );
  }
}

class Dock extends StatefulWidget {
  @override
  _DockState createState() => _DockState();
}

class _DockState extends State<Dock> {
  List<String> icons = ['Home', 'Settings', 'Profile', 'Files', 'Mail'];
  String? draggingIcon;
  int? draggingIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: icons.asMap().entries.map((entry) {
        int index = entry.key;
        String icon = entry.value;

        return DragTarget<String>(
          onWillAccept: (data) => data != null && data != icon,
          onAccept: (data) {
            setState(() {
              int oldIndex = icons.indexOf(data);
              icons.removeAt(oldIndex);
              icons.insert(index, data);
              draggingIcon = null;
              draggingIndex = null;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Draggable<String>(
                data: icon,
                child: _buildDockButton(icon, draggingIcon == icon),
                feedback: Material(
                  color: Colors.transparent,
                  child: _buildDockButton(icon, true),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: _buildDockButton(icon, false),
                ),
                onDragStarted: () {
                  setState(() {
                    draggingIcon = icon;
                    draggingIndex = index;
                  });
                },
                onDraggableCanceled: (velocity, offset) {
                  setState(() {
                    draggingIcon = null;
                    draggingIndex = null;
                  });
                },
                onDragEnd: (details) {
                  setState(() {
                    draggingIcon = null;
                    draggingIndex = null;
                  });
                },
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildDockButton(String icon, bool isDragging) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isDragging ? 60 : 50,
      width: isDragging ? 60 : 50,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        shape: BoxShape.circle,
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Center(
        child: Text(
          icon[0],
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
