import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cars_frontend/controller/cars_notifier.dart';
import 'package:cars_frontend/di.dart';
import 'dart:html' as html;


class FilterCars extends ConsumerStatefulWidget {
  const FilterCars({super.key});

  @override
  _FilterCarsState createState() => _FilterCarsState();
}

class _FilterCarsState extends ConsumerState<FilterCars> {
  final filterController = TextEditingController();
  FilterProperty selectedFilterProperty = FilterProperty.any;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    html.document.getElementById('pretraga')?.setAttribute('id', 'pretraga');
    html.document.getElementById('atribu')?.setAttribute('id', 'atribut');
    html.document.getElementById('reset')?.setAttribute('id', 'reset');
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            key: const ValueKey('pretraga'),
            controller: filterController,
            onChanged: _filterLibraries,
          ),
        ),
        SizedBox(width: 50),
        DropdownMenu(
          key: const ValueKey('atribut'),
          dropdownMenuEntries: FilterProperty.values
              .map<DropdownMenuEntry<FilterProperty>>(
                (filterProperty) => DropdownMenuEntry<FilterProperty>(
                  value: filterProperty,
                  label: filterProperty.label,
                ),
              )
              .toList(),
          initialSelection: selectedFilterProperty,
          onSelected: (FilterProperty? property) {
            setState(() => selectedFilterProperty = property!);
          },
        ),
        SizedBox(width: 50),
        ElevatedButton(onPressed: _resetFilter, key: Key('reset'), child: Text("Reset filter")),
      ],
    );
  }

  void _filterLibraries(final String value) {
    ref.read(libraryNotifierProvider.notifier).filterData(
          selectedFilterProperty,
          value.toLowerCase(),
        );
  }

  void _resetFilter() {
    setState(() {
      selectedFilterProperty = FilterProperty.any;
      filterController.text = '';
    });
    ref.read(libraryNotifierProvider.notifier).resetFilter();
  }
}
