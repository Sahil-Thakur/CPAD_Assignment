import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'employee_login_screen.dart';

class EmployeeDetails extends ParseObject implements ParseCloneable {
  static const String keyTableName = 'employeeRecord';

  EmployeeDetails() : super(keyTableName);
  EmployeeDetails.clone() : this();

  @override
  EmployeeDetails clone(Map<String, dynamic> map) => EmployeeDetails.clone()..fromJson(map);

  String get employeeName => get<String>('fullName') ?? '';
  String get employeeMobileNumber => get<String>('mNumber') ?? '';
  String get employeeEmailID => get<String>('eID') ?? '';
  String get employeeRole => get<String>('role') ?? '';
  String get id => objectId ?? '';

  set employeeName(String value) => set<String>('fullName', value);
  set employeeMobileNumber(String value) => set<String>('mNumber', value);
  set employeeEmailID(String value) => set<String>('eID', value);
  set employeeRole(String value) => set<String>('role', value);

  Future<bool> createEmployee() async => (await save()).success;
  Future<bool> updateEmployee() async => (await save()).success;
  Future<bool> deleteEmployee() async => (await delete()).success;

  static Future<List<EmployeeDetails>> getEmployees() async {
    final query = QueryBuilder<ParseObject>(EmployeeDetails());
    final response = await query.query();
    if (response.success && response.results != null) {
      return response.results!
          .map((e) => EmployeeDetails.clone()..fromJson((e as ParseObject).toJson()))
          .toList();
    } else {
      return [];
    }
  }
}

class EmployeeApp extends StatelessWidget {
  const EmployeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Records',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ),
      home: const EmployeeHomeScreen(),
    );
  }
}

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => EmployeeHomeScreenState();
}

class EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  final key = GlobalKey<FormState>();
  final employeeNameController = TextEditingController();
  final employeeEmailIDController = TextEditingController();
  final employeeMobileNumberController = TextEditingController();
  final employeeRoleController = TextEditingController();

  bool busy = false;
  bool isEditMode = false;
  EmployeeDetails? selectedEmployee;
  List<EmployeeDetails> employeeList = [];

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    final employees = await EmployeeDetails.getEmployees();
    setState(() => employeeList = employees);
  }

  void fillForm(EmployeeDetails employee) {
    setState(() {
      isEditMode = true;
      selectedEmployee = employee;
      employeeNameController.text = employee.employeeName;
      employeeEmailIDController.text = employee.employeeEmailID;
      employeeMobileNumberController.text = employee.employeeMobileNumber;
      employeeRoleController.text = employee.employeeRole;
    });
  }

  void resetForm() {
    FocusScope.of(context).unfocus(); // remove cursor
    setState(() {
      isEditMode = false;
      selectedEmployee = null;
      employeeNameController.clear();
      employeeEmailIDController.clear();
      employeeMobileNumberController.clear();
      employeeRoleController.clear();
    });
  }

  Future<void> deleteEmployee(EmployeeDetails employee) async {
    setState(() => busy = true);
    try {
      final success = await employee.deleteEmployee();
      if (success) {
        resetForm();
        loadEmployees();
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> addEmployee() async {
    if (key.currentState!.validate()) {
      setState(() => busy = true);
      try {
        final newEmployee = EmployeeDetails()
          ..employeeName = employeeNameController.text
          ..employeeEmailID = employeeEmailIDController.text
          ..employeeMobileNumber = employeeMobileNumberController.text
          ..employeeRole = employeeRoleController.text;

        final success = await newEmployee.createEmployee();
        if (success) {
          resetForm();
          loadEmployees();
        }
      } finally {
        if (mounted) setState(() => busy = false);
      }
    }
  }

  Future<void> updateEmployee() async {
    if (key.currentState!.validate() && selectedEmployee != null) {
      setState(() => busy = true);
      try {
        selectedEmployee!
          ..employeeName = employeeNameController.text
          ..employeeEmailID = employeeEmailIDController.text
          ..employeeMobileNumber = employeeMobileNumberController.text
          ..employeeRole = employeeRoleController.text;

        final success = await selectedEmployee!.updateEmployee();
        if (success) {
          resetForm();
          loadEmployees();
        }
      } finally {
        if (mounted) setState(() => busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Employee Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployeeLoginScreen(),
                ),
              );            },
          )
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (isEditMode) {
            resetForm();
          }
          return false;
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: employeeList.length,
                itemBuilder: (context, index) {
                  final employee = employeeList[index];
                  return ListTile(
                    title: Text(employee.employeeName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Role: ${employee.employeeRole}'),
                        Text('Mobile: ${employee.employeeMobileNumber}'),
                        Text('Email: ${employee.employeeEmailID}'),
                      ],
                    ),
                    onTap: () {
                      if (isEditMode) {
                        resetForm();
                      }
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => fillForm(employee),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteEmployee(employee),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 450),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Form(
                  key: key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildTextField(
                        controller: employeeNameController,
                        label: 'Name',
                        icon: Icons.person,
                        validatorMsg: 'Enter name',
                      ),
                      const SizedBox(height: 8),
                      buildTextField(
                        controller: employeeMobileNumberController,
                        label: 'Mobile Number',
                        icon: Icons.phone,
                        validatorMsg: 'Enter mobile number',
                      ),
                      const SizedBox(height: 8),
                      buildTextField(
                        controller: employeeEmailIDController,
                        label: 'Email',
                        icon: Icons.email,
                        validatorMsg: 'Enter valid email',
                        emailValidation: true,
                      ),
                      const SizedBox(height: 8),
                      buildTextField(
                        controller: employeeRoleController,
                        label: 'Role',
                        icon: Icons.work,
                        validatorMsg: 'Enter role',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: busy || isEditMode ? null : addEmployee,
                              child: const Text('Add'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: busy || !isEditMode ? null : updateEmployee,
                              child: const Text('Update'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorMsg,
    bool emailValidation = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return validatorMsg;
        if (emailValidation && !value.contains('@')) return 'Enter valid email';
        return null;
      },
    );
  }

  @override
  void dispose() {
    employeeNameController.dispose();
    employeeEmailIDController.dispose();
    employeeMobileNumberController.dispose();
    employeeRoleController.dispose();
    super.dispose();
  }
}
