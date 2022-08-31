import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/drug.dart';
import '../models/supplier.dart';
import '../notification_service.dart';
import '../utils.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/select_supplier.dart';

class NewDrug extends StatefulWidget {
  const NewDrug({Key? key}) : super(key: key);

  @override
  State<NewDrug> createState() => _NewDrugState();
}

class _NewDrugState extends State<NewDrug> {
  FormGroup get buildForm => fb.group({
        'type': FormControl<String>(validators: [Validators.required]),
        'quantity': FormControl<int>(
            validators: [Validators.number, Validators.required]),
        'date': FormControl<DateTime>(
            value: DateTime.now(), validators: [Validators.required])
      });

  late FocusNode _focusNode;
  bool _loading = false;
  Supplier? _supplier;
  final _controller = TextEditingController();

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
          title: const Text('Add drug'),
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
                            const InputDecoration(labelText: 'Drug type'),
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
                      TextFormField(
                        onTap: () async {
                          final supplier = await Navigator.push<Supplier>(
                              context,
                              MaterialPageRoute<Supplier>(
                                  builder: (ctx) => SelectSupplier()));
                          _controller.text = supplier?.name ?? '';
                          setState(() => _supplier = supplier);
                        },
                        readOnly: true,
                        controller: _controller,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if ((v ?? '').isEmpty || _supplier == null) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Supplier',
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
                            if (form.invalid || _supplier == null) {
                              form.markAllAsTouched();
                              CustomSnackBar.snackBar(context,
                                  text: 'Please fill all fields',
                                  message: Message.success);
                              return;
                            }
                            setState(() => _loading = true);
                            final drug = Drug(
                                type: form
                                    .control('type')
                                    .value
                                    .toString()
                                    .capitalize(),
                                supplier: _supplier!,
                                quantity: int.parse(
                                    form.control('quantity').value.toString()),
                                date: Timestamp.fromDate(
                                    form.control('date').value as DateTime));

                            final id = Random().nextInt(200000);
                            final ref =
                                FirebaseFirestore.instance.collection('drugs');
                            ref.add(drug.toMap()).then((value) {
                              NotificationService().notify(
                                  'Medication Time',
                                  '''You have a ${drug.type} medication to give today. 
                                  Administer the drug to ensure a healthy farm :)''',
                                  id: id,
                                  time: 2628288, // Schedule for a month
                                  channel: 'drug_channel');
                              form.reset();
                              _supplier = null;
                              setState(() => _loading = false);
                              CustomSnackBar.snackBar(context,
                                  text: 'Drug has been added successfully',
                                  message: Message.success);
                              setState(() => _loading = false);
                            }).catchError((Object err) {
                              setState(() => _loading = false);
                            });
                          },
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                              : const Text('SUBMIT DRUG'))
                    ],
                  ),
                );
              }),
        ));
  }
}
