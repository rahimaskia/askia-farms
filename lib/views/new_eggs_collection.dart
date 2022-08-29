import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../widgets/custom_snackbar.dart';

class NewEggsCollection extends StatefulWidget {
  const NewEggsCollection({Key? key}) : super(key: key);

  @override
  State<NewEggsCollection> createState() => _NewEggsCollectionState();
}

class _NewEggsCollectionState extends State<NewEggsCollection> {
  FormGroup get buildForm => fb.group({
        'numberOfEggs': FormControl<int>(
            validators: [Validators.number, Validators.required]),
        'broken': FormControl<int>(
            validators: [Validators.number, Validators.required]),
        'date': FormControl<DateTime>(
            value: DateTime.now(), validators: [Validators.required]),
        'time': FormControl<TimeOfDay>(
            value: TimeOfDay.now(), validators: [Validators.required])
      });

  late FocusNode _focusNode;
  late FocusNode _focusNode1;
  bool _loading = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode1 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Egg collection'),
        ),
        body: SingleChildScrollView(
          child: ReactiveFormBuilder(
              form: () => buildForm,
              builder: (ctx, form, child) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Column(
                    children: [
                      ReactiveTextField<int>(
                        formControlName: 'numberOfEggs',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Number of eggs'),
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                          ValidationMessage.number: 'Must be a number',
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReactiveTextField<int>(
                        formControlName: 'broken',
                        decoration: const InputDecoration(
                            labelText: 'No. of eggs broken'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                          ValidationMessage.number: 'Must be a number',
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReactiveDatePicker<DateTime>(
                        formControlName: 'date',
                        firstDate: DateTime(1985),
                        lastDate: DateTime(2030),
                        builder: (context, picker, child) {
                          Widget suffix = InkWell(
                            onTap: () {
                              _focusNode.unfocus();

                              // Disable text field's focus node request
                              _focusNode.canRequestFocus = false;

                              // Clear field value
                              picker.control.value = null;
                              //Enable the text field's focus node request after
                              // some delay
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                _focusNode.canRequestFocus = true;
                              });
                            },
                            child: const Icon(Icons.clear),
                          );

                          if (picker.value == null) {
                            suffix = const Icon(Icons.calendar_today);
                          }

                          return ReactiveTextField(
                            onTap: () {
                              if (_focusNode.canRequestFocus) {
                                _focusNode.unfocus();
                                picker.showPicker();
                              }
                            },
                            valueAccessor: DateTimeValueAccessor(
                              dateTimeFormat: DateFormat('dd MMM yyyy'),
                            ),
                            focusNode: _focusNode,
                            formControlName: 'date',
                            validationMessages: (f) => {
                              ValidationMessage.required:
                                  'This field is required'
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              suffixIcon: suffix,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ReactiveTimePicker(
                        formControlName: 'time',
                        builder: (context, picker, child) {
                          Widget suffix = InkWell(
                            onTap: () {
                              _focusNode1.unfocus();

                              // Disable text field's focus node request
                              _focusNode1.canRequestFocus = false;

                              // Clear field value
                              picker.control.value = null;
                              //Enable the text field's focus node request after
                              // some delay
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                _focusNode1.canRequestFocus = true;
                              });
                            },
                            child: const Icon(Icons.clear),
                          );

                          if (picker.value == null) {
                            suffix = const Icon(Icons.calendar_today);
                          }

                          return ReactiveTextField(
                            onTap: () {
                              if (_focusNode1.canRequestFocus) {
                                _focusNode1.unfocus();
                                picker.showPicker();
                              }
                            },
                            valueAccessor: TimeOfDayValueAccessor(),
                            focusNode: _focusNode1,
                            formControlName: 'time',
                            validationMessages: (f) => {
                              ValidationMessage.required:
                                  'This field is required'
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Time',
                              suffixIcon: suffix,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            if (form.invalid) {
                              form.markAllAsTouched();
                              return;
                            }
                            setState(() => _loading = true);
                            final ref =
                                FirebaseFirestore.instance.collection('eggs');
                            ref.add(form.value).then((value) {
                              form.reset();
                              setState(() => _loading = false);
                              CustomSnackBar.snackBar(context,
                                  text: 'Egg collection has been saved',
                                  message: Message.success);
                            });
                          },
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                              : const Text('FINISH UP'))
                    ],
                  ),
                );
              }),
        ));
  }
}
