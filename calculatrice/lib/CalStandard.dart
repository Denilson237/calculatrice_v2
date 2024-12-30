import 'dart:math';
import 'package:calculatrice/riverpod.dart';
import 'package:calculatrice/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';

class Calstandard extends ConsumerStatefulWidget {
  const Calstandard({super.key});

  @override
  CalstandardState createState() => CalstandardState();
}

class CalstandardState extends ConsumerState<Calstandard> {
  final TextEditingController operations = TextEditingController();
  final TextEditingController solutions = TextEditingController();
  final String defaultValue = "0";
  
  String equation = "0";
  late ScrollController _operationsScrollController;
  late ScrollController _solutionsScrollController;
  dynamic result = 0.0;
  String data1 = "";
  String data2 = '';

  @override
  void initState() {
    super.initState();
    solutions.text = defaultValue;
    _operationsScrollController = ScrollController();
    _solutionsScrollController = ScrollController();
    operations.addListener(_scrollToEndOp);
    solutions.addListener(_scrollToEndSol);
  }

  @override
  void dispose() {
    operations.dispose();
    solutions.dispose();
    _operationsScrollController.dispose();
    _solutionsScrollController.dispose();
    super.dispose();
  }

  void _scrollToEndOp() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _operationsScrollController
          .jumpTo(_operationsScrollController.position.maxScrollExtent);
    });
  }

  void _scrollToEndSol() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _solutionsScrollController
          .jumpTo(_solutionsScrollController.position.maxScrollExtent);
    });
  }

  String lastChar = "";
  List<String> operations3 = ["(",")","^","10^x","2ˣ","D","㏑","log₂","log₁₀","n!","rad","deg","x⁻¹","x²","x³","asin","acos","atan","²√","³√","⁴√","sinh","cosh","tanh","e","e^x","π","sin","cos","tan"];
  List<String> operation1 = ["","⁺/₋",'%','÷',"7", "8","9","x","4","5","6","-","1","2","3","+","wig","0",",","="];
  List<String> operationStanOper = ["7","8","9","", '÷', "4", "5", "6","⁺/₋","x", "1", "2","3","%", "-", "wig", "0",",","=","+"];
  String effacement = "AC";
  @override
  Widget build(BuildContext context) {
    
    final position = ref.watch(positions);
    final exSolution = ref.watch(exsol);
    final exOperation = ref.watch(exopra);
    Orientation orientation = MediaQuery.of(context).orientation;
    print(orientation);
    var marges = orientation == Orientation.landscape? 64.0:10.0; 
    int util = orientation == Orientation.landscape? 10 : solutions.text.length; 
    exSolution.isNotEmpty
        ? equation = result = solutions.text = exSolution
        : "";
    exOperation.isNotEmpty ? operations.text = exOperation : "";

    if (equation.length > 1) {
      effacement = "⌫";
    }
    if (equation == result) {
      effacement = "AC";
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(3),
        margin:  EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            text(_operationsScrollController, operations.text,_solutionsScrollController,solutions.text, util, marges),
           
           !position && orientation == Orientation.portrait? scientifique(exOperation, exSolution, orientation) : SizedBox(),
            (position || !position)&& orientation == Orientation.portrait?standard(position, exOperation, exSolution): SizedBox(),
           !position && orientation == Orientation.landscape? scientHorizontal(position, exOperation, exSolution, orientation): SizedBox(),
           position && orientation == Orientation.landscape? standHorizontal(position, exOperation, exSolution): SizedBox(),
          ],
        ),
      ),
    );
  }
  
   Widget scientHorizontal(position, exOperation, exSolution, orientation){

    return Expanded(
      flex: 5,
      child: Container(
        margin: EdgeInsets.only(left: 64,right: 64),
        child: Row(
          children: [
            scientifique(exOperation, exSolution, orientation),
            standard(position, exOperation, exSolution),
            
          ],
        ),
      ),
    );
  }
  Widget standHorizontal(position, exOperation, exSolution){

    return Expanded(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(left: 64, right: 64),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: !position ? 1.6 : 2.9),
                  itemCount: operationStanOper.length,
                  itemBuilder: (context, i) {
                    var texte = operationStanOper[i];
                    late Color color;
                    [0, 1,10,11, 2,6,5,7,10,12,15,16,17].contains(i)
                        ? color = Colors.grey[850]!
                        : [3,8,13].contains(i)
                            ? color = Colors.grey[700]!
                            : color = Colors.amber[700]!;
                
                    return InkWell(
                      child: Card(
                          color: color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          child: i == 15
                              ? Center(child: popup(position))
                              : Center(
                                  child: Text(
                                    i == 3 ? texte = effacement : texte,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                )),
                      onTap: () {
                        i != 15
                            ? setState(() {
                                boutons(texte, exOperation, exSolution);
                              })
                            : popup(position);
                      },
                      onLongPress: () {
                        i == 3
                            ? setState(() {
                                boutons("AC", exOperation, exSolution);
                              })
                            : "";
                      },
                    );
                  },
                ),
              ),
            );
  }

  Widget standard(position, exOperation, exSolution){
    return Expanded(
              flex: 4,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: !position ? 1.6 : 1.04),
                itemCount: operation1.length,
                itemBuilder: (context, i) {
                  var texte = operation1[i];
                  late Color color;
                  [0, 1, 2].contains(i)
                      ? color = Colors.grey[700]!
                      : [3, 7, 11, 15, 19].contains(i)
                          ? color = Colors.amber[700]!
                          : color = Colors.grey[850]!;

                  return InkWell(
                    child: Card(
                        color: color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        child: i == 16
                            ? Center(child: popup(position))
                            : Center(
                                child: Text(
                                  i == 0 ? texte = effacement : texte,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: !position ? 18 : 28,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              )),
                    onTap: () {
                      i != 16
                          ? setState(() {
                              boutons(texte, exOperation, exSolution);
                            })
                          : popup(position);
                    },
                    onLongPress: () {
                      i == 0
                          ? setState(() {
                              boutons("AC", exOperation, exSolution);
                            })
                          : "";
                    },
                  );
                },
              ),
            );
  }
  Widget scientifique(exOperation, exSolution, orientation){
    return Expanded(
                    flex:orientation == Orientation.landscape ?  6:3,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6, childAspectRatio:  orientation == Orientation.landscape ? 1.6 : 1.275),//1.275),
                      itemCount: operations3.length,
                      itemBuilder: (context, j) {
                        var texte2 = operations3[j];

                        return InkWell(
                          child: Card(
                              color: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: Center(
                                child: Text(
                                  texte2,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              )),
                          onTap: () {
                            setState(() {
                              boutons(texte2, exSolution, exOperation);
                            });
                          },
                        );
                      },
                    ));
                    
  }


  void _handleMenuSelection(bool result) {
     ref.read(positions.notifier).state = result;
  }

  Widget popup(bool position) {
    Color color;
    Color color2;
    position
        ? {color = Colors.orange[600]!, color2 = Colors.white}
        : {color = Colors.white, color2 = Colors.orange[600]!};
    return PopupMenuButton<bool>(
        onSelected: _handleMenuSelection,
        shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
        color: Colors.grey[900],
        icon: const Icon(Icons.grid_on, color: Colors.white, size: 27),
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: true,
                  child: Row(
                    children: [
                      Icon(
                        Icons.calculate,
                        color: color,
                      ),
                      Text("   Élémentaire",
                          style: TextStyle(color: color, fontSize: 16))
                    ],
                  )),
              PopupMenuItem(
                  value: false,
                  child: Row(
                    children: [
                      Icon(
                        Icons.functions,
                        color: color2,
                      ),
                      Text(
                        "   Scientifique",
                        style: TextStyle(color: color2, fontSize: 16),
                      )
                    ],
                  ))
            ]);
  }

  

  formatage(val) {
    if (val.length > 12) {
      var p = double.parse(val).toStringAsExponential(8);
      p = p.replaceFirst(RegExp(r"0+e"), "e");
      p = p.replaceFirst(RegExp(r"\.e"), "e");
      solutions.text = data1 = misenforme(p);
    } else {
      solutions.text = data1 = misenforme(result);
    }
  }

  calcul() {
    if (equation.contains("³√")) {
      var equat = equation.split("³√").last;
      equation = "$equat)^(1/3)";
    } else if (equation.contains("⁴√")) {
      var equat = equation.split("⁴√")[1];
      equation = "$equat)^(1/4)";
    }
    equation = equation.replaceAll("²√", "sqrt");
    equation = equation.replaceAll("x", "*");
    equation = equation.replaceAll("÷", "/");
    equation = equation.replaceAll(",", ".");
    equation = equation.replaceAll("log₂(", "(1/ln(2)) * ln(");
    equation = equation.replaceAll("log₁₀(", "(1/ln(10)) * ln(");
    equation = equation.replaceAll("rad(", "((π/180) * ");
    equation = equation.replaceAll("deg(", "((180/π) * ");
    equation = equation.replaceAll("π", "3.141592653589793");
    equation = equation.replaceAll("²", "^2");
    equation = equation.replaceAll("³", "^3");

    var pOuvert = 0;
    var pFermer = 0;

    for (var i = 0; i < equation.length; i++) {
      if (equation[i] == "(") {
        pOuvert++;
      } else if (equation[i] == ")") {
        pFermer++;
      }
    }

    if ((pFermer < pOuvert)) {
      var cg = pOuvert - pFermer;

      var p = ")" * cg;
      equation = equation + p;
    }

    try {
      final parser = Parser();
      final expression = parser.parse(equation);
      final context = ContextModel();
      result = '${expression.evaluate(EvaluationType.REAL, context)}';

      if (result.split("").last == "0" && result[result.length - 2] == ".") {
        result = result.substring(0, result.length - 2);
        operations.text = data2 = misenforme(equation);
        equation = result;

        formatage(result);
      } else if (result.contains(".") && !result.contains("e")) {
        operations.text = data2 = misenforme(equation);
        equation = result;
        var result1 = result.length > 12 ? result.substring(0, 12) : result;
        result1 = double.parse(result1).toStringAsFixed(8);
        result1 = double.parse(result1).toString();

        if (result1.split("").last == "0" &&
            result1[result1.length - 2] == ".") {
          result1 = result1.substring(0, result1.length - 2);
        }
        solutions.text = data1 = misenforme(result1);
      } else if (result.contains("e")) {
        operations.text = data2 = misenforme(equation);
        equation = result.replaceAll("e+", "*10^");

        if (result.contains(".") && result.length > 14) {
          var redt = '${result.substring(0, 8)}e${result.split("e")[1]}';
          solutions.text = data1 = misenforme(redt);
        } else {
          solutions.text = data1 = misenforme(result);
        }
      } else {
        operations.text = data2 = misenforme(equation);
        equation = defaultValue;
        formatage(result);
      }
      /////////////////////////////////////////////////////////////////////////// enregistement ////////////////////////////////
      enregistrer({"operations": data2, "solutions": data1, "chek": false});
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    } catch (e) {
      result = "error";
      operations.text = misenforme(equation);
      equation = defaultValue;
      solutions.text = misenforme(result);
      return solutions.text;
    }
  }

  void boutons(String text, exSolution, exOperation) {
    exSolution.isNotEmpty ? ref.read(exopra.notifier).state = "" : "";
    exOperation.isNotEmpty ? ref.read(exsol.notifier).state = "" : "";
    text = equation != "0" &&
            (num.tryParse(equation.split("").last) != null ||
                ["³", "²", "π", "!", ")"].contains(equation.split("").last))
        ? text.replaceAll("(", "x(")
        : text;
    text = text.replaceAll("㏑", "ln(");
    text = text.replaceAll("log₂", "log₂(");
    text = text.replaceAll("log₁₀", "log₁₀(");
    text = text.replaceAll("n!", "!");
    text = text.replaceAll("rad", "rad(");
    text = text.replaceAll("deg", "deg(");
    text = text.replaceAll("x⁻¹", "1÷(");
    text = text.replaceAll("x²", "²");
    text = text.replaceAll("x³", "³");
    text = text.replaceAll("²√", "²√(");
    text = text.replaceAll("³√", "³√(");
    text = text.replaceAll("⁴√", "⁴√(");
    text = text.replaceAll("e^x", "e^(");

    operations.text = "";
    if (text == "AC" || (text == "⌫" && result == equation)) {
      equation = defaultValue;
      solutions.text = misenforme(equation);
      operations.text = "";
      result = 0.0;
    } else if (text == "⌫") {
      if (["s", "n", "d", "g"].contains(equation.split("").last) &&
          equation[equation.length - 2] != "l") {
        equation = equation.substring(0, equation.length - 3);
      } else if (equation.split("").last == "n" &&
          equation[equation.length - 2] == "l") {
        equation = equation.substring(0, equation.length - 2);
      } else if (equation.split("").last == "₂") {
        equation = equation.substring(0, equation.length - 4);
      } else if (equation.split("").last == "₀") {
        equation = equation.substring(0, equation.length - 5);
      } else {
        equation = equation.substring(0, equation.length - 1);
      }

      if (equation.isEmpty) {
        equation = defaultValue;
        operations.text = "";
        result = 0.0;
      }
      solutions.text = misenforme(equation);
    } else if (text == "⁺/₋") {
      if (equation != "0") {
        equation = "(-$equation)";
        solutions.text = equation;
      }
    } else if (text == "%") {
      equation = "($equation/100)";
      solutions.text = equation;
    } else if (text == "10^x") {
      equation = "10^($equation)";
      solutions.text = equation;
    } else if (text == "2ˣ") {
      equation = "2^($equation)";
      solutions.text = equation;
    } else if (text == "ln(" && equation != "0") {
      equation = "ln($equation)";
      solutions.text = equation;
    } else if (text == "log₂(" && equation != "0") {
      equation = "log₂($equation)";
      solutions.text = equation;
    } else if (text == "log₁₀(" && equation != "0") {
      equation = "log₁₀($equation)";
      solutions.text = equation;
    } else if (text == "rad(" && equation != "0") {
      equation = "rad($equation)";
      solutions.text = equation;
    } else if (text == "deg(" && equation != "0") {
      equation = "deg($equation)";
      solutions.text = equation;
    } else if (text == "D") {
      equation = "0";
      operations.text = "Hello World !";
      solutions.text = "My name is Denilson";
    } else if (text == "²√(") {
      equation = "($equation)^(1/2)";
      calcul();
    } else if (text == "³√(" ) {
      equation = "($equation)^(1/3)";
      calcul();
    } else if (text == "⁴√(" ) {
      equation = "($equation)^(1/4)";
      calcul();
    } else if (text == "e^(" && equation != "0") {
      equation = "e^($equation)";
      calcul();
    } else if (text == "e") {
      if (equation == '0') {
        equation = "(e^1)";
      } else if (num.tryParse(equation.split("").last) != null &&
              equation != '0' ||
          [")", "²", "³", "!", "π"].contains(equation.split("").last)) {
        equation += "*(e^1)";
      } else if ([","].contains(equation.split("").last)) {
        operations.text = "problème de syntaxe";
      } else {
        equation += "(e^1)";
      }
      solutions.text = misenforme(equation);
    } else if (text == "sin") {
      equation = "sin($equation)";
      solutions.text = equation;
    } else if (text == "cos") {
      equation = "cos($equation)";
      solutions.text = equation;
    } else if (text == "tan") {
      equation = 'tan($equation)';
      solutions.text = equation;
    } else if (text == "asin") {
      operations.text = "asin($equation)";
      equation = asin(double.parse(equation)).toString();
      solutions.text = equation;
      result = equation = equation == "NaN" ? defaultValue : equation;
    } else if (text == "acos") {
      operations.text = "acos($equation)";
      equation = acos(double.parse(equation)).toString();
      solutions.text = equation;
      result = equation = equation == "NaN" ? defaultValue : equation;
    } else if (text == "atan") {
      operations.text = "atan($equation)";
      equation = atan(double.parse(equation)).toString();
      solutions.text = equation;
      result = equation = equation == "NaN" ? defaultValue : equation;
    } else if (text == "sinh") {
      equation = '(e^($equation)-e^(-$equation))/2';
      calcul();
    } else if (text == "cosh") {
      equation = '(e^($equation)+e^(-$equation))/2';
      calcul();
    } else if (text == "tanh") {
      equation =
          '(e^($equation)-e^(-$equation))/(e^($equation)+e^(-$equation))';
      calcul();
    } else if (text == "1÷(" && equation != "0") {
      equation = "1÷($equation)";
      solutions.text = misenforme(equation);
    } else if (text == "=") {
      if (["("].contains(equation.split("").last)) {
        equation = equation.substring(0, equation.length - 1);
      }
      if (["-", '+', "÷", "x"].contains(equation.split("").last)) {
        equation = equation.substring(0, equation.length - 1);
      }
      if (num.tryParse(equation) != null) {
        return;
      } else {
        calcul();
      }
    } else if (result == equation &&
        !["-", "+", "x", "÷", "^", "²", "!", "x(", "³"].contains(text)) {
      if (text == ",") {
        solutions.text = equation = "0,";
      } else {
        solutions.text = equation = text;
        result = 0.0;
      }
    } else {
      if (equation == "0" &&
          ![",", "x", "÷", "+", "²", "³", "^", "!", ")"].contains(text)) {
        solutions.text = equation = text;
      } else if (equation == "0" && (["x", "÷", "+"].contains(text))) {
        return;
      } else if (num.tryParse(equation.split("").last) == null &&
          text == "," &&
          equation.split("").last != ",") {
        if (["³", "²", "!"].contains(equation.split("").last)) {
          return;
        }
        equation += "0,";
        solutions.text = equation;
      } else if (["³", "²"].contains(text) &&
          (equation.split("").last != "π" &&
                  equation.split("").last != ")" &&
                  num.tryParse(equation.split("").last) == null ||
              ["³", "²"].contains(equation.split("").last))) {
        operations.text = "syntaxe";
        return;
      } else if (text == "^" &&
          (equation.split("").last != "π" &&
                  equation.split("").last != ")" &&
                  num.tryParse(equation.split("").last) == null ||
              equation.split("").last == "^")) {
        operations.text = "syntaxe";
        return;
      } else if (text == "!" &&
          (equation.split("").last != "π" &&
                  equation.split("").last != ")" &&
                  num.tryParse(equation.split("").last) == null ||
              equation.split("").last == "!")) {
        operations.text = "syntaxe";
      } else if (text == ")") {
        var count = 0;
        for (var i = 0; i < equation.length; i++) {
          if (equation[i] == "(") {
            count++;
          } else if (equation[i] == ")") {
            count--;
          }
        }
        if (count > 0 && equation[equation.length - 1] != "(") {
          equation += text;
          solutions.text = misenforme(equation);
        } else {
          operations.text = "syntaxe";
        }
      } else if (text == "π" &&
          (["π"].contains(equation.split("").last) ||
              num.tryParse(equation.split("").last) != null)) {
        equation += "*π";
        solutions.text = misenforme(equation);
      } else if (["x(", "(", "x", "+", "!", "÷", "^"].contains(text) &&
          ["("].contains(equation.split("").last)) {
        operations.text = "syntaxe";
        return;
      } else if (["x", "÷"].contains(equation.split("").last) &&
          ["-"].contains(text)) {
        solutions.text = equation += text;
        return;
      } else if (equation.contains(",") &&
          text == "," &&
          equation.split("").last != ",") {
        var t = equation;
        var equa = "";
        List symb = ["+", "-", "x", "÷"];
        for (var i in symb) {
          if (t.contains(i)) {
            t = t.split(i).last;
          }
          if (!t.contains(",") && !t.contains("i")) {
            equa = t;
          }
        }
        if (equa == "") {
          return;
        } else {
          equation += text;
          solutions.text = equation;
        }
      } else if (["-", "+", "x", "÷", ",", "^"]
              .contains(equation.split("").last) &&
          [",", "+", "-", "x", "÷", "^"].contains(text)) {
        if (equation != "-") {
          if (["+", "x", "÷"].contains(equation[equation.length - 2]) &&
              equation[equation.length - 1] == "-") {
            return;
          }
        }
        if (["+", "x", "÷"].contains(text) && equation == "-") {
          return;
        } else {
          equation =
              equation.replaceRange(equation.length - 1, equation.length, text);
          solutions.text = equation;
        }
      } else if (num.tryParse(text) != null &&
          [")", "!", "π"].contains(equation.split("").last)) {
        equation += '*$text';
        solutions.text = misenforme(equation);
      } else {
        equation += text;
        solutions.text = misenforme(equation);
      }
    }
  }

  enregistrer(newdata) async {
    ref.read(obtenir).enregistrer(newdata);
  }
}
