import 'package:flutter/material.dart';

import '../todo_model.dart';

class InputWidget extends StatefulWidget {
  final String? current;

  const InputWidget({this.current, Key? key}) : super(key: key);

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController _tCon = TextEditingController();

  String? get current => widget.current;

  @override
  void initState() {
    if (current != null) _tCon.text = current as String;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState?.validate();
          setState(() {});
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(current != null ? 'Edit Todo' : 'Add Todo',style: TextStyle(color: Colors.redAccent,fontSize: 25),),
            TextFormField(
              controller: _tCon,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: (_formKey.currentState?.validate() ?? false)
                    ? () {
                        if (_formKey.currentState?.validate() ?? false) {
                          Navigator.of(context).pop(Todo(details: _tCon.text));
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    primary: (_formKey.currentState?.validate() ?? false)
                        ?  Colors.redAccent
                        : Colors.redAccent),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(current != null ? 'Edit' : 'Add',style: TextStyle(fontSize: 25),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
