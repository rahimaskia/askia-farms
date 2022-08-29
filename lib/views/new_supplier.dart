import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../widgets/custom_snackbar.dart';

class NewSupplier extends StatefulWidget {
  const NewSupplier({Key? key}) : super(key: key);

  @override
  State<NewSupplier> createState() => _NewSupplierState();
}

class _NewSupplierState extends State<NewSupplier> {
  FormGroup get buildForm => fb.group({
        'name': ['', Validators.required],
        'address': fb.group({
          'country': ['Ghana', Validators.required],
          'city': ['', Validators.required],
          'state': ['', Validators.required],
          'line1': ['', Validators.required],
          'line2': [''],
        }),
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
          title: const Text('Create a supplier'),
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
                        formControlName: 'name',
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration:
                            const InputDecoration(labelText: 'Supplier name'),
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'address.state',
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(labelText: 'Region'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'address.city',
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(labelText: 'Town'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'address.line1',
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                            labelText: 'Line 1 (Street, house no. etc)'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.streetAddress,
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'address.line2',
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(labelText: 'Line 2'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.streetAddress,
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
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
                                .collection('suppliers');
                            ref.add(form.value).then((value) {
                              form.reset();
                              setState(() => _loading = false);
                              CustomSnackBar.snackBar(context,
                                  text: 'Supplier has been created',
                                  message: Message.success);
                            });
                          },
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                              : const Text('ADD SUPPLIER'))
                    ],
                  ),
                );
              }),
        ));
  }
}
