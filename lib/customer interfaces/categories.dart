import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graduation_project/components/text%20form.dart';
import 'package:graduation_project/customer%20interfaces/show%20profissional.dart';
import 'package:graduation_project/providers/category_provider.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _Categories();
}

class _Categories extends State<Categories> {
  @override
  void initState() {
    // لمنع تحديث حالة الشاشة بينما لا تزال في مرحلة البناء
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categorypro = context.watch<CategoryProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        automaticallyImplyLeading: false,
        centerTitle: true,
        shadowColor: Colors.black,
        toolbarHeight: 60,
        title: TextForm(
          text: "فئات الخدمة",
          size: 43,
          weight: FontWeight.bold,
          color: Colors.blue[900],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.all(15),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_forward_outlined),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: categorypro.isLoading
          ? Center(child: CircularProgressIndicator())
          : categorypro.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextForm(
                    text: categorypro.errorMessage!,
                    size: 22,
                    color: Colors.red,
                  ),
                  Gap(10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoryProvider>().loadCategories();
                    },
                    child: TextForm(text: "اعادة المحاولة"),
                  ),
                ],
              ),
            )
          : categorypro.categories.isEmpty
          ? Center(child: Text("لا توجد فئات متاحة حالياً"))
          : Padding(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: categorypro.categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  final category = categorypro.categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShowProfessionals(category: category.name),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      color: Colors.white,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: TextForm(
                            text: category.name,
                            align: TextAlign.center,
                            weight: FontWeight.w600,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
