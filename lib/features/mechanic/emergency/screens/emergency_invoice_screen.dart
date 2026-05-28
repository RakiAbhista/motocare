import 'package:flutter/material.dart';
import '../widgets/invoice/invoice_customer_info.dart';
import '../widgets/invoice/invoice_vehicle_details.dart';
import '../widgets/invoice/invoice_service_list.dart';
import '../widgets/invoice/invoice_action_buttons.dart';

class EmergencyInvoiceScreen extends StatelessWidget {
  const EmergencyInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF181C20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Emergency',
          style: TextStyle(
            color: Color(0xFF181C20),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InvoiceCustomerInfo(),
            SizedBox(height: 24),
            InvoiceVehicleDetails(),
            SizedBox(height: 32),
            InvoiceServiceList(),
            SizedBox(height: 32),
            InvoiceActionButtons(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

