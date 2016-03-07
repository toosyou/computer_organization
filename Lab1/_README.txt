1. There are two test cases: a basic one and the other for bonus points.
	For testing a specific test case, copy all of those txt files to the folder where verilog files exist.
	For testing the basic test case, no need to modify testbench.v
	For the bonus case, please un-comment //`define BONUS
	For the use of the extra 3-bit ALU control input, Please refer to the architecture diagram in the PDF.

2. Basically "carryout" and "overflow" are meaningful only in the case of ADD and SUB.
	You can assume "carryout" and "overflow" 0 in the case other than ADD and SUB.

3. Name your submission (as a zip file) with your student ID, e.g., 0316001_0316002.zip
	And please attach your student IDs as comments at the top of each file
	ex.	alu.v
	-------------------------
	|//0316001_0316002		|
	|module alu(.....);		|
	|.....					|
	|.....					|
	|.....					|
	|endmodule				|
	-------------------------
	Remember to write the report.

4. DON'T change the module name of "alu", and DON'T change its input/output names.

5. If you have any problem, use E3 Discussion or email to us. TA will response ASAP.

=====

1. 測資說明 : 分別有兩個資料夾，一個為基本題的測資，一個為bonus的測資，

              在做測試時，將txt檔全放入與Project同個資料夾下，
 
              在做基本題時，不須修改testbench，
 
              但在做bonus時，請將testbench中一開始的 //`define BONUS 註解拿掉 

   * 注意 : alu port 的命名要與所附的 alu.v相同

            bonus_control 為額外增加的 3 bits control，請參考pdf所附的參考架構圖


2. carryout 與 overflow 這兩個 flag 通常只有在做 ADD 與 SUB 運算時才需用到

3. 繳交時請以學號為壓縮檔檔名(e.g. 0316001_0316002.zip)，記得寫報告
   
   每個verilog檔最上面請以註解標注學號
   
   ex.	alu.v
	-------------------------
	|//0316001_0316002		|
	|module alu(.....);		|
	|.....					|
	|.....					|
	|.....					|
	|endmodule				|
	-------------------------

4. 請勿擅自更動alu module的input ouput
	alu_top 為範例檔同學可以視情況改動


5. 有任何問題可以上討論版留言或寄信，助教看到會盡快回答


