import 'package:flutter/material.dart';
import 'dart:math';

/// Widget handle Multi Select Dropdown [MultiSelectDropdownMenu]
class MultiSelectDropdownMenu<T> extends FormField<List<T>> {
  final List<T> items;
  final bool filter;
  final double maxHeight;
  final FormFieldSetter<List<T>> onSaved;
  final FormFieldValidator<List<T>> validator;
  final List<T> initialValue;
  final bool autovalidate;
  final bool enabled;
  final InputDecoration decoration;

  MultiSelectDropdownMenu({
    Key key,
    @required this.items,
    this.filter = false,
    this.maxHeight = 250,
    this.onSaved,
    this.initialValue,
    this.validator,
    this.autovalidate = false,
    this.enabled = true,
    this.decoration = const InputDecoration(),
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autovalidate,
          enabled: enabled,
          builder: (
            FormFieldState state,
          ) {
            final _MultiSelectDropdownMenuState fieldState =
                state as _MultiSelectDropdownMenuState;
            ;
            // Apply color for icon when field has error
            final InputDecoration baseDecoration =
                fieldState.widget.decoration.copyWith(
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                color: fieldState.hasError
                    ? Colors.red
                    : IconTheme.of(fieldState.context).color,
              ),
            );
            // Apply default input theme
            final InputDecoration decoration = baseDecoration.applyDefaults(
              Theme.of(fieldState.context).inputDecorationTheme,
            );
            return Container(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: InputDecorator(
                  child: Text(fieldState.selectedLabel),
                  decoration:
                      decoration.copyWith(errorText: fieldState.errorText),
                ),
                onTap: () {
                  if (items == null || items.length == 0) {
                    return;
                  }
                  // Get current input render box
                  final RenderBox inputBox =
                      fieldState.context.findRenderObject();
                  // Cast to rect with global position
                  final Rect inputRect =
                      inputBox.localToGlobal(Offset.zero) & inputBox.size;
                  Navigator.of(fieldState.context).push(
                    _MultiSelectDropdownRoute(
                      child: _MultiSelectDropdownContent(
                        items: items,
                        fieldState: fieldState,
                        filter: filter,
                      ),
                      inputRect: inputRect,
                      maxHeight: maxHeight,
                      filter: filter,
                    ),
                  );
                },
              ),
            );
          },
        );

  @override
  _MultiSelectDropdownMenuState<T> createState() =>
      _MultiSelectDropdownMenuState();
}

class _MultiSelectDropdownContent extends StatefulWidget {
  final List items;
  final _MultiSelectDropdownMenuState fieldState;
  final bool filter;

  _MultiSelectDropdownContent(
      {@required this.items, @required this.fieldState, this.filter});

  @override
  __MultiSelectDropdownContentState createState() =>
      __MultiSelectDropdownContentState();
}

class __MultiSelectDropdownContentState
    extends State<_MultiSelectDropdownContent> {
  TextEditingController _textController;
  List filteredItems;

  @override
  void initState() {
    super.initState();
    if (widget.filter) {
      _textController = TextEditingController();
      // Initial filtered items
      updateFilteredItems();
      _textController.addListener(() {
        setState(() {
          // Subsequent filtered items
          updateFilteredItems();
        });
      });
    } else {
      filteredItems = widget.items;
    }
  }

  updateFilteredItems() {
    filteredItems = widget.items.where((element) {
      if (_textController.text != null ||
          _textController.text.toString() != '') {
        return element.toString().contains(_textController.text.toString());
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.filter)
              TextField(
                controller: _textController,
                decoration: InputDecoration(labelText: 'Search...'),
              ),
            // [Flexible] allow ListView with shrinkWrap to scrollable, when content too large
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filteredItems.length,
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final key = filteredItems.elementAt(index);
                  return ListTile(
                    onTap: () {
                      setState(() {
                        widget.fieldState.updateCheckbox(
                            key, !widget.fieldState.itemDictionary[key]);
                      });
                    },
                    leading: Checkbox(
                      value: widget.fieldState.itemDictionary[key],
                      onChanged: (checked) {
                        setState(() {
                          widget.fieldState.updateCheckbox(key, checked);
                        });
                      },
                    ),
                    title: Text('$key'),
                  );
                },
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: kElevationToShadow[9],
        ),
      ),
    );
  }
}

class _MultiSelectDropdownMenuState<T> extends FormFieldState<List<T>> {
  Map<T, bool> _itemDictionary;

  @override
  MultiSelectDropdownMenu<T> get widget =>
      super.widget as MultiSelectDropdownMenu<T>;

  @override
  void initState() {
    super.initState();
    // Set default value
    // Default Select all
    if (widget.initialValue == null) {
      setValue(widget.items);
      _itemDictionary =
          Map.fromIterable(widget.items, key: (e) => e, value: (e) => true);
    } else {
      _itemDictionary = Map.fromIterable(widget.initialValue,
          key: (e) => e, value: (e) => true);
    }
  }

  Map<T, bool> get itemDictionary {
    return _itemDictionary;
  }

  String get selectedLabel {
    final selectedItems = _itemDictionary.keys
        .where((element) => _itemDictionary[element])
        .toList();
    if (selectedItems.length == widget.items.length) {
      return 'All';
    }
    String label = '';
    if (selectedItems.length > 0) {
      label += selectedItems.elementAt(0) as String;
    }
    int remainItems = selectedItems.length - 1;
    if (remainItems > 0) {
      label += '(+$remainItems Items)';
    }
    return label;
  }

  updateCheckbox(dynamic key, bool value) {
    _itemDictionary.update(key, (oldValue) => value);
    super.didChange(_itemDictionary.keys
        .where((element) => _itemDictionary[element])
        .toList());
  }
}

/// Create a popup route to push on top of stack
/// Get available constraint with [LayoutBuilder]
class _MultiSelectDropdownRoute extends PopupRoute {
  /// Child to render inside [Popup]
  Widget child;

  /// Coordinate, width and height of the [inputRect]
  /// Base on current coordinate we can decide where to render the [Popup]
  Rect inputRect;
  bool filter;
  double maxHeight;

  _MultiSelectDropdownRoute(
      {@required this.child,
      @required this.inputRect,
      this.filter,
      this.maxHeight});

  /// Color for the barrier, can set color to see the barrier area
  @override
  Color get barrierColor => null;

  /// When tap outside Current Route will be pop of the Stack
  @override
  bool get barrierDismissible => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    print(inputRect.top);

    return ScaleTransition(
      scale: animation.drive(Tween(begin: 0.9, end: 1.0)),
      alignment: Alignment.topLeft,
      child: FadeTransition(
        opacity: animation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _MultiSelectDropdownPage(
              child: child,
              constraints: constraints,
              inputRect: inputRect,
              filter: filter,
              maxHeight: maxHeight,
            );
          },
        ),
      ),
    );
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 100);

  @override
  String get barrierLabel => 'BarrierLabel';
}

class _MultiSelectDropdownPage extends StatelessWidget {
  final BoxConstraints constraints;
  final Widget child;
  final Rect inputRect;
  final bool filter;
  final double maxHeight;

  _MultiSelectDropdownPage(
      {this.constraints,
      this.child,
      this.inputRect,
      this.filter,
      this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _MultiSelectDropdownDelegate(
        inputRect: inputRect,
        filter: filter,
        maxHeight: maxHeight,
      ),
      child: child,
    );
  }
}

class _MultiSelectDropdownDelegate extends SingleChildLayoutDelegate {
  final Rect inputRect;
  final bool filter;
  final double maxHeight;

  _MultiSelectDropdownDelegate(
      {@required this.inputRect, this.filter, this.maxHeight});

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Start at 1 / 3 of input height
    double y = inputRect.top + inputRect.height / 3;
    double height = y + maxHeight;
    // Not enough space move y to the top
    if (height > size.height) {
      y = max(0, inputRect.top - childSize.height);
    }
    double x = inputRect.left;
    return Offset(x, y);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // Given constraint for child
    // Adjust dimension of child
    double width = inputRect.width;
    return BoxConstraints(
        maxHeight: maxHeight, minHeight: 0, minWidth: width, maxWidth: width);
  }
}
