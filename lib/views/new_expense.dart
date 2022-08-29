import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../widgets/custom_snackbar.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({Key? key}) : super(key: key);

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  FormGroup get buildForm => fb.group({
        'type': FormControl<String>(validators: [Validators.required]),
        'quantity': FormControl<int>(
            validators: [Validators.number, Validators.required]),
        'unitCost': FormControl<double>(validators: [
          Validators.required,
          Validators.pattern(RegExp(r'[+-]?([0-9]*[.])?[0-9]+$'))
        ]),
        'date': FormControl<DateTime>(
            value: DateTime.now(), validators: [Validators.required])
      });

  late FocusNode _focusNode;
  bool _loading = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Record expenditure'),
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
                      ReactiveTextField<String>(
                        formControlName: 'type',
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        decoration:
                            const InputDecoration(labelText: 'Expense type'),
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReactiveTextField<int>(
                        formControlName: 'quantity',
                        decoration:
                            const InputDecoration(labelText: 'Quantity'),
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
                      ReactiveTextField(
                        formControlName: 'unitCost',
                        textInputAction: TextInputAction.next,
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                          ValidationMessage.pattern: 'Must be a number',
                        },
                        decoration: const InputDecoration(
                          labelText: 'Unit cost',
                        ),
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
                      OutlinedButton(
                          onPressed: () {
                            if (form.invalid) {
                              form.markAllAsTouched();
                              return;
                            }
                            setState(() => _loading = true);
                            final ref = FirebaseFirestore.instance
                                .collection('expenses');
                            ref.add(form.value).then((value) {
                              form.reset();
                              setState(() => _loading = false);
                              CustomSnackBar.snackBar(context,
                                  text:
                                      'Expense has been successfully recorded',
                                  message: Message.success);
                            });
                          },
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                              : const Text('ADD EXPENSE'))
                    ],
                  ),
                );
              }),
        ));
  }

  Map<String, dynamic>? doubleNum(AbstractControl<dynamic> control) {
    final numberRegex = RegExp(r'[+-]?([0-9]*[.])?[0-9]+$');
    if (control.isNull || !numberRegex.hasMatch(control.value.toString())) {
      return <String, dynamic>{'double': true};
    }
    return null;
  }
}
