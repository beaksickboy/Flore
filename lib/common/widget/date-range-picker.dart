import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerForm extends FormField<DateTime> {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime currentDate;
  final DatePickerEntryMode initialEntryMode;
  final SelectableDayPredicate selectableDayPredicate;
  final String cancelText;
  final String confirmText;
  final Locale locale;
  final bool useRootNavigator;
  final RouteSettings routeSettings;
  final TextDirection textDirection;
  final TransitionBuilder transitionBuilder;
  final DatePickerMode initialDatePickerMode;

  // Form Configuration
  final FormFieldSetter<DateTime> onSaved;
  final FormFieldValidator<DateTime> validator;
  final DateTime initialValue;
  final bool autovalidate;
  final bool enabled;
  final InputDecoration decoration;
  final DateFormat dateFormat;

  DatePickerForm(
      {Key key,
      this.firstDate,
      this.lastDate,
      this.currentDate,
      this.initialEntryMode = DatePickerEntryMode.calendar,
      this.selectableDayPredicate,
      this.cancelText,
      this.confirmText,
      this.locale,
      this.useRootNavigator = true,
      this.routeSettings,
      this.textDirection,
      this.transitionBuilder,
      this.initialDatePickerMode = DatePickerMode.day,
      this.onSaved,
      this.initialValue,
      this.enabled = true,
      this.autovalidate = false,
      this.validator,
      this.decoration = const InputDecoration(),
      dateFormat})
      : dateFormat = dateFormat ?? DateFormat('yyyy/MM/dd'),
        super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            enabled: enabled,
            builder: (FormFieldState state) {
              final _DatePickerFormState fieldState =
                  state as _DatePickerFormState;
              ;
              // Apply color for icon when field has error
              final InputDecoration baseDecoration =
                  fieldState.widget.decoration.copyWith(
                suffixIcon: Icon(
                  Icons.date_range,
                  color: fieldState.hasError
                      ? Colors.red
                      : IconTheme.of(fieldState.context).color,
                ),
              );
              // Apply default input theme
              final InputDecoration decoration = baseDecoration.applyDefaults(
                Theme.of(fieldState.context).inputDecorationTheme,
              );

              return GestureDetector(
                child: InputDecorator(
                  decoration: decoration,
                  child: Text(
                      '${fieldState.widget.dateFormat.format(fieldState.value)}'),
                ),
                onTap: () {
                  showDatePicker(
                    context: fieldState.context,
                    firstDate: firstDate ?? DateTime(2000),
                    lastDate: lastDate ?? DateTime(3000),
                    useRootNavigator: useRootNavigator,
                    builder: transitionBuilder,
                    cancelText: cancelText,
                    confirmText: confirmText,
                    currentDate: currentDate,
                    routeSettings: routeSettings,
                    locale: locale,
                    initialDate: fieldState.value,
                    selectableDayPredicate: selectableDayPredicate,
                  ).then((value) => {
                        if (value != null) {fieldState.didChange(value)}
                      });
                },
              );
            });

  @override
  _DatePickerFormState createState() => _DatePickerFormState();
}

class _DatePickerFormState extends FormFieldState<DateTime> {
  DatePickerForm get widget => super.widget as DatePickerForm;

  @override
  void initState() {
    super.initState();
    setValue(DateTime.now());
  }
}

class DateRangePickerForm extends FormField<DateTimeRange> {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime currentDate;
  final DatePickerEntryMode initialEntryMode;
  final SelectableDayPredicate selectableDayPredicate;
  final String cancelText;
  final String confirmText;
  final Locale locale;
  final bool useRootNavigator;
  final RouteSettings routeSettings;
  final TextDirection textDirection;
  final TransitionBuilder transitionBuilder;
  final DatePickerMode initialDatePickerMode;

  // Form Configuration
  final FormFieldSetter<DateTimeRange> onSaved;
  final FormFieldValidator<DateTimeRange> validator;
  final DateTimeRange initialValue;
  final bool autovalidate;
  final bool enabled;
  final InputDecoration decoration;
  final DateFormat dateFormat;

  DateRangePickerForm(
      {Key key,
      this.firstDate,
      this.lastDate,
      this.currentDate,
      this.initialEntryMode = DatePickerEntryMode.calendar,
      this.selectableDayPredicate,
      this.cancelText,
      this.confirmText,
      this.locale,
      this.useRootNavigator = true,
      this.routeSettings,
      this.textDirection,
      this.transitionBuilder,
      this.initialDatePickerMode = DatePickerMode.day,
      this.onSaved,
      this.initialValue,
      this.enabled = true,
      this.autovalidate = false,
      this.validator,
      this.decoration = const InputDecoration(),
      dateFormat})
      : dateFormat = dateFormat ?? DateFormat('yyyy/MM/dd'),
        super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            enabled: enabled,
            builder: (FormFieldState state) {
              final _DateRangePickerFormState fieldState =
                  state as _DateRangePickerFormState;
              ;
              // Apply color for icon when field has error
              final InputDecoration baseDecoration =
                  fieldState.widget.decoration.copyWith(
                suffixIcon: Icon(
                  Icons.date_range,
                  color: fieldState.hasError
                      ? Colors.red
                      : IconTheme.of(fieldState.context).color,
                ),
              );
              // Apply default input theme
              final InputDecoration decoration = baseDecoration.applyDefaults(
                Theme.of(fieldState.context).inputDecorationTheme,
              );
              return GestureDetector(
                  child: InputDecorator(
                    decoration: decoration,
                    child: Text(
                        '${fieldState.widget.dateFormat.format(fieldState.value.start)} - ${fieldState.widget.dateFormat.format(fieldState.value.end)}'),
                  ),
                  onTap: () {
                    showDateRangePicker(
                      context: fieldState.context,
                      firstDate: firstDate ?? DateTime(2000),
                      lastDate: lastDate ?? DateTime(3000),
                      useRootNavigator: useRootNavigator,
                      builder: transitionBuilder,
                      cancelText: cancelText,
                      confirmText: confirmText,
                      currentDate: currentDate,
                      routeSettings: routeSettings,
                      locale: locale,
                      initialDateRange: fieldState.value,
                    ).then((value) => {
                          if (value != null) {fieldState.didChange(value)}
                        });
                  });
            });

  @override
  _DateRangePickerFormState createState() => _DateRangePickerFormState();
}

class _DateRangePickerFormState extends FormFieldState<DateTimeRange> {
  DateRangePickerForm get widget => super.widget as DateRangePickerForm;

  @override
  void initState() {
    super.initState();
    setValue(widget.initialValue ??
        DateTimeRange(
          start: DateTime.now().subtract(Duration(days: 1)),
          end: DateTime.now(),
        ));
  }
}
