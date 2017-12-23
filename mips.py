import os
from assembler import assembler_checker
from error import error_handler
from PyQt5 import QtCore, QtGui, QtWidgets

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(800, 584)
        MainWindow.setStyleSheet("\n"
"  background-color: #282c35\n"
"")
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        
        
        
        
        
        
        self.textEdit = QtWidgets.QTextEdit(self.centralwidget)
        self.textEdit.setGeometry(QtCore.QRect(30, 100, 411, 301))
        self.textEdit.setStyleSheet("border: 1px solid #21242b;\n"
"  background-color: #1e2128;\n"
"color:#d4d8e1;\n"
"font-size: 14px;\n"
"font-weight:600;\n"
"padding-left: 10px;\n"
"padding-top: 5px;\n"
"line-height:1.8;")     
        self.textEdit.setObjectName("textEdit")
        
        
        
        
        
        
        
        self.textBrowser = QtWidgets.QTextBrowser(self.centralwidget)
        self.textBrowser.setGeometry(QtCore.QRect(30, 410, 411, 81))
        self.textBrowser.setStyleSheet("border: 1px solid #21242b;\n"
"  background-color: #1e2128;\n"
"color:#d4d8e1;\n"
"font-size: 12px;\n"
"font-weight:400;\n"
"padding-left: 10px;\n"
"padding-top: 20px;"
)    
        self.textBrowser.setObjectName("textBrowser")
        
        
        
        
        
        
        
        
        self.textBrowser_2 = QtWidgets.QTextBrowser(self.centralwidget)
        self.textBrowser_2.setGeometry(QtCore.QRect(450, 100, 321, 391))
        self.textBrowser_2.setStyleSheet("border: 1px solid #21242b;\n"
"  background-color: #1e2128;\n"
"color:#d4d8e1;\n"
"font-size: 14px;\n"
"font-weight:600;\n"
"padding-left: 10px;\n"
"padding-top: 5px;")
        self.textBrowser_2.setObjectName("textBrowser_2")
        
        
        
        
        
        self.pushButton = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton.clicked.connect(self.upload)
        self.pushButton.setGeometry(QtCore.QRect(30, 500, 111, 41))
        self.pushButton.setStyleSheet("background-color:#ab709c;\n"
"font: 75 14pt \"Myriad Hebrew\";\n"
"  border: 1px solid  #ab709c;\n"
"  cursor: pointer;\n"
"  color: #fff;\n"
" \n"
"  font-weight: 500;\n"
"font: 87 11pt \"Segoe UI Black\";\n"
"\n"
"")
            
            
            
            
            
        self.pushButton.setObjectName("pushButton")
        self.pushButton_2 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_2.clicked.connect(self.build)
        self.pushButton_2.setGeometry(QtCore.QRect(150, 500, 141, 41))
        self.pushButton_2.setStyleSheet("background-color: #619378;\n"
"  border: 1px solid #619378;\n"
"  cursor: pointer;\n"
"  color: #fff;\n"
"  font-size: 18px;\n"
"  font-weight: 500;\n"
"font: 87 13pt \"Segoe UI Black\";")   
        self.pushButton_2.setObjectName("pushButton_2")
        
        
        
        
        self.pushButton_3 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_3.clicked.connect(self.read_result)
        self.pushButton_3.setGeometry(QtCore.QRect(300, 500, 141, 41))
        self.pushButton_3.setStyleSheet("background-color: #619378;\n"
"  border: 1px solid #619378;\n"
"  cursor: pointer;\n"
"  color: #fff;\n"
"  font-size: 18px;\n"
"  font-weight: 500;\n"
"font: 87 13pt \"Segoe UI Black\";")
        self.pushButton_3.setObjectName("pushButton_3")
        
        
        
        
        
        self.label_3 = QtWidgets.QLabel(self.centralwidget)
        self.label_3.setGeometry(QtCore.QRect(570, 530, 221, 20))
        self.label_3.setStyleSheet("background-color: transparent;\n"
"color:#ccc;")
        self.label_3.setObjectName("label_3")
        
        
        
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(330, 20, 91, 41))
        self.label.setStyleSheet("  font-size: 40px;\n"
"  font-weight: 400;\n"
"color:#d4d8e1;\n"
"letter-spacing: 30px;\n"
"font: 35 36pt \"Khaled Font\";")
        self.label.setObjectName("label")
        
        
        
        
        self.label_2 = QtWidgets.QLabel(self.centralwidget)
        self.label_2.setGeometry(QtCore.QRect(240, 60, 101, 31))
        self.label_2.setStyleSheet("  font-size: 14px;\n"
"  font-weight: 600;\n"
"color:#d4d8e1;\n"
"letter-spacing: 30px;\n"
"font: 75 10pt \"Segoe Print\";")
        self.label_2.setObjectName("label_2")
        
        
        
        
        self.label_4 = QtWidgets.QLabel(self.centralwidget)
        self.label_4.setGeometry(QtCore.QRect(340, 60, 71, 31))
        self.label_4.setStyleSheet("  font-size: 14px;\n"
"  font-weight: 600;\n"
"color:#d4d8e1;\n"
"letter-spacing: 30px;\n"
"color:#ab709c;\n"
"font: 75 10pt \"Segoe Print\";")
        self.label_4.setObjectName("label_4")
        
        
        
        
        self.label_5 = QtWidgets.QLabel(self.centralwidget)
        self.label_5.setGeometry(QtCore.QRect(410, 60, 91, 31))
        self.label_5.setStyleSheet("  font-size: 14px;\n"
"  font-weight: 600;\n"
"color:#d4d8e1;\n"
"letter-spacing: 30px;\n"
"font: 75 10pt \"Segoe Print\";")
        self.label_5.setObjectName("label_5")
        
        
           
       
        
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 800, 21))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def upload(self):
         inputvalue = self.textEdit.toPlainText()
         output = open('input.txt','w')
         output.write(inputvalue)
         errorfile = open('error.txt','r+')
         errorfile.truncate()
         self.textBrowser.clear()
         self.textBrowser_2.clear()
         
    def build(self):
        error_handler()
        errorvalue = self.textBrowser
        error_file = open('error.txt','r')
        errors = error_file.readlines()
        i = 0
        while(i < len(errors)):
            errorvalue.append(errors[i]) 
            i = i+1
        assembler_checker(errors[0])    
            
    def read_result(self):
        resultvalue = self.textBrowser_2 
        result_file = open('show.txt','r')
        result = result_file.readlines()
        i = 0
        while(i < len(result)):
            resultvalue.append(result[i])  
            i = i+1

        

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "Mips"))
        self.pushButton.setText(_translate("MainWindow", "Upload"))
        self.pushButton_2.setText(_translate("MainWindow", "Build"))
        self.pushButton_3.setText(_translate("MainWindow", "Run"))
        self.label_3.setText(_translate("MainWindow", " Copyrights reserved to ghostbusters team"))
        self.label.setText(_translate("MainWindow", "MIPS"))
        self.label_2.setText(_translate("MainWindow", "a compiler for"))
        self.label_4.setText(_translate("MainWindow", "assembly"))
        self.label_5.setText(_translate("MainWindow", "instructions"))
     


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())

