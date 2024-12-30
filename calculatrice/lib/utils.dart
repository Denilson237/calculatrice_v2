

import 'package:flutter/material.dart';

Widget text(_operationsScrollController, operationstext,_solutionsScrollController,solutionstext, util, marges){
  return Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(left:marges, right: marges, bottom: 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.bottomRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _operationsScrollController,
                        child: Text(
                          operationstext,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _solutionsScrollController,
                        child: Text(
                          solutionstext,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: util <= 8 ? 55 : 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
}

String misenforme(equationt) {
    if (equationt.contains("^(1/2)")) {
      var equat = equationt.split("^(1/2)").first;
      equationt = "²√$equat";
    } else if (equationt.contains("^(1/3)")) {
      var equat = equationt.split("^(1/3)").first;
      equationt = "³√$equat";
    } else if (equationt.contains("^(1/4)")) {
      var equat = equationt.split("^(1/4)").first;
      equationt = "⁴√$equat";
    }
    equationt = equationt.replaceAll("*", "x");
    equationt = equationt.replaceAll("/", "÷");
    equationt = equationt.replaceAll(".", ",");
    equationt = equationt.replaceAll("(1÷ln(2)) x ln(", "log₂(");
    equationt = equationt.replaceAll("(1÷ln(10)) x ln(", "log₁₀(");
    equationt = equationt.replaceAll("3,141592653589793", "π");
    equationt = equationt.replaceAll("((π÷180) x ", "rad(");
    equationt = equationt.replaceAll("((180÷π) x ", "deg(");
    equationt = equationt.replaceAll("^2", "²");
    equationt = equationt.replaceAll("^3", "³");
    equationt = equationt.replaceAll("sqrt", "²√");
    return equationt;
  }
  